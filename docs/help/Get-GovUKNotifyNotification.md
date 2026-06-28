---
external help file: GovUKNotify-help.xml
Module Name: GovUKNotify
online version: https://docs.notifications.service.gov.uk/rest-api.html#get-message-data
schema: 2.0.0
---

# Get-GovUKNotifyNotification

## SYNOPSIS
Retrieves the data for one or more GOV.UK Notify messages.

## SYNTAX

### List (Default)
```
Get-GovUKNotifyNotification [-TemplateType <String>] [-Status <String[]>] [-Reference <String>]
 [-OlderThan <String>] [-IncludeJobs] [-All] [-ApiKey <String>] [-BaseUrl <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-GovUKNotifyNotification [-NotificationId] <String> [-ApiKey <String>] [-BaseUrl <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
With -NotificationId, calls 'GET /v2/notifications/{id}' and returns a single message.
Otherwise calls 'GET /v2/notifications' and returns messages, optionally filtered by template
type, status, and reference.
Each page returns up to 250 messages; use -All to follow
pagination and return every matching message.
You can only retrieve messages within your data
retention period (7 days by default).

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyNotification -NotificationId '740e5834-3a29-46b4-9a6f-16142fde533a'
```

### EXAMPLE 2
```
Get-GovUKNotifyNotification -TemplateType email -Status delivered -All
```

## PARAMETERS

### -All
Follow pagination and return every matching message, not just the first page of up to 250.

```yaml
Type: SwitchParameter
Parameter Sets: List
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

### -IncludeJobs
Include notifications sent as part of a batch (bulk) upload.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotificationId
The id of a single notification to retrieve.

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

### -OlderThan
Return messages older than this notification id (pagination).

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
Filter the list by the reference you supplied when sending.

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

### -Status
Filter the list by one or more delivery statuses, for example 'delivered' or 'permanent-failure'.

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateType
Filter the list by template type: 'email', 'sms' or 'letter'.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### A single notification object, or a stream of notification objects for the list.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#get-message-data](https://docs.notifications.service.gov.uk/rest-api.html#get-message-data)

