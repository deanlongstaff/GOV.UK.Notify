#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Get-GovUKNotifyReceivedText.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Get-GovUKNotifyReceivedText' {

    It 'requests the received text messages endpoint' {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ received_text_messages = @(@{ id = '1'; content = 'hi' }) } }
        $Result = Get-GovUKNotifyReceivedText
        $Result.content | Should -Be 'hi'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq '/v2/received-text-messages'
        }
    }

    It 'adds the older_than query parameter when supplied' {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ received_text_messages = @() } }
        Get-GovUKNotifyReceivedText -OlderThan 'abc'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Path -eq '/v2/received-text-messages?older_than=abc'
        }
    }

    It 'follows pagination when -All is specified' {
        InModuleScope GovUKNotify {
            $script:Page = 0
            Mock Invoke-GovUKNotifyApi {
                $script:Page++
                if ($script:Page -eq 1) {
                    return @{ received_text_messages = (1..250 | ForEach-Object { @{ id = "id-$_" } }) }
                }
                return @{ received_text_messages = @(@{ id = 'final' }) }
            }

            $Result = Get-GovUKNotifyReceivedText -All
            $Result.Count | Should -Be 251
            Should -Invoke Invoke-GovUKNotifyApi -Times 2
        }
    }
}
