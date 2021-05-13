#include-once
#include <MyUDFs\Log.au3>


#include-once

Global $UDFName = 'MonitorOff'


#cs | INDEX | ===============================================

	Title				MonitorOff
	Description	 		MonitorOff

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				04.03.2016

#ce	=========================================================



Global Const $lciWM_SYSCommand = 274
Global Const $lciSC_MonitorPower = 61808
Global Const $lciPower_Off = 2
Global Const $lciPower_On = -1

Global $MonitorIsOff = False





#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        T_MO_Execute()

    EndIf

#EndRegion Example




Func T_MO_Execute ()

    HotKeySet("{F11}", "_MO_OFF")
    HotKeySet("{F10}", "_MO_ON")
    HotKeySet("{Esc}", "_Quit")

    MsgBox(64, "Monitor On/Off", "Press F11 to turn off the monitor." & @LF & _
            "Press F10 to turn on the monitor back." & @LF & _
            "Press ESC to turn on the monitor and exit program.")

    While 1
        Sleep(10)
    WEnd

EndFunc   ;==>T_MO_Execute





#cs | FUNCTION | ============================================

	Name				_MO_ON

	Author				Asror Zakirov (aka Asror.Z)
	Created				04.03.2016

#ce	=========================================================

Func _MO_ON()
    $MonitorIsOff = False
    Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')

    DllCall('user32.dll', 'int', 'SendMessage', _
            'hwnd', $Progman_hwnd, _
            'int', $lciWM_SYSCommand, _
            'int', $lciSC_MonitorPower, _
            'int', $lciPower_On)

EndFunc   ;==>_MO_ON




#cs | FUNCTION | ============================================

	Name				_MO_OFF

	Author				Asror Zakirov (aka Asror.Z)
	Created				04.03.2016

#ce	=========================================================

Func _MO_OFF()
    $MonitorIsOff = True
    Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')

    While $MonitorIsOff = True
        DllCall('user32.dll', 'int', 'SendMessage', _
                'hwnd', $Progman_hwnd, _
                'int', $lciWM_SYSCommand, _
                'int', $lciSC_MonitorPower, _
                'int', $lciPower_Off)
        _IdleWaitCommit(0)
        Sleep(20)
    WEnd
EndFunc   ;==>_MO_OFF



Func _IdleWaitCommit($idlesec)
    Local $iSave, $LastInputInfo = DllStructCreate ("uint;dword")
    DllStructSetData ($LastInputInfo, 1, DllStructGetSize ($LastInputInfo))
    DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
    Do
        $iSave = DllStructGetData ($LastInputInfo, 2)
        Sleep(60)
        DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
    Until (DllStructGetData ($LastInputInfo, 2)-$iSave) > $idlesec Or $MonitorIsOff = False
    Return DllStructGetData ($LastInputInfo, 2)-$iSave
EndFunc   ;==>_IdleWaitCommit


Func _Quit()
    _MO_ON()
    Exit
EndFunc   ;==>_Quit