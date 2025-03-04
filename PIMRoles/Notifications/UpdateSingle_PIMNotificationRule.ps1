#To update privileged role's mail notifications
#login with graph with the correct scope
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

#replace 9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3 with the ID that you want to target - this is the ID of the Application Administrator role
$policyID = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3'"

$NotificationLevel = "All" # None, Critical, All
#Rule names can be found at this link - https://learn.microsoft.com/en-us/graph/identity-governance-pim-rules-overview#notification-rules
$RuleID = "Notification_Admin_Admin_Assignment" # select one of these - "Notification_Admin_Admin_Eligibility", "Notification_Requestor_Admin_Eligibility", "Notification_Approver_Admin_Eligibility", "Notification_Admin_Admin_Assignment", "Notification_Requestor_Admin_Assignment", "Notification_Approver_Admin_Assignment", "Notification_Admin_EndUser_Assignment", "Notification_Requestor_EndUser_Assignment", "Notification_Approver_EndUser_Assignment"
$RecipientType = $RuleID.Split("_")[1] # Requestor, Approver, Admin - Aligns with the rule ID - First word in rule ID after notification
$level = $RuleID.Split("_")[-1]  # Eligibility, Assignment - Aligns with the rule ID - last word in rule ID
#define the parameters for the patch request to set the rules for the role
$params = @{
    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
    #id = $RuleID
    target = @{
        caller = "Admin"
        operations = @(
            "all"
        )
    }
    notificationType = "Email"
    recipientType = $RecipientType
    notificationLevel = $NotificationLevel
    isDefaultRecipientsEnabled = $true
    notificationRecipients = @(
    "mailalias@domainname.com",
    "mailalias2@domainname.com"
        )
    level = $level
    inheritableSettings = @(
    )
    enforcedSettings = @(
    )
}


$URI = "https://graph.microsoft.com/v1.0/policies/roleManagementPolicies/$($policyID.PolicyId)/rules/$($RuleID)"
Invoke-GraphRequest -Method PATCH -Uri $URI -Body $params -ContentType "application/json"
