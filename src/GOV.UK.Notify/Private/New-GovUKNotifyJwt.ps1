function New-GovUKNotifyJwt {
    <#
        .SYNOPSIS
        Creates a short-lived JSON Web Token for GOV.UK Notify API authentication.

        .DESCRIPTION
        GOV.UK Notify authenticates requests with a JWT (HS256) carried in the Authorization header.
        The token's 'iss' claim is the service id and it is signed with the secret key, both of which
        are embedded in the API key using the format '{key_name}-{service_id}-{secret_key}', where
        service_id and secret_key are each UUIDs.

        The token's 'iat' (issued at) claim is the current UTC time in epoch seconds. GOV.UK Notify
        rejects tokens whose 'iat' is more than 30 seconds from its own clock, so a fresh token is
        generated for every request.

        This is an internal helper and is not exported by the module.

        .PARAMETER ApiKey
        The GOV.UK Notify API key, in the format '{key_name}-{service_id}-{secret_key}'.

        .OUTPUTS
        System.String. The encoded JWT.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Generates a token value in memory; it does not change any system state.')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiKey
    )

    # -- The key name may itself contain hyphens, so parse the two UUIDs from the end of the key.
    $Parts = $ApiKey -split '-'
    if ($Parts.Count -lt 11) {
        throw "Invalid GOV.UK Notify API key format. Expected '{key_name}-{service_id}-{secret_key}', where service_id and secret_key are UUIDs."
    }

    $SecretKey = ($Parts[-5..-1]) -join '-'
    $ServiceId = ($Parts[-10..-6]) -join '-'

    # -- Build the JWT header and payload.
    $Header = [ordered]@{ typ = 'JWT'; alg = 'HS256' } | ConvertTo-Json -Compress
    $Payload = [ordered]@{
        iss = $ServiceId
        iat = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    } | ConvertTo-Json -Compress

    $EncodedHeader = ConvertTo-GovUKNotifyBase64Url -Bytes ([System.Text.Encoding]::UTF8.GetBytes($Header))
    $EncodedPayload = ConvertTo-GovUKNotifyBase64Url -Bytes ([System.Text.Encoding]::UTF8.GetBytes($Payload))
    $SigningInput = "$EncodedHeader.$EncodedPayload"

    # -- Sign with HMAC-SHA256 using the secret key.
    $Hmac = [System.Security.Cryptography.HMACSHA256]::new([System.Text.Encoding]::UTF8.GetBytes($SecretKey))
    try {
        $SignatureBytes = $Hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($SigningInput))
    }
    finally {
        $Hmac.Dispose()
    }
    $EncodedSignature = ConvertTo-GovUKNotifyBase64Url -Bytes $SignatureBytes

    return "$SigningInput.$EncodedSignature"
}
