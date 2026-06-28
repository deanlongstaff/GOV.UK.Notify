# Changelog

All notable changes to the **GOV.UK.Notify** module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-06-28

### Added

- Initial public release covering the full GOV.UK Notify REST API.
- Connection management: `Connect-GovUKNotify`, `Disconnect-GovUKNotify`, `Get-GovUKNotifyContext`.
- Sending: `Send-GovUKNotifyEmail`, `Send-GovUKNotifySms`, `Send-GovUKNotifyLetter`,
  `Send-GovUKNotifyPrecompiledLetter`, and the `New-GovUKNotifyFileAttachment` helper for
  sending files by email.
- Message data: `Get-GovUKNotifyNotification` (single, filtered list, and `-All` pagination) and
  `Get-GovUKNotifyLetterPdf`.
- Templates: `Get-GovUKNotifyTemplate` (by id, by id + version, or all) and
  `Get-GovUKNotifyTemplatePreview`.
- Inbound: `Get-GovUKNotifyReceivedText` (with `-All` pagination).
- Automatic JWT authentication, transient-error/rate-limit retry handling, and structured error
  reporting based on the Notify error type and HTTP status code.
- Per-cmdlet Markdown help (platyPS), compiled to MAML external help that ships with the module.
- Pester test suite, PSScriptAnalyzer configuration, GitHub Actions CI/CD, an automated release
  workflow, and documentation.

[Unreleased]: https://github.com/deanlongstaff/GOV.UK.Notify/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/deanlongstaff/GOV.UK.Notify/releases/tag/v1.0.0
