#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Send-GovUKNotifyEmail.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Send-GovUKNotifyEmail' {

    BeforeEach {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ id = 'n1' } }
    }

    It 'requires EmailAddress and TemplateId' {
        (Get-Command Send-GovUKNotifyEmail).Parameters['EmailAddress'].Attributes.Mandatory | Should -Contain $true
        (Get-Command Send-GovUKNotifyEmail).Parameters['TemplateId'].Attributes.Mandatory | Should -Contain $true
    }

    It 'posts to the email endpoint with the required body fields' {
        Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId 't1'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Path -eq '/v2/notifications/email' -and
            $Body.email_address -eq 'amala@example.com' -and
            $Body.template_id -eq 't1'
        }
    }

    It 'includes optional fields only when supplied' {
        Send-GovUKNotifyEmail -EmailAddress 'a@b.com' -TemplateId 't1' -Personalisation @{ name = 'A' } -Reference 'ref1' -EmailReplyToId 'reply1' -OneClickUnsubscribeUrl 'https://u.example' -SanitiseContentFor 'name'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Body.personalisation.name -eq 'A' -and
            $Body.reference -eq 'ref1' -and
            $Body.email_reply_to_id -eq 'reply1' -and
            $Body.one_click_unsubscribe_url -eq 'https://u.example' -and
            $Body.sanitise_content_for -contains 'name'
        }
    }

    It 'omits optional fields when not supplied' {
        Send-GovUKNotifyEmail -EmailAddress 'a@b.com' -TemplateId 't1'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            -not $Body.ContainsKey('reference') -and -not $Body.ContainsKey('personalisation')
        }
    }

    It 'passes an explicit API key through to the request engine' {
        Send-GovUKNotifyEmail -EmailAddress 'a@b.com' -TemplateId 't1' -ApiKey 'explicit'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $ApiKey -eq 'explicit' }
    }

    It 'does not call the API when -WhatIf is used' {
        Send-GovUKNotifyEmail -EmailAddress 'a@b.com' -TemplateId 't1' -WhatIf
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 0
    }
}
