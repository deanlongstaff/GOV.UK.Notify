function Get-GovUKNotifyTemplatePreview {
    <#
        .SYNOPSIS
        Generates a preview of a GOV.UK Notify template with personalisation applied.

        .DESCRIPTION
        Calls 'POST /v2/template/{id}/preview' to render a template with the supplied personalisation
        and returns the resulting subject, body and (for emails) HTML. The keys in -Personalisation
        must match the template's placeholder fields; extra keys are ignored by GOV.UK Notify.

        .PARAMETER TemplateId
        The id of the template to preview.

        .PARAMETER Personalisation
        A hashtable of placeholder values for the template.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Get-GovUKNotifyTemplatePreview -TemplateId $tid -Personalisation @{ first_name = 'Amala' }

        .OUTPUTS
        The rendered template preview object returned by GOV.UK Notify.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#generate-a-preview-template
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,

        [Parameter()]
        [hashtable]$Personalisation,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $Body = @{
        personalisation = if ($Personalisation) { $Personalisation } else { @{} }
    }

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    return Invoke-GovUKNotifyApi -Method 'POST' -Path "/v2/template/$TemplateId/preview" -Body $Body @ConnectionParams
}
