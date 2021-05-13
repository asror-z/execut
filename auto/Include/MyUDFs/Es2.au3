#include <Array.au3>
#include-once
#include <MyUDFs\FileZ.au3>


Global $UDFName = 'Es2.au3'


#cs | CURRENT | =============================================

	_ES_SearchFolderPath($sSearchString, $bCaseSetsitive = True, $sSearchDir = Default)
	_ES_ExecuteText($sESCommand)

#ce	=========================================================



#Region Example

    If @ScriptName = $UDFName Then

        T_ES_SearchFolderPath()
        ; T_ES_ExecuteText()

    EndIf

#EndRegion Example


#cs | INDEX | ===============================================

	Title				ES
	Description	 		Everything UDF

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				21.04.2016

#ce	=========================================================

#cs

	You need to copy es.exe to windows directory

#ce








#cs | FUNCTION | ============================================

	Name				_ES_SearchFolderPath
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _ES_SearchFolderPath($sSearchString)
    

    Local $aArray = _ES_ExecuteText('-i -p -d -w -S', $sSearchString)

    _ArrayDelete($aArray, UBound($aArray)-1)
    _ArrayDelete($aArray, 0)

	; _Log($aArray)
	
    If UBound($aArray) = 0 Then

        ShellExecuteWait('C:\Program Files\Everything\Everything.exe', '-nocase -ontop -noww -s "' & $sSearchString & '"')

       ; Send("{RWIN}+{RIGHT}")

    Else

        Return $aArray[0]
        
    EndIf

EndFunc   ;==>_ES_SearchFolderPath




#cs | TESTING | =============================================

	Name				T_ES_SearchFolderPath

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_ES_SearchFolderPath()

    $sItem = _ES_SearchFolderPath('\PowerShell\Element\ \Disable-ClusterStorageSpacesDirect')
    _Log($sItem)

EndFunc   ;==>T_ES_SearchFolderPath




#cs | FUNCTION | ============================================

	Name				_ES_ExecuteText
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _ES_ExecuteText($sCmd, $sKeyword)
    

	If Not FileExists (@ScriptDir & '\es2.exe') Then ExitBox('Es2.exe not exists!')
	
    Local $iPID = Run('es2.exe ' & $sCmd & ' ' & $sKeyword, @ScriptDir, @SW_HIDE, $STDOUT_CHILD)

    ProcessWaitClose($iPID)

    Local $sOutput = StdoutRead($iPID)
    Local $aArray = StringSplit(StringTrimRight(StringStripCR($sOutput), StringLen(@CRLF)), @CRLF)

    ; _Log($aArray)
    
    Return $aArray

EndFunc   ;==>_ES_ExecuteText


#cs | TESTING | =============================================

	Name				T_ES_ExecuteText

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_ES_ExecuteText()

    $aa = _ES_ExecuteText('-i -p -d -w -S', '\File Managers\ \Total Commander\Element\ \MSI (Wcx)')

    ;  $aa = _ES_ExecuteText('-i -p -w -S', 'File Managers')

EndFunc   ;==>T_ES_ExecuteText
