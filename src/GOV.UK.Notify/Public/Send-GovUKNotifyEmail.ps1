function Send-GovUKNotifyEmail {
    <#
        .SYNOPSIS
        Sends an email using a GOV.UK Notify template.

        .DESCRIPTION
        Calls 'POST /v2/notifications/email' to send an email built from one of your GOV.UK Notify
        templates. To send a file by email, build the value for a template placeholder with
        New-GovUKNotifyFileAttachment and include it in -Personalisation.

        .PARAMETER EmailAddress
        The recipient's email address.

        .PARAMETER TemplateId
        The id of the email template to use. Copy it from the Templates page of the GOV.UK Notify
        dashboard.

        .PARAMETER Personalisation
        A hashtable of placeholder values for the template. Values may be strings, arrays (rendered as
        bullet points), or a file object from New-GovUKNotifyFileAttachment.

        .PARAMETER Reference
        An optional identifier for the message or batch. Must not contain personal data.

        .PARAMETER EmailReplyToId
        An optional reply-to address id configured on your service.

        .PARAMETER OneClickUnsubscribeUrl
        An optional one-click unsubscribe URL added to the email headers for subscription emails.

        .PARAMETER SanitiseContentFor
        An optional list of personalisation keys whose content GOV.UK Notify should sanitise
        (escape Markdown and remove URLs) to reduce the risk of malicious content injection.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ first_name = 'Amala' }

        .EXAMPLE
        $file = New-GovUKNotifyFileAttachment -Path ./invite.pdf
        Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }

        .OUTPUTS
        The notification response object returned by GOV.UK Notify.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#send-an-email
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$EmailAddress,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,

        [Parameter()]
        [hashtable]$Personalisation,

        [Parameter()]
        [string]$Reference,

        [Parameter()]
        [string]$EmailReplyToId,

        [Parameter()]
        [string]$OneClickUnsubscribeUrl,

        [Parameter()]
        [string[]]$SanitiseContentFor,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $Body = @{
        email_address = $EmailAddress
        template_id   = $TemplateId
    }
    if ($Personalisation) { $Body.personalisation = $Personalisation }
    if ($Reference) { $Body.reference = $Reference }
    if ($EmailReplyToId) { $Body.email_reply_to_id = $EmailReplyToId }
    if ($OneClickUnsubscribeUrl) { $Body.one_click_unsubscribe_url = $OneClickUnsubscribeUrl }
    if ($SanitiseContentFor) { $Body.sanitise_content_for = $SanitiseContentFor }

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ShouldProcess($EmailAddress, 'Send GOV.UK Notify email')) {
        return Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/email' -Body $Body @ConnectionParams
    }
}
