#-----------------------------------------------------------
#
#    This script will parse a single group for all 
#    group memebers and nested groups and export a CSV
#    to C:\Admins.  Edit line 13 to change the export path
#    if required.  
#
#    You may need to run this multiple times one each group
#    name to gather all the details
#
#-----------------------------------------------------------

$Outputpath = "ADAdmins";

$Currentlocation = Get-Location
$PathTest = Test-Path -path "C:\$($Outputpath)";
$Server = Read-Host -Prompt "Input the FQDN for the Domain (Example:  r1.aig.net)"
$ADGroupName = Read-Host -Prompt "Input the Group (Example:  Administrators or Domain Admins)"
$CsvPath = "c:\$($outputpath)\$($Server)_$($ADGroupName)_$(Get-Date -Format ddMMyyyy).csv"
#$ADGroupName = "Administrators"
$Output = @()

if ($pathtest -eq $FALSE )
	{
	cd "C:\";
	mkdir $($Outputpath)
	write-host "Output path $($Outputpath) created"
	CD $currentlocation
	}
elseif ($pathtest -eq $TRUE )
	{ 
	write-host  "Output path exists, Continuing script"
	}


$ADGroupMembers_Users = Get-ADGroupMember $ADGroupName -Recursive -Server $Server
$ADGroupMembers_Groups = Get-ADGroupMember $ADGroupName -Server $Server | Where-Object {$_.ObjectClass -eq "group"}

foreach ($m in $ADGroupMembers_Users) {
  $Output += Get-ADUser $m | select Name,GivenName,sn,SamAccountName,Description,Department,employeeID,ObjectClass,Enabled
}

foreach ($m in $ADGroupMembers_Groups) {
  $Output += Get-ADGroup $m -Properties Description | select Name,Description,ObjectClass
}

$Output | Export-Csv -NoTypeInformation -Path $CsvPath
