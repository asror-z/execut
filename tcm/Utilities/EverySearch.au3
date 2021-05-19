#include <MyUDFs\_ShellFolder.au3>
#include <MyUDFs\_ShellAll.au3>


#include <Array.au3>
#include <File.au3>


#pragma compile(ExecLevel, none)
#pragma compile(x64, true)


Local $sDrive, $sDir, $sFilename, $sExtension

If $CmdLine[0] > 0 Then

	Local $sFullPath = $CmdLine[1]

	Local $aPathSplit = _PathSplit($sFullPath, $sDrive, $sDir, $sFilename, $sExtension)

    ShellExecute('Everything', '-nocase -ontop -noww -s "' & $sFilename & '"')

	; Send("{LWIN}{LEFT}")

Else 

		_ShellAll_Uninstall()
		_ShellFolder_Uninstall() 

	IF @Compiled Then
		_ShellAll_Install('EverySearch') 
		_ShellFolder_Install('EverySearch') 
	EndIf
	
EndIf