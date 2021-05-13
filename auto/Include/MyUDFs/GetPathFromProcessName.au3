#include <WinAPIEx.au3>
#include <Array.au3>
#include <File.au3>
#include <MyUDFs\FileOperations.au3>

Global $UDFName = 'GetPathFromProcessName'



If @ScriptName = $UDFName & '.au3' Then

	_GetPathFromProcessName('notepad++')
	_GetPathFromProcessName('totalcmd')

EndIf




Func _GetPathFromProcessName($sPName)
    Local $iPID	=	ProcessExists($sPName & '.exe')

    If Not $iPID Then Return SetError(ConsoleWrite('Error: Not $iPID'), 0, '')

    Local $sFullPath =  _WinAPI_GetProcessFileName($iPID)
	Local $aPath	=	_FO_PathSplit($sFullPath)[0]
	
	ConsoleWrite($sPName & ':  ' & $aPath & @CRLF)
	
    Return $aPath

EndFunc   ;==>_GetPathFromProcessName










