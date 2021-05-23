#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIEx.au3>
#include <TrayConstants.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\FileZ.au3>




Func ExecuteAsrorZ($sFullPathToFolder, $wait = True)

    Local $aFileList = _FileListToArray($sFullPathToFolder, Default, Default, True)

    ConsoleWrite ('$sFullPathToFolder - ' & $sFullPathToFolder & @CRLF )

    If Not @error Then

        For $i = 1 To UBound($aFileList) - 1

            ConsoleWrite($aFileList[$i] & @CRLF)

            If StringInStr($aFileList[$i], 'asrorz.cmd') > 1 Then

			
				If $wait Then	
                ShellExecuteWait($aFileList[$i],"",$sFullPathToFolder,"",@SW_MINIMIZE)
				Else
				ShellExecute($aFileList[$i],"",$sFullPathToFolder,"",@SW_MINIMIZE)
				Endif
                _GetFileName($aFileList[$i])
                
                Sleep($iMinDelay)
            Else
                ConsoleWrite('Other Detected' & @CRLF)
            EndIf

        Next

    EndIf

EndFunc   ;==>Executer


Func Executer($sFullPathToFolder)

    Local $aFileList = _FileListToArray($sFullPathToFolder, Default, Default, True)

    ConsoleWrite ('$sFullPathToFolder - ' & $sFullPathToFolder & @CRLF )

    If Not @error Then

        For $i = 1 To UBound($aFileList) - 1

            ConsoleWrite($aFileList[$i] & @CRLF)

            If StringInStr($aFileList[$i], '@ Other') < 1 And StringInStr($aFileList[$i], '- Theory') < 1 Then

                _GetFileName($aFileList[$i])
                ShellExecute($aFileList[$i],"","","",@SW_MINIMIZE)
                
                Sleep($iMinDelay)
            Else
                ConsoleWrite('Other Detected' & @CRLF)
            EndIf

        Next

    EndIf

EndFunc   ;==>Executer



Func _GetFileName ($sFullPath)

    Local $szDrive, $szDir, $szFName, $szExt
    Local $aTestPath = _PathSplit($sFullPath, $szDrive, $szDir, $szFName, $szExt)
    Local $sFileName = $aTestPath[3]
    ConsoleWrite('Now executing: ' & $sFileName)
    ; TrayTip('Now Executing', $sFileName, 0, $TIP_ICONASTERISK)

    Return $sFileName

EndFunc   ;==>_GetFileName
