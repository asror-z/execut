#include-once
#include <MyUDFs\Log.au3>
#include <Date.au3>

Global $UDFName = 'HotKeySetEx'
Global $sHKS_Hotkey, $sHKS_FuncName, $sHKS_HandleString, $bHKS_IsActive

OnAutoItExitRegister('__HKS_Remove')


#cs | INDEX | ===============================================

	Title				HotKeySetEx
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				18.03.2016

#ce	=========================================================


#Region Example

    If @ScriptName = $UDFName & '.au3' Then

        T_HotKeySetEx()

    EndIf

#EndRegion Example

#cs | TESTING | =============================================

	Name				T_HotKeySetEx
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func T_HotKeySetEx()
    

    HotKeySetEx ('!^y', 'T_Test', '[CLASS:TTOTAL_CMD]')

EndFunc   ;==>T_HotKeySetEx




Func T_Test ()

    Mbox('aaaaaaa')

EndFunc   ;==>T_Test

#cs | FUNCTION | ============================================

	Name				HotKeySetEx

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func HotKeySetEx ($sHotkey, $sFuncName, $sHandleString)
    

    $sHKS_Hotkey		=	$sHotkey
    $sHKS_FuncName		=	$sFuncName
    $sHKS_HandleString	=	$sHandleString
	$bHKS_IsActive		=	False

    While 1

        WinWaitActive($sHKS_HandleString)
        __HKS_Set ()

        WinWaitNotActive($sHKS_HandleString)
        __HKS_Remove ()

    WEnd

EndFunc   ;==>HotKeySetEx





#cs | INTERNAL FUNCTION | ===================================

	Name				__HKS_Remove

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func __HKS_Remove ()
    

    ; Remove Hotkey
    If $bHKS_IsActive Then
        
        If HotKeySet($sHKS_Hotkey) Then
            $bHKS_IsActive = False
            _Log(_Now() & ' | OK! HotKey ' & $sHKS_Hotkey & ' successfully removed!')
        Else
            ExitBox('Cannot Remove Hotkey' & @CRLF & '$sHotkey: ' & $sHKS_Hotkey)
        EndIf
        
    EndIf

EndFunc   ;==>__HKS_Remove








#cs | INTERNAL FUNCTION | ===================================

	Name				__HKS_Set

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func __HKS_Set ()
    

    If Not $bHKS_IsActive Then
        
        If HotKeySet($sHKS_Hotkey, $sHKS_FuncName) Then
            $bHKS_IsActive = True
            _Log(_Now() & ' | OK! HotKey ' & $sHKS_Hotkey & ' successfully set!')
        Else
            ExitBox('Cannot Set Hotkey' & @CRLF & '$sHotkey: ' & $sHKS_Hotkey & @CRLF & '$sFuncName: ' & $sHKS_FuncName)
        EndIf
        
    EndIf

EndFunc   ;==>__HKS_Set









