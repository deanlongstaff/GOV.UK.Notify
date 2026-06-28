function Get-GovUKNotifyTemplate {
    <#
        .SYNOPSIS
        Retrieves one template, a specific template version, or all templates.

        .DESCRIPTION
        With -TemplateId, calls 'GET /v2/template/{id}' for the latest version, or
        'GET /v2/template/{id}/version/{version}' when -Version is also supplied. Without -TemplateId,
        calls 'GET /v2/templates' and returns all templates, optionally filtered by -Type.

        .PARAMETER TemplateId
        The id of a single template to retrieve.

        .PARAMETER Version
        A specific version number of the template to retrieve.

        .PARAMETER Type
        Filter the list of all templates by type: 'email', 'sms' or 'letter'.

        .PARAMETER ApiKey
        An explicit API key, overriding any connected session.

        .PARAMETER BaseUrl
        An explicit base URL, overriding any connected session.

        .EXAMPLE
        Get-GovUKNotifyTemplate -TemplateId $tid

        .EXAMPLE
        Get-GovUKNotifyTemplate -TemplateId $tid -Version 2

        .EXAMPLE
        Get-GovUKNotifyTemplate -Type email

        .OUTPUTS
        A single template object, or a stream of template objects for the list.

        .LINK
        https://docs.notifications.service.gov.uk/rest-api.html#get-a-template
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Single', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,

        [Parameter(ParameterSetName = 'Single')]
        [ValidateRange(1, 2147483647)]
        [int]$Version,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('email', 'sms', 'letter')]
        [string]$Type,

        [Parameter()]
        [string]$ApiKey,

        [Parameter()]
        [string]$BaseUrl
    )

    $ConnectionParams = @{}
    if ($PSBoundParameters.ContainsKey('ApiKey')) { $ConnectionParams['ApiKey'] = $ApiKey }
    if ($PSBoundParameters.ContainsKey('BaseUrl')) { $ConnectionParams['BaseUrl'] = $BaseUrl }

    if ($PSCmdlet.ParameterSetName -eq 'Single') {
        if ($PSBoundParameters.ContainsKey('Version')) {
            return Invoke-GovUKNotifyApi -Method 'GET' -Path "/v2/template/$TemplateId/version/$Version" @ConnectionParams
        }
        return Invoke-GovUKNotifyApi -Method 'GET' -Path "/v2/template/$TemplateId" @ConnectionParams
    }

    $Path = '/v2/templates'
    if ($Type) { $Path += "?type=$Type" }

    $Response = Invoke-GovUKNotifyApi -Method 'GET' -Path $Path @ConnectionParams
    return $Response.templates
}
