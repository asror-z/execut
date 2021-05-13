#include <Date.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\Log.au3>


#include-once

Global $UDFName = '_DateDiffTire'


#cs | INDEX | ===============================================

	Title				_DateDiffTire
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				21.11.2016

#ce	=========================================================


If @ScriptName = $UDFName & '.au3' Then

    $ss = _DateDiffTire('2016-11-18')
    _Log($ss)

	

	
EndIf




#cs | FUNCTION | ============================================

	Name				_DateDiffTire
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.11.2016

#ce	=========================================================
Func _DateDiffTire($sDate)

    $sDate = StringReplace($sDate, '-', '/')

    Local $iDateCalc = _DateDiff('D', $sDate, _NowCalc())
    
    Return $iDateCalc

EndFunc   ;==>_DateDiffTire
