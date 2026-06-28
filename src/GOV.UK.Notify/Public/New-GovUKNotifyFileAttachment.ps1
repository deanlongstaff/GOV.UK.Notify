function New-GovUKNotifyFileAttachment {
    <#
        .SYNOPSIS
        Builds a file object for sending a file by email through GOV.UK Notify.

        .DESCRIPTION
        Produces the hashtable that GOV.UK Notify expects for a "send a file by email" placeholder.
        Assign the result to a template placeholder in the -Personalisation argument of
        Send-GovUKNotifyEmail. Supply the file as a path, a byte array, or an already base64-encoded
        string.

        .PARAMETER Path
        Path to the file to attach. The file is read and base64-encoded automatically, and its name is
        used as the filename unless -FileName is given.

        .PARAMETER Bytes
        The file contents as a byte array.

        .PARAMETER Base64Content
        The file contents as an already base64-encoded string.

        .PARAMETER FileName
        The filename shown to the recipient. Should include the correct file extension.

        .PARAMETER ConfirmEmailBeforeDownload
        Whether the recipient must confirm their email address before downloading. GOV.UK Notify
        defaults this to true. Set to $false to turn the check off (not recommended for sensitive files).

        .PARAMETER RetentionPeriod
        How long the file is available to download, for example '4 weeks'. Allowed range is 1 to 78
        weeks. Defaults to 26 weeks at GOV.UK Notify if omitted.

        .EXAMPLE
        $file = New-GovUKNotifyFileAttachment -Path ./report.csv -RetentionPeriod '4 weeks'
        Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }

        .OUTPUTS
        System.Collections.Hashtable representing the file object.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#send-a-file-by-email
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Builds an in-memory personalisation object; it does not change any system state.')]
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Path', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'Bytes')]
        [ValidateNotNull()]
        [byte[]]$Bytes,

        [Parameter(Mandatory = $true, ParameterSetName = 'Base64')]
        [ValidateNotNullOrEmpty()]
        [string]$Base64Content,

        [Parameter()]
        [string]$FileName,

        [Parameter()]
        [bool]$ConfirmEmailBeforeDownload,

        [Parameter()]
        [ValidatePattern('^\d+\s+weeks?$')]
        [string]$RetentionPeriod
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            $ResolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
            $FileBytes = [System.IO.File]::ReadAllBytes($ResolvedPath)
            $EncodedContent = [Convert]::ToBase64String($FileBytes)
            if (-not $PSBoundParameters.ContainsKey('FileName')) {
                $FileName = [System.IO.Path]::GetFileName($ResolvedPath)
            }
        }
        'Bytes' {
            $EncodedContent = [Convert]::ToBase64String($Bytes)
        }
        'Base64' {
            $EncodedContent = $Base64Content
        }
    }

    $Attachment = @{ file = $EncodedContent }
    if ($FileName) { $Attachment.filename = $FileName }
    if ($PSBoundParameters.ContainsKey('ConfirmEmailBeforeDownload')) {
        $Attachment.confirm_email_before_download = $ConfirmEmailBeforeDownload
    }
    if ($RetentionPeriod) { $Attachment.retention_period = $RetentionPeriod }

    return $Attachment
}
