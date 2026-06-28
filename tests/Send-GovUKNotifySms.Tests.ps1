#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Send-GovUKNotifySms.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1" -Force
}

Describe 'Send-GovUKNotifySms' {

    BeforeEach {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ id = 'n1' } }
    }

    It 'posts to the sms endpoint with the required body fields' {
        Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId 't1'
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Path -eq '/v2/notifications/sms' -and
            $Body.phone_number -eq '+447900900123' -and
            $Body.template_id -eq 't1'
        }
    }

    It 'includes personalisation, reference and sms_sender_id when supplied' {
        Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId 't1' -Personalisation @{ code = '123' } -Reference 'ref' -SmsSenderId 'sender1'
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Body.personalisation.code -eq '123' -and $Body.reference -eq 'ref' -and $Body.sms_sender_id -eq 'sender1'
        }
    }

    It 'does not call the API when -WhatIf is used' {
        Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId 't1' -WhatIf
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 0
    }
}
