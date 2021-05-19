#include <MyUDFs\_ShellAll.au3>
#include <MyUDFs\_ShellFolder.au3>

#include <MyUDFs\FileZ.au3>

#include <Array.au3>
#include <File.au3>

Local $sDrive, $sDir, $sFilename, $sExtension


#pragma compile(ExecLevel, none)
#pragma compile(Compatibility, win7)


If $CmdLine[0] > 0 Then

    ; _ArrayDisplay($CmdLine)
    
    $sFilename = $CmdLine[1]
    $sFilename = _FZ_Name($sFilename, $eFZN_FilenameNoExt)

    
    ShellExecute('Everything', '-nocase -ontop -noww -s "' & $sFilename & '"')

    ; Send("{LWIN}{LEFT}")

EndIf