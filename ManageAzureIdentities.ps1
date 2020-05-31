<#
Let's learn how to manage Azure AD identities (Users, Groups & Azure AD roles) in Azure using PowerShell

1. Task 1 - User Management
              a) Find users in Azure AD
              b) Create a user in Azure AD

2. Task 2 - Group Management
                a) Find Azure AD Groups and users in those groups
                b) Create an Azure AD Group
                c) Set owner and add multiple users in the group
                d) Create a Dynamic Group

3. Task 3 - Azure AD Role Assignment
               a) Find an Azure AD Role
               b) Assign an Azure AD role to a user
#>
##############################################################################################################################

                                                #Task 1 - User Management#

##############################################################################################################################

# Install AzureAD Powershell Module
Install-Module -Name AzureAD

# Import AzureAD PowerShell Module
Import-Module -Name AzureAD

# Connect to Azure
Connect-AzAccount

# Connect to Azure AD
Connect-AzureAD -TenantId ef676517-XXXX-XXXX-XXX-XXXXX

# Find the user in Azure AD
Get-AzureADUser -SearchString "testuser101"

# Find the user in Azure AD with the location listed as US
Get-AzureADUser -Filter "State eq 'US'"

# Create user in Azure AD

$domain = "jaspreetxsinghoutlook.onmicrosoft.com"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "azure@123"

$user = @{

    City = "Wellington"
    Country = "US"
    Department = "Information Technology"
    DisplayName = "TestUser102"
    GivenName = "TestUser102"
    JobTitle = "IT Specialists"
    UserPrincipalName = "testuser102@$domain"
    PasswordProfile = $PasswordProfile
    PostalCode = "19001"
    State = "PA"
    StreetAddress = "2 bluff Highway"
    Surname = "102"
    TelephoneNumber = "215-347-0021"
    MailNickname = "testuser102"
    AccountEnabled = $true

}

$newuser = New-AzureADUser @user

$newuser | Format-List

##############################################################################################################################

                                            #Task 2 - Group Management#

##############################################################################################################################

# Get all groups from Azure AD
Get-AzureADGroup

# Get the Information Technology Group
$group = Get-AzureADGroup -SearchString "DBA"

# Get all the members and owner of the Azure AD Group
Get-AzureADGroupMember -ObjectId $group.ObjectId

# Find the owner of the group
Get-AzureADGroupOwner -ObjectId $group.ObjectId

# Create a new Azure AD Group

$NewGroup = @{
    DisplayName = "Marketing Group"
    Description = "This is a security group for Marketing Team"
    MailEnabled = $false
    MailNickName = "MarketingGroup"
    SecurityEnabled = $true
    
}

$newgroup = New-AzureADGroup @NewGroup

$newgroup

# Update the group description
Set-AzureADGroup -ObjectId $newgroup.ObjectId -Description "For Security Specialists"

# Set user1 as the owner of the group
$User1 = Get-AzureADUser -Filter "DisplayName eq 'demotestuser1'"
Add-AzureADGroupOwner -ObjectId $newgroup.ObjectId -RefObjectId $User1.ObjectId

# Add multiple users to the security group
$users = Get-AzureADUser -SearchString "Demotestuser"
foreach($user in $users){
Add-AzureADGroupMember -ObjectId $newgroup.ObjectId -RefObjectId $user.objectId
}

# Add a new user in Azure AD Group

# To add a user in the group we need to find the Object ID of the group & the user
$MarketingGroup = Get-AzureADGroup -Filter "Displayname eq 'Marketing Group'"
$User = Get-AzureADUser -Filter "Displayname eq 'testuser102'"

# Now add a user to the group
Add-AzureADGroupMember -ObjectId $MarketingGroup.ObjectId -RefObjectId $User.ObjectId

# Verify the group & members of the group
Get-AzureADGroup
Get-AzureADGroupMember -ObjectId $newgroup.ObjectId

# Create Dynamic Group
New-AzureADMSGroup -DisplayName "Dynamic Group 01" -Description "Dynamic group created from PS" -MailEnabled $False -MailNickName "group" -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(user.department -contains ""Marketing"")" -MembershipRuleProcessingState "On"

$dynamicGroup = @{
    DisplayName = "Telemarketing Group"
    MailEnabled = $false
    MailNickName = "TelemarketingGroup"
    SecurityEnabled = $true
    Description = "Dynamic group for Marketing"
    GroupTypes = "DynamicMembership"
    MembershipRule = "(user.department -contains ""Marketing"")"
    MembershipRuleProcessingState = "On"
}
New-AzureADMSGroup @dynamicGroup


##############################################################################################################################

                                        #Task 3 - Azure AD Role Management#

##############################################################################################################################

# Get the Azure AD Role (Enabled)

Get-AzureADDirectoryRole | Select-Object -Property Displayname, Description | Sort-Object -Property DisplayName
# The above command does not show all the roles because the roles won't be enabled in PowerShell unless you populated them with at least one user. Run the below command to view all the in-built Azure AD roles

Get-AzureADDirectoryRoleTemplate | Select-Object -Property DisplayName, Description | Sort-Object -Property DisplayName

# Assing Power BI Service Administrator role to demotestuser11
$RoleTemplate = Get-AzureADDirectoryRoleTemplate | Where-Object {$_.DisplayName -eq "Power BI Service Administrator"}

Enable-AzureADDirectoryRole -RoleTemplateId $RoleTemplate.ObjectId

# Verify if the Power BI Service Administrator role is active and showing in the list of roles
Get-AzureADDirectoryRole | Select-Object -Property Displayname, Description | Sort-Object -Property DisplayName

# Assign the variable to the role
$role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Power BI Service Administrator'}

# Find the user in Azure AD to assign the role
$rolemember = Get-AzureADUser -ObjectId "demotestuser11@jaspreetxsinghoutlook.onmicrosoft.com"

# Assign the role to the user
Add-AzureADDirectoryRoleMember -ObjectId $Role.ObjectId -RefObjectId $rolemember.ObjectId

# Verify the membership of the user
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser