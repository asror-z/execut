
#include-once

Global $UDFName = 'RegJump'


#cs | INDEX | ===============================================

	Title				RegJump
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				29.12.2017

#ce	=========================================================

If @ScriptName = $UDFName & '.au3' Then


    

EndIf



Func RegJump($sKey)
	ShellExecute('regjump', $sKey)
EndFunc   ;==>RegJump