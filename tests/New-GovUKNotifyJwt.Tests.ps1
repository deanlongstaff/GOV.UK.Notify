#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for the private New-GovUKNotifyJwt helper.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GovUKNotify/GovUKNotify.psd1" -Force

    # -- A well-formed test key: {key_name}-{service_id (5 parts)}-{secret_key (5 parts)}.
    $script:TestKey = 'testkey-26785a09-ab16-4eb0-8407-a37497a57506-3d844edf-8d35-48ac-975b-e847b4f122b0'

    function ConvertFrom-Base64Url {
        param([string]$Value)
        $Value = $Value.Replace('-', '+').Replace('_', '/')
        switch ($Value.Length % 4) {
            2 { $Value += '==' }
            3 { $Value += '=' }
        }
        return [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
    }
}

Describe 'New-GovUKNotifyJwt' {

    It 'throws when the API key has too few parts' {
        InModuleScope GovUKNotify {
            { New-GovUKNotifyJwt -ApiKey 'not-a-valid-key' } | Should -Throw '*Invalid GOV.UK Notify API key format*'
        }
    }

    It 'returns a token with three dot-separated parts' {
        $Token = InModuleScope GovUKNotify -Parameters @{ Key = $script:TestKey } { param($Key) New-GovUKNotifyJwt -ApiKey $Key }
        ($Token -split '\.').Count | Should -Be 3
    }

    It 'encodes the JWT header with typ and alg' {
        $Token = InModuleScope GovUKNotify -Parameters @{ Key = $script:TestKey } { param($Key) New-GovUKNotifyJwt -ApiKey $Key }
        $Header = ConvertFrom-Base64Url -Value ($Token -split '\.')[0] | ConvertFrom-Json
        $Header.typ | Should -Be 'JWT'
        $Header.alg | Should -Be 'HS256'
    }

    It 'sets the iss claim to the service id extracted from the key' {
        $Token = InModuleScope GovUKNotify -Parameters @{ Key = $script:TestKey } { param($Key) New-GovUKNotifyJwt -ApiKey $Key }
        $Payload = ConvertFrom-Base64Url -Value ($Token -split '\.')[1] | ConvertFrom-Json
        $Payload.iss | Should -Be '26785a09-ab16-4eb0-8407-a37497a57506'
    }

    It 'sets the iat claim to a recent epoch time' {
        $Token = InModuleScope GovUKNotify -Parameters @{ Key = $script:TestKey } { param($Key) New-GovUKNotifyJwt -ApiKey $Key }
        $Payload = ConvertFrom-Base64Url -Value ($Token -split '\.')[1] | ConvertFrom-Json
        $Now = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
        [Math]::Abs($Now - [int64]$Payload.iat) | Should -BeLessThan 30
    }

    It 'correctly parses a key whose name contains hyphens' {
        $KeyWithHyphenName = 'my-test-key-26785a09-ab16-4eb0-8407-a37497a57506-3d844edf-8d35-48ac-975b-e847b4f122b0'
        $Token = InModuleScope GovUKNotify -Parameters @{ Key = $KeyWithHyphenName } { param($Key) New-GovUKNotifyJwt -ApiKey $Key }
        $Payload = ConvertFrom-Base64Url -Value ($Token -split '\.')[1] | ConvertFrom-Json
        $Payload.iss | Should -Be '26785a09-ab16-4eb0-8407-a37497a57506'
    }
}
