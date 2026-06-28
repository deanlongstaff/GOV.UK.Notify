function Get-GovUKNotifyNotification {
    <#
        .SYNOPSIS
        Retrieves the data for one or more GOV.UK Notify messages.

        .DESCRIPTION
        With -NotificationId, calls 'GET /v2/notifications/{id}' and returns a single message.
        Otherwise calls 'GET /v2/notifications' and returns messages, optionally filtered by template
        type, status, and reference. Each page returns up to 250 messages; use -All to follow
        pagination and return every matching message. You can only retrieve messages within your data
        retention period (7 days by default).

        .PARAMETER NotificationId
        The id of a single notification to retrieve.

        .PARAMETER TemplateType
        Filter the list by template type: 'email', 'sms' or 'letter'.

        .PARAMETER Status
        Filter the list by one or more delivery statuses, for example 'delivered' or 'permanent-failure'.

        .PARAMETER Reference
        Filter the list by the reference you supplied when sending.

        .PARAMETER OlderThan
        Return messages older than this notification id (pagination).

        .PARAMETER IncludeJobs
        Include notifications sent as part of a batch (bulk) upload.

        .PARAMETER All
        Follow pagination and return every matching message, not just the first page of up to 250.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Get-GovUKNotifyNotification -NotificationId '740e5834-3a29-46b4-9a6f-16142fde533a'

        .EXAMPLE
        Get-GovUKNotifyNotification -TemplateType email -Status delivered -All

        .OUTPUTS
        A single notification object, or a stream of notification objects for the list.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#get-message-data
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Single', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$NotificationId,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('email', 'sms', 'letter')]
        [string]$TemplateType,

        [Parameter(ParameterSetName = 'List')]
        [string[]]$Status,

        [Parameter(ParameterSetName = 'List')]
        [string]$Reference,

        [Parameter(ParameterSetName = 'List')]
        [string]$OlderThan,

        [Parameter(ParameterSetName = 'List')]
        [switch]$IncludeJobs,

        [Parameter(ParameterSetName = 'List')]
        [switch]$All,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ParameterSetName -eq 'Single') {
        return Invoke-GovUKNotifyApi -Method 'GET' -Path "/v2/notifications/$NotificationId" @ConnectionParams
    }

    # -- Build the static part of the query (everything except older_than).
    $BaseQuery = [System.Collections.Generic.List[string]]::new()
    if ($TemplateType) { $BaseQuery.Add("template_type=$TemplateType") }
    foreach ($SingleStatus in $Status) { $BaseQuery.Add("status=$([uri]::EscapeDataString($SingleStatus))") }
    if ($Reference) { $BaseQuery.Add("reference=$([uri]::EscapeDataString($Reference))") }
    if ($IncludeJobs) { $BaseQuery.Add('include_jobs=true') }

    $CurrentOlderThan = $OlderThan
    do {
        $Query = [System.Collections.Generic.List[string]]::new($BaseQuery)
        if ($CurrentOlderThan) { $Query.Add("older_than=$CurrentOlderThan") }

        $Path = '/v2/notifications'
        if ($Query.Count -gt 0) { $Path += '?' + ($Query -join '&') }

        $Response = Invoke-GovUKNotifyApi -Method 'GET' -Path $Path @ConnectionParams
        $Items = @($Response.notifications)

        if ($Items.Count -gt 0) {
            $Items
            $CurrentOlderThan = $Items[-1].id
        }
    } while ($All -and $Items.Count -ge 250)
}
