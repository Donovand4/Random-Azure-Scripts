#duplicates distribution group members to a defined security group.
#requires an application to be registered with the following permissions: User.ReadWrite.All, GroupMember.ReadWrite.All
$TenantID = Get-AutomationVariable -Name 'TenantID'
$SourceGroupID = Get-AutomationVariable -Name 'SourceGroup'
$DestinationGroupID = Get-AutomationVariable -Name 'DestinationGroup'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'

$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

if ($connection)
{
	$groupmembers = (Get-MgGroupMember -GroupId $SourceGroupID).id

	$membersOData = @()
	foreach ($groupmember in $groupmembers) {
		$membersOData += "https://graph.microsoft.com/v1.0/directoryObjects/$($groupmember)"
	}

	$params = @{
		"Members@odata.bind" = @(
			$membersOData
		)
	}

	Update-MgGroup -GroupId $DestinationGroupID -BodyParameter $params
	write-output "Group Updated"
}
