---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://github.com/deanlongstaff/GOV.UK.Notify
schema: 2.0.0
---

# Get-GovUKNotifyContext

## SYNOPSIS
Returns the current GOV.UK Notify connection context.

## SYNTAX

```
Get-GovUKNotifyContext [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns a summary of the connection established by Connect-GovUKNotify, including the key name,
service id and base URL.
The API key itself is never returned in full; only the last four
characters are shown.
Returns $null when there is no active connection.

## EXAMPLES

### EXAMPLE 1
```
Get-GovUKNotifyContext
```

## PARAMETERS

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

### System.Management.Automation.PSCustomObject, or $null when not connected.
## NOTES

## RELATED LINKS

[https://github.com/deanlongstaff/GOV.UK.Notify](https://github.com/deanlongstaff/GOV.UK.Notify)

