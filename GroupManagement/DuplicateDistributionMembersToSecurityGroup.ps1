#duplicates distribution group members to a defined security group.
# ---  requires an application to be registered with the following permissions: User.ReadWrite.All, GroupMember.ReadWrite.All
$TenantID = Get-AutomationVariable -Name 'TenantID'
$SourceGroupID = Get-AutomationVariable -Name 'SourceGroup'
$DestinationGroupID = Get-AutomationVariable -Name 'DestinationGroup'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'

$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

if ($connection)
{
	$groupmembers = (Get-MgGroupMember -GroupId $SourceGroupID).id
	
	foreach ($groupmember in $groupmembers) 
	{
		New-MgGroupMember -GroupId $DestinationGroupID -DirectoryObjectId $groupmember
	}

	write-output "Group Updated"
}
