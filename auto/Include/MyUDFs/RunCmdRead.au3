#RequireAdmin

#include-once



Global $iDelayCmd = 1000

#cs | FUNCTION | ============================================

	Name				_CmdRead
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func RunCmdRead($sCmd)

    Local Const $iPID = Run(@ComSpec & ' /c ' & $sCmd, @WorkingDir, @SW_HIDE, $STDERR_MERGED)

    If $iPID > 0 Then

        _Log('Starting Thread: ' & $sCmd)

        While True

            $sOut = StdoutRead($iPID, False, False)

            If @error Then
                ProcessClose($iPID)
                ExitLoop 1

            ElseIf $sOut Then
                $bIsExitbox = True

                $sOut  = StringTrimRight(StringStripCR($sOut), StringLen(@CRLF))
                $sOut  = StringReplace($sOut, @CR & @CR, '')
                $sOut  = StringReplace($sOut, Chr(27), @TAB)
                $sOut  = StringReplace($sOut, '[0m', '')
                $sOut  = StringReplace($sOut, '[0', '')
                $sOut  = StringReplace($sOut, '[', '')

                _Log($sOut)

            EndIf

            Sleep($iDelayCmd)
        WEnd

        _Log('Exiting Thread: ' & $sCmd)

    Else
        _Log('Cannot Start Thread: ' & $sCmd)
    EndIf

EndFunc   ;==>_CmdRead








#cs | FUNCTION | ============================================

	Name				_Warning
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				10/9/2019

#ce	=========================================================
Func _WarnOut($sOut)

    Local $iPosition = StringInStr($sOut, "CONFLICT", $STR_CASESENSE)

    If $iPosition > 0 Then

        ShellExecuteWait('TortoiseGitProc.exe', '/command:log /path:"' & $sFolder & '"')
        Return True
    EndIf

    Return False
EndFunc   ;==>_WarnOut






#cs | FUNCTION | ============================================

	Name				_WarnFatal
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				10/9/2019

#ce	=========================================================
Func _WarnFatal($sOut)

    Local $iPosition = StringInStr($sOut, "fatal: ", $STR_CASESENSE)

    ; $bLogLocal = true
    
    If $iPosition > 0 Then
        _Log($sOut, 'Error')
        Return True
    EndIf

    Return False


EndFunc   ;==>_WarnFatal