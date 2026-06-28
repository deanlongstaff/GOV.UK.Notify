@{
    RootModule           = 'GovUKNotify.psm1'
    ModuleVersion        = '1.0.0'
    GUID                 = 'a97bbf02-57b9-4133-9b37-9cf3a4cc5131'
    Author               = 'Dean Longstaff'
    CompanyName          = 'Dean Longstaff'
    Copyright            = '(c) 2026 Dean Longstaff. All rights reserved.'
    Description          = 'A community PowerShell client for the GOV.UK Notify REST API. Send emails, text messages and letters, attach files, generate template previews, and retrieve message status and inbound text messages. Handles JWT authentication, transient-error retries and rate limiting automatically.'

    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Core', 'Desktop')

    FunctionsToExport    = @(
        # -- Connection
        'Connect-GovUKNotify'
        'Disconnect-GovUKNotify'
        'Get-GovUKNotifyContext'

        # -- Send a message
        'Send-GovUKNotifyEmail'
        'Send-GovUKNotifySms'
        'Send-GovUKNotifyLetter'
        'Send-GovUKNotifyPrecompiledLetter'
        'New-GovUKNotifyFileAttachment'

        # -- Get message data
        'Get-GovUKNotifyNotification'
        'Get-GovUKNotifyLetterPdf'

        # -- Templates
        'Get-GovUKNotifyTemplate'
        'Get-GovUKNotifyTemplatePreview'

        # -- Inbound
        'Get-GovUKNotifyReceivedText'
    )

    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    PrivateData          = @{
        PSData = @{
            Tags         = @(
                'GOV.UK', 'GOVUK', 'Notify', 'Notifications', 'Email', 'SMS', 'Letter',
                'Government', 'GDS', 'REST', 'API', 'PSEdition_Core', 'PSEdition_Desktop'
            )
            LicenseUri   = 'https://github.com/deanlongstaff/GOV.UK.Notify/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/deanlongstaff/GOV.UK.Notify'
            ReleaseNotes = 'https://github.com/deanlongstaff/GOV.UK.Notify/blob/main/CHANGELOG.md'
        }
    }
}
