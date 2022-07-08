#App Permissions = User.Read.All
#reports all guests with groupmemberships
$TenantID = Get-AutomationVariable -Name 'TenantID'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'
$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

$report = @()
$GuestUsers = Get-MgUser -Filter "userType eq 'Guest'" -All -Property DisplayName, AccountEnabled, id | Select-Object DisplayName, AccountEnabled, id
foreach ($guest in $GuestUsers) {    
    $membership = Get-MgUserMemberOf -UserId $guest.id -Property * | select-object -ExpandProperty additionalproperties | select-object @{name = "Group"; Expression = { $_.'displayName'}}
    
    $Array = New-Object -TypeName PSObject -Property @{
        user            = $guest.displayName
        AccountEnabled  = $guest.accountEnabled
        Group = $membership.Group -join ";"
    }
    $report += $Array | select-object user,accountEnabled,group
}

Write-Output ($report | ConvertTo-Json)
