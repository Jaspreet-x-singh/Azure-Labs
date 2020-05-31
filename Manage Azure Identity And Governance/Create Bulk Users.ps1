# Connect to Azure
Connect-AzAccount -Tenant egXXXXXXXXXX-XXXXXXXXXX

### Connect to AzureAD
Connect-AzureAD -TenantId $TenantId

     
###Global Variable
$AzureDirectory = "@jaspreetxsingh.onmicrosoft.com"
 
foreach($i in 1..10) {  
$RandomPassword = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | Sort-Object {Get-Random})[0..12] -join ''
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = $RandomPassword
$Username = "demotestuser" + $i
$AccountName = $Username +$AzureDirectory
$firstname = "Demo"
$LastName = "testuser"
$Phone = "02102020203"
New-AzureADUser -DisplayName $Username -PasswordProfile $PasswordProfile -UserPrincipalName $AccountName -AccountEnabled $true -MailNickName $Username -GivenName $firstname -Surname $LastName -TelephoneNumber $Phone -Mobile $Phone
$AccountName|Out-File -FilePath C:\Temp\jaspreet_Script_output.csv -Append
$RandomPassword |Out-File -FilePath C:\Temp\jaspreet_Script_output.csv -Append    
}