# Changelog

All notable changes to the Cloudhub Java client are documented here.
This project adheres to [Semantic Versioning](https://semver.org).

## [2.0.0] - 2026-06-30

### Fixed
- **Client sends the `X-Api-Key` header.** CloudHub's spec declares the `ApiKey` security *scheme*
  but no *requirement* (its `AddSecurityRequirement` is commented out), so the generated operations
  had empty `authNames` and every authenticated call failed with **HTTP 401**. The
  `normalizeOpenApiSpec` step injects a global security requirement
  (`openapi/overrides.json` → `globalSecurity: [{ ApiKey: [] }]`) so all operations attach the key.

### Added — automated CloudHub sync pipeline
- `openapi/cloudhub.json` — OpenAPI spec captured from CloudHub, committed as the source of truth.
- `openapi-generator.gradle` — pinned OpenAPI Generator (7.14.0) config and a `normalizeOpenApiSpec`
  task (the declarative spec-fix hook, driven by `openapi/overrides.json`).
- `.openapi-generator-ignore` — protects hand-maintained files from regeneration (now committed).
- `scripts/Update-JavaClient.ps1` — one command: capture spec → regenerate → build.
- `.config/dotnet-tools.json` — pins the Swashbuckle CLI used for headless spec capture.
- `.claude/skills/update-cloudhub-client` — skill that orchestrates the pipeline, summarizes the
  upstream diff, recommends the version bump, and flags judgment calls.
- `cloudhub.CloudhubUtils` — new home for the `convertCertificateToString` /
  `convertToSignHashToByteArray64` helpers (previously inside the generated `SessionsApi`).

### Changed
- `cloudhub.client.CloudhubClient` is now a thin subclass of the generated `cloudhub.client.ApiClient`
  (keeping the `(baseURL, apiKey)` constructor and 2-minute timeouts) instead of a renamed copy of the
  generated invoker. Existing `new CloudhubClient(endpoint, apiKey)` usage is unchanged. (`setBasePath`
  now returns `ApiClient` rather than `CloudhubClient`, affecting only fluent chaining.)
- `build.gradle`: signing is now required only when publishing to the **remote** Maven repository, and
  the OSSRH credentials resolve null-safely. This lets regeneration, `build`, and `publishToMavenLocal`
  run without a GPG key or credentials (CI / local testing); the real `publish` to Sonatype is unchanged.

### Migration note (source compatibility)
- The two helpers moved from `cloudhub.SessionsApi` to `cloudhub.CloudhubUtils`. Update any callers:
  `SessionsApi.convertCertificateToString(...)` → `CloudhubUtils.convertCertificateToString(...)`.

### Updated to the CloudHub 2.0.0 API surface
Regenerated from the current CloudHub spec. Changes since client 1.0.5:
- **Added** endpoints: `GET /api/sessions/services/{name}/availability`, `GET /api/sessions/custom-state`.
- **Added** model `GetServiceAvailabilityResponse`; added `CertificateModel.serviceName`.
- **Changed** `SessionCreateRequest`: `lifetimeInMinutes` → `lifetimeInSeconds` (int32); added
  `identifierType`; `redirectUri` is now required.
- **Changed (breaking)** `TrustServiceSessionTypes` is now a **string** enum (was integer) — the wire
  format changed upstream. This alone implies a **major** version bump.
