function Get-GovUKNotifyLetterPdf {
    <#
        .SYNOPSIS
        Retrieves the PDF contents of a GOV.UK Notify letter notification.

        .DESCRIPTION
        Calls 'GET /v2/notifications/{id}/pdf' and returns the raw PDF bytes, or writes them to a file
        with -OutFile. The PDF is only available once the letter has finished processing and has passed
        its virus scan.

        .PARAMETER NotificationId
        The id of the letter notification.

        .PARAMETER OutFile
        Optional path to write the PDF to. When supplied, no bytes are returned.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Get-GovUKNotifyLetterPdf -NotificationId $id -OutFile ./letter.pdf

        .OUTPUTS
        System.Byte[] when -OutFile is not used; otherwise nothing.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#get-a-pdf-for-a-letter-notification
    #>
    [CmdletBinding()]
    [OutputType([byte[]])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$NotificationId,

        [Parameter()]
        [string]$OutFile,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    $Bytes = Invoke-GovUKNotifyApi -Method 'GET' -Path "/v2/notifications/$NotificationId/pdf" -Raw @ConnectionParams

    if ($PSBoundParameters.ContainsKey('OutFile') -and -not [string]::IsNullOrWhiteSpace($OutFile)) {
        $ResolvedPath = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($OutFile)
        [System.IO.File]::WriteAllBytes($ResolvedPath, $Bytes)
        Write-Verbose "Saved letter PDF to $ResolvedPath."
        return
    }

    # -- Return the byte array as a single object rather than streaming individual bytes.
    return , $Bytes
}
