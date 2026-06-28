function Resolve-GovUKNotifyContext {
    <#
        .SYNOPSIS
        Resolves the API key and base URL to use for a request.

        .DESCRIPTION
        Internal helper. An explicitly supplied -ApiKey (and optional -BaseUrl) always takes
        precedence. Otherwise the values stored by Connect-GovUKNotify in the module session context
        are used. If neither is available, a terminating error is thrown.

        .PARAMETER ApiKey
        An explicit API key that overrides the connected session, if supplied.

        .PARAMETER BaseUrl
        An explicit base URL that overrides the connected session, if supplied.

        .OUTPUTS
        System.Collections.Hashtable with 'ApiKey' and 'BaseUrl' keys.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string]$ApiKey,
        [string]$BaseUrl
    )

    $DefaultBaseUrl = 'https://api.notifications.service.gov.uk'

    # -- Resolve the API key: explicit parameter first, then the connected session context.
    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        if ($null -eq $script:GovUKNotifyContext) {
            throw 'Not connected to GOV.UK Notify. Run Connect-GovUKNotify -ApiKey <key> first, or pass -ApiKey to this command.'
        }
        $ApiKey = $script:GovUKNotifyContext.ApiKey
    }

    # -- Resolve the base URL: explicit parameter, then session context, then the production default.
    if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
        if ($null -ne $script:GovUKNotifyContext -and -not [string]::IsNullOrWhiteSpace($script:GovUKNotifyContext.BaseUrl)) {
            $BaseUrl = $script:GovUKNotifyContext.BaseUrl
        }
        else {
            $BaseUrl = $DefaultBaseUrl
        }
    }

    return @{
        ApiKey  = $ApiKey
        BaseUrl = $BaseUrl.TrimEnd('/')
    }
}
