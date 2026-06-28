function Invoke-GovUKNotifyApi {
    <#
        .SYNOPSIS
        Sends an authenticated request to the GOV.UK Notify REST API.

        .DESCRIPTION
        Internal request engine used by every public cmdlet. It resolves the API key and base URL,
        generates a fresh JWT for each attempt, serialises the request body to JSON, and parses the
        response. Transient failures (HTTP 429, 500, 502, 503, 504) are retried with exponential
        backoff, honouring a Retry-After header when present. GOV.UK Notify error responses are parsed
        and surfaced as a single, descriptive terminating error containing the HTTP status code and the
        Notify error type.

        .PARAMETER Method
        The HTTP method, 'GET' or 'POST'.

        .PARAMETER Path
        The request path appended to the base URL, for example '/v2/notifications/email'.

        .PARAMETER Body
        An optional hashtable serialised to a JSON request body for POST requests.

        .PARAMETER ApiKey
        An explicit API key. If omitted, the connected session context is used.

        .PARAMETER BaseUrl
        An explicit base URL. If omitted, the connected session context or the production default is used.

        .PARAMETER Raw
        Return the raw response bytes instead of parsed JSON. Used for the letter PDF endpoint.

        .PARAMETER MaxRetry
        Maximum number of retries for transient failures. Defaults to 3.

        .PARAMETER RetryDelaySeconds
        Base delay, in seconds, used for exponential backoff between retries. Defaults to 1.

        .OUTPUTS
        The parsed JSON response object, or System.Byte[] when -Raw is specified.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'POST')]
        [string]$Method,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [hashtable]$Body,

        [string]$ApiKey,

        [string]$BaseUrl,

        [switch]$Raw,

        [int]$MaxRetry = 3,

        [int]$RetryDelaySeconds = 1
    )

    $Context = Resolve-GovUKNotifyContext -ApiKey $ApiKey -BaseUrl $BaseUrl
    $Uri = '{0}{1}' -f $Context.BaseUrl, $Path

    $JsonBody = $null
    if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body) {
        $JsonBody = $Body | ConvertTo-Json -Depth 10
    }

    $RetryableStatus = @(429, 500, 502, 503, 504)
    $Attempt = 0

    while ($true) {
        $Attempt++

        # -- A fresh token per attempt: GOV.UK Notify tokens expire ~30 seconds after issue.
        $Token = New-GovUKNotifyJwt -ApiKey $Context.ApiKey
        $Headers = @{ Authorization = "Bearer $Token" }

        try {
            if ($Raw) {
                $Response = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $Headers -UseBasicParsing -ErrorAction Stop
                # -- Return the byte array as a single object so the pipeline does not unroll it.
                return , $Response.RawContentStream.ToArray()
            }

            $RequestParams = @{
                Uri         = $Uri
                Method      = $Method
                Headers     = $Headers
                ErrorAction = 'Stop'
            }
            if ($null -ne $JsonBody) {
                $RequestParams.Body = $JsonBody
                $RequestParams.ContentType = 'application/json'
            }

            return Invoke-RestMethod @RequestParams
        }
        catch {
            $ErrorRecordItem = $_
            $StatusCode = $null
            $ResponseBody = $null

            # -- Extract the HTTP status code (the StatusCode enum type is shared across PS editions).
            if ($ErrorRecordItem.Exception.Response) {
                try { $StatusCode = [int]$ErrorRecordItem.Exception.Response.StatusCode } catch { $StatusCode = $null }
            }

            # -- Extract the response body. PowerShell 7 populates ErrorDetails.Message; Windows
            #    PowerShell 5.1 requires reading the response stream.
            if ($ErrorRecordItem.ErrorDetails -and $ErrorRecordItem.ErrorDetails.Message) {
                $ResponseBody = $ErrorRecordItem.ErrorDetails.Message
            }
            elseif ($ErrorRecordItem.Exception.Response -and ($ErrorRecordItem.Exception.Response | Get-Member -Name GetResponseStream -ErrorAction SilentlyContinue)) {
                try {
                    $Stream = $ErrorRecordItem.Exception.Response.GetResponseStream()
                    $Reader = [System.IO.StreamReader]::new($Stream)
                    try { $ResponseBody = $Reader.ReadToEnd() } finally { $Reader.Dispose() }
                }
                catch {
                    $ResponseBody = $null
                }
            }

            # -- Parse the Notify error payload (status_code + errors[]) for a friendly message.
            $ErrorSummary = $null
            if (-not [string]::IsNullOrWhiteSpace($ResponseBody)) {
                try {
                    $Parsed = $ResponseBody | ConvertFrom-Json -ErrorAction Stop
                    if ($Parsed.status_code) { $StatusCode = [int]$Parsed.status_code }
                    if ($Parsed.errors) {
                        $ErrorSummary = ($Parsed.errors | ForEach-Object { "$($_.error): $($_.message)" }) -join '; '
                    }
                }
                catch {
                    $ErrorSummary = $ResponseBody
                }
            }
            if ([string]::IsNullOrWhiteSpace($ErrorSummary)) {
                $ErrorSummary = $ErrorRecordItem.Exception.Message
            }

            # -- Retry transient failures with exponential backoff.
            if ($StatusCode -in $RetryableStatus -and $Attempt -le $MaxRetry) {
                $Delay = [Math]::Min([Math]::Pow(2, $Attempt - 1) * $RetryDelaySeconds, 30)

                # -- Honour Retry-After when the server provides it.
                try {
                    $ResponseHeaders = $ErrorRecordItem.Exception.Response.Headers
                    if ($ResponseHeaders) {
                        if ($ResponseHeaders['Retry-After']) {
                            $Delay = [int]$ResponseHeaders['Retry-After']
                        }
                        elseif ($ResponseHeaders.RetryAfter -and $ResponseHeaders.RetryAfter.Delta) {
                            $Delay = [int]$ResponseHeaders.RetryAfter.Delta.TotalSeconds
                        }
                    }
                }
                catch {
                    Write-Verbose 'Unable to read the Retry-After header; using the computed backoff delay.'
                }

                Write-Verbose ("GOV.UK Notify request failed (HTTP {0}). Retry {1}/{2} in {3}s." -f $StatusCode, $Attempt, $MaxRetry, $Delay)
                Start-Sleep -Seconds $Delay
                continue
            }

            # -- Non-retryable, or retries exhausted: throw a single descriptive terminating error.
            $StatusText = if ($StatusCode) { " (HTTP $StatusCode)" } else { '' }
            $Message = "GOV.UK Notify API request '$Method $Path' failed${StatusText}: $ErrorSummary"
            $Exception = [System.Exception]::new($Message, $ErrorRecordItem.Exception)
            $NewError = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'GovUKNotifyApiError',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                $Path
            )
            throw $NewError
        }
    }
}
