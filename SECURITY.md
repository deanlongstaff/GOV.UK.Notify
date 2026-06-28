# Security Policy

## Supported versions

The latest released version on the PowerShell Gallery receives security updates.

## Reporting a vulnerability

**Do not open a public issue for security vulnerabilities.**

If you believe you have found a security vulnerability in this module, please report it privately
using [GitHub's private vulnerability reporting](https://docs.github.com/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability)
on this repository, or by contacting the maintainers directly.

Please include:

- A description of the vulnerability and its impact.
- Steps to reproduce.
- Any suggested remediation.

We will acknowledge your report as soon as possible and keep you informed of progress toward a fix.

## Handling of credentials

- This module never logs or persists your GOV.UK Notify API key. The key is held only in memory
  for the duration of your session (via `Connect-GovUKNotify`) and is used solely to sign
  short-lived JSON Web Tokens for API requests.
- `Get-GovUKNotifyContext` masks the API key by default.
- Never commit API keys to source control. Treat a Notify API key as a secret: if one is exposed,
  revoke it in the GOV.UK Notify dashboard immediately.
