<#
    .SYNOPSIS
    Build, lint, test, document and publish tasks for the GOV.UK.Notify module.

    .DESCRIPTION
    A dependency-light build script used locally and by CI. It installs Pester, PSScriptAnalyzer and
    platyPS on demand, runs static analysis and the Pester suite, generates Markdown and external
    (MAML) help, bumps the module version, stages the module for packaging, and publishes it to the
    PowerShell Gallery.

    .PARAMETER Task
    The task to run:
      - Test    (default) runs Analyze then the Pester suite.
      - Analyze runs PSScriptAnalyzer.
      - Docs    regenerates the Markdown help under docs/help.
      - Build   stages the module (with compiled external help) to the output folder.
      - Bump    increases the module version and updates the changelog.
      - Publish builds and publishes the module to the PowerShell Gallery.

    .PARAMETER BumpType
    For the Bump task, which part of the version to increase: 'Major', 'Minor' or 'Patch' (default).

    .PARAMETER Version
    For the Bump task, an explicit version to set, overriding -BumpType.

    .PARAMETER ApiKey
    The PowerShell Gallery API key, required for the Publish task.

    .PARAMETER OutputPath
    Where the Build task stages the module. Defaults to ./output.

    .EXAMPLE
    ./build.ps1 -Task Test

    .EXAMPLE
    ./build.ps1 -Task Docs

    .EXAMPLE
    ./build.ps1 -Task Bump -BumpType Minor

    .EXAMPLE
    ./build.ps1 -Task Publish -ApiKey $env:PSGALLERY_API_KEY
#>
[CmdletBinding()]
param(
    [ValidateSet('Test', 'Analyze', 'Docs', 'Build', 'Bump', 'Publish')]
    [string]$Task = 'Test',

    [ValidateSet('Major', 'Minor', 'Patch')]
    [string]$BumpType = 'Patch',

    [string]$Version,

    [string]$ApiKey,

    [string]$OutputPath = (Join-Path $PSScriptRoot 'output')
)

$ErrorActionPreference = 'Stop'

$ModuleName = 'GOV.UK.Notify'
$SourcePath = Join-Path $PSScriptRoot "src/$ModuleName"
$ManifestPath = Join-Path $SourcePath "$ModuleName.psd1"
$SettingsPath = Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1'
$TestsPath = Join-Path $PSScriptRoot 'tests'
$DocsPath = Join-Path $PSScriptRoot 'docs/help'
$ChangelogPath = Join-Path $PSScriptRoot 'CHANGELOG.md'
$RepoUrl = 'https://github.com/deanlongstaff/GOV.UK.Notify'

$PesterMinimum = [version]'5.5.0'
$AnalyzerMinimum = [version]'1.21.0'
$PlatyPSMinimum = [version]'0.14.2'

function Install-BuildDependency {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][version]$MinimumVersion
    )

    if (Get-Module -ListAvailable -Name $Name | Where-Object Version -GE $MinimumVersion) {
        return
    }

    Write-Host "Installing $Name (>= $MinimumVersion)..."
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Install-PackageProvider -Name NuGet -MinimumVersion '2.8.5.201' -Force -Scope CurrentUser | Out-Null
    }
    Install-Module -Name $Name -MinimumVersion $MinimumVersion -Scope CurrentUser -Force -SkipPublisherCheck
}

function Invoke-Analyze {
    Install-BuildDependency -Name 'PSScriptAnalyzer' -MinimumVersion $AnalyzerMinimum
    Import-Module PSScriptAnalyzer -Force

    Write-Host "Running PSScriptAnalyzer on $SourcePath..."
    $Results = Invoke-ScriptAnalyzer -Path $SourcePath -Recurse -Settings $SettingsPath

    if ($Results) {
        $Results | Format-Table -AutoSize | Out-String | Write-Host
        throw "PSScriptAnalyzer found $($Results.Count) issue(s)."
    }
    Write-Host 'PSScriptAnalyzer: no issues found.'
}

function Invoke-Test {
    Install-BuildDependency -Name 'Pester' -MinimumVersion $PesterMinimum
    Install-BuildDependency -Name 'PSScriptAnalyzer' -MinimumVersion $AnalyzerMinimum
    Import-Module Pester -MinimumVersion $PesterMinimum -Force

    $Configuration = New-PesterConfiguration
    $Configuration.Run.Path = $TestsPath
    $Configuration.Run.PassThru = $true
    $Configuration.Output.Verbosity = 'Detailed'
    $Configuration.TestResult.Enabled = $true
    $Configuration.TestResult.OutputPath = (Join-Path $PSScriptRoot 'testResults.xml')
    $Configuration.TestResult.OutputFormat = 'NUnitXml'
    $Configuration.CodeCoverage.Enabled = $true
    $Configuration.CodeCoverage.Path = (Get-ChildItem -Path $SourcePath -Recurse -Filter '*.ps1').FullName
    $Configuration.CodeCoverage.OutputPath = (Join-Path $PSScriptRoot 'coverage.xml')
    $Configuration.CodeCoverage.OutputFormat = 'JaCoCo'

    $Result = Invoke-Pester -Configuration $Configuration

    if ($Result.FailedCount -gt 0) {
        throw "$($Result.FailedCount) test(s) failed."
    }
    Write-Host "All $($Result.PassedCount) test(s) passed."
}

