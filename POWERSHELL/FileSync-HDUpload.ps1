 $souceFolder = $ARGS[0]
 $targetFolder = $ARGS[1]

function main ($sourceFolder, $targetFolder) {

    #$targetFolder = "F:\CACHE\ETERE\"
    #$videoServer = "\\10.3.65.103\fs0\clip.dir\"
    #$videoServer = "F:\CACHE\ETERE\"
        
    
    $sourceItems = Get-ChildItem -path $souceFolder -Recurse
    $targetItems = Get-ChildItem -path $targetFolder -Recurse
    
    #$targetItems.Length
    
    if ($sourceItems.Length -eq 0) {
        exit
    }
    
    ### remove processed files
    
 
    $removeItems = Compare-Object -ReferenceObject $sourceItems -DifferenceObject $targetItems -PassThru | ?{$_.sideIndicator -eq "=>"}

    foreach ($itemToRemove in $removeItems)
    {

        $t = get-date
        if ($itemToRemove -eq $null) {
            continue
        }
        write-host "AAA : $itemToRemove"
        $f = $itemToRemove.ToString().Trim()
        if ($f -eq '') {
            continue
        }
            
        $targetFile = $targetFolder + "\" + $f

    
        $logline1 = "$(Get-Date), remove $targetFile"
        Write-Host $logline1
        Remove-Item -Path $targetFile -verbose
    }
    
    
    #### copy new files
    
    
    if ($targetItems -eq $null) {
        $differentItems = $sourceItems
    } else {
        $differentItems = Compare-Object -ReferenceObject $sourceItems -DifferenceObject $targetItems -PassThru | ?{$_.sideIndicator -eq "<="}
    }

    if ($differenctItems -eq $null) {
        $t = get-date
        write-host "$t : The $targetFolder is most up-to-date"
    }

    foreach ($itemToCopy in $differentItems)
    {

        $t = get-date
        if ($itemToCopy -eq $null) {
            write-host "$t : The $targetFolder is most up-to-date"
            continue
        }
        $f = $itemToCopy.ToString().Trim()
        if ($f -eq '') {
            continue
        }
            
        $sourceFile = $souceFolder +  "\" + $f
        $targetFile = $targetFolder + "\" + $f

    
        $logline1 = "$(Get-Date), $sourceFile, $targetFile"
        Write-Host $logline1
        #Copy-File $sourceFile $targetFile
        Copy-Item -Path $sourceFile -Destination $targetFile -verbose
    
        #write-host "$sourceFile, $targetFile"
        Start-Sleep -s 8
        #& $CMD $tempFilename


        #Rename-Item $tempFilename $targetFile

    }

}



while ($true)
{
    main $sourceFolder $targetFolder
    Start-Sleep -s 20
}
