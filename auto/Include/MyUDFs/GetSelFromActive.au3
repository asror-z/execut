#include-once
#include <MyUDFs\Log.au3>



#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        T_Execute()

    EndIf

#EndRegion Example




Func T_Execute ()

    HotKeySet('!z', 'T_GS_GetSelFromActive')
    _Log('Start GetSelFromActive')
    
    While 1
        Sleep(200)
    WEnd

EndFunc   ;==>T_Execute









#cs | TESTING | =============================================

	Name				T_GS_GetSelFromActive
	Author				Asror Zakirov (aka Asror.Z)
	Created				02.03.2016

#ce	=========================================================

Func T_GS_GetSelFromActive()
    

    Local $sText = _GS_GetSelFromActive()
    Mbox($sText)

EndFunc   ;==>T_GS_GetSelFromActive





Func _GS_GetSelFromActive()


    ;Get window title, in case we need it


    $sOldClip = ClipGet()
    ClipPut('')

	SendEx('^{INS}')
    If ClipGet() <> '' Then $sText = ClipGet()

    ControlSendEx('^{INS}')
    If ClipGet() <> '' Then $sText = ClipGet()

    SendEx('^c')
    If ClipGet() <> '' Then $sText = ClipGet()

    ControlSendEx('^c')
    If ClipGet() <> '' Then $sText = ClipGet()
	
    ClipPut($sOldClip)
    Return $sText
EndFunc   ;==>_GS_GetSelFromActive





#cs | FUNCTION | ============================================

	Name				ControlSendEx

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.03.2016

#ce	=========================================================

Func ControlSendEx ($sSendStr)
    
    
    $sWinTitle = WinGetTitle("[ACTIVE]")
    $hActiveCtrl = ControlGetFocus($sWinTitle)
    
    _Log('ControlSendEx: ' & $sSendStr)
    
    ControlSend($sWinTitle, "", $hActiveCtrl, $sSendStr)

EndFunc   ;==>ControlSendEx



#cs | FUNCTION | ============================================

	Name				SendEx

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.03.2016

#ce	=========================================================

Func SendEx ($sSendStr)
    

    Send($sSendStr)
    _Log('SendEx: ' & $sSendStr)
    
EndFunc   ;==>SendEx




