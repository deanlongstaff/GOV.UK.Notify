#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for Send-GovUKNotifyPrecompiledLetter.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'Send-GovUKNotifyPrecompiledLetter' {

    BeforeEach {
        Mock -ModuleName GovUKNotify Invoke-GovUKNotifyApi { @{ id = 'n1'; reference = 'ref'; postage = 'second' } }
    }

    It 'posts reference and base64 content to the letter endpoint' {
        Send-GovUKNotifyPrecompiledLetter -Reference 'batch-1' -Content 'YmFzZTY0'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and
            $Path -eq '/v2/notifications/letter' -and
            $Body.reference -eq 'batch-1' -and
            $Body.content -eq 'YmFzZTY0'
        }
    }

    It 'includes postage when supplied' {
        Send-GovUKNotifyPrecompiledLetter -Reference 'batch-1' -Content 'YmFzZTY0' -Postage 'first'
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $Body.postage -eq 'first' }
    }

    It 'rejects an invalid postage value' {
        { Send-GovUKNotifyPrecompiledLetter -Reference 'batch-1' -Content 'YmFzZTY0' -Postage 'overnight' } | Should -Throw
    }

    It 'reads a file from -Path and base64-encodes it' {
        $TempFile = Join-Path $TestDrive 'letter.pdf'
        $Bytes = [byte[]](1, 2, 3, 4, 5)
        [System.IO.File]::WriteAllBytes($TempFile, $Bytes)
        $Expected = [Convert]::ToBase64String($Bytes)

        Send-GovUKNotifyPrecompiledLetter -Reference 'batch-1' -Path $TempFile
        Should -Invoke -ModuleName GovUKNotify Invoke-GovUKNotifyApi -Times 1 -ParameterFilter { $Body.content -eq $Expected }
    }
}
