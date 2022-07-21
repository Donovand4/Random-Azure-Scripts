# ---  requires an application to be registered with the following permissions: User.ReadWrite.All, GroupMember.ReadWrite.All
# --- syncs a source group to a destination group - ONE WAY
$TenantID = Get-AutomationVariable -Name 'TenantID'
$SourceGroupID = Get-AutomationVariable -Name 'SourceGroup'
$DestinationGroupID = Get-AutomationVariable -Name 'DestinationGroup'
$AppID = Get-AutomationVariable -Name 'ServicePrincipalAppID' #app id from app registrations that has been granted access to read the users and manage groups.
$AuthCert = Get-AutomationCertificate -Name 'cert'

$connection = Connect-MgGraph -ClientID $AppID -TenantId $TenantID -CertificateThumbprint $AuthCert.Thumbprint

if ($connection)
{
	$Srcgroupmembers = (Get-MgGroupMember -GroupId $SourceGroupID).id
	$DstgroupMembers = (Get-MgGroupMember -GroupId $DestinationGroupID).id

foreach ($Srcgroupmember in $Srcgroupmembers)
{
	if ($DstgroupMembers -notcontains $Srcgroupmember)
	{
		New-MgGroupMember -GroupId $DestinationGroupID -DirectoryObjectId $Srcgroupmember
		write-output "Dest group missing source group user $($Srcgroupmember)"
	}
}

foreach ($DstgroupMember in $DstgroupMembers)
{
	if ($Srcgroupmembers -notcontains $DstgroupMember)
	{
		Remove-MgGroupMemberByRef -GroupId $DestinationGroupID -DirectoryObjectId $DstgroupMember
		write-output "source group missing destination group user $($DstgroupMember) - Removed from Destination Group"
	}
}

	write-output "Group Updated"
}
