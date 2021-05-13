#include-once
#include <MyUDFs\Log.au3>

; this com errorhandler works with the taskplaner udf and the mailercom udf

;com errorhandler
Global $oMyRet[2]
Global $bErrorFound = False
Global $oMyError = ObjEvent("AutoIt.Error", "ComErrFunc")
Global $comerrorhandlerdebug = 1

If @Compiled Then
    $comerrorhandlerdebug = 0
EndIf

Func ComErrFunc()
    ;store error in global variable and SetError so we can use this in our program
    $oMyRet[0] = Hex($oMyError.number, 8)
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    
    $sErr = "We intercepted a COM Error !" & @CRLF & @CRLF & _
            "err.description is: " & @TAB & $oMyError.description & @CRLF & _
            "err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
            "err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
            "err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
            "err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
            "err.source is: " & @TAB & $oMyError.source & @CRLF & _
            "err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
            "err.helpcontext is: " & @TAB & $oMyError.helpcontext
    
	FileWrite('1.txt', $sErr)
	_Log($sErr, "AutoItCOM Test")
	
    $bErrorFound = True ;for taskplanerudf something to check for when this function returns
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>ComErrFunc

;end com errorhandler