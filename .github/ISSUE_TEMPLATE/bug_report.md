---
name: Bug report
about: Report a problem with the GOV.UK.Notify module
title: "[Bug] "
labels: bug
---

## Describe the bug

A clear and concise description of what the bug is.

## To reproduce

Steps or a minimal code sample that reproduces the problem. **Do not include your API key or any
personal data.**

```powershell
# Example
Connect-GovUKNotify -ApiKey $key
Send-GovUKNotifyEmail -EmailAddress 'test@example.com' -TemplateId $tid
```

## Expected behaviour

What you expected to happen.

## Actual behaviour

What actually happened, including the full error message (with any secrets redacted).

## Environment

- Module version: <!-- (Get-Module GOV.UK.Notify).Version -->
- PowerShell edition and version: <!-- $PSVersionTable.PSEdition / .PSVersion -->
- Operating system:

## Additional context

Anything else that might help.
