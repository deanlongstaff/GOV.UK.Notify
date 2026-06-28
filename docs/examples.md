# Examples

A scenario-based companion to the cmdlet help. Run `Get-Help <cmdlet> -Full` for full parameter
details.

## Connecting

```powershell
# Connect for the session (recommended).
Connect-GovUKNotify -ApiKey $env:GOVUKNOTIFY_API_KEY

# Inspect the connection (the API key is masked).
Get-GovUKNotifyContext

# Disconnect when finished.
Disconnect-GovUKNotify
```

To work with multiple services, skip `Connect-GovUKNotify` and pass `-ApiKey` per call.

## Email

```powershell
# Minimal.
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid

# With personalisation, a reply-to address and a reference.
Send-GovUKNotifyEmail `
    -EmailAddress 'amala@example.com' `
    -TemplateId   $tid `
    -Personalisation @{ first_name = 'Amala'; required_documents = @('passport', 'utility bill') } `
    -EmailReplyToId $replyToId `
    -Reference 'welcome-batch-2025-01'

# Subscription email with a one-click unsubscribe link.
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid `
    -OneClickUnsubscribeUrl 'https://example.com/unsubscribe?opaque=abc123'

# Sanitise untrusted personalisation values.
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid `
    -Personalisation @{ name = $untrustedInput } -SanitiseContentFor 'name'
```

### Send a file by email

```powershell
# From a path (filename defaults to the file's name).
$file = New-GovUKNotifyFileAttachment -Path ./invoice.pdf
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }

# Control retention and turn off the email-confirmation check (not recommended for sensitive files).
$file = New-GovUKNotifyFileAttachment -Path ./report.csv -RetentionPeriod '4 weeks' -ConfirmEmailBeforeDownload $false
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }
```

## Text messages

```powershell
Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId $tid -Personalisation @{ code = '123456' }

# Use a specific sender id.
Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId $tid -SmsSenderId $senderId
```

## Letters

```powershell
# Template letter (the address lines are required personalisation).
Send-GovUKNotifyLetter -TemplateId $tid -Personalisation @{
    address_line_1 = 'Amala Bird'
    address_line_2 = '123 High Street'
    address_line_3 = 'London'
    address_line_4 = 'SW14 6BH'
    name           = 'Amala'
}

# Precompiled PDF letter from a file.
Send-GovUKNotifyPrecompiledLetter -Reference 'batch-001' -Path ./letter.pdf -Postage first
```

## Message status

```powershell
# Single message.
Get-GovUKNotifyNotification -NotificationId '740e5834-3a29-46b4-9a6f-16142fde533a'

# Filtered list (first page of up to 250).
Get-GovUKNotifyNotification -TemplateType email -Status delivered, sending -Reference 'welcome-batch-2025-01'

# Every matching message, following pagination.
Get-GovUKNotifyNotification -TemplateType sms -All

# Download a letter's PDF.
Get-GovUKNotifyLetterPdf -NotificationId $id -OutFile ./letter.pdf
```

## Templates

```powershell
# Latest version of one template.
Get-GovUKNotifyTemplate -TemplateId $tid

# A specific version.
Get-GovUKNotifyTemplate -TemplateId $tid -Version 2

# All email templates.
Get-GovUKNotifyTemplate -Type email

# Render a preview.
Get-GovUKNotifyTemplatePreview -TemplateId $tid -Personalisation @{ first_name = 'Amala' }
```

## Inbound text messages

```powershell
# Most recent page.
Get-GovUKNotifyReceivedText

# Everything, following pagination.
Get-GovUKNotifyReceivedText -All
```

## Error handling

```powershell
try {
    Send-GovUKNotifyEmail -EmailAddress 'not-an-email' -TemplateId $tid
}
catch {
    # The message contains the HTTP status code and the Notify error type.
    Write-Warning $_.Exception.Message
}
```
