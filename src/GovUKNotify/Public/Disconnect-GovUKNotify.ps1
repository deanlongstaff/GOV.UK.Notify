function Disconnect-GovUKNotify {
    <#
        .SYNOPSIS
        Clears the stored GOV.UK Notify connection for the current session.

        .DESCRIPTION
        Removes the API key and base URL stored by Connect-GovUKNotify from the module session
        context. After disconnecting, cmdlets require an explicit -ApiKey again.

        .EXAMPLE
        Disconnect-GovUKNotify

        .OUTPUTS
        None.

        .LINK
        https://github.com/deanlongstaff/GOV.UK.Notify
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    if ($null -eq $script:GovUKNotifyContext) {
        Write-Verbose 'No active GOV.UK Notify connection to disconnect.'
        return
    }

    if ($PSCmdlet.ShouldProcess('GOV.UK Notify session', 'Disconnect')) {
        $script:GovUKNotifyContext = $null
        Write-Verbose 'Disconnected from GOV.UK Notify.'
    }
}
