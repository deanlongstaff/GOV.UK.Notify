---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#generate-a-preview-template
schema: 2.0.0
---

# Get-GovUKNotifyTemplatePreview

## SYNOPSIS
Generates a preview of a GOV.UK Notify template with personalisation applied.

## SYNTAX

```
Get-GovUKNotifyTemplatePreview [-TemplateId] <String> [-Personalisation <Hashtable>] [-ApiKey <String>]
 [-BaseUrl <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Calls 'POST /v2/template/{id}/preview' to render a template with the supplied personalisation
and returns the resulting subject, body and (for emails) HTML.
The keys in -Personalisation
must match the template's placeholder fields; extra keys are ignored by GOV.UK Notify.

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyTemplatePreview -TemplateId $tid -Personalisation @{ first_name = 'Amala' }
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

### -Personalisation
A hashtable of placeholder values for the template.

```yaml
Type: Hashtable
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

### -TemplateId
The id of the template to preview.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### The rendered template preview object returned by GOV.UK Notify.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#generate-a-preview-template](https://docs.notifications.service.gov.uk/rest-api.html#generate-a-preview-template)

