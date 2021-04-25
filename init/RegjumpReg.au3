#RequireAdmin
#include <Array.au3>
#include <File.au3>

$sDrive = ""
$sDir = ""
$sFilename = ""
$sExtension = ""

$filePath = 'd:\Develop\Projects\execut\app\regjump.exe'


If @error Then
    MsgBox(4096, "", "Не выбрано ни одного файла")
Else
	
	$aPathSplit = _PathSplit($filePath, $sDrive, $sDir, $sFilename, $sExtension)

	; _ArrayDisplay($aPathSplit, "_PathSplit of " & @ScriptFullPath)

	$sWorkingDir = $sDrive & $sDir
			
	$sFileName = InputBox("sFileName", "sFileName", $sFilename)
	
	$sRegUrl = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\' & $sFileName & $sExtension
	
	
	RegWrite($sRegUrl, "", "REG_SZ", $filePath)
	
	RegWrite($sRegUrl, "Path", "REG_SZ", $sWorkingDir)
	RegWrite($sRegUrl, "useURL", "REG_SZ", "1")
	
	; ОК+Отмена, иконка «Знак вопроса», активно кнопка «ОК»
	$choose = MsgBox(1 + 32 + 0 + 8192 + 262144, @ScriptName, "Do you want start Registry Jumper on processed Section")
	
	If $choose Then ShellExecute ("regjump", $sRegUrl, @ScriptDir)
	
EndIf
