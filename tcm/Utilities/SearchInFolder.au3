#include "UDF\_ShellFolder-1_0.au3"
#include "UDF\_ShellAll.au3"

#include <Array.au3>
#include <File.au3>

Local $sDrive, $sDir, $sFilename, $sExtension


#pragma compile(Icon, "- Theory\Everything.ico")
#pragma compile(Out, SearchInFolder.exe)
#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)
#pragma compile(x64, true)


If $CmdLine[0] > 0 Then

	Local $sFullPath = $CmdLine[1]

	Local $aPathSplit = _PathSplit($sFullPath, $sDrive, $sDir, $sFilename, $sExtension)

	ShellExecute(@ProgramFilesDir & '\Everything\Everything.exe', '-nocase -noww -ontop -p "' & $sFilename & '"')
	
	; Send("{LWIN}{LEFT}")

Else 
		_ShellAll_Uninstall()
		_ShellFolder_Uninstall() 

	IF @Compiled Then
		
		_ShellAll_Install('SearchInFolder') 
		_ShellFolder_Install('SearchInFolder') 
	EndIf
EndIf