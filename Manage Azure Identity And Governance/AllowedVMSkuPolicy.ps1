
# Reference - https://docs.microsoft.com/en-us/azure/governance/policy/how-to/programmatically-create
# https://www.petri.com/control-virtual-machines-sizes-azure-admins-can-deploy

# Connect to Azure Portal
Connect-AzAccount

# Register Microsoft Policy Insights before using Azure Policy

Register-AzResourceProvider -ProviderNamespace "Microsoft.PolicyInsights"

# Create a policy Definition

New-AzPolicyDefinition -Name 'allowedVmSkuPolicy' -DisplayName 'Audit VM SKU Size' -Policy 'C:\Repo_Learning\Learning\SQL Commands\AllowedVMSkuPolicy.json'

# Create a Policy Assignment

$RG = Get-AzResourceGroup -Name Dev
$Policy = Get-AzPolicyDefinition -Name 'allowedVmSkuPolicy' 

New-AzPolicyAssignment -Name 'allowedVmSkuPolicy' -PolicyDefinition $Policy -Scope $RG.ResourceId

# Verify the new Azure Policy Definition

Get-AzPolicyDefinition -Name 'allowedVmSkuPolicy'

########################################################################################
Login-AzureRmAccount

$rg = Get-AzureRmResourceGroup -Name firstdevtestlabs013940422614002

$Policy_Def= Get-AzureRmPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq "Audit VMs that do not use managed disks" }

New-AzureRmPolicyAssignment -Name "Check for Managed Disks" -DisplayName "Check for Managed Disks" -Scope $rg.ResourceId -PolicyDefinition $Policy_Def