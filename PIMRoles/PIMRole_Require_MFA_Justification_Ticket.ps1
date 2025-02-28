#To update 1 role
#login with graph with the correct scope
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

#Gettting all roles and take note of the ID of the role you want to target
Get-MgRoleManagementDirectoryRoleDefinition 

#replace 9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3 with the ID that you want to target - this is the ID of the Application Administrator role
$policyID = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3'"

#define the parameters for the patch request to set the rules for the role
$params = @{
    "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyEnablementRule"
    id            = "Enablement_EndUser_Assignment"
    enabledRules  = @(
        "Justification"
        "MultiFactorAuthentication"
        "Ticketing"
    )
    target        = @{
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

$URI = "https://graph.microsoft.com/v1.0/policies/roleManagementPolicies/$($policyID.PolicyId)/rules/Enablement_EndUser_Assignment"

Invoke-GraphRequest -Method PATCH -Uri $URI -Body $params -ContentType "application/json" 
