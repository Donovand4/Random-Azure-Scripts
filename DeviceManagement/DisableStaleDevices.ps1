#the appID service principal must be granted the following permissions: GA or Cloud Device Administrator permissions.
$TenantID = Get-AutomationVariable -Name 'TenantID'
$notsignedonindays = Get-AutomationVariable -Name 'StaleDeviceLastSigninDays'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'
$DateLimit = (get-date).adddays(-$notsignedonindays)
$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

if ($connection)
{
	$staleDevices = Get-MgDevice -All:$true | Where {$_.ApproximateLastSignInDateTime -le $DateLimit}
	foreach ($device in $staleDevices)
	{
		Update-MgDevice -DeviceId $device.Id -AccountEnabled:$false
	}
	
	write-output "Total of ($(($staleDevices).count)) devices disabled."
}
