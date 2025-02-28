#To update 1 role's max eligibility duration
#login with graph with the correct scope
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

#replace 9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3 with the ID that you want to target - this is the ID of the Application Administrator role
$policyID = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3'"

#define the max duration for the roles eligibility - Format = ISO 8601 - Max is "PT24H0M"
$MaxDuration = "PT2H0M"
#define the parameters for the patch request to set the rules for the role
$params = @{
    "@odata.type"        = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
    id                   = "Expiration_EndUser_Assignment"
    isExpirationRequired = $true
    maximumDuration      = $MaxDuration
    target               = @{
        "@odata.type"       = "microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
        caller              = "EndUser"
        operations          = @(
            "All"
        )
        level               = "Assignment"
        inheritableSettings = @(
        )
        enforcedSettings    = @(
        )
    }
}


$URI = "https://graph.microsoft.com/v1.0/policies/roleManagementPolicies/$($policyID.PolicyId)/rules/Expiration_EndUser_Assignment"
Invoke-GraphRequest -Method PATCH -Uri $URI -Body $params -ContentType "application/json"
