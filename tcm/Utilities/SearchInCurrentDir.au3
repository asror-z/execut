#include <Array.au3>
#include <File.au3>

Local $sDrive, $sDir, $sFilename, $sExtension


#pragma compile(Icon, "Everything.ico")
#pragma compile(Out, SearchInCurrentDir.exe)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(x64, true)


If $CmdLine[0] > 0 Then

	;	_ArrayDisplay($CmdLine)


	$sFullPathFile = $CmdLine[1]
	$sFullPath = FileReadLine($sFullPathFile, 1)

	If FileExists($sFullPath) and StringInStr(FileGetAttrib($sFullPath),"D") Then
		$sParentDir = _PathFull($sFullPath & "..\") 
	Else
		Local $aPathSplit = _PathSplit($sFullPath, $sDrive, $sDir, $sFilename, $sExtension)
		$sParentDir = $sDrive & $sDir		
	EndIf
	
	
	ShellExecute('Everything', '-nocase -noww -ontop -p "' & $sParentDir & '"')
	
	; Send("{LWIN}{LEFT}")
	
		
	
Else
	
	$sss = 'D:\Application\Software\Windows\NTFS MFT Search\Everything\Element\Shell Context Menu\UDF\'

		Local $sParentDir = _PathFull($sss & "..\") 

	ConsoleWrite($sParentDir)
EndIf