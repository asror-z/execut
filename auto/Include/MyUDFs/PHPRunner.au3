#include <MyUDFs\Exit.au3>

Func _GetFileName ($sFullPath)

    Local $szDrive, $szDir, $szFName, $szExt
    Local $aTestPath = _PathSplit($sFullPath, $szDrive, $szDir, $szFName, $szExt)
    Local $sFileName = $aTestPath[3]
    ConsoleWrite('Now executing: ' & $sFileName)
    TrayTip('Now Executing', $sFileName, 0, $TIP_ICONASTERISK)

    Return $sFileName

EndFunc   ;==>_GetFileName


Func PHPRunner($sFolderName)

    Local $sFullPathToFolder = $sCRMv2RunDir & '\' & $sFolderName
    Local $aFileList = _FileListToArray($sFullPathToFolder, "*", Default, True)

    ConsoleWrite ('$sFolderName - ' & $sFolderName & @CRLF)
    ConsoleWrite ('$sFullPathToFolder - ' & $sFullPathToFolder & @CRLF )

    FileChangeDir($sFullPathToFolder)

    If Not @error Then

        ConsoleWrite ('Starting Process - ' & $sFullPathToFolder & @CRLF )

        For $i = 1 To UBound($aFileList) - 1
            
            $sFileToRun =$aFileList[$i]

            _GetFileName($sFileToRun)
            
            If FileExists($sFileToRun) Then
                _Log('Running: ' & $sFileToRun)
                ShellExecuteWait($sFileToRun)
            Else
                _Log('File Not Exists: ' & $sFileToRun)
            EndIf
            
        Next

    EndIf

EndFunc   ;==>PHPRunner
