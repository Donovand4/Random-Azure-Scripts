<#
.SYNOPSIS
    Creates conditional forwarders for Azure Private Link DNS zones for the commercial cloud.
.DESCRIPTION
    This script creates conditional forwarders for Azure Private Link DNS zones in a specified Active Directory domain.
    It uses the Add-DnsServerConditionalForwarderZone cmdlet to add the forwarders to the DNS server.
.PARAMETER ForwarderIP
    The IP address of the DNS server to which the conditional forwarders will point.
.PARAMETER ReplicationScope
    The replication scope for the conditional forwarders. Valid values are "Forest", "Domain", "Custom", and "Legacy".

    Below is a description of each replication scope:
    Custom = Replicate the conditional forwarder to all DNS servers running on domain controllers enlisted in a custom directory partition.
    Domain = Replicate the conditional forwarder to all DNS servers that run on domain controllers in the domain.
    Forest = Replicate the conditional forwarder to all DNS servers that run on domain controllers in the forest.
    Legacy = Replicate the conditional forwarder to all domain controllers in the domain.

.EXAMPLE    
    Create-PrivateEndpointConditionalForwarders -ForwarderIP 192.168.0.100 -ReplicationScope Forest

    Creates conditional forwarders for Azure Private Link DNS zones with the specified forwarder IP and replication scope.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateScript({ $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' })]
    [string] $ForwarderIP,

    [Parameter(Mandatory, Position = 1)]
    [ValidateSet("Forest", "Domain", "Custom", "Legacy")]
    $ReplicationScope
)

# Define the list of DNS zones to create conditional forwarders for
$DNSZones = @(
    "api.azureml.ms",
    "notebooks.azure.net",
    "instances.azureml.ms",
    "aznbcontent.net",
    "inference.ml.azure.com",
    "cognitiveservices.azure.com",
    "openai.azure.com",
    "services.ai.azure.com",
    "directline.botframework.com",
    "token.botframework.com",
    "sql.azuresynapse.net",
    "dev.azuresynapse.net",
    "azuresynapse.net",
    "servicebus.windows.net",
    "datafactory.azure.net",
    "adf.azure.com",
    "azurehdinsight.net",
    "analysis.windows.net",
    "pbidedicated.windows.net",
    "tip1.powerquery.microsoft.com",
    "azuredatabricks.net",
    "wvd.microsoft.com",
    "database.windows.net",
    "documents.azure.com",
    "mongo.cosmos.azure.com",
    "cassandra.cosmos.azure.com",
    "gremlin.cosmos.azure.com",
    "table.cosmos.azure.com",
    "analytics.cosmos.azure.com",
    "postgres.cosmos.azure.com",
    "postgres.database.azure.com",
    "mysql.database.azure.com",
    "mariadb.database.azure.com",
    "redis.cache.windows.net",
    "redisenterprise.cache.azure.net",
    "his.arc.azure.com",
    "guestconfiguration.azure.com",
    "dp.kubernetesconfiguration.azure.com",
    "eventgrid.azure.net",
    "azure-api.net",
    "workspace.azurehealthcareapis.com",
    "fhir.azurehealthcareapis.com",
    "dicom.azurehealthcareapis.com",
    "azure-devices.netservicebus.windows.net",
    "azure-devices-provisioning.net",
    "api.adu.microsoft.com",
    "azureiotcentral.com",
    "digitaltwins.azure.net",
    "media.azure.net",
    "monitor.azure.com",
    "oms.opinsights.azure.com",
    "ods.opinsights.azure.com",
    "agentsvc.azure-automation.net",
    "blob.core.windows.net",
    "services.visualstudio.com",
    "applicationinsights.azure.com",
    "purview.azure.com",
    "purviewstudio.azure.com",
    "purview-service.microsoft.com",
    "prod.migration.windowsazure.com",
    "azure.com",
    "grafana.azure.com",
    "vault.azure.net",
    "vaultcore.azure.net",
    "managedhsm.azure.net",
    "azconfig.io",
    "attest.azure.net",
    "table.core.windows.net",
    "queue.core.windows.net",
    "file.core.windows.net",
    "web.core.windows.net",
    "dfs.core.windows.net",
    "afs.azure.net",
    "search.windows.net",
    "azurewebsites.net",
    "scm.azurewebsites.net",
    "service.signalr.net",
    "webpubsub.azure.com"
)

# Loop through each DNS zone and create a conditional forwarder
foreach ($zone in $DNSZones) {
    Add-DnsServerConditionalForwarderZone -Name $zone -ReplicationScope $ReplicationScope -MasterServers $ForwarderIP
}
