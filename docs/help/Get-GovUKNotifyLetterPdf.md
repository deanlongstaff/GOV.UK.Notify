---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://docs.notifications.service.gov.uk/rest-api.html#get-a-pdf-for-a-letter-notification
schema: 2.0.0
---

# Get-GovUKNotifyLetterPdf

## SYNOPSIS
Retrieves the PDF contents of a GOV.UK Notify letter notification.

## SYNTAX

```
Get-GovUKNotifyLetterPdf [-NotificationId] <String> [-OutFile <String>] [-ApiKey <String>] [-BaseUrl <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Calls 'GET /v2/notifications/{id}/pdf' and returns the raw PDF bytes, or writes them to a file
with -OutFile.
The PDF is only available once the letter has finished processing and has passed
its virus scan.

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyLetterPdf -NotificationId $id -OutFile ./letter.pdf
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

### -NotificationId
The id of the letter notification.

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

### -OutFile
Optional path to write the PDF to.
When supplied, no bytes are returned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Byte[] when -OutFile is not used; otherwise nothing.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#get-a-pdf-for-a-letter-notification](https://docs.notifications.service.gov.uk/rest-api.html#get-a-pdf-for-a-letter-notification)

