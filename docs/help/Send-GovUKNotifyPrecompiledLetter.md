---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#send-a-precompiled-letter
schema: 2.0.0
---

# Send-GovUKNotifyPrecompiledLetter

## SYNOPSIS
Sends a precompiled (PDF) letter through GOV.UK Notify.

## SYNTAX

### Path (Default)
```
Send-GovUKNotifyPrecompiledLetter -Reference <String> -Path <String> [-Postage <String>] [-ApiKey <String>]
 [-BaseUrl <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Content
```
Send-GovUKNotifyPrecompiledLetter -Reference <String> -Content <String> [-Postage <String>] [-ApiKey <String>]
 [-BaseUrl <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Calls 'POST /v2/notifications/letter' with a base64-encoded PDF.
Supply the letter either as a
file with -Path (which is read and encoded for you) or as an already base64-encoded string with
-Content.
The PDF must meet the GOV.UK Notify letter specification.
Your service must be live
and you must use a live API key (not a team key).

## EXAMPLES

### EXAMPLE 1
```
Send-GovUKNotifyPrecompiledLetter -Reference 'batch-001' -Path ./letter.pdf -Postage first
```

## PARAMETERS

### -ApiKey
An explicit API key, overriding any connected session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
An already base64-encoded PDF string.

```yaml
Type: String
Parameter Sets: Content
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to a PDF file to send.
The file is read and base64-encoded automatically.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Postage
Optional postage class: 'first', 'second' or 'economy'.
Defaults to second class at GOV.UK
Notify if omitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
A required identifier for the letter or batch.
Must not contain personal data.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

[https://docs.notifications.service.gov.uk/rest-api.html#send-a-precompiled-letter](https://docs.notifications.service.gov.uk/rest-api.html#send-a-precompiled-letter)

