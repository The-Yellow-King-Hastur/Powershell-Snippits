$Import = Import-Csv -Path "[PATH]\All_Home_Drives.csv" -Header "Name" -Delimiter ","

    $i=0
    foreach($Drive in $Import){
    $Path = $Drive.Name
    $folderSize = Get-ChildItem -Force -Path $Path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue
    $folderSizeInMB = "{0:N2} MB" -f ($folderSize.Sum / 1MB)
    $folderSizeInGB = "{0:N2} GB" -f ($folderSize.Sum / 1GB)
    
        $FolderProperties = @{
            SizeInGB = $folderSizeInGB
            SizeInMB = $folderSizeInMB
            Folder = $Path
            }
        New-Object PSObject -Property $FolderProperties

      
        $Progress = $i/$Import.count*100
        Write-Progress -Id 1 -Activity "Locating" -Status "Drive $Path found." -PercentComplete $Progress
        Start-Sleep -Milliseconds 100;$i++

        $j=0
        $Progress2 = $j/$Path.count*100
            foreach($child in Get-ChildItem -Force -Path $Path -Recurse -ErrorAction SilentlyContinue){
            $Sub = $child
        Write-Progress -ParentId 1 -Activity "Scanning" -Status "Now Calculating: $Path\$Sub" -PercentComplete $Progress2
        Start-Sleep -Milliseconds 10;$j++
        }

    $Output = [PSCustomObject]@{
        
            'Folder' = $Path;
            'SizeMB' = $folderSizeInMB
            'SizeGB' = $folderSizeInGB
            }

            $Output | Export-Csv -Path "[PATH]\All_Home_Drive_Size.csv" -NoTypeInformation -Append
}


