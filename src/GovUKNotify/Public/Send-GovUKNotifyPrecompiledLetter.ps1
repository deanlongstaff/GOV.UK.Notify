function Send-GovUKNotifyPrecompiledLetter {
    <#
        .SYNOPSIS
        Sends a precompiled (PDF) letter through GOV.UK Notify.

        .DESCRIPTION
        Calls 'POST /v2/notifications/letter' with a base64-encoded PDF. Supply the letter either as a
        file with -Path (which is read and encoded for you) or as an already base64-encoded string with
        -Content. The PDF must meet the GOV.UK Notify letter specification. Your service must be live
        and you must use a live API key (not a team key).

        .PARAMETER Reference
        A required identifier for the letter or batch. Must not contain personal data.

        .PARAMETER Path
        Path to a PDF file to send. The file is read and base64-encoded automatically.

        .PARAMETER Content
        An already base64-encoded PDF string.

        .PARAMETER Postage
        Optional postage class: 'first', 'second' or 'economy'. Defaults to second class at GOV.UK
        Notify if omitted.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Send-GovUKNotifyPrecompiledLetter -Reference 'batch-001' -Path ./letter.pdf -Postage first

        .OUTPUTS
        The notification response object returned by GOV.UK Notify.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#send-a-precompiled-letter
    #>
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Reference,

        [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'Content')]
        [ValidateNotNullOrEmpty()]
        [string]$Content,

        [Parameter()]
        [ValidateSet('first', 'second', 'economy')]
        [string]$Postage,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $ResolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
        $Bytes = [System.IO.File]::ReadAllBytes($ResolvedPath)
        $Content = [Convert]::ToBase64String($Bytes)
    }

    $Body = @{
        reference = $Reference
        content   = $Content
    }
    if ($Postage) { $Body.postage = $Postage }

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ShouldProcess("precompiled letter '$Reference'", 'Send GOV.UK Notify precompiled letter')) {
        return Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/letter' -Body $Body @ConnectionParams
    }
}
