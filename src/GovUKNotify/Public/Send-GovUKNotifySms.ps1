function Send-GovUKNotifySms {
    <#
        .SYNOPSIS
        Sends a text message using a GOV.UK Notify template.

        .DESCRIPTION
        Calls 'POST /v2/notifications/sms' to send a text message built from one of your GOV.UK Notify
        templates.

        .PARAMETER PhoneNumber
        The recipient's phone number. This can be a UK or international number.

        .PARAMETER TemplateId
        The id of the text message template to use.

        .PARAMETER Personalisation
        A hashtable of placeholder values for the template.

        .PARAMETER Reference
        An optional identifier for the message or batch. Must not contain personal data.

        .PARAMETER SmsSenderId
        An optional text message sender id configured on your service. Omit to use the default sender.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId $tid -Personalisation @{ code = '123456' }

        .OUTPUTS
        The notification response object returned by GOV.UK Notify.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#send-a-text-message
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'SMS is an acronym, not a plural noun.')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$PhoneNumber,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,

        [Parameter()]
        [hashtable]$Personalisation,

        [Parameter()]
        [string]$Reference,

        [Parameter()]
        [string]$SmsSenderId,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $Body = @{
        phone_number = $PhoneNumber
        template_id  = $TemplateId
    }
    if ($Personalisation) { $Body.personalisation = $Personalisation }
    if ($Reference) { $Body.reference = $Reference }
    if ($SmsSenderId) { $Body.sms_sender_id = $SmsSenderId }

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ShouldProcess($PhoneNumber, 'Send GOV.UK Notify text message')) {
        return Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/sms' -Body $Body @ConnectionParams
    }
}
