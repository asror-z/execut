
#include-once

Global $UDFName = 'ProcessCloseEx'


#cs | INDEX | ===============================================

	Title				ProcessCloseEx
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				28.12.2017

#ce	=========================================================


    If @ScriptName = $UDFName & '.au3' Then

        ProcessCloseEx('NVDisplay.Container.exe')

    EndIf

Func ProcessCloseEx($sPID)
    If IsString($sPID) Then $sPID = ProcessExists($sPID)
    If Not $sPID Then Return SetError(1, 0, 0)
    
    Return Run(@ComSpec & " /c taskkill /F /PID " & $sPID & " /T", @SystemDir, @SW_HIDE)
EndFunc