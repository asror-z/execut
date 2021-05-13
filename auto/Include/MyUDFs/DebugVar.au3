#include <Array.au3>


Local $UDFName = 'DebugVar'

Global $aIncludeDir[3] = [ _
        @ScriptDir & '\', _
        EnvGet('AU_Home') & '\Include\MyUDFs\', _
        EnvGet('AU_Home') & '\Include\' _
        ]



$test = "testing"
$mytest = "123"


DebugVar($test)
DebugVar($mytest)

_MyFunction()
Func _MyFunction ()

    DebugVar($test)

EndFunc   ;==>_MyFunction

DebugVar($test)


Func DebugVar($var, $iLine = @ScriptLineNumber)

    Local $sFileName = $UDFName & '.au3'

    Local $sFullPath = '', $sFuncName, $sTraceText

    For $vElement In $aIncludeDir
        $sFullPath = $vElement & $sFileName
        If FileExists($sFullPath) Then ExitLoop
    Next

    ; ConsoleWrite($sFullPath & @CRLF)
    
    If Not FileExists($sFullPath) Then
        ConsoleWrite('Line: ' & @ScriptLineNumber & ' | @Error: ' & @error & ' | @Extended: ' & @extended & ' | Text: File Not Exists ' & @CRLF)
    EndIf

    ; File Read

    Local $aFileContent = FileReadToArray($sFullPath)

    ; Function Name
    
    For $i = $iLine To 1 Step -1

        Select
            Case StringInStr($aFileContent[$i], "EndFunc") > 0
                $sFuncName = 'Main Context'
                ExitLoop

            Case StringInStr($aFileContent[$i], "Func ") = 1

                $sFuncPattern = '^Func +([\w_]*)'
                $aRes = StringRegExp($aFileContent[$i], $sFuncPattern, 3)

                If @error Then
                    MsgBox(0, 'Error', @error)
                Else
                    $sFuncName = $aRes[0]
                    ExitLoop
                EndIf

        EndSelect
    Next
    
    If Not $sFuncName Then $sFuncName = 'Main Context'

    $sDebugLine = $aFileContent[$iLine - 1]
    $aDebugLine = StringRegExp($sDebugLine, "DebugVar\((.*)\)", 3)

    If IsArray($aDebugLine) Then
        ConsoleWrite($sFileName & ' | ' & $sFuncName & ' | Line: ' & $iLine & '| ' & $aDebugLine[0] & ": '" & $var & @CRLF)

    Else
        ConsoleWrite('Line: ' & @ScriptLineNumber & ' | @Error: ' & @error & ' | @Extended: ' & @extended & ' | Text: You need to override UDFName aDebugLine in top your script ' & @CRLF)
    EndIf

    Return 1

EndFunc   ;==>DebugVar


