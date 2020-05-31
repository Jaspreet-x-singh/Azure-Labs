# In this example, we will create azure resources and apply tags on those azure resources using PowerShell

$ResourceGroupName = "CloudMaster"
$Location = "AustraliaEast"
$WebAppName = "cloud179"


# To connect to the subscription
Connect-AzAccount

# Create a resource group
New-AzResourceGroup -Name CloudMaster -Location $Location

# Create a App Service Plan in the Resource Group
New-AzAppServicePlan -Name "cloud9" -Location $Location -ResourceGroupName "CloudMaster" -Tier Free

# Create a Web App in the Resource Group
New-AzWebApp -Name $WebAppName -Location $Location -AppServicePlan "cloud9" -ResourceGroupName $ResourceGroupName

# Publish Web App
Publish-AzWebApp -ResourceGroupName $ResourceGroupName -Name $WebAppName -ArchivePath WebApplicationDemo.deps.zip


# Get the existing Tags from all the resources
Get-AzTag

# Get Tag from the particular Resource Name
(Get-AzResource -ResourceGroupName $ResourceGroupName -resourcename $WebAppName).Tags

# Check existing Tags
(Get-AzResourceGroup -Name $ResourceGroupName).Tags

# Assign Tags to the resource group
Set-AzResourceGroup -Name $ResourceGroupName -Tag @{Dept = "IT"; Owner="Jaspreet Singh"}

# Get a reference to an Azure Resource
$r = Get-AzResource -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites

 # Add new tags to existing Tags
$tags = (Get-AzResourceGroup -Name $ResourceGroupName).Tags
$tags.Add("CostCenter", "6011")
#or
$tags +=@{Location = "NZ"; LifeCyclePhase = "Testing"}

# Write new tags to an azure resource
Set-AzResource -ResourceId $r.Id -Tag $tags -Force

# Write new tags to the Azure Resource Group
Set-AzResourceGroup -Name $ResourceGroupName -Tag $tags

# Remove the Tags
Set-AzResourceGroup -Tag @{} -Name $ResourceGroupName


