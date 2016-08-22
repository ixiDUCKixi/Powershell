#-----------------------------------------------------------
#
#    This script will parse a single group for all 
#    group memebers and nested groups and export a CSV
#    to C:\Admins.  Edit line 16 to change the export path
#    if required.  
#
#    You may need to run this multiple times one each group
#    name to gather all the details
#
#-----------------------------------------------------------


$Server = Read-Host -Prompt "Input the FQDN for the Domain (Example:  r1.aig.net)"
$ADGroupName = Read-Host -Prompt "Input the Group (Example:  Administrators)"
$CsvPath = "c:\ADAdmins\$($Server)_Administrators_$(Get-Date -Format ddMMyyyy).csv"
#$ADGroupName = "Administrators"
$Output = @()

$ADGroupMembers_Users = Get-ADGroupMember $ADGroupName -Recursive -Server $Server
$ADGroupMembers_Groups = Get-ADGroupMember $ADGroupName -Server $Server | Where-Object {$_.ObjectClass -eq "group"}

foreach ($m in $ADGroupMembers_Users) {
  $Output += Get-ADUser $m | select Name,SamAccountName,Description,ObjectClass,Enabled
}

foreach ($m in $ADGroupMembers_Groups) {
  $Output += Get-ADGroup $m -Properties Description | select Name,Description,ObjectClass
}

$Output | Export-Csv -NoTypeInformation -Path $CsvPath