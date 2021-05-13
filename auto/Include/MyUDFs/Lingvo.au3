#include-once
#include <MyUDFs\Log.au3>

Global $UDFName = 'Lingvo'


#cs | INDEX | ===============================================

	Title				Lingvo
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				18.03.2016

#ce	=========================================================



#Region Example

    If @ScriptName = $UDFName & '.au3' Then

        T_L_Translate()

    EndIf

#EndRegion Example




#cs | TESTING | =============================================

	Name				T_L_Translate
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func T_L_Translate()
    

EndFunc   ;==>T_L_Translate


#cs | FUNCTION | ============================================

	Name				_L_Translate

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func _L_Translate ($sText)
    

    _L_Input_Send($sText)

EndFunc   ;==>_L_Translate






#cs | FUNCTION | ============================================

	Name				_L_Win_GetHandle

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _L_Win_GetHandle ()
    

    Local $sL16_Class	=	'[CLASS:Lv16_MainWindow]'
    Local $sL12_Class	=	'[CLASS:LV12_MainWindow]'
    Local $sVersion
    Select
        Case WinExists($sL16_Class)
            $hL_Handle	=	WinGetHandle($sL16_Class)
            $sVersion	=	'16'

        Case WinExists($sL12_Class)
            $hL_Handle	=	WinGetHandle($sL12_Class)
            $sVersion	=	'12'

        Case Else
            ExitBox('Lingvo Application is not running!')
    EndSelect

    _Log('Version: ' & $sVersion)

    Return $hL_Handle
EndFunc   ;==>_L_Win_GetHandle




#cs | FUNCTION | ============================================

	Name				_L_Win_Activate

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _L_Win_Activate ()
    

    WinActivate(_L_Win_GetHandle())
    WinWaitActive(_L_Win_GetHandle())

    If Not WinActive(_L_Win_GetHandle()) Then ExitBox('Cannot Activate Lingvo Window')

    _Log('Lingvo Win Activated')

EndFunc   ;==>_L_Win_Activate





#cs | TESTING | =============================================

	Name				T_L_Win_IsActive
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func T_L_Win_IsActive()
    

    _L_Win_IsActive()

EndFunc   ;==>T_L_Win_IsActive

#cs | FUNCTION | ============================================

	Name				_L_Win_IsActive

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _L_Win_IsActive ()
    

    Local $bIsActive 	=	WinActive(_L_Win_GetHandle())
    _Log($bIsActive, '$bIsActive')

    Return $bIsActive

EndFunc   ;==>_L_Win_IsActive







#cs | FUNCTION | ============================================

	Name				_L_Input_GetHandle

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func _L_Input_GetHandle()

    Local $sHandleString 	=	'[CLASS:RichEdit20W; INSTANCE:1]'
    Local $hLI_Handle 	=	ControlGetHandle(_L_Win_GetHandle(), '', $sHandleString)
	
    _Log($hLI_Handle, '$hLI_Handle')

    Return $hLI_Handle

EndFunc   ;==>_L_Input_GetHandle







#cs | TESTING | =============================================

	Name				T_L_Input_SetFocus
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func T_L_Input_SetFocus()
    

    _L_Input_SetFocus()


EndFunc   ;==>T_L_Input_SetFocus

#cs | FUNCTION | ============================================

	Name				_L_Input_SetFocus

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _L_Input_SetFocus()
    

    _L_Win_Activate()
    Local $hLI_Handle = _L_Input_GetHandle()

    If Not ControlFocus(_L_Win_GetHandle(), '', $hLI_Handle) Then
        _Log('Error! 	Cannot Set Focus to ' & $hLI_Handle)
    Else
        _Log('OK!	Set Focus to: ' & $hLI_Handle)
    EndIf

EndFunc   ;==>_L_Input_SetFocus







#cs | FUNCTION | ============================================

	Name				_L_Input_Send

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func _L_Input_Send ($sText)
    
    
    _L_Input_SetFocus()

    ; If Not Then _Log('Error! 	Cannot Send Text to ' & $hLI_Handle)

    If Not ControlSetText(_L_Win_GetHandle(), '', _L_Input_GetHandle(), $sText) Then ExitBox('ControlSetText Error')
    
    If Not ControlSend(_L_Win_GetHandle(), '', _L_Input_GetHandle(), '{ENTER}{ENTER}') Then ExitBox('ControlSend Error')
    
    _Log('OK!	Send Text: ' & $sText)
EndFunc   ;==>_L_Input_Send

