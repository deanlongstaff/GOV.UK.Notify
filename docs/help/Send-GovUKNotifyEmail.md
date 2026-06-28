---
external help file: GovUKNotify-help.xml
Module Name: GovUKNotify
online version: https://docs.notifications.service.gov.uk/rest-api.html#send-an-email
schema: 2.0.0
---

# Send-GovUKNotifyEmail

## SYNOPSIS
Sends an email using a GOV.UK Notify template.

## SYNTAX

```
Send-GovUKNotifyEmail [-EmailAddress] <String> [-TemplateId] <String> [[-Personalisation] <Hashtable>]
 [[-Reference] <String>] [[-EmailReplyToId] <String>] [[-OneClickUnsubscribeUrl] <String>]
 [[-SanitiseContentFor] <String[]>] [[-ApiKey] <String>] [[-BaseUrl] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Calls 'POST /v2/notifications/email' to send an email built from one of your GOV.UK Notify
templates.
To send a file by email, build the value for a template placeholder with
New-GovUKNotifyFileAttachment and include it in -Personalisation.

## EXAMPLES

### EXAMPLE 1
```
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ first_name = 'Amala' }
```

### EXAMPLE 2
```
$file = New-GovUKNotifyFileAttachment -Path ./invite.pdf
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }
```

## PARAMETERS

### -ApiKey
An explicit API key, overriding any connected session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseUrl
An explicit base URL, overriding any connected session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailAddress
The recipient's email address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailReplyToId
An optional reply-to address id configured on your service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OneClickUnsubscribeUrl
An optional one-click unsubscribe URL added to the email headers for subscription emails.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Personalisation
A hashtable of placeholder values for the template.
Values may be strings, arrays (rendered as
bullet points), or a file object from New-GovUKNotifyFileAttachment.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reference
An optional identifier for the message or batch.
Must not contain personal data.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanitiseContentFor
An optional list of personalisation keys whose content GOV.UK Notify should sanitise
(escape Markdown and remove URLs) to reduce the risk of malicious content injection.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateId
The id of the email template to use.
Copy it from the Templates page of the GOV.UK Notify
dashboard.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### The notification response object returned by GOV.UK Notify.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#send-an-email](https://docs.notifications.service.gov.uk/rest-api.html#send-an-email)

