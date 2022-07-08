#App Permissions = User.ReadWrite.All, AuditLog.Read.All
#reports all guests with last signing dates
$TenantID = Get-AutomationVariable -Name 'TenantID'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'
$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint
Select-MgProfile -Name beta

$GuestUsers = Get-MgUser -Filter "userType eq 'Guest'" -All -Property DisplayName, UserPrincipalName, AccountEnabled, mail, CreationType, UserType, ExternalUserState, signInActivity `
 | Select-Object DisplayName, UserPrincipalName, AccountEnabled, mail, CreationType, UserType, ExternalUserState, `
 @{N='LastSignInDateTime';E={$_.signInActivity.LastSignInDateTime.DateTime}}, @{N='LastNonInteractiveSignInDateTime';E={$_.signInActivity.LastNonInteractiveSignInDateTime.DateTime}}

Write-Output ($GuestUsers | ConvertTo-Json)
