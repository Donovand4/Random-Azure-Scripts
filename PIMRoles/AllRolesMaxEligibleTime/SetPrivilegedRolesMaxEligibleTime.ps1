#To update privileged role's max eligibility duration
#login with graph with the correct scope
Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

#Adjust this path to the csv template
$RecommendedRoleDurations = Import-Csv -Path "C:\Temp\PIMRoleTimes.csv"

foreach ($role in $RecommendedRoleDurations) {
    #gets the DirectoryRole policy ID
    $policyID = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole' and roleDefinitionId eq '$($role.Id)'"
    #define the max duration for the roles eligibility - Format = ISO 8601 - Max is "PT24H0M"
    $MaxDuration = "PT$($role.Hours)H$($role.Minutes)M"
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
}
