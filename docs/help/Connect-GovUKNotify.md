---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#api-keys
schema: 2.0.0
---

# Connect-GovUKNotify

## SYNOPSIS
Stores a GOV.UK Notify API key for the current session.

## SYNTAX

```
Connect-GovUKNotify [-ApiKey] <String> [[-BaseUrl] <String>] [-PassThru] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Validates the supplied API key and stores it, together with the base URL, in the module
session context.
Once connected, the other GOV.UK.Notify cmdlets can be called without passing
an API key.
The key is held in memory only and is never written to disk.

Each command still accepts an explicit -ApiKey, which overrides the connected session.
This is
useful when you need to work with more than one Notify service in the same session.

## EXAMPLES

### EXAMPLE 1
```
Connect-GovUKNotify -ApiKey $env:GOVUKNOTIFY_API_KEY
```

Connects using an API key held in an environment variable.

### EXAMPLE 2
```
Connect-GovUKNotify -ApiKey $key -PassThru
```

Connects and returns the masked connection context.

## PARAMETERS

### -ApiKey
The GOV.UK Notify API key, in the format '{key_name}-{service_id}-{secret_key}'.
Create API
keys on the API integration page of the GOV.UK Notify dashboard.

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

### -BaseUrl
The API base URL.
Defaults to the production endpoint
'https://api.notifications.service.gov.uk'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://api.notifications.service.gov.uk
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return the resulting (masked) connection context.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None by default, or a PSCustomObject describing the connection when -PassThru is used.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#api-keys](https://docs.notifications.service.gov.uk/rest-api.html#api-keys)

