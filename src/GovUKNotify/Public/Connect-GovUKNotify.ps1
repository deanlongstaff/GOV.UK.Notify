function Connect-GovUKNotify {
    <#
        .SYNOPSIS
        Stores a GOV.UK Notify API key for the current session.

        .DESCRIPTION
        Validates the supplied API key and stores it, together with the base URL, in the module
        session context. Once connected, the other GovUKNotify cmdlets can be called without passing
        an API key. The key is held in memory only and is never written to disk.

        Each command still accepts an explicit -ApiKey, which overrides the connected session. This is
        useful when you need to work with more than one Notify service in the same session.

        .PARAMETER ApiKey
        The GOV.UK Notify API key, in the format '{key_name}-{service_id}-{secret_key}'. Create API
        keys on the API integration page of the GOV.UK Notify dashboard.

        .PARAMETER BaseUrl
        The API base URL. Defaults to the production endpoint
        'https://api.notifications.service.gov.uk'.

        .PARAMETER PassThru
        Return the resulting (masked) connection context.

        .EXAMPLE
        Connect-GovUKNotify -ApiKey $env:GOVUKNOTIFY_API_KEY

        Connects using an API key held in an environment variable.

        .EXAMPLE
        Connect-GovUKNotify -ApiKey $key -PassThru

        Connects and returns the masked connection context.

        .OUTPUTS
        None by default, or a PSCustomObject describing the connection when -PassThru is used.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#api-keys
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl = 'https://api.notifications.service.gov.uk',

        [switch]$PassThru
    )

    # -- Validate the key shape and extract the service id and key name for display.
    $Parts = $ApiKey -split '-'
    if ($Parts.Count -lt 11) {
        throw "Invalid GOV.UK Notify API key format. Expected '{key_name}-{service_id}-{secret_key}', where service_id and secret_key are UUIDs."
    }

    $ServiceId = ($Parts[-10..-6]) -join '-'
    $KeyName = ($Parts[0..($Parts.Count - 11)]) -join '-'

    $script:GovUKNotifyContext = @{
        ApiKey    = $ApiKey
        BaseUrl   = $BaseUrl.TrimEnd('/')
        ServiceId = $ServiceId
        KeyName   = $KeyName
    }

    Write-Verbose ("Connected to GOV.UK Notify service '{0}' ({1}) at {2}." -f $KeyName, $ServiceId, $script:GovUKNotifyContext.BaseUrl)

    if ($PassThru) {
        return Get-GovUKNotifyContext
    }
}
