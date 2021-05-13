#include-once
#include <MyUDFs\Log.au3>


Global $UDFName = 'RegExists.au3'


#cs | INDEX | ===============================================

	Title				RegExists.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/25/2016

#ce	=========================================================


#cs | CURRENT | =============================================

	RegExists($sKeyName, $sValueName = '')

#ce	=========================================================



#Region Example

    If @ScriptName = $UDFName Then

        TRegExists()

    EndIf

#EndRegion Example


Func TRegExists()

    

    _Log("RegExists('HKEY_CURRENT_USER\Software\2VG\Download Master', 'AddingURL')")
    _Log("RegExists('HKEY_CURRENT_USER\Software\2VG\Download Master', 'AddingUsRL')")
    _Log("RegExists('HKEY_CURRENT_USER', 'AddingUsRL')")
    _Log("RegExists('HKEY_CURRENT_USER')")


EndFunc   ;==>TRegExists




#cs | FUNCTION | ============================================

	Name				RegExists
	Desc				Варинат универсальный можно проверить раздел, а можно и параметр
	Проблема в том, что тип параметра может не поддерживаться, а параметр существует, в итоге функция лишь приблизительно определяет, что недопустимо в программировании.

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func RegExists($sKeyName, $sValueName = '')
    

    RegRead($sKeyName, $sValueName)
    If $sValueName == '' Then
        Return Not (@error > 0)
    Else
        Return @error = 0
    EndIf

EndFunc   ;==>RegExists
