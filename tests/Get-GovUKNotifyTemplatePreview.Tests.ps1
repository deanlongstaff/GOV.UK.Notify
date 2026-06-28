#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Get-GovUKNotifyTemplatePreview.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1" -Force
}

Describe 'Get-GovUKNotifyTemplatePreview' {

    BeforeEach {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ id = 't1'; body = 'Dear Amala' } }
    }

    It 'posts to the preview endpoint with personalisation' {
        Get-GovUKNotifyTemplatePreview -TemplateId 't1' -Personalisation @{ first_name = 'Amala' } | Out-Null
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Path -eq '/v2/template/t1/preview' -and
            $Body.personalisation.first_name -eq 'Amala'
        }
    }

    It 'sends an empty personalisation object when none is supplied' {
        Get-GovUKNotifyTemplatePreview -TemplateId 't1' | Out-Null
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Body.ContainsKey('personalisation')
        }
    }
}
