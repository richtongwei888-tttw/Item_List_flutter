[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\d+\.\d+\.\d+$')]
    [string]$Version,

    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 2147483647)]
    [int]$Build,

    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$versionPath = Join-Path $repoRoot 'VERSION'
$pubspecPath = Join-Path $repoRoot 'pubspec.yaml'
$changelogPath = Join-Path $repoRoot 'CHANGELOG.md'
$tag = "v$Version"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    Write-Host "> $Command $($Arguments -join ' ')" -ForegroundColor Cyan
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE`: $Command"
    }
}

function Read-RequiredFile {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Required file is missing: $Path"
    }
    return [System.IO.File]::ReadAllText($Path)
}

Set-Location $repoRoot

$status = & git status --porcelain
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to read Git worktree status.'
}
if ($status) {
    throw 'Release requires a clean Git worktree.'
}

if (-not $DryRun) {
    $branch = (& git branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0 -or $branch -ne 'main') {
        throw 'A real release must run from the main branch.'
    }

    Invoke-Checked git @('fetch', 'origin', 'main', '--tags')
    $syncCounts = ((& git rev-list --left-right --count 'origin/main...HEAD').Trim() -split '\s+')
    if ($LASTEXITCODE -ne 0 -or $syncCounts.Count -ne 2) {
        throw 'Unable to compare main with origin/main.'
    }
    if ($syncCounts[0] -ne '0' -or $syncCounts[1] -ne '0') {
        throw 'main must exactly match origin/main before creating a release.'
    }

    & git rev-parse --quiet --verify "refs/tags/$tag" *> $null
    if ($LASTEXITCODE -eq 0) {
        throw "Tag $tag already exists."
    }
}

$originalVersion = Read-RequiredFile $versionPath
$originalPubspec = Read-RequiredFile $pubspecPath
$changelog = Read-RequiredFile $changelogPath

$currentVersion = $originalVersion.Trim()
if ($currentVersion -ne $Version -and $currentVersion -ne "$Version-dev") {
    throw "VERSION must be $Version or $Version-dev, found $currentVersion."
}

$pubspecMatch = [regex]::Match(
    $originalPubspec,
    '(?m)^version:\s*(?<value>\S+)\s*$'
)
if (-not $pubspecMatch.Success) {
    throw 'pubspec.yaml does not contain a version field.'
}
$expectedPubspecVersion = "$Version+$Build"
if ($pubspecMatch.Groups['value'].Value -ne $expectedPubspecVersion) {
    throw "pubspec.yaml must contain version $expectedPubspecVersion."
}

$escapedVersion = [regex]::Escape($Version)
if ($changelog -notmatch "(?m)^## \[$escapedVersion\] - \d{4}-\d{2}-\d{2}\s*$") {
    throw "CHANGELOG.md must contain a dated heading for [$Version]."
}

$metadataWritten = $false
try {
    [System.IO.File]::WriteAllText($versionPath, "$Version`n", $utf8NoBom)
    $pubspecVersionRegex = New-Object System.Text.RegularExpressions.Regex `
        -ArgumentList '(?m)^version:\s*\S+\s*$'
    $releasePubspec = $pubspecVersionRegex.Replace(
        $originalPubspec,
        "version: $expectedPubspecVersion",
        1
    )
    [System.IO.File]::WriteAllText($pubspecPath, $releasePubspec, $utf8NoBom)
    $metadataWritten = $true

    Invoke-Checked dart @('run', 'build_runner', 'build')
    Invoke-Checked dart @(
        'format',
        '--output=none',
        '--set-exit-if-changed',
        'lib',
        'test',
        'integration_test'
    )
    Invoke-Checked flutter @('analyze')
    Invoke-Checked flutter @('test')
    Invoke-Checked flutter @('build', 'apk', '--release')
    Invoke-Checked git @('diff', '--check')

    if ($DryRun) {
        Write-Host 'Dry run passed. Commit, tag, and push were skipped.' -ForegroundColor Green
        return
    }

    Invoke-Checked git @('add', 'VERSION', 'pubspec.yaml')
    Invoke-Checked git @('commit', '-m', "release: $tag")
    Invoke-Checked git @('tag', '-a', $tag, '-m', "Clear Flow $tag")
    Invoke-Checked git @('push', 'origin', 'main')
    Invoke-Checked git @('push', 'origin', $tag)

    Write-Host "Released $tag ($Build)." -ForegroundColor Green
}
finally {
    if ($DryRun -and $metadataWritten) {
        [System.IO.File]::WriteAllText($versionPath, $originalVersion, $utf8NoBom)
        [System.IO.File]::WriteAllText($pubspecPath, $originalPubspec, $utf8NoBom)
    }
}
