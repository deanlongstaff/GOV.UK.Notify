#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Send-GovUKNotifyLetter.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Send-GovUKNotifyLetter' {

    BeforeEach {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ id = 'n1' } }
    }

    It 'posts to the letter endpoint with template id and personalisation' {
        $Address = @{ address_line_1 = 'Amala Bird'; address_line_2 = '123 High Street'; address_line_3 = 'SW14 6BH' }
        Send-GovUKNotifyLetter -TemplateId 't1' -Personalisation $Address
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Path -eq '/v2/notifications/letter' -and
            $Body.template_id -eq 't1' -and
            $Body.personalisation.address_line_1 -eq 'Amala Bird'
        }
    }

    It 'includes a reference when supplied' {
        Send-GovUKNotifyLetter -TemplateId 't1' -Personalisation @{ address_line_1 = 'A'; address_line_2 = 'B'; address_line_3 = 'SW14 6BH' } -Reference 'ref'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $Body.reference -eq 'ref' }
    }

    It 'requires Personalisation' {
        (Get-Command Send-GovUKNotifyLetter).Parameters['Personalisation'].Attributes.Mandatory | Should -Contain $true
    }
}
