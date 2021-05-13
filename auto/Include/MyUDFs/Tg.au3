#include-once
#include <ScreenCapture.au3>
#include <Date.au3>
#include <MyUDFs\Telegram.au3>
#include <MyUDFs\SysConsts.au3>
#include <MyUDFs\TgCons.au3>

Global $UDFName = 'Tg'

#cs | INDEX | ===============================================

	Title				Tg
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				24.12.2017

#ce	=========================================================



If @ScriptName = $UDFName & '.au3' Then

    ; _ArrayDisplay($ChatMon)

    ; _Tg('Qalesan', $ChatUMS, False)
    _Tg('Qalesan', $ChatMonitor)

EndIf







#cs | FUNCTION | ============================================

	Name				_TgLog
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				25.01.2018

#ce	=========================================================
Func _TgLog($sMsg)

    _Tg($sMsg, $ChatLogger)

EndFunc   ;==>_TgLog









#cs | FUNCTION | ============================================

	Name				_Tg
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				24.12.2017

#ce	=========================================================

Func _Tg($sMessage, $ChatID = $Log_Error)

	If Not _WinAPI_IsInternetConnected() Then ExitBox('Internet not connected!')

    If Not $bIsTgInit Then _InitBot($TgToken)

    $iServer = _GetServer()
    $sUser = _GetUser()
    
	_Log($sMessage)

    $sMessage = $sMessage & $sCRLF & $sCRLF & @ComputerName & ' [' & $iServer & '] | ' & $sUser & ' | ' & _Now()

    $sMessage = StringReplace($sMessage, @CRLF, $sCRLF)

    _SendMsg($ChatID, $sMessage)

EndFunc   ;==>_Tg




#cs | FUNCTION | ============================================

	Name				_TgScreen
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				24.12.2017

#ce	=========================================================
Func _TgScreen($sMessage, $ChatID = $ChatMonitor)

    If Not _WinAPI_IsInternetConnected() Then ExitBox('Internet not connected!')

    If Not $bIsTgInit Then _InitBot($TgToken)

    $sMessage = $sMessage & $sCRLF & @CRLF & @ComputerName & ' | ' & @UserName & ' | ' & _Now()
    $sFileName = @ScriptDir & "\NvScreen.jpg"

    FileDelete($sFileName)

    _ScreenCapture_Capture($sFileName)
    _SendPhoto($ChatID, $sFileName, $sMessage)


EndFunc   ;==>_TgScreen


