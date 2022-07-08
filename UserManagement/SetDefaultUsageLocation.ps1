#App SP Permissions = User.ReadWrite.All
$TenantID = Get-AutomationVariable -Name 'TenantID'
$Usagelocation = Get-AutomationVariable -Name 'DefaultUsagelocation'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'
$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

if ($connection)
{ 
	$NullUsageLocations = Get-MgUser -Property id,userprincipalname,UsageLocation,companyName -Filter "UsageLocation eq null" -ConsistencyLevel eventual -CountVariable Count 
	foreach ($user in $NullUsageLocations) 
	{
    	Update-MgUser -UserId $user.Id -UsageLocation $Usagelocation
	}
	
	write-output "Total of ($count) users with no default local found."
}
