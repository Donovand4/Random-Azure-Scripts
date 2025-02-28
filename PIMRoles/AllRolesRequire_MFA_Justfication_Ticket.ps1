#To update all roles - grab coffee it will be a while
#login with graph with the correct scope
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

#Get all roles policies
$policyID = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'"

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

#Ppdate all roles
foreach ($policy in $policyID) {
    $URI = "https://graph.microsoft.com/v1.0/policies/roleManagementPolicies/$($policy.PolicyId)/rules/Enablement_EndUser_Assignment"
    Invoke-GraphRequest -Method PATCH -Uri $URI -Body $params -ContentType "application/json" 
}
