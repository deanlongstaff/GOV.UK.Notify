#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }
<#
    Pester tests for the private Invoke-GovUKNotifyApi request engine.
    The HTTP layer (Invoke-RestMethod / Invoke-WebRequest), JWT generation and Start-Sleep are mocked,
    so no real network requests are made.
#>

BeforeAll {
    Import-Module "$PSScriptRoot/../src/GOV.UK.Notify/GOV.UK.Notify.psd1" -Force
}

Describe 'Invoke-GovUKNotifyApi' {

    Context 'Successful JSON requests' {

        It 'builds the URL from the base URL and path and returns the parsed body' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Invoke-RestMethod { @{ id = 'abc' } }

                $Result = Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/notifications/abc' -ApiKey 'k' -BaseUrl 'https://example.test'

                $Result.id | Should -Be 'abc'
                Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                    $Uri -eq 'https://example.test/v2/notifications/abc' -and $Method -eq 'GET'
                }
            }
        }

        It 'sends the bearer token in the Authorization header' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Invoke-RestMethod { @{ ok = $true } }

                Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/templates' -ApiKey 'k' -BaseUrl 'https://example.test' | Out-Null

                Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                    $Headers['Authorization'] -eq 'Bearer fake.jwt.token'
                }
            }
        }

        It 'serialises the body to JSON and sets the content type for POST' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Invoke-RestMethod { @{ id = 'n1' } }

                Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/email' -Body @{ email_address = 'a@b.com' } -ApiKey 'k' -BaseUrl 'https://example.test' | Out-Null

                Should -Invoke Invoke-RestMethod -Times 1 -ParameterFilter {
                    $ContentType -eq 'application/json' -and ($Body | ConvertFrom-Json).email_address -eq 'a@b.com'
                }
            }
        }
    }

    Context 'Raw (binary) requests' {

        It 'returns the raw response bytes when -Raw is used' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Invoke-WebRequest {
                    [pscustomobject]@{ RawContentStream = [System.IO.MemoryStream]::new([byte[]](1, 2, 3, 4)) }
                }

                $Bytes = Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/notifications/x/pdf' -Raw -ApiKey 'k' -BaseUrl 'https://example.test'

                ($Bytes -join ',') | Should -Be '1,2,3,4'
                Should -Invoke Invoke-WebRequest -Times 1
            }
        }
    }

    Context 'Error handling' {

        It 'throws a descriptive error containing the status code and Notify error type' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Invoke-RestMethod {
                    $ErrorItem = [System.Management.Automation.ErrorRecord]::new(
                        [System.Exception]::new('Bad Request'), 'X', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null)
                    $ErrorItem.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"status_code":400,"errors":[{"error":"ValidationError","message":"email_address Not a valid email address"}]}')
                    throw $ErrorItem
                }

                { Invoke-GovUKNotifyApi -Method 'POST' -Path '/v2/notifications/email' -Body @{ x = 1 } -ApiKey 'k' -BaseUrl 'https://example.test' } |
                    Should -Throw '*HTTP 400*ValidationError*'
            }
        }

        It 'does not retry a non-retryable 400 error' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Start-Sleep { }
                Mock Invoke-RestMethod {
                    $ErrorItem = [System.Management.Automation.ErrorRecord]::new(
                        [System.Exception]::new('Bad Request'), 'X', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null)
                    $ErrorItem.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"status_code":400,"errors":[{"error":"ValidationError","message":"bad"}]}')
                    throw $ErrorItem
                }

                { Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/templates' -ApiKey 'k' -BaseUrl 'https://example.test' } | Should -Throw
                Should -Invoke Invoke-RestMethod -Times 1
            }
        }
    }

    Context 'Retry behaviour' {

        It 'retries a transient 429 and then succeeds' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Start-Sleep { }
                $script:InvokeCount = 0
                Mock Invoke-RestMethod {
                    $script:InvokeCount++
                    if ($script:InvokeCount -lt 3) {
                        $ErrorItem = [System.Management.Automation.ErrorRecord]::new(
                            [System.Exception]::new('Too Many Requests'), 'X', [System.Management.Automation.ErrorCategory]::LimitsExceeded, $null)
                        $ErrorItem.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"status_code":429,"errors":[{"error":"RateLimitError","message":"slow down"}]}')
                        throw $ErrorItem
                    }
                    return @{ id = 'eventually-ok' }
                }

                $Result = Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/templates' -ApiKey 'k' -BaseUrl 'https://example.test' -MaxRetry 3
                $Result.id | Should -Be 'eventually-ok'
                Should -Invoke Invoke-RestMethod -Times 3
            }
        }

        It 'gives up after MaxRetry attempts and throws' {
            InModuleScope GOV.UK.Notify {
                Mock New-GovUKNotifyJwt { 'fake.jwt.token' }
                Mock Start-Sleep { }
                Mock Invoke-RestMethod {
                    $ErrorItem = [System.Management.Automation.ErrorRecord]::new(
                        [System.Exception]::new('Server Error'), 'X', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null)
                    $ErrorItem.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('{"status_code":500,"errors":[{"error":"Exception","message":"Internal server error"}]}')
                    throw $ErrorItem
                }

                { Invoke-GovUKNotifyApi -Method 'GET' -Path '/v2/templates' -ApiKey 'k' -BaseUrl 'https://example.test' -MaxRetry 2 } | Should -Throw '*HTTP 500*'
                # -- Initial attempt plus 2 retries.
                Should -Invoke Invoke-RestMethod -Times 3
            }
        }
    }
}
