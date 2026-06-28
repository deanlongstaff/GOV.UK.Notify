#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Get-GovUKNotifyLetterPdf.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Get-GovUKNotifyLetterPdf' {

    BeforeEach {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { , [byte[]](80, 68, 70) }
    }

    It 'requests the letter pdf endpoint with -Raw' {
        Get-GovUKNotifyLetterPdf -NotificationId 'abc' | Out-Null
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq '/v2/notifications/abc/pdf' -and $Raw -eq $true
        }
    }

    It 'returns the pdf bytes when no OutFile is given' {
        $Bytes = Get-GovUKNotifyLetterPdf -NotificationId 'abc'
        ($Bytes -join ',') | Should -Be '80,68,70'
    }

    It 'writes the pdf to OutFile when supplied' {
        $TempFile = Join-Path $TestDrive 'out.pdf'
        Get-GovUKNotifyLetterPdf -NotificationId 'abc' -OutFile $TempFile
        Test-Path $TempFile | Should -BeTrue
        ([System.IO.File]::ReadAllBytes($TempFile) -join ',') | Should -Be '80,68,70'
    }
}
