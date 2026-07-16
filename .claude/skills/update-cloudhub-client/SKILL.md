---
name: update-cloudhub-client
description: >
  Re-sync this Java client (cloudhub-java-client) with the CloudHub .NET API: capture the
  latest OpenAPI spec from CloudHub, regenerate the client, re-apply the protected
  customizations, build, summarize what changed, and bump the version. Use whenever the
  client must mirror new/changed CloudHub endpoints or models, after CloudHub is updated,
  or when asked to "update / regenerate / sync the cloudhub java client".
---

# Update the Cloudhub Java client

This skill drives a mostly-deterministic pipeline and supplies the judgment the pipeline
can't. The mechanical work lives in `scripts/Update-JavaClient.ps1`, `openapi-generator.gradle`,
and `.openapi-generator-ignore`. Your job is to run it, read the spec diff, make the few
decisions a generator can't, and report clearly.

## How the pieces fit (read first)

- The client mirrors CloudHub's **OpenAPI spec** — it has no binary dependency on CloudHub.
- `openapi/cloudhub.json` is the committed **source of truth**. `git diff` on it = "what changed upstream".
- Code generation regenerates everything under `src/main/java/**`, `src/test/java/**`, `docs/**`
  **except** files in `.openapi-generator-ignore` (the hand-written `CloudhubClient.java`,
  `CloudhubUtils.java`, `build.gradle`, `README.md`, `CHANGELOG.md`, gradle wrapper, this skill).
- `hideGenerationTimestamp=true` keeps generator output stable, so a re-run with no upstream
  change produces an **empty diff**.

## Prerequisites

- **.NET SDK** compatible with CloudHub's target framework (currently `net10.0`), and access to
  restore CloudHub's NuGet dependencies (private Lacuna feed or a warm package cache).
- **JDK 8+** on `PATH` (or `JAVA_HOME` set) — Gradle and the generator need it.
- The **CloudHub repo** checked out, by default as a sibling folder `../cloudhub`.

## Procedure

### 1. Capture the new spec
Run capture-only first so you can inspect the diff before regenerating:
```
pwsh scripts/Update-JavaClient.ps1 -SpecOnly
```
This builds CloudHub, then writes `openapi/cloudhub.json` via the Swashbuckle CLI tool
(`dotnet swagger tofile ... v1`). If the build/capture fails, see **Troubleshooting**.

### 2. Review what changed upstream
```
git diff -- openapi/cloudhub.json
```
Read the diff and write a short human summary grouped as:
- **Added** paths / schemas / properties
- **Removed** paths / schemas / properties  ← breaking
- **Changed** types, `required`, enum members, `format`  ← often breaking

### 3. Classify the change → decide the version bump
Use [semver](https://semver.org) against the current `version` in `build.gradle`:

| Change | Bump |
|---|---|
| Only additive (new endpoints/models/optional fields) | **minor** |
| Removed/renamed endpoint, field, or enum member; a property became `required`; a type or wire `format` changed; an enum's underlying type changed (e.g. integer→string) | **major** |
| Doc-only / cosmetic | **patch** |

State the recommended new version and the reason. CloudHub's own version is a useful signal
but the client's Maven version is independent — bump it on its own merits.

### 4. Handle judgment items the generator can't (FLAG, don't guess)
Scan the spec diff for these and resolve each explicitly:

- **New INTEGER-valued enum** (`{"enum": [1,2,...], "type": "integer"}`): the generator would emit
  `NUMBER_1`, `NUMBER_2`, …. Add a mapping to `openapi/overrides.json` under `enumVarnames`
  (schema name → ordered constant names). String enums self-name — no action.
- **New endpoint returning `string/format: byte` or a stream**: the existing client provides
  helpers in `cloudhub/CloudhubUtils.java` (`convertCertificateToString`,
  `convertToSignHashToByteArray64`). Consider whether the new endpoint warrants a similar
  convenience helper; if unsure, **flag it for a human** rather than inventing one.
- **Removed endpoints/fields**: confirm intentional, call it out as breaking in the summary.
- **New auth scheme**: the generated `ApiClient` wires schemes from the spec automatically, but
  `CloudhubClient`'s convenience constructor only knows `X-Api-Key`. Update `CloudhubClient.java`
  if a new scheme must be first-class.

### 5. Regenerate + build
```
pwsh scripts/Update-JavaClient.ps1 -SkipCloudHubBuild
```
(`-SkipCloudHubBuild` reuses the assemblies from step 1.) This runs `openApiGenerate`, the
idempotent JavaDoc safety patch, then `clean build`. The build must be green.

### 6. Finalize
- Bump `version` in `build.gradle` to the value from step 3 (the generator reads it for `artifactVersion`).
- Prepend an entry to `CHANGELOG.md`: new version, date, and the step-2 summary.
- Re-run `git status` / `git diff` and sanity-check that **only** intended files changed and that
  the protected files (`CloudhubClient.java`, `CloudhubUtils.java`) are untouched.

### 7. Report
Tell the user: the new version, the upstream-change summary, any flagged judgment items and how
you resolved them, and the build result. Do **not** commit/push unless asked.

## Verifying the result
- `./gradlew clean build` is green.
- Idempotence: a second `-SkipCloudHubBuild` run with no upstream change leaves an empty `git diff`.
- Protected customizations intact: `CloudhubClient extends ApiClient` with the `(baseURL, apiKey)`
  ctor + 2-minute timeouts; `CloudhubUtils` helpers present.

## Troubleshooting
- **CloudHub build fails on restore**: the private Lacuna NuGet feed isn't configured. Add it
  (`dotnet nuget add source ...`) or build on a machine with a warm package cache. If you only
  have a pre-exported `swagger.json`, copy it to `openapi/cloudhub.json` and skip to step 2.
- **`dotnet swagger tofile` fails**: confirm the Swagger doc name is still `v1`
  (`Site/Startup.cs` → `SwaggerDoc("v1", ...)`); pass the matching name as the last arg.
- **Generation overwrote a hand-written file**: it isn't listed in `.openapi-generator-ignore` —
  add it and regenerate.
- **JavaDoc build error about `<table summary>`**: the safety patch in the script handles it; if
  it recurs, add a `templates/api_doc.mustache` override (the gradle config auto-uses `templates/`).
- **Spurious diffs on every run**: ensure `hideGenerationTimestamp=true` is still set in
  `openapi-generator.gradle`.
