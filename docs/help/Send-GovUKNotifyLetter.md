---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#send-a-letter
schema: 2.0.0
---

# Send-GovUKNotifyLetter

## SYNOPSIS
Sends a letter using a GOV.UK Notify template.

## SYNTAX

```
Send-GovUKNotifyLetter [-TemplateId] <String> [-Personalisation] <Hashtable> [[-Reference] <String>]
 [[-ApiKey] <String>] [[-BaseUrl] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Calls 'POST /v2/notifications/letter' to send a letter built from one of your GOV.UK Notify
templates.
The -Personalisation hashtable must include the recipient's address as
'address_line_1' through 'address_line_7'.
The address must have at least 3 lines; the first
two lines must contain alphanumeric characters and the last line must be a real UK postcode or
the name of a country outside the UK.

Your service must be live to send letters.

## EXAMPLES

### EXAMPLE 1
```
$address = @{
    address_line_1 = 'Amala Bird'
    address_line_2 = '123 High Street'
    address_line_3 = 'SW14 6BH'
}
Send-GovUKNotifyLetter -TemplateId $tid -Personalisation $address
```

## PARAMETERS

### -ApiKey
An explicit API key, overriding any connected session.

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

### -BaseUrl
An explicit base URL, overriding any connected session.

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

### -Personalisation
A hashtable of placeholder values, including the required address lines and any other template
placeholders.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
An optional identifier for the letter or batch.
Must not contain personal data.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateId
The id of the letter template to use.

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

[https://docs.notifications.service.gov.uk/rest-api.html#send-a-letter](https://docs.notifications.service.gov.uk/rest-api.html#send-a-letter)

