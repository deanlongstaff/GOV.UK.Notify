---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#get-received-text-messages
schema: 2.0.0
---

# Get-GovUKNotifyReceivedText

## SYNOPSIS
Retrieves text messages received by your GOV.UK Notify service.

## SYNTAX

```
Get-GovUKNotifyReceivedText [[-OlderThan] <String>] [-All] [[-ApiKey] <String>] [[-BaseUrl] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Calls 'GET /v2/received-text-messages' and returns received text messages, most recent first.
Each page returns up to 250 messages; use -All to follow pagination and return every message.
You can only retrieve messages that are 7 days old or newer.
Receiving text messages must be
enabled in your service settings.

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyReceivedText -All
```

## PARAMETERS

### -All
Follow pagination and return every received text message, not just the first page of up to 250.

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

### -ApiKey
An explicit API key, overriding any connected session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OlderThan
Return received text messages older than this message id (pagination).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### A stream of received text message objects.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#get-received-text-messages](https://docs.notifications.service.gov.uk/rest-api.html#get-received-text-messages)

