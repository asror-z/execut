#include-once

Global $UDFName = 'Dialogs'


#cs | INDEX | ===============================================

	Title				Dialogs
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				25.01.2018

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name				Mbox

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016

#ce	=========================================================

Func Mbox ($sMsg, $sDesc = Null)

    If Not $sDesc Then
        MsgBox($MB_OK + $MB_ICONINFORMATION, "Info", $sMsg)
    Else
        MsgBox($MB_OK + $MB_ICONINFORMATION, $sDesc, $sDesc & @CRLF & @CRLF  & $sMsg)
    EndIf
EndFunc   ;==>Mbox




#cs | FUNCTION | ============================================

	Name				MboxQ

	Author				Asror Zakirov (aka Asror.Z)
	Created				20.02.2016

#ce	=========================================================

Func MboxQ ($sQuestion, $bSecondDefButton = Default)

    Local $iFlag	=	($bSecondDefButton = Default) ? $MB_YESNO + $MB_ICONQUESTION  : $MB_YESNO + $MB_ICONQUESTION + $MB_DEFBUTTON2

    If MsgBox($iFlag, "Question", $sQuestion) = 6 Then Return True

    Return False

EndFunc   ;==>MboxQ





#cs | FUNCTION | ============================================

	Name				MboxE
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				07.02.2018

#ce	=========================================================
Func MboxE($sMsg, $sTitle = 'Error!')

    MsgBox($MB_OK + $MB_ICONERROR, $sTitle, $sMsg)
    
EndFunc   ;==>MboxE



#cs | FUNCTION | ============================================

	Name				Inbox
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/15/2016

#ce	=========================================================

Func Inbox ($sTitle, $sDefault = '')

    Local $sPasswd = InputBox("Enter Information", $sTitle, $sDefault)

    If @error Then ExitBox('There is no data entered :)')

    Return $sPasswd
EndFunc   ;==>Inbox

