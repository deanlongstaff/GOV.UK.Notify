---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#get-a-template
schema: 2.0.0
---

# Get-GovUKNotifyTemplate

## SYNOPSIS
Retrieves one template, a specific template version, or all templates.

## SYNTAX

### List (Default)
```
Get-GovUKNotifyTemplate [-Type <String>] [-ApiKey <String>] [-BaseUrl <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-GovUKNotifyTemplate [-TemplateId] <String> [-Version <Int32>] [-ApiKey <String>] [-BaseUrl <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
With -TemplateId, calls 'GET /v2/template/{id}' for the latest version, or
'GET /v2/template/{id}/version/{version}' when -Version is also supplied.
Without -TemplateId,
calls 'GET /v2/templates' and returns all templates, optionally filtered by -Type.

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyTemplate -TemplateId $tid
```

### EXAMPLE 2
```
Get-GovUKNotifyTemplate -TemplateId $tid -Version 2
```

### EXAMPLE 3
```
Get-GovUKNotifyTemplate -Type email
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
The id of a single template to retrieve.

```yaml
Type: String
Parameter Sets: Single
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Filter the list of all templates by type: 'email', 'sms' or 'letter'.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
A specific version number of the template to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### A single template object, or a stream of template objects for the list.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#get-a-template](https://docs.notifications.service.gov.uk/rest-api.html#get-a-template)

