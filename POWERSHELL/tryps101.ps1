$case = $ARGS[0]
$subcase = $ARGS[1]
write-output "$case : $subcase"

if ($case -eq 0) {
    $env:HD_FILE_MANAGER_LOG = '\\10.13.200.1\MasterCtrl\HD_FILE_MANAGER_LOG'
    $env:LOUTH_LOG='\\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML'
    $env:WORKSPACE='J:\Qsync\WORKSPACE\SHELL'
} elseif ($case -eq 1) {
    write-output 'case1'
} elseif ($case -eq 2) {
    write-output 'case 2'
} elseif ($case -eq 3) {
    Get-ExecutionPolicy
    Set-ExecutionPolicy RemoteSigned
} elseif ($case -eq 'case-get-eventlog') {
    # $_ represent current object
    $event = Get-EventLog -logname application -newest 100
    $event | select-string -inputobject{$_.message} -pattern "Error"
} elseif ($case -eq 6) {
    write-output 'case 6'
    #Get-ChildItem -path \\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML -include *.xml.dberr #not work
    #Get-ChildItem -path \\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML\* -include *.xml.dberr #work
    #Get-ChildItem -path \\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML\ -include *.dberr -Recurse #work
    #Get-ChildItem \\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML
    pwd
} elseif ($case -eq 7) {  #check if there is *.dberr file
    write-output 'case 7'
    $XMLPath = "\\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML"
    $c = get-date -UFormat %Y%m%d

    for ($i = $c - 7; $i -le $c; $i++) {
        #Write-Output $i
        #$filelist = Get-ChildItem $XMLPath -name -filter $i-*.xml
        $filelist = Get-ChildItem $XMLPath -name -filter $i-*.dberr
        #write-output $filelist
        #write.output $filelist.count
        foreach ($e in $filelist) {
            write-output $e
            get-content $XMLPath\$e
        }

    }
    #$filelist = Get-ChildItem $XMLPath -name
    #$filelist
} elseif ($case -eq 8) {
    write-output 'case 8'
    $XMLPath = "\\10.13.200.1\MasterCtrl\MSG\LOUTH\HD-InputXML"
    $fname = "20160917-125101.xml"
    $lines = get-content $XMLPath\$fname
    foreach ($l in $lines) {
        write-output $l
    }
}  elseif ($case -eq 9) { #主控刪除清單 portotype of bin\purge.ps1
    write-output 'case 9'
    $LOGPath = "D:\Log_HDfileUpload"
    $c = get-date -UFormat %Y%m%d
    $c = $c -1
    $purgeFile = "D$c.log"
    #write-output $purgeFile
    $lines = get-content $LOGPath\$purgeFile
    #clear-content purge20160920.txt
    clear-content purge20160919.txt
    foreach ($l in $lines) {
        #write-output $l
        $video = $l.split(":")
        $videoID = $video[4].split(".")
        Write-Output $videoID[0] | add-Content purge20160919.txt
    }
} elseif ($case -eq 10) {  #copy file
    write-output 'case 10'
    $logPath = "d:\Log_HDFileUpload"
    $c = get-date -UFormat %Y%m%d
    $c = $c - 1
    $f = "$logPath/D$c.log"
    $dest = "\\10.1.253.15\office\7-工程部\主控刪除清單"
    copy-item -path $f $dest
} elseif ($case -eq 12) {
    write-output 'case 12'
    $LOGPath = "D:\Log_HDfileUpload"
    $cdate = get-date -UFormat %Y%m%d
    $yesterday = $cdate - 1
    $dest = "d:\workspace\tmp"
    $logfiles = "*$yesterday.log"
    $deletefile = "D$cdate.log"

    copy-item -path "$LOGpath\$logfiles" -dest $dest -verbose
    copy-item -path "$LOGPath\$deletefile" -dest $dest -verbos



} elseif ($case -eq 15) {
    write-output 'case 15'
    #like du -h -d1
    #統計資料夾的容量大小 MAMdownload
    $startFolder = 'c:\'
    $colItems = Get-ChildItem $startFolder | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    foreach ($i in $colItems)
    {
        $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
        $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
    }
} elseif ($case -eq 16) {
    write-output 'case 16'
    #回報 10.13.200.6 的容量
} elseif ($case -eq 17) {
    write-output 'case 17'
    get-item ./ | Get-Member
} elseif ($case -eq 18) { #WMI
    write-output 'case 18'
    get-ciminstance -Namespace root\securitycenter2 -classname antispywareproduct
} elseif ($case -eq 19) { #PSProider
    write-output 'case 19'
    Get-PSDrive  #get PSDrive mapping info
    new-item -type directory testfolder   #mkdir testfolder

} elseif ($case -eq 20) {
    write-output 'case 20'
    #emulate linux top
    while (1) { ps | sort -desc cpu | select -first 30; sleep -seconds 2; cls }
    While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 5; cls}


} elseif ($case -eq 21) { #Where-Object
    write-output 'case 21'
    get-process | where {$_.ProcessName -match "[^chrome|svchost|WmiPrvSE]"} # filter out process

} elseif ($case -eq 23) { #Timecode converter Drop frame : frame2timecode()
    write-output 'case 23'
    #實際上 1小時的帶有 108108 frames
    $dropH = 60*60*29.97 #107892
    $dropM = 60*29.97 #1798.2
    $dropM10 = 17982
    $dropS = 1798

    $frames = 1801
    $frames = $ARGS[1]
    $HH = [MATH]::Floor($frames / $dropH)
    write-output $HH
    $itmp = $frames % $dropH
    write-output $itmp
    $MM = [MATH]::Floor($itmp/$dropM10) *  10  #算有多少10 分鐘
    #$MM = [MATH]::Floor($itmp/1798.2)
    write-output $MM
    $itmp = $itmp % $dropM10
    if ($itmp -gt 2) {
        $t = ($itmp - 2) /$dropS #第一分鐘不須 sikp frames 00:00:59:29 -> 00:01:00:02
        #write-output 't=' $t
        $M1 = [MATH]::Floor($t)
        write-output $M1
        $itmp = ($itmp - 2) % $dropS
        $itmp = $itmp + 2
        #$itmp = $itmp % dropS ==> got wrong result 1798 : 00:00:00;00, 1799:00:00:00;01
    } else {
        $M1 = 0
    }

    $MM = $MM + $M1
    $SS = [MATH]::Floor($itmp/30)
    $FF = $itmp % 30

    write-output $HH':'$MM':'$SS':'$FF

} elseif ($case -eq 24) {
    $nonDropH = 60*60*30 #108000
    $nonDropM = 60*30
    $nonDropS = 30

    $frames = 1801
    $HH = [MATH]::Floor($frames /$nonDropH)
    $itmp = $frames % $nonDropH
    $MM = [MATH]::Floor($itmp/$nonDropM)
    $itmp = $itmp % $nonDropM
    $SS = [MATH]::Floor($itmp / $nonDropS)
    $FF = $itmp % $nonDropS
    write-output $HH':'$MM':'$SS':'$FF

} elseif ($case -eq 25) {
    $frameNumber = 1801 # 00:01:00;03
    $frameNumber = 19782 # 00:11:00;02
    $frameNumber = 19781 # 00:10:59;29
    $frameNumber = $ARGS[1]
    $drop10M = 17982
    $dropM = 1798
    $D = [MATH]::Floor($frameNumber/$drop10M)
    $M = $frameNumber % $drop10M
    $frameNumber = $frameNumber + 18 * $D + 2 * [MATH]::Floor(($M - 2) / $dropM)

    $frames = $frameNumber % 30
    $seconds = [MATH]::Floor($frameNumber / 30) % 60
    $minutes = [MATH]::Floor([MATH]::Floor($frameNumber / 30) / 60) % 60
    $hours = [MATH]::Floor([MATH]::Floor([MATH]::Floor($frameNumber / 30) / 60) / 60) % 24

    write-output $hours':'$minutes':'$seconds':'$frames

} elseif ($case -eq "C_Compare_Object") { #cannot use C_Compare-Object
    if ($False) {
       if (Test-path -path c:\temp\A) {
           remove-item -path C:\temp\A -Recurse
       }

       if (Test-Path -path c:\temp\B) {
           remove-item -path c:\temp\B -Recurse
       }

       mkdir C:\temp\A
       touch c:\temp\A\1.txt
       touch c:\temp\A\2.txt
       touch c:\temp\A\3.txt
       touch c:\temp\A\5.txt
       copy-item -Path c:\temp\A -Destination c:\temp\B -Recurse
       touch c:\temp\A\6.txt
       touch c:\temp\A\7.txt
       touch c:\temp\B\8.txt
       touch c:\temp\B\9.txt

       mkdir c:\temp\A\C\D
       touch c:\temp\A\C\1.txt
       touch c:\temp\A\C\2.txt
       touch c:\temp\A\C\3.txt
       touch c:\temp\A\C\4.txt

       touch c:\temp\A\C\D\1.txt
       touch c:\temp\A\C\D\4.txt

       mkdir c:\temp\B\C
       touch c:\temp\B\C\1.txt
       touch c:\temp\B\C\2.txt
       touch c:\temp\B\C\3.txt
       touch c:\temp\B\C\4.txt

       compare-object -referenceobject $(get-childitem "c:\temp\A") -differenceobject $(get-childitem "c:\temp\B")
    }

    if ($False) {
        #if targetItems = null, the compare-object will fail
        $sourceItems = Get-ChildItem -path \\10.13.200.6\Approved
        $targetItems = @(Get-ChildItem -path \\10.13.200.25\Approved)

        if ($targetItems.Length -eq 0) {
            write-host "empty1"
        }

    }

    if ($False) {
        #if targetItems = null, the compare-object will fail
        $sourceItems = Get-ChildItem -path \\10.13.200.6\Approved
        $targetItems = Get-ChildItem -path \\10.13.200.25\Approved
        $targetItems
        if ($targetItems -eq $null) {
            write-host "empty1"
        } else {
            #$differentItems = Compare-Object -ReferenceObject $sourceItems -DifferenceObject $targetItems -PassThru | ?{$_.sideIndicator -eq "<="}
            $differentItems
        }
    }

    if ($False) {
        #if targetItems = null, the compare-object will fail
        $targetItems = Get-ChildItem -path \\10.13.200.25\Approved
        $targetItems.Length
        if ($targetItems.Length -eq 0) {
            write-host "empty1"
        }
    }

    if ($false) {
        compare-object -referenceobject $(get-childitem "\\10.13.200.6\HDUpload") -differenceobject $(get-childitem "\\10.13.200.25\HDUpload")
    }

    if ($False) {
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B")
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru | ?{$_.sideIndicator -eq "<="}


        #remove file
        $diffObj = compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru | ?{$_.sideIndicator -eq "=>"}   #show right side only
        #$diffObj | get-member  #System.IO.FileInfo
        write-host "-----------------------"
        foreach ($obj in $diffObj) {
            #$obj | get-member #System.IO.FileInfo
            $fname = $obj.ToString()
            #$f2 = $obj.Name
            #write-host "A:$f1"
            #write-host "B:$f2"
            remove-item -path "c:\temp\B\$fname"  -verbose
        }


        #copy new file
        $diffObj = compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru | ?{$_.sideIndicator -eq "<="}   #show left side only
        foreach ($obj in $diffObj) {
            $fname = $obj.ToString()
            copy-item -path "c:\temp\A\$fName" -dest "c:\temp\B\$fname" -verbose
        }
    }

    if ($False) {  #compare
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B")
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru
        #compare-object -ReferenceObject $(get-childitem "c:\temp\A") -differenceObject $(get-childitem "C:\temp\B") -PassThru | ?{$_.sideIndicator -eq "<="}
        #$sourceDIR = "\\10.13.200.6\HDUpload"
        #$targetDIR = "\\10.13.200.25\HDUpload"
        $sourceDIR = "C:\temp\A"
        $targetDIR = "C:\temp\B"

        $sourceObj = get-childitem -path $sourceDIR -Recurse
        $targetObj = get-childitem -path $targetDIR -Recurse

        #remove file
        $checkObj = compare-object -ReferenceObject $sourceObj -differenceObject $targetObj -PassThru | ?{$_.sideIndicator -eq "<="}
        #$diffObj | get-member  #System.IO.FileInfo
        #compare-object -ReferenceObject $sourceDIR -differenceObject $targetDIR -PassThru -IncludeEqual | Select-Object -property FullName, SideIndicator
        write-host "-----------------------"
        foreach ($obj in $checkObj) {
            $type = $obj.getType().Name

            if ($type -eq "DirectoryInfo") {
                $dir = $obj.FullName
                $targetObj = $dir.Replace($sourceDIR, $targetDIR)
                if (!(Test-Path -path $targetObj)) {
                    mkdir $targetObj -Verbose
                }
            } else {
                $fname = $obj.FullName
                $targetObj = $fname.Replace($sourceDIR, $targetDIR)
                if (!(Test-Path -path $targetObj)) {
                    new-item -path $targetObj -itemType File -verbose
                }
            }

        }

    }

    if ($False) {  #diffsize.ps1
        $sourceObj = get-childitem -path $sourceDIR
        $targetObj = get-childitem -path $targetDIR


        $checkObj = compare-object -ReferenceObject $sourceObj -differenceObject $targetObj -PassThru -IncludeEqual | ?{$_.sideIndicator -eq "=="}


        foreach ($obj in $checkObj) {

            $fname = $obj.ToString()
            $srcObj = get-item -path $sourceDIR\$fname
            $destObj = get-item -path $targetDIR\$fname
            $type = $srcObj.GetType().Name
            if ($type -ne "FileInfo") {
                #write-host "$fname : $type"
                continue
            }

            $size1 = get-item -path $sourceDIR\$fname | Select-Object -ExpandProperty Length
            $size2 = get-item -path $targetDIR\$fname | Select-Object -ExpandProperty Length

            if ($size1 -ne $size2) {
                write-host "$fname : $size1 : $size2"
            }
        }
    }

    if ($True) {
        $SOURCE_DIR = "\\10.13.200.22\mamnas1\Approved\MACRO"
        $TARGET_DIR = "\\10.13.200.22\mamnas1\Approved"

        $sourceObj = Get-ChildItem -path $SOURCE_DIR
        $targetObj = get-childItem -path $TARGET_DIR

        $equalObj = compare-object -ReferenceObject $sourceObj -DifferenceObj $targetObj -PassThru -IncludeEqual | ?{$_.SideIndicator -eq "=="}
        foreach ($obj in $equalObj) {
            $fname = $obj.Name
            $srcObj = "$SOURCE_DIR\$fname"
            $destObj = "$TARGET_DIR\$fname"
            $srcSize = get-item $srcObj | ?{$_.Length}
            $destSize = get-item $destObj | ?{$_.Length}


            if ($srcSize -eq $destSize) {
                write-host "$srcObj = $srcSize, $destObj = $destSize"
            }
        }
    }
} elseif ($case -eq "C_Replace") {
    $src = "C:\temp\A"
    $dest = "C:\temp\B"
    $str1 = "C:\temp\A\C\D\1.txt"
    $str2 = $str1.Replace($src, $dest)
    $str2

} elseif ($case -eq "C_import-csv") {
    if ($False) {
        $p = import-csv c:\temp\purge.txt -Delimiter ','
        foreach ($i in $p) {
           $i
           break
        }
    }

    if ($False) {
        $audioList = import-csv C:\temp\AUDIO.log
        #$audioList | get-Member
        #break
        $arrList = New-Object System.Collections.ArrayList
        $h = New-Object System.Collections.Hashtable
        foreach($a in $audioList) {
            #$a | Get-Member
            $time = $a.TIME
            $status = $a.STATUS
            $video = $a.VIDEO
            if (!$arrList.Contains($video)) {
                $arrList.Add($video)
            }
            if (!$h.ContainsKey($video)) {
                $h.Add($video)
            }


            #write- '$time || $status || $video'
            #break
        }
        $arrList
    }

    if ($False) {
        $TARGET_DIR = "\\10.13.200.22\mamnas1\Approved\"
        $copyList = import-csv C:\temp\ToApproved.csv
        foreach ($c in $copyList) {
            $gpfsObj = $c.GPFS
            $videoID = $c.VIDEO_ID.SubString(2,6)
            Write-Host "GPFS = $gpfsPath, VIDEO ID = $videoID"
            $targetObj = "$TARGET_DIR\$videoID.mxf"
            if ((Test-Path $targetObj) -ne $True) {
                Write-Host "Need copy $gpfsObj to $targetObj"
            } else {
                write-host "Found $targetObj"
            }
        }
    }


} elseif ($case -eq "C_split") {
    if ($Flase) {
        $str = "This string is cool. Very cool. It also rocks. Very cool. I mean dude.Very cool. Very cool."
        $str.Split("also")
        $str = "新北市中和區中和路前0公尺處永貞路路口，永車道"
        $a = $str.Split("路")
        $a[0]
        $str.Split({"路"})[0]
        $str.Split({"路", "口"})
    }

    if ($True) {
        $CopyToApprovedList = "\\10.13.200.6\Approved\GPFS-Approved_List.txt"
        BCP "select FSFILE_PATH_H, FSVIDEO_PROG from MAM..VW_GET_IN_TAPE_LIBRARY_LIST_MIX_TO_APPROVED" queryout $CopyToApprovedList -c -t "," -S 10.13.210.33 -U "mam_admin" -P "ptsP@ssw0rd"
        $TARGET_DIR = "\\10.13.200.22\mamnas1\Approved\"
        $copyList = get-content $CopyToApprovedList
        $num = $copyList.Count
        Write-host "$num need to process"
        $count = 1
        foreach ($c in $copyList) {
            $arr = $c.Split(",")
            $gpfsObj = $arr[0].Trim()
            $videoID = $arr[1].SubString(2,6).Trim()
            $targetObj = "$TARGET_DIR\$videoID.mxf"
            if ((Test-Path $targetObj) -ne $True) {
                Write-Host "$count $num Need copy $gpfsObj to $targetObj"
            } else {
                write-host "$count $num : Found $targetObj"
            }
            $count++
        }
        $num = $copyList.Count
        Write-host "$num is copied"
    }

} elseif ($case -eq "C_Web") {
    if ($True) {
        $url = $ARGS[1]
        $url
        $client = New-Object System.Net.WebClient
        $contents = $client.DownloadString($url)
        $contents
    }
} elseif ($case -eq "C_Web_Service") {
    $serviceUrl = "http://10.13.220.3/DataSource/WSPTS_AP.asmx?op=PTS_Get_MoveJobs"
    $url = "$serviceUrl"
    $client = New-Object System.Net.WebClient
    $contents = $client.DownloadString($url)
    get-content $contents
    write-host "TESTA"
    $xmlDoc = [xml] $contents
    write-host "TESTB"
    $xmlDoc
} elseif ($case -eq "C_move-item") {
    if ($True) {
        move-item no-such-file.txt c:\A\
        write-output $?   # False
        move-item file-exist.txt c:\NO-SUCH-FOLDER\
        write-output $?  # True
    }

} elseif ($case -eq 'C_get-childitem') {

    if ($True) {
       #get-childitem -path //10.13.200.25/MAMDownload -File -Recurse
       #get-childitem -path //10.13.200.25/MAMDownload/hsing1 -Recurse -exclude hsing1*
       #get-childitem -path //10.13.200.25/MAMDownload/hsing1 -Recurse  | ?{$_.PSIsContainer -and $_.FullName -notmatch "hsing1"}
       #get-childitem -path //10.13.200.25/MAMDownload/hsing1 -Recurse -File | ?{$_.FullName -notmatch "hsing1"}
       #Filter specific folder
       get-childitem -path //10.13.200.25/MAMDownload/ -Recurse -File | sort-object CreattionTime | where {$_.FullName -notmatch "hsing1"} | %{$_.FullName}
    }

    if ($False) {

        #This command gets only the names of items in the current directory.
        get-childitem -path ./ -name

        #to get file list of size 0
        get-childitem -path ./ -recurse  | where-object {$_.length -eq 0} |
        get-childitem -name |
        out-file size0.txt

        Get-ChildItem env:
        #to show specific env
        $env:HOMEPATH

        #to create, modify env variable
        $env:VAR='sdddddd'

        get-childitem ./  | %{$_.FullName, $_.Length, $_.CreationTime, $_.LastWriteTime, $_.LastAccessTime}
        get-childitem ./  | where-object {$_.LastWriteTime -gt (Get-Date).AddDays(-3)}
        get-childitem ./  | where-object {$_.LastWriteTime -gt (Get-Date).AddDays(-3)} | %{$_.LastWriteTime, $_.FullName}
        get-childitem -path F:\Movie\人間四月天 | where-object {$_.Length -gt 0.5GB}
    }

    if ($False) {
        $markUploadList = get-childitem -path \\10.13.200.6\MarkUpload\新媒體部 -Recurse | %{$_.FullName}
        foreach ($fPath in $markUploadList) {
            $fName = Split-Path $fPath -leaf
            $fObj = Get-item -path "$fPath"
            #write-output $fPath, $fName
            $parent = $fObj.Parent
            $ext = $fObj.Extension
            $base = $fObj.BaseName
            write-output $fPath
            write-output "$parent, $Base, $ext"
        }
    }

    if ($False) {
        $fPath = '\\10.13.200.6\MarkUpload\NewMedia\Program\[AA]-BB\ CC.mov'  #fail
        $result = test-path -path $fPath
        write-output $result   #False
        $fobj = Get-item -path $fPath
        (Get-item -path $fPath).BaseName

        $fPath = '\\10.13.200.6\MarkUpload\NewMedia\Program\CC.mov'
        (Get-item -path $fPath).BaseName
    }

    if ($False) {
        $fPath = '\\10.13.200.6\MarkUpload\NewMedia\Program\[AA]-BB CC.mov'  #fail

        $fName = [system.IO.Path]::GetFileNameWithoutExtension($fPath)
        $ext = [system.IO.Path]::GetExtension($fPath)
        write "$fName, $ext"
    }

    if ($False) {
        $markUploadList = get-childitem -path \\10.13.200.6\MarkUpload -Recurse | %{$_.FullName}
        foreach ($fPath in $markUploadList) {
            $ext = [System.IO.Path]::GetExtension($fPath)
            $base = [System.IO.Path]::GetFileNameWithoutExtension($fPath)
            if ($ext -eq ".MXF") {
                write-output $fPath
                write-output "$Base, $ext"
            }
        }
    }
} elseif ($case -eq "test") {
    if ($False) {
        #$pathStr = "\\10.13.200.6\MarkUpload\企劃部\節目\紫色大稻埕60分鐘版共34集\003VLJ.mxf"
        $pathStr = "\\10.13.200.6\MarkUpload\企劃部\節目\紫色大稻埕60分鐘版共34集\003WOC.mxf"
        $fPath = get-childitem -path $pathStr -Recurse | %{$_.FullName}
        write-output $markUploadList
        $ext = [System.IO.Path]::GetExtension($fPath)
        $base = [System.IO.Path]::GetFileNameWithoutExtension($fPath)

        write-output "$ext, $base"
        $keep_list = get-content -path "\\10.13.200.25\Review\NOT_DELETE.log"
        if ($ext -eq ".MXF" -and ($base | select-string -pattern '^00[\w]{4}$') ) {
            if ($keep_list.Contains($base) -eq $False) {
                write-output "00$base"
            }
        }

    }

    if ($True) {
        $base = "003VLJ"
        $keep_list = get-content -path "c:\temp\list.txt"

        $videoID = "00" + $base
        if ($keep_list.Contains($videoID) -eq $False) {
            write-output "00$base"
        }
    }

}
