---
external help file: GovUKNotify-help.xml
Module Name: GovUKNotify
online version: https://docs.notifications.service.gov.uk/rest-api.html#send-a-text-message
schema: 2.0.0
---

# Send-GovUKNotifySms

## SYNOPSIS
Sends a text message using a GOV.UK Notify template.

## SYNTAX

```
Send-GovUKNotifySms [-PhoneNumber] <String> [-TemplateId] <String> [[-Personalisation] <Hashtable>]
 [[-Reference] <String>] [[-SmsSenderId] <String>] [[-ApiKey] <String>] [[-BaseUrl] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Calls 'POST /v2/notifications/sms' to send a text message built from one of your GOV.UK Notify
templates.

## EXAMPLES

### EXAMPLE 1
```
Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId $tid -Personalisation @{ code = '123456' }
```

## PARAMETERS

### -ApiKey
An explicit API key, overriding any connected session.

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

### -BaseUrl
An explicit base URL, overriding any connected session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Personalisation
A hashtable of placeholder values for the template.

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

### -PhoneNumber
The recipient's phone number.
This can be a UK or international number.

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

### -SmsSenderId
An optional text message sender id configured on your service.
Omit to use the default sender.

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

### -TemplateId
The id of the text message template to use.

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

[https://docs.notifications.service.gov.uk/rest-api.html#send-a-text-message](https://docs.notifications.service.gov.uk/rest-api.html#send-a-text-message)

