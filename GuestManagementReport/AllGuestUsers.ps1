#App Permissions = User.Read.All
$TenantID = Get-AutomationVariable -Name 'TenantID'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'
$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

$GuestUsers = Get-MgUser -Filter "userType eq 'Guest'" -All | Select-Object DisplayName, UserPrincipalName, AccountEnabled, mail, CreationType, RefreshTokensValidFromDateTime, UserType, UserState

Write-Output ($GuestUsers | ConvertTo-Json)
