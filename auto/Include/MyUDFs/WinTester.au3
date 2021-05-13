#include <Misc.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <MyUDFs\Log.au3>




#cs | FUNCTION | ============================================

	Name				MainProcess
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================
Func MainProcess()
	

    $iDelay = 3000

    _Singleton(@ScriptName)
	Local $sLogDir = @ScriptDir & '\Logger'

    While True

		$sFileName = _NowTime()
        $sFileName = StringReplace($sFileName, ':', '-') & ' '
        $sFileName &= '(' & @ScriptName & ') .txt'
        $sFileName = $sLogDir & '\' & $sFileName
		
		DirCreate($sLogDir)
	
	    $sText = WinGetTitle("[ACTIVE]")
        FileWriteLine($sFileName, $sText)
        FileWriteLine($sFileName, @CRLF)
        FileWriteLine($sFileName, @CRLF)
		
        FileWriteLine($sFileName, @UserName)
        FileWriteLine($sFileName, @CRLF)
        FileWriteLine($sFileName, @CRLF)

        FileWriteLine($sFileName, EnvGet('APPDATA'))
        FileWriteLine($sFileName, @CRLF)
        FileWriteLine($sFileName, @CRLF)
		
		; _Log($sText)
	
        $sText = _ArrayToString(_WinAPI_EnumWindowsTop())
        FileWriteLine($sFileName, $sText)
		
        Sleep($iDelay)

    WEnd

EndFunc   ;==>MainProcess