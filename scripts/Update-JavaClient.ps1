<#
.SYNOPSIS
    Re-syncs the Cloudhub Java client with the CloudHub API in one command.

.DESCRIPTION
    Pipeline stages:
      1. Build the CloudHub .NET Site (so its assemblies exist).
      2. Capture its OpenAPI spec headlessly -> openapi/cloudhub.json   (Swashbuckle CLI).
      3. Regenerate the Java client                                      (./gradlew openApiGenerate).
      4. Apply a conditional JavaDoc safety patch to generated sources.
      5. Compile + verify                                                (./gradlew clean build).

    Files listed in .openapi-generator-ignore (CloudhubClient.java, CloudhubUtils.java,
    build.gradle, README.md, ...) are never overwritten.

    After it runs, `git diff openapi/cloudhub.json` shows exactly what changed upstream.

.PARAMETER CloudHubRepo
    Path to the CloudHub .NET repo. Defaults to a sibling folder named "cloudhub".

.PARAMETER Configuration
    .NET build configuration (Debug/Release). Default: Debug.

.PARAMETER SpecOnly
    Capture the spec only; skip generation and build.

.PARAMETER SkipCloudHubBuild
    Reuse already-built CloudHub assemblies (skip stage 1).

.PARAMETER SkipGradleBuild
    Regenerate but skip the final `clean build` (stage 5).

.EXAMPLE
    pwsh scripts/Update-JavaClient.ps1
.EXAMPLE
    pwsh scripts/Update-JavaClient.ps1 -CloudHubRepo ..\cloudhub -Configuration Release
#>
[CmdletBinding()]
param(
    [string] $CloudHubRepo,
    [ValidateSet('Debug', 'Release')] [string] $Configuration = 'Debug',
    [switch] $SpecOnly,
    [switch] $SkipCloudHubBuild,
    [switch] $SkipGradleBuild
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Fail($msg) { Write-Error $msg; exit 1 }

# --- Resolve paths -----------------------------------------------------------
$RepoRoot = Split-Path -Parent $PSScriptRoot
Write-Step "Java client repo: $RepoRoot"

if (-not $CloudHubRepo) { $CloudHubRepo = Join-Path (Split-Path -Parent $RepoRoot) 'cloudhub' }
$resolved = Resolve-Path -LiteralPath $CloudHubRepo -ErrorAction SilentlyContinue
$CloudHubRepo = if ($resolved) { $resolved.Path } else { $null }
if (-not $CloudHubRepo) { Fail "CloudHub repo not found. Pass -CloudHubRepo <path>." }
Write-Host "CloudHub repo:   $CloudHubRepo"

$SiteCsproj = Join-Path $CloudHubRepo 'Site\Lacuna.Cloudhub.Site.csproj'
if (-not (Test-Path $SiteCsproj)) { Fail "Site project not found at $SiteCsproj" }

$SpecPath = Join-Path $RepoRoot 'openapi\cloudhub.json'

# --- Stage 1: build CloudHub -------------------------------------------------
if (-not $SkipCloudHubBuild) {
    Write-Step "Building CloudHub Site ($Configuration)"
    dotnet build $SiteCsproj -c $Configuration --nologo -v minimal
    if ($LASTEXITCODE -ne 0) { Fail "CloudHub build failed (exit $LASTEXITCODE)." }
} else {
    Write-Step "Skipping CloudHub build (-SkipCloudHubBuild)"
}

# --- Stage 2: capture the spec ----------------------------------------------
Write-Step "Locating built Site assembly"
$SiteDll = Get-ChildItem -Path (Join-Path $CloudHubRepo "Site\bin\$Configuration") -Recurse -Filter 'Lacuna.Cloudhub.Site.dll' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $SiteDll) { Fail "Could not find Lacuna.Cloudhub.Site.dll under Site\bin\$Configuration. Build first (omit -SkipCloudHubBuild)." }
Write-Host "Assembly: $($SiteDll.FullName)"

Write-Step "Restoring the Swashbuckle CLI tool"
Push-Location $RepoRoot
try {
    dotnet tool restore
    if ($LASTEXITCODE -ne 0) { Fail "dotnet tool restore failed." }

    Write-Step "Capturing OpenAPI spec -> openapi/cloudhub.json"
    New-Item -ItemType Directory -Force -Path (Split-Path $SpecPath) | Out-Null
    dotnet swagger tofile --output $SpecPath $SiteDll.FullName v1
    if ($LASTEXITCODE -ne 0) { Fail "Spec capture failed. (Doc name 'v1' must match the Swashbuckle SwaggerDoc id.)" }
    Write-Host "Spec written: $((Get-Item $SpecPath).Length) bytes"
}
finally { Pop-Location }

if ($SpecOnly) { Write-Step "Done (spec only). Review with: git -C `"$RepoRoot`" diff openapi/cloudhub.json"; exit 0 }

# --- Java required from here on ---------------------------------------------
if (-not (Get-Command java -ErrorAction SilentlyContinue) -and -not $env:JAVA_HOME) {
    Fail "No JDK found (java not on PATH, JAVA_HOME unset). Generation/build need a JDK 8+. Install one, or re-run with -SpecOnly and generate where Java is available."
}

$Gradlew = Join-Path $RepoRoot 'gradlew.bat'

# --- Stage 3: regenerate -----------------------------------------------------
Write-Step "Regenerating the Java client (./gradlew openApiGenerate)"
& $Gradlew -p $RepoRoot normalizeOpenApiSpec openApiGenerate
if ($LASTEXITCODE -ne 0) { Fail "openApiGenerate failed (exit $LASTEXITCODE)." }

# --- Stage 4: JavaDoc safety patch (idempotent; usually a no-op on 7.x) ------
Write-Step "Applying JavaDoc HTML5 safety patch (if needed)"
$patched = 0
Get-ChildItem -Path (Join-Path $RepoRoot 'src\main\java') -Recurse -Filter '*.java' | ForEach-Object {
    $text = Get-Content -LiteralPath $_.FullName -Raw
    $new = [regex]::Replace($text, '<table summary="([^"]*)">', '<table><caption>$1</caption>')
    if ($new -ne $text) { Set-Content -LiteralPath $_.FullName -Value $new -NoNewline; $patched++ }
}
Write-Host "Files patched: $patched"

# --- Stage 5: compile + verify ----------------------------------------------
if (-not $SkipGradleBuild) {
    Write-Step "Building + verifying (./gradlew clean build)"
    & $Gradlew -p $RepoRoot clean build
    if ($LASTEXITCODE -ne 0) { Fail "Gradle build failed (exit $LASTEXITCODE)." }
} else {
    Write-Step "Skipping Gradle build (-SkipGradleBuild)"
}

Write-Step "Done."
Write-Host "Review upstream API changes:  git -C `"$RepoRoot`" diff openapi/cloudhub.json"
Write-Host "Review generated code changes: git -C `"$RepoRoot`" status"
Write-Host "Remember to bump `version` in build.gradle and add a CHANGELOG entry (the skill does this)."
