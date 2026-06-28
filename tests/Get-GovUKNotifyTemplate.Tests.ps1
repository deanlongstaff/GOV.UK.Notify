#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Get-GovUKNotifyTemplate.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1" -Force
}

Describe 'Get-GovUKNotifyTemplate' {

    It 'gets the latest version of a single template by id' {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ id = 't1'; version = 3 } }
        $Result = Get-GovUKNotifyTemplate -TemplateId 't1'
        $Result.id | Should -Be 't1'
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq '/v2/template/t1'
        }
    }

    It 'gets a specific template version when -Version is supplied' {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ id = 't1'; version = 2 } }
        Get-GovUKNotifyTemplate -TemplateId 't1' -Version 2 | Out-Null
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Path -eq '/v2/template/t1/version/2'
        }
    }

    It 'lists all templates and returns the templates array' {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ templates = @(@{ id = 't1' }, @{ id = 't2' }) } }
        $Result = Get-GovUKNotifyTemplate
        $Result.Count | Should -Be 2
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $Path -eq '/v2/templates' }
    }

    It 'filters the template list by type' {
        Mock -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi { @{ templates = @() } }
        Get-GovUKNotifyTemplate -Type email
        Should -Invoke -ModuleName GOV.UK.Notify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $Path -eq '/v2/templates?type=email' }
    }
}
