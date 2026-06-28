#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Module-level quality tests: manifest validity, exported surface, comment-based help and linting.
#>

BeforeDiscovery {
    Import-Module "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1" -Force
    $ExportedCommands = (Get-Command -Module GOV.UK.Notify).Name
}

BeforeAll {
    $script:ManifestPath = "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1"
    $script:ModulePath = "$PSScriptRoot/../src/GOV.UK.Notify"
    $script:SettingsPath = "$PSScriptRoot/../PSScriptAnalyzerSettings.psd1"
    Import-Module $script:ManifestPath -Force
}

Describe 'Module manifest' {

    It 'is a valid module manifest' {
        { Test-ModuleManifest -Path $script:ManifestPath -ErrorAction Stop } | Should -Not -Throw
    }

    It 'exports exactly the documented public commands' {
        $Exported = (Get-Command -Module GOV.UK.Notify).Name
        $Exported.Count | Should -Be 13
    }

    It 'does not export private helpers' {
        Get-Command -Module GOV.UK.Notify -Name 'Invoke-GovUKNotifyApi' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        Get-Command -Module GOV.UK.Notify -Name 'New-GovUKNotifyJwt' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
    }
}

Describe 'Comment-based help' {

    It '<_> has a synopsis and at least one example' -ForEach $ExportedCommands {
        $Help = Get-Help -Name $_ -ErrorAction Stop
        $Help.Synopsis.Trim() | Should -Not -BeNullOrEmpty
        @($Help.Examples.Example).Count | Should -BeGreaterThan 0
    }
}

Describe 'Static analysis' {

    It 'passes PSScriptAnalyzer with no errors or warnings' -Skip:(-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        Import-Module PSScriptAnalyzer -Force
        $Analysis = Invoke-ScriptAnalyzer -Path $script:ModulePath -Recurse -Settings $script:SettingsPath
        $Analysis | Should -BeNullOrEmpty -Because ("`n" + ($Analysis | Format-Table -AutoSize | Out-String))
    }
}
