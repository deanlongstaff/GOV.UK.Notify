#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for New-GovUKNotifyFileAttachment.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force
}

Describe 'New-GovUKNotifyFileAttachment' {

    It 'base64-encodes a file from -Path and defaults the filename to the file name' {
        $TempFile = Join-Path $TestDrive 'report.csv'
        Set-Content -Path $TempFile -Value 'a,b,c' -NoNewline
        $Expected = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($TempFile))

        $Result = New-GovUKNotifyFileAttachment -Path $TempFile
        $Result.file | Should -Be $Expected
        $Result.filename | Should -Be 'report.csv'
    }

    It 'encodes a byte array' {
        $Result = New-GovUKNotifyFileAttachment -Bytes ([byte[]](1, 2, 3))
        $Result.file | Should -Be ([Convert]::ToBase64String([byte[]](1, 2, 3)))
    }

    It 'accepts already base64-encoded content' {
        $Result = New-GovUKNotifyFileAttachment -Base64Content 'YWJj'
        $Result.file | Should -Be 'YWJj'
    }

    It 'includes confirm_email_before_download only when specified' {
        $WithFlag = New-GovUKNotifyFileAttachment -Base64Content 'YWJj' -ConfirmEmailBeforeDownload $false
        $WithFlag.confirm_email_before_download | Should -BeFalse

        $WithoutFlag = New-GovUKNotifyFileAttachment -Base64Content 'YWJj'
        $WithoutFlag.ContainsKey('confirm_email_before_download') | Should -BeFalse
    }

    It 'includes a valid retention period' {
        $Result = New-GovUKNotifyFileAttachment -Base64Content 'YWJj' -RetentionPeriod '4 weeks'
        $Result.retention_period | Should -Be '4 weeks'
    }

    It 'rejects an invalid retention period' {
        { New-GovUKNotifyFileAttachment -Base64Content 'YWJj' -RetentionPeriod 'forever' } | Should -Throw
    }

    It 'uses an explicit filename over the file name' {
        $TempFile = Join-Path $TestDrive 'data.bin'
        Set-Content -Path $TempFile -Value 'x' -NoNewline
        $Result = New-GovUKNotifyFileAttachment -Path $TempFile -FileName 'custom.csv'
        $Result.filename | Should -Be 'custom.csv'
    }
}
