# GOV.UK.Notify

[![CI](https://github.com/deanlongstaff/GOV.UK.Notify/actions/workflows/ci.yml/badge.svg)](https://github.com/deanlongstaff/GOV.UK.Notify/actions/workflows/ci.yml)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GOV.UK.Notify)](https://www.powershellgallery.com/packages/GOV.UK.Notify)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/GOV.UK.Notify)](https://www.powershellgallery.com/packages/GOV.UK.Notify)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A community PowerShell client for the [GOV.UK Notify](https://www.notifications.service.gov.uk/) REST API.

Send emails, text messages and letters, attach files, generate template previews, and retrieve
message status and inbound text messages — all from PowerShell. The module handles JWT
authentication, transient-error retries and rate limiting for you.

> This is an independent, community-maintained module. It is not produced or endorsed by the
> Government Digital Service. "GOV.UK Notify" is a service provided by GDS.

## Features

- Full coverage of the GOV.UK Notify REST API surface.
- Automatic JWT (HS256) authentication — connect once, then call any cmdlet.
- Built-in retry with backoff for transient failures (HTTP 429/5xx) and clear, structured errors.
- Works on **PowerShell 7+** and **Windows PowerShell 5.1**.
- No external dependencies.

## Requirements

- PowerShell 7.2 or later, or Windows PowerShell 5.1.
- A GOV.UK Notify account and an API key. See [API keys](https://docs.notifications.service.gov.uk/rest-api.html#api-keys).

## Installation

```powershell
Install-Module -Name GOV.UK.Notify -Scope CurrentUser
```

## Quick start

```powershell
Import-Module GOV.UK.Notify

# Connect once; the key is held in memory for the session only.
Connect-GovUKNotify -ApiKey $env:GOVUKNOTIFY_API_KEY

# Send an email from a template.
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId '9d751e0e-f929-4891-82a1-a3e1c3c18ee3' -Personalisation @{
    first_name       = 'Amala'
    appointment_date = '1 January 2025 at 1:00pm'
}
```

## Authentication

A GOV.UK Notify API key has the format `{key_name}-{service_id}-{secret_key}`, where `service_id`
and `secret_key` are UUIDs. The module derives the service id and signing secret from the key and
generates a short-lived JWT for every request — you never construct tokens yourself.

You can either connect once for the session:

```powershell
Connect-GovUKNotify -ApiKey $key
Send-GovUKNotifySms -PhoneNumber '+447900900123' -TemplateId $tid
```

…or pass `-ApiKey` (and optionally `-BaseUrl`) to any individual cmdlet, which overrides the
connected session. This is useful when working with more than one Notify service at once:

```powershell
Send-GovUKNotifyEmail -EmailAddress 'a@example.com' -TemplateId $tid -ApiKey $otherServiceKey
```

The API key is never written to disk or logged. `Get-GovUKNotifyContext` shows only the last four
characters.

## Cmdlet reference

| Cmdlet                              | REST endpoint                    | Purpose                                             |
| ----------------------------------- | -------------------------------- | --------------------------------------------------- |
| `Connect-GovUKNotify`               | –                                | Store an API key for the session.                   |
| `Disconnect-GovUKNotify`            | –                                | Clear the stored API key.                           |
| `Get-GovUKNotifyContext`            | –                                | Show the current connection (key masked).           |
| `Send-GovUKNotifyEmail`             | `POST /v2/notifications/email`   | Send an email from a template.                      |
| `Send-GovUKNotifySms`               | `POST /v2/notifications/sms`     | Send a text message from a template.                |
| `Send-GovUKNotifyLetter`            | `POST /v2/notifications/letter`  | Send a letter from a template.                      |
| `Send-GovUKNotifyPrecompiledLetter` | `POST /v2/notifications/letter`  | Send a precompiled PDF letter.                      |
| `New-GovUKNotifyFileAttachment`     | –                                | Build a "file by email" object for personalisation. |
| `Get-GovUKNotifyNotification`       | `GET /v2/notifications[/{id}]`   | Get one message, or a filtered/paginated list.      |
| `Get-GovUKNotifyLetterPdf`          | `GET /v2/notifications/{id}/pdf` | Download a letter's PDF.                            |
| `Get-GovUKNotifyTemplate`           | `GET /v2/template[s]`            | Get one template, a version, or all templates.      |
| `Get-GovUKNotifyTemplatePreview`    | `POST /v2/template/{id}/preview` | Render a template with personalisation.             |
| `Get-GovUKNotifyReceivedText`       | `GET /v2/received-text-messages` | Get inbound text messages.                          |

Run `Get-Help <cmdlet> -Full` for full parameter details and examples. Per-cmdlet reference
documentation is generated under [docs/help/](docs/help), and scenario examples are in
[docs/examples.md](docs/examples.md).

## Common scenarios

### Send a file by email

```powershell
$file = New-GovUKNotifyFileAttachment -Path ./invoice.pdf -RetentionPeriod '4 weeks'
Send-GovUKNotifyEmail -EmailAddress 'amala@example.com' -TemplateId $tid -Personalisation @{
    first_name   = 'Amala'
    link_to_file = $file
}
```

### Send a letter

```powershell
Send-GovUKNotifyLetter -TemplateId $tid -Personalisation @{
    address_line_1 = 'Amala Bird'
    address_line_2 = '123 High Street'
    address_line_3 = 'London'
    address_line_4 = 'SW14 6BH'
}
```

### Check message status

```powershell
# A single message
Get-GovUKNotifyNotification -NotificationId '740e5834-3a29-46b4-9a6f-16142fde533a'

# Every delivered email, following pagination
Get-GovUKNotifyNotification -TemplateType email -Status delivered -All
```

### Preview a template

```powershell
Get-GovUKNotifyTemplatePreview -TemplateId $tid -Personalisation @{ first_name = 'Amala' }
```

## Error handling

Cmdlets throw a terminating error when GOV.UK Notify rejects a request. The message includes the
HTTP status code and the Notify error type, which are stable and safe to branch on:

```powershell
try {
    Send-GovUKNotifyEmail -EmailAddress 'not-an-email' -TemplateId $tid
}
catch {
    Write-Warning "Notify rejected the request: $($_.Exception.Message)"
}
```

## Development

```powershell
# Lint and run the full Pester suite (installs Pester and PSScriptAnalyzer on demand).
./build.ps1 -Task Test

# Lint only.
./build.ps1 -Task Analyze

# Regenerate the per-cmdlet Markdown help after changing comment-based help.
./build.ps1 -Task Docs

# Import from source for manual testing.
Import-Module ./src/GOV.UK.Notify/GOV.UK.Notify.psd1 -Force
```

The per-cmdlet Markdown help under `docs/help/` is generated from the comment-based help with
[platyPS](https://github.com/PowerShell/platyPS) and is checked into the repository; CI fails if it
is out of date. It is compiled to MAML external help and shipped with the module at publish time.

Releases are automated: maintainers run the **Release** GitHub Actions workflow and choose a
`major`, `minor` or `patch` bump. It bumps the version, updates the changelog, runs the tests,
publishes to the PowerShell Gallery, then tags and creates a GitHub release.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full contributor guide.

## Testing against GOV.UK Notify

All GOV.UK Notify testing happens in production; there is no separate test environment. Use a
[test API key](https://docs.notifications.service.gov.uk/rest-api.html#test) and the documented
smoke-test recipients to avoid sending real messages.

## License

Released under the [MIT License](LICENSE). © Dean Longstaff.
