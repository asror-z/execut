#include <MyUDFs\Log.au3>

Global $UDFName = 'FileInUse'

Func FileInUse($sFilename)
    $hFile = FileOpen($sFilename, 1)

    $bResult = False

    If $hFile = -1 Then
        $bResult = True
    EndIf

    FileClose($hFile)
    Return $bResult
    
EndFunc   ;==>FileInUse


If @ScriptName = $UDFName & '.au3' Then

    $sFilename =  FileOpenDialog('Open', 'C:', "All (*.*)", $FD_FILEMUSTEXIST)

    If @error Then ExitBox('No file is selected')

    If FileInUse($sFilename) Then
        MsgBox(0, "", "File is in use")
    Else
        MsgBox(0, "", "Not in use - go nuts")
    EndIf

EndIf
