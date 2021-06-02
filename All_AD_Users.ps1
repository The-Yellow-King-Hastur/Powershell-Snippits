$UserList = Get-ADUser -filter * -SearchBase "OU=[OU NAME],OU=[OU NAME],DC=[DC NAME],DC=[DC NAME],DC=[DC NAME],DC=[DC NAME]" -SearchScope Subtree -Properties Name,HomeDirectory  | Select-Object Name,HomeDirectory
$Export = Export-Csv -Path "[INPUT PATH]\All_User_Drives.csv" -NoTypeInformation -Append
$i=0
foreach($User in $UserList){
$Progress = $i/$UserList.count*100
Write-Progress -Activity 'Locating Users and Home Drives' -CurrentOperation $User -PercentComplete $Progress
Start-Sleep -Milliseconds 200;$i++
} 
$Export
