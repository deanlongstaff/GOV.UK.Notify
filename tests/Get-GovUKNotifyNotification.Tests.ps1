#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Get-GovUKNotifyNotification.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Get-GovUKNotifyNotification' {

    Context 'Single notification' {

        It 'gets a single notification by id' {
            Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ id = 'abc'; status = 'delivered' } }
            $Result = Get-GovUKNotifyNotification -NotificationId 'abc'
            $Result.id | Should -Be 'abc'
            Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
                $Method -eq 'GET' -and $Path -eq '/v2/notifications/abc'
            }
        }
    }

    Context 'Listing notifications' {

        It 'returns the notifications array from the response' {
            Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ notifications = @(@{ id = '1' }, @{ id = '2' }) } }
            $Result = Get-GovUKNotifyNotification
            $Result.Count | Should -Be 2
        }

        It 'builds query parameters for template type, status and reference' {
            Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ notifications = @() } }
            Get-GovUKNotifyNotification -TemplateType email -Status delivered, sending -Reference 'my ref' -IncludeJobs
            Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
                $Path -like '/v2/notifications?*' -and
                $Path -like '*template_type=email*' -and
                $Path -like '*status=delivered*' -and
                $Path -like '*status=sending*' -and
                $Path -like '*reference=my%20ref*' -and
                $Path -like '*include_jobs=true*'
            }
        }
    }

    Context 'Pagination' {

        It 'follows pagination when -All is specified' {
            InModuleScope GovUKNotify {
                $script:Page = 0
                Mock Invoke-GovUKNotifyApi {
                    $script:Page++
                    if ($script:Page -eq 1) {
                        return @{ notifications = (1..250 | ForEach-Object { @{ id = "id-$_" } }) }
                    }
                    return @{ notifications = @(@{ id = 'final' }) }
                }

                $Result = Get-GovUKNotifyNotification -All
                $Result.Count | Should -Be 251
                Should -Invoke Invoke-GovUKNotifyApi -Times 2
            }
        }

        It 'returns only the first page without -All' {
            InModuleScope GovUKNotify {
                $script:Page = 0
                Mock Invoke-GovUKNotifyApi {
                    $script:Page++
                    return @{ notifications = (1..250 | ForEach-Object { @{ id = "id-$_" } }) }
                }

                $Result = Get-GovUKNotifyNotification
                $Result.Count | Should -Be 250
                Should -Invoke Invoke-GovUKNotifyApi -Times 1
            }
        }
    }
}
