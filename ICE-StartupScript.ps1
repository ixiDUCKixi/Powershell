Get-Module -ListAvailable | Where-Object {$_.Path -like 'C:\Scripts\*'} | Update-Module -Force -Confirm:$false -ErrorAction SilentlyContinue 
