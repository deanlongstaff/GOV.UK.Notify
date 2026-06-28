function Get-GovUKNotifyContext {
    <#
        .SYNOPSIS
        Returns the current GOV.UK Notify connection context.

        .DESCRIPTION
        Returns a summary of the connection established by Connect-GovUKNotify, including the key name,
        service id and base URL. The API key itself is never returned in full; only the last four
        characters are shown. Returns $null when there is no active connection.

        .EXAMPLE
        Get-GovUKNotifyContext

        .OUTPUTS
        System.Management.Automation.PSCustomObject, or $null when not connected.

        .LINK
        https://github.com/deanlongstaff/GOV.UK.Notify
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    if ($null -eq $script:GovUKNotifyContext) {
        Write-Verbose 'No active GOV.UK Notify connection.'
        return $null
    }

    $Key = [string]$script:GovUKNotifyContext.ApiKey
    $Ending = if ($Key.Length -ge 4) { $Key.Substring($Key.Length - 4) } else { $Key }

    return [pscustomobject]@{
        PSTypeName   = 'GovUKNotify.Context'
        KeyName      = $script:GovUKNotifyContext.KeyName
        ServiceId    = $script:GovUKNotifyContext.ServiceId
        BaseUrl      = $script:GovUKNotifyContext.BaseUrl
        ApiKeyEnding = $Ending
    }
}
