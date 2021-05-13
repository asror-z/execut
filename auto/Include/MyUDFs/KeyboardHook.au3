#include-once
#include <Misc.au3>
#include <MyUDFs\Log.au3>

Global $UDFName = 'KeyboardHook'
Global $KH_FunctionName

#cs | INDEX | ===============================================

	Title				KeyboardHook
	Description	 		KeyboardHook

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				07.03.2016

#ce	=========================================================





Func _KH_Test ($nKeyCode)

    $bLetterChars = (($nKeyCode >= 65) And ($nKeyCode <= 90))
    $bNumbers = (($nKeyCode >= 48) And ($nKeyCode <= 57))
    $bNumpad = (($nKeyCode >= 96) And ($nKeyCode <= 105))
    $bFunctional = (($nKeyCode >= 112) And ($nKeyCode <= 123))
    $bSpecial = (($nKeyCode >= 8) And ($nKeyCode <= 46))

    $bCondition = $bLetterChars Or $bNumpad Or $bNumbers Or $bSpecial

    If $bCondition Then

        ; Only for TC
        If WinActive("[CLASS:TTOTAL_CMD]") Then
            _Log('TC is active: ' & $nKeyCode )
        Else
            _Log('TC is NOT active: ' & $nKeyCode)
        EndIf

    EndIf
EndFunc   ;==>_KH_Test






#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        _KH_Init ('_KH_Test')

    EndIf

#EndRegion Example










#cs | FUNCTION | ============================================

	Name				_KH_Init

	Author				Asror Zakirov (aka Asror.Z)
	Created				07.03.2016

#ce	=========================================================

Func _KH_Init ($sFunctionName)
    

    $KH_FunctionName = $sFunctionName
    _KH_DllCall ()

    While 1
        Sleep(10)
    WEnd

    OnAutoItExitRegister ( "_KH_Exit")

EndFunc   ;==>_KH_Init





#cs | FUNCTION | ============================================

	Name				_KH_DllCall

	Author				Asror Zakirov (aka Asror.Z)
	Created				07.03.2016

#ce	=========================================================

Func _KH_DllCall ()
    

    Global Const $WH_KEYBOARD_LL    = 13

    Global $hStub_KH_Hook           = DllCallbackRegister("_KH_Hook", "int", "int;ptr;ptr")

    Global $hMod                    = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)

    Global $hHook                   = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_KEYBOARD_LL, "ptr", DllCallbackGetPtr($hStub_KH_Hook), "hwnd", $hMod[0], "dword", 0)
    
EndFunc   ;==>_KH_DllCall






#cs | FUNCTION | ============================================

	Name				_KH_Hook

	Author				Asror Zakirov (aka Asror.Z)
	Created				07.03.2016

#ce	=========================================================

Func _KH_Hook($nCode, $wParam, $lParam)
    
    

    Local $aRet, $KEYHOOKSTRUCT

    If $nCode < 0 Then
        $aRet = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hHook[0], "int", $nCode, "ptr", $wParam, "ptr", $lParam)
        Return $aRet[0]
    EndIf

    If $wParam = 256 Then
        $KEYHOOKSTRUCT = DllStructCreate("dword;dword;dword;dword;ptr", $lParam)
        
        $pKeyCode = DllStructGetData($KEYHOOKSTRUCT, 1)
        Call($KH_FunctionName, $pKeyCode)
    EndIf

    $aRet = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hHook[0], "int", $nCode, "ptr", $wParam, "ptr", $lParam)

    Return $aRet[0]
EndFunc   ;==>_KH_Hook






#cs | FUNCTION | ============================================

	Name				_KH_Exit

	Author				Asror Zakirov (aka Asror.Z)
	Created				07.03.2016

#ce	=========================================================

Func _KH_Exit()

    If $hStub_KH_Hook Then DllCallbackFree($hStub_KH_Hook)
    $hStub_KH_Hook = 0

    DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hHook[0])
    If @HotKeyPressed <> "" Then Exit
EndFunc   ;==>_KH_Exit