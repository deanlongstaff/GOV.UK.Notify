function Send-GovUKNotifyLetter {
    <#
        .SYNOPSIS
        Sends a letter using a GOV.UK Notify template.

        .DESCRIPTION
        Calls 'POST /v2/notifications/letter' to send a letter built from one of your GOV.UK Notify
        templates. The -Personalisation hashtable must include the recipient's address as
        'address_line_1' through 'address_line_7'. The address must have at least 3 lines; the first
        two lines must contain alphanumeric characters and the last line must be a real UK postcode or
        the name of a country outside the UK.

        Your service must be live to send letters.

        .PARAMETER TemplateId
        The id of the letter template to use.

        .PARAMETER Personalisation
        A hashtable of placeholder values, including the required address lines and any other template
        placeholders.

        .PARAMETER Reference
        An optional identifier for the letter or batch. Must not contain personal data.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        $address = @{
            address_line_1 = 'Amala Bird'
            address_line_2 = '123 High Street'
            address_line_3 = 'SW14 6BH'
        }
        Send-GovUKNotifyLetter -TemplateId $tid -Personalisation $address

        .OUTPUTS
        The notification response object returned by GOV.UK Notify.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#send-a-letter
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [hashtable]$Personalisation,

        [Parameter()]
        [string]$Reference,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $Body = @{
        template_id     = $TemplateId
        personalisation = $Personalisation
    }
    if ($Reference) { $Body.reference = $Reference }

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ShouldProcess("letter template $TemplateId", 'Send GOV.UK Notify letter')) {
        return Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/letter' -Body $Body @ConnectionParams
    }
}
