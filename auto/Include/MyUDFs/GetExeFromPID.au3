#include <Date.au3>
#include <WinAPIEx.au3>
#include <MyUDFs\FileZ.au3>

#include-once

Global $UDFName = 'GetExeFromPID'


#cs | INDEX | ===============================================

	Title				GetExeFromPID
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				30.01.2018

#ce	=========================================================

If @ScriptName = $UDFName & '.au3' Then

    $sExe = GetExeFromPID(ProcessExists('Slimjet.exe'))
    _Log('$sExe')
EndIf




#cs | FUNCTION | ============================================

	Name				GetExeFromPID
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2018

#ce	=========================================================
Func GetExeFromPID($iPID)

    $sFullPath = _WinAPI_GetProcessFileName($iPID)

    $sExeName = _FZ_Name($sFullPath, $eFZN_FilenameFull)
    Return $sExeName

EndFunc   ;==>GetExeFromPID


