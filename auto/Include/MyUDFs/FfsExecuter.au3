#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIEx.au3>
#include <MyUDFs\FileZ.au3>
#include <MsgBoxConstants.au3>


Global $UDFName = 'FfsExecuter'

If @ScriptName = $UDFName & '.au3' Then
    FfsExecuter(@ScriptDir)
EndIf



Func FfsExecuter($sFullPathToFolder)

    Local $aFileList = _FileListToArray($sFullPathToFolder, "*.ffs_batch", $FLTAR_FILES)
    ; _Log($aFileList, '$aFileList')

    If Not @error Then

        If UBound($aFileList) > 1 Then
            For $i = 1 To UBound($aFileList) - 1

                $sCurrFile 	= 	$sFullPathToFolder &  '\' &  $aFileList[$i]
                $sTempFile	=	@TempDir & '\' & $aFileList[$i]

                ; _Log($aFileList[$i], 'Now Syncing: ')

                If FileExists($sTempFile) Then
                    $iDelete = FileDelete($sTempFile)

                    If Not $iDelete Then
                        ExitBox('Cannot Delete ' & $sTempFile)
                    EndIf

                EndIf


                FileCopy($sCurrFile, $sTempFile, 1+8)


                Local $iRetval = _ReplaceStringInFile($sTempFile, 'ProgressDialog Minimized="false"', 'ProgressDialog Minimized="true"')

                If $iRetval = -1 Then
                    ExitBox("ProgressDialog Minimized=true | could not be replaced in file: " & $sTempFile & " Error: " & @error)
                EndIf



                Local $iRetval2 = _ReplaceStringInFile($sTempFile, 'AutoClose="false"', 'AutoClose="true"')

                If $iRetval2 = -1 Then
                    ExitBox("AutoClose=false | could not be replaced in file: " & $sTempFile & " Error: " & @error)
                EndIf
				
				

                ShellExecuteWait($sTempFile, "", '', '', @SW_MINIMIZE)
                Sleep(100)

            Next
        EndIf

    Else

        ; ExitBox('There is no files: ' & $sFullPathToFolder)
    EndIf

EndFunc   ;==>FfsExecuter
