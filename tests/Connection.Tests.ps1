#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Connect-GovUKNotify, Disconnect-GovUKNotify and Get-GovUKNotifyContext.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
    $script:TestKey = 'testkey-26785a09-ab16-4eb0-8407-a37497a57506-3d844edf-8d35-48ac-975b-e847b4f122b0'
}

Describe 'GovUKNotify connection' {

    AfterEach {
        Disconnect-GovUKNotify -ErrorAction SilentlyContinue
    }

    Context 'Connect-GovUKNotify' {

        It 'throws when the API key format is invalid' {
            { Connect-GovUKNotify -ApiKey 'invalid-key' } | Should -Throw '*Invalid GOV.UK Notify API key format*'
        }

        It 'stores the connection and exposes the service id via Get-GovUKNotifyContext' {
            Connect-GovUKNotify -ApiKey $script:TestKey
            $Context = Get-GovUKNotifyContext
            $Context.ServiceId | Should -Be '26785a09-ab16-4eb0-8407-a37497a57506'
            $Context.KeyName | Should -Be 'testkey'
            $Context.BaseUrl | Should -Be 'https://api.notifications.service.gov.uk'
        }

        It 'never exposes the full API key' {
            Connect-GovUKNotify -ApiKey $script:TestKey
            $Context = Get-GovUKNotifyContext
            $Context.PSObject.Properties.Name | Should -Not -Contain 'ApiKey'
            $Context.ApiKeyEnding | Should -Be '22b0'
        }

        It 'accepts a custom base URL and trims a trailing slash' {
            Connect-GovUKNotify -ApiKey $script:TestKey -BaseUrl 'https://example.test/'
            (Get-GovUKNotifyContext).BaseUrl | Should -Be 'https://example.test'
        }

        It 'returns the context when -PassThru is used' {
            $Result = Connect-GovUKNotify -ApiKey $script:TestKey -PassThru
            $Result.ServiceId | Should -Be '26785a09-ab16-4eb0-8407-a37497a57506'
        }
    }

    Context 'Disconnect-GovUKNotify' {

        It 'clears the stored connection' {
            Connect-GovUKNotify -ApiKey $script:TestKey
            Disconnect-GovUKNotify
            Get-GovUKNotifyContext | Should -BeNullOrEmpty
        }
    }

    Context 'Get-GovUKNotifyContext' {

        It 'returns $null when not connected' {
            Disconnect-GovUKNotify -ErrorAction SilentlyContinue
            Get-GovUKNotifyContext | Should -BeNullOrEmpty
        }
    }
}
