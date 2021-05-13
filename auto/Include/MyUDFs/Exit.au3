#include-once
#include <MyUDFs\Log.au3>



Global $UDFName = 'Exit.au3'


#cs | INDEX | ===============================================

	Title				Exit.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				13.02.2018

#ce	=========================================================



Global $oMyError = ObjEvent("AutoIt.Error", "ErrCOM")
Global $bErrorFound = False


#cs | CURRENT | =============================================

	ErrCOM()
	ExitBox($sMsg, $sScriptName = @ScriptName, $sLine = @ScriptLineNumber, $sUDFName = $UDFName)

#ce	=========================================================

#Region Example


    If @ScriptName = $UDFName Then

        Local $oShell = ObjCreate("Shell.Application")

        $oShell.InvalidFunction()

        TExitBox()
        _Log('safsaf')
        _Log('safsaf')
        _Log('safsaf')

    EndIf

#EndRegion Example







#cs | FUNCTION | ============================================

	Name				ErrCOM

	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func ErrCOM($sScriptName = @ScriptName, $sLine = @ScriptLineNumber)

    Local $sWinDesc = ($oMyError.windescription) ? 'Window Description: ' & $oMyError.windescription: ''
    Local $sErrNumber = (Hex($oMyError.number, 8)) ? 'ErrNumber: ' & Hex($oMyError.number, 8) & @CRLF: ''
    Local $sScriptLine = ($oMyError.scriptline) ? 'ScriptLine: ' & $oMyError.scriptline & @CRLF: ''

    Local $sDesc = ($oMyError.description) ? 'Description: ' & $oMyError.description & @CRLF: ''
    Local $sLastDllError = ($oMyError.lastdllerror) ? 'LastDllError: ' & $oMyError.lastdllerror & @CRLF: ''
    Local $sSource = ($oMyError.source) ? 'Source: ' & $oMyError.source & @CRLF: ''
    Local $sHelpFile = ($oMyError.helpfile) ? 'HelpFile: ' & $oMyError.helpfile & @CRLF: ''
    Local $sHelpContext = ($oMyError.helpcontext) ? 'HelpContext: ' & $oMyError.helpcontext & @CRLF: ''

    Local $sFullError = $sWinDesc & $sErrNumber & $sScriptLine & $sDesc & $sLastDllError & $sSource & $sHelpFile & $sHelpContext
    
    $sFullError =  StringStripWS($sFullError,  $STR_STRIPTRAILING)
    $bErrorFound = True
    
    ExitBox($sFullError, 'COM Error...', $sLine, False)

    Return SetError($sErrNumber, 10, False)

EndFunc   ;==>ErrCOM



#cs | FUNCTION | ============================================

	Name				_Eol

	Author				Asror Zakirov (aka Asror.Z)
	Created				26.02.2016

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name				ExitBox
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func ExitBox($sMsg, $sTitle = 'Exit Detected...', $sLine = @ScriptLineNumber, $bExit = True)


    ;	Print EXITBOX Label without References

    If $bExit Then
        $sMsg = 'EXIT:	' & $sMsg
    EndIf

    ;	Print Core Log String with References

    $sLogStr = _Log($sMsg, '', $sLine)
    $sLogStr = StringReplace($sLogStr, '#', @CRLF & '#')
    
    ;	Show MboxE if AsrorPC

    If $bIsAsrorPCNotCompiled Then

        Local $sMediaFile = @WindowsDir & "\Media\chord.wav"

        If FileExists($sMediaFile) Then
            SoundPlay($sMediaFile)
        EndIf

        MboxE($sLogStr, $sTitle)

    EndIf

	Exit
	
EndFunc   ;==>ExitBox


#cs | TESTING | =============================================

	Name				TExitBox

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func TExitBox()

    ExitBox('adad')

EndFunc   ;==>TExitBox