function Invoke-Docs {
    Install-BuildDependency -Name 'platyPS' -MinimumVersion $PlatyPSMinimum
    Import-Module platyPS -Force
    Import-Module $ManifestPath -Force

    if (-not (Test-Path $DocsPath)) {
        New-Item -ItemType Directory -Path $DocsPath -Force | Out-Null
    }

    # -- Regenerate the cmdlet Markdown deterministically from the comment-based help.
    New-MarkdownHelp -Module $ModuleName -OutputFolder $DocsPath -WithModulePage -AlphabeticParamsOrder -Force |
        Out-Null
    Write-Host "Markdown help written to $DocsPath."
}

function Build-ExternalHelp {
    param([Parameter(Mandatory)][string]$DestinationEnUs)

    Install-BuildDependency -Name 'platyPS' -MinimumVersion $PlatyPSMinimum
    Import-Module platyPS -Force

    $CmdletMarkdown = Get-ChildItem -Path $DocsPath -Filter '*.md' -ErrorAction SilentlyContinue |
        Where-Object Name -NE "$ModuleName.md"
    if (-not $CmdletMarkdown) {
        Invoke-Docs
    }

    if (-not (Test-Path $DestinationEnUs)) {
        New-Item -ItemType Directory -Path $DestinationEnUs -Force | Out-Null
    }

    # -- Compile the Markdown into MAML external help so Get-Help is rich and consistent.
    New-ExternalHelp -Path $DocsPath -OutputPath $DestinationEnUs -Force | Out-Null
    Write-Host "External help compiled to $DestinationEnUs."
}

function Invoke-Build {
    Write-Host "Validating manifest $ManifestPath..."
    Test-ModuleManifest -Path $ManifestPath | Out-Null

    $StagePath = Join-Path $OutputPath $ModuleName
    if (Test-Path $StagePath) {
        Remove-Item -Path $StagePath -Recurse -Force
    }
    New-Item -ItemType Directory -Path $StagePath -Force | Out-Null

    Write-Host "Staging module to $StagePath..."
    Copy-Item -Path (Join-Path $SourcePath '*') -Destination $StagePath -Recurse -Force

    Build-ExternalHelp -DestinationEnUs (Join-Path $StagePath 'en-US')

    return $StagePath
}

function Invoke-Bump {
    $Raw = Get-Content -Path $ManifestPath -Raw
    if ($Raw -notmatch "ModuleVersion\s*=\s*'([^']+)'") {
        throw 'Could not find ModuleVersion in the manifest.'
    }
    $Current = [version]$Matches[1]

    if ($Version) {
        $New = [version]$Version
    }
    else {
        switch ($BumpType) {
            'Major' { $New = [version]('{0}.0.0' -f ($Current.Major + 1)) }
            'Minor' { $New = [version]('{0}.{1}.0' -f $Current.Major, ($Current.Minor + 1)) }
            'Patch' { $New = [version]('{0}.{1}.{2}' -f $Current.Major, $Current.Minor, ([Math]::Max($Current.Build, 0) + 1)) }
        }
    }
    $NewVersion = $New.ToString()
    Write-Host "Bumping module version $Current -> $NewVersion"

    # -- Update the manifest version (targeted replace preserves formatting and comments).
    $Raw = $Raw -replace "(ModuleVersion\s*=\s*')[^']+(')", "`${1}$NewVersion`${2}"
    Set-Content -Path $ManifestPath -Value $Raw -NoNewline

    # -- Update the changelog: promote Unreleased to a dated version section and fix the links.
    if (Test-Path $ChangelogPath) {
        $Changelog = Get-Content -Path $ChangelogPath -Raw
        $Date = (Get-Date).ToString('yyyy-MM-dd')

        $Changelog = $Changelog -replace '## \[Unreleased\]', "## [Unreleased]`n`n## [$NewVersion] - $Date"
        $Changelog = $Changelog -replace 'compare/v[0-9]+\.[0-9]+\.[0-9]+\.\.\.HEAD', "compare/v$NewVersion...HEAD"

        $TagLink = "[$NewVersion]: $RepoUrl/releases/tag/v$NewVersion"
        if ($Changelog -notmatch [regex]::Escape($TagLink) -and $Changelog -match '(?m)^\[Unreleased\]:.*$') {
            $Changelog = $Changelog -replace [regex]::Escape($Matches[0]), "$($Matches[0])`n$TagLink"
        }

        Set-Content -Path $ChangelogPath -Value $Changelog -NoNewline
    }

    Write-Host "Module version is now $NewVersion."
    return $NewVersion
}

function Invoke-Publish {
    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        throw 'The Publish task requires -ApiKey (the PowerShell Gallery API key).'
    }

    $StagePath = Invoke-Build

    Write-Host "Publishing $ModuleName to the PowerShell Gallery..."
    Publish-Module -Path $StagePath -NuGetApiKey $ApiKey -Verbose
    Write-Host 'Publish complete.'
}

switch ($Task) {
    'Analyze' { Invoke-Analyze }
    'Test' {
        Invoke-Analyze
        Invoke-Test
    }
    'Docs' { Invoke-Docs }
    'Build' { Invoke-Build | Out-Null }
    'Bump' { Invoke-Bump | Out-Null }
    'Publish' { Invoke-Publish }
}
