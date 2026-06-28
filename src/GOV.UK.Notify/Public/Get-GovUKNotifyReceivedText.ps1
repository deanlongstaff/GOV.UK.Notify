function Get-GovUKNotifyReceivedText {
    <#
        .SYNOPSIS
        Retrieves text messages received by your GOV.UK Notify service.

        .DESCRIPTION
        Calls 'GET /v2/received-text-messages' and returns received text messages, most recent first.
        Each page returns up to 250 messages; use -All to follow pagination and return every message.
        You can only retrieve messages that are 7 days old or newer. Receiving text messages must be
        enabled in your service settings.

        .PARAMETER OlderThan
        Return received text messages older than this message id (pagination).

        .PARAMETER All
        Follow pagination and return every received text message, not just the first page of up to 250.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Get-GovUKNotifyReceivedText -All

        .OUTPUTS
        A stream of received text message objects.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#get-received-text-messages
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$OlderThan,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    $CurrentOlderThan = $OlderThan
    do {
        $Path = '/v2/received-text-messages'
        if ($CurrentOlderThan) { $Path += "?older_than=$CurrentOlderThan" }

        $Response = Invoke-GovUKNotifyApi -Method 'GET' -Path $Path @ConnectionParams
        $Items = @($Response.received_text_messages)

        if ($Items.Count -gt 0) {
            $Items
            $CurrentOlderThan = $Items[-1].id
        }
    } while ($All -and $Items.Count -ge 250)
}
