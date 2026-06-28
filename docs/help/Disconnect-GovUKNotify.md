---
external help file: GOV.UK.Notify-help.xml
Module Name: GOV.UK.Notify
online version: https://github.com/deanlongstaff/GOV.UK.Notify
schema: 2.0.0
---

# Disconnect-GovUKNotify

## SYNOPSIS
Clears the stored GOV.UK Notify connection for the current session.

## SYNTAX

```
Disconnect-GovUKNotify [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes the API key and base URL stored by Connect-GovUKNotify from the module session
context.
After disconnecting, cmdlets require an explicit -ApiKey again.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-GovUKNotify
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

### None.
## NOTES

## RELATED LINKS

[https://github.com/deanlongstaff/GOV.UK.Notify](https://github.com/deanlongstaff/GOV.UK.Notify)

