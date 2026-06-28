#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for the private Resolve-GovUKNotifyContext helper.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Resolve-GovUKNotifyContext' {

    AfterEach {
        Disconnect-GovUKNotify -ErrorAction SilentlyContinue
    }

    It 'throws when no API key is supplied and no session is connected' {
        InModuleScope GovUKNotify {
            $script:GovUKNotifyContext = $null
            { Resolve-GovUKNotifyContext } | Should -Throw '*Not connected to GOV.UK Notify*'
        }
    }

    It 'uses an explicit API key over the connected session' {
        InModuleScope GovUKNotify {
            $script:GovUKNotifyContext = @{ ApiKey = 'session-key'; BaseUrl = 'https://session.example' }
            $Result = Resolve-GovUKNotifyContext -ApiKey 'explicit-key'
            $Result.ApiKey | Should -Be 'explicit-key'
        }
    }

    It 'falls back to the connected session API key and base URL' {
        InModuleScope GovUKNotify {
            $script:GovUKNotifyContext = @{ ApiKey = 'session-key'; BaseUrl = 'https://session.example' }
            $Result = Resolve-GovUKNotifyContext
            $Result.ApiKey | Should -Be 'session-key'
            $Result.BaseUrl | Should -Be 'https://session.example'
        }
    }

    It 'defaults to the production base URL when none is set' {
        InModuleScope GovUKNotify {
            $script:GovUKNotifyContext = $null
            $Result = Resolve-GovUKNotifyContext -ApiKey 'explicit-key'
            $Result.BaseUrl | Should -Be 'https://api.notifications.service.gov.uk'
        }
    }

    It 'trims a trailing slash from the base URL' {
        InModuleScope GovUKNotify {
            $Result = Resolve-GovUKNotifyContext -ApiKey 'k' -BaseUrl 'https://example.test/'
            $Result.BaseUrl | Should -Be 'https://example.test'
        }
    }
}
