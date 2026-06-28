---
external help file: GovUKNotify-help.xml
Module Name: GovUKNotify
online version: https://docs.notifications.service.gov.uk/rest-api.html#send-a-file-by-email
schema: 2.0.0
---

# New-GovUKNotifyFileAttachment

## SYNOPSIS
Builds a file object for sending a file by email through GOV.UK Notify.

## SYNTAX

### Path (Default)
```
New-GovUKNotifyFileAttachment [-Path] <String> [-FileName <String>] [-ConfirmEmailBeforeDownload <Boolean>]
 [-RetentionPeriod <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Bytes
```
New-GovUKNotifyFileAttachment -Bytes <Byte[]> [-FileName <String>] [-ConfirmEmailBeforeDownload <Boolean>]
 [-RetentionPeriod <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Base64
```
New-GovUKNotifyFileAttachment -Base64Content <String> [-FileName <String>]
 [-ConfirmEmailBeforeDownload <Boolean>] [-RetentionPeriod <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Produces the hashtable that GOV.UK Notify expects for a "send a file by email" placeholder.
Assign the result to a template placeholder in the -Personalisation argument of
Send-GovUKNotifyEmail.
Supply the file as a path, a byte array, or an already base64-encoded
string.

## EXAMPLES

### EXAMPLE 1
```
$file = New-GovUKNotifyFileAttachment -Path ./report.csv -RetentionPeriod '4 weeks'
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{ link_to_file = $file }
```

## PARAMETERS

### -Base64Content
The file contents as an already base64-encoded string.

```yaml
Type: String
Parameter Sets: Base64
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Bytes
The file contents as a byte array.

```yaml
Type: Byte[]
Parameter Sets: Bytes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfirmEmailBeforeDownload
Whether the recipient must confirm their email address before downloading.
GOV.UK Notify
defaults this to true.
Set to $false to turn the check off (not recommended for sensitive files).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileName
The filename shown to the recipient.
Should include the correct file extension.

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

### -Path
Path to the file to attach.
The file is read and base64-encoded automatically, and its name is
used as the filename unless -FileName is given.

```yaml
Type: String
Parameter Sets: Path
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

### -RetentionPeriod
How long the file is available to download, for example '4 weeks'.
Allowed range is 1 to 78
weeks.
Defaults to 26 weeks at GOV.UK Notify if omitted.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable representing the file object.
## NOTES

## RELATED LINKS

[https://docs.notifications.service.gov.uk/rest-api.html#send-a-file-by-email](https://docs.notifications.service.gov.uk/rest-api.html#send-a-file-by-email)

