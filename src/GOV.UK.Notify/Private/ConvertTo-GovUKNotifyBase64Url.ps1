function ConvertTo-GovUKNotifyBase64Url {
    <#
        .SYNOPSIS
        Encodes a byte array as a base64url string (RFC 7515) with padding removed.

        .DESCRIPTION
        Internal helper used when building JSON Web Tokens. Converts standard base64 to the
        URL-safe alphabet ('+' -> '-', '/' -> '_') and strips '=' padding.

        .PARAMETER Bytes
        The bytes to encode.

        .OUTPUTS
        System.String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [byte[]]$Bytes
    )

    return [Convert]::ToBase64String($Bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
}
