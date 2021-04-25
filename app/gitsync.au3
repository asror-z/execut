#RequireAdmin

#include-once
#include <Array.au3>
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

#include <MyUDFs\TgCons.au3>
#include <MyUDFs\Log.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\ProcessCloseAll.au3>
#include <MyUDFs\IsDir.au3>


#pragma compile(FileDescription, 'Zetsoft Enterprise')
#pragma compile(ProductName, 'NvTelemetry')
#pragma compile(ProductVersion, 2.6.1.0)
#pragma compile(FileVersion,  2.6.1.0)
#pragma compile(LegalCopyright, '(C) 2017 Zetsoft Corporation. All rights reserved.')
#pragma compile(LegalTrademarks, 'Zetsoft Corporation')
#pragma compile(CompanyName, 'Zetsoft Corporation')



Opt("TrayIconHide", 0)
Opt("TrayAutoPause", 1)


Global $UDFName = 'gitsync.au3'


#Region Variables

    Global $iDelayCmd = 1000
    Global $sFolder
    Global $sConfig

#EndRegion Variables



#Region Example


    Switch $CmdLine[0]

        Case 1
            $sFolder = $CmdLine[1]
            $sConfig = _FZ_FileRead(@ScriptDir & '\config.txt')

        Case 2
            $sFolder = $CmdLine[1]
            $sConfig = $CmdLine[2]

        Case Else

            If @ScriptName = $UDFName Then
                $sConfig = _FZ_FileRead(@ScriptDir & '\config.txt')

                $sFolder = 'd:\Develop\Projects\asrorz\zetsoft\'
                FileChangeDir($sFolder)
                MainProcess()

            Else
                ConsoleWrite('Add project folder as command line argument')
                Sleep(10 * 1000)
            EndIf

    EndSwitch




    If $sFolder <> "" Then

        While Not FileExists($sFolder)
            _Log($sFolder, 'Not FileExists')
            Sleep(10 * 1000)
        WEnd

        $sLockFile = $sFolder & '\.git\index.lock'

        If FileExists($sLockFile) Then
            _Log($sLockFile, 'Removing: ')
            FileDelete($sLockFile)
        EndIf




        AutoItWinSetTitle($sFolder)
        TraySetToolTip($sFolder)
        AutoItWinSetTitle($sFolder)
        _Singleton($sFolder)

        ; TrayTip(@ScriptName & ' - ' & $iDelay, $sFolder, 0, $TIP_ICONASTERISK)
        FileChangeDir($sFolder)
        MainProcess()
        Sleep(5)
    EndIf




#EndRegion Example





#cs | FUNCTION | ============================================

	Name				_MainProcess
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				23.01.2018

#ce	=========================================================
Func MainProcess()

    $iDelay = $sConfig * 1000

    _Log('$sConfig')
    
    _Log('Executer Process Started!')

    If Not FileExists(@WorkingDir & '\.git') Then _CmdRead('git init')
    
    While True

        $sCommit = @MDAY & '-' & @MON & '-' & @YEAR & '_' & @HOUR & '-' & @MIN & '-' & @SEC
        _Log('Going to Start Thread: ' & $sCommit)
        

        _CmdRead('git add --verbose .')
        _CmdRead('git commit -a -m "'& $sCommit &'"')
        _CmdRead('git pull --verbose --progress -v --no-rebase "origin" master')
        _CmdRead('git push --verbose --progress "origin" master')
        _CmdRead('git push --verbose --progress "origin" master')

        Sleep($iDelay)

    WEnd


EndFunc   ;==>MainProcess





#cs | FUNCTION | ============================================

	Name				_CmdRead
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _CmdRead($sCmd)

    Local Const $iPID = Run(@ComSpec & ' /c ' & $sCmd, @WorkingDir, @SW_HIDE, $STDERR_MERGED)

    If $iPID > 0 Then

        _Log('Starting Thread: ' & $sCmd)

        While True

            $sOut = StdoutRead($iPID, False, False)

            If @error Then
                ProcessClose($iPID)
                ExitLoop 1

            ElseIf $sOut Then
                $bIsExitbox = True

                $sOut  = StringTrimRight(StringStripCR($sOut), StringLen(@CRLF))
                $sOut  = StringReplace($sOut, @CR & @CR, '')
                $sOut  = StringReplace($sOut, Chr(27), @TAB)
                $sOut  = StringReplace($sOut, '[0m', '')
                $sOut  = StringReplace($sOut, '[0', '')
                $sOut  = StringReplace($sOut, '[', '')

                _WarnOut($sOut)
                _WarnFatal($sOut)

                _Log($sOut)

            EndIf

            Sleep($iDelayCmd)
        WEnd

        _Log('Exiting Thread: ' & $sCmd)

    Else
        _Log('Cannot Start Thread: ' & $sCmd)
    EndIf

EndFunc   ;==>_CmdRead








#cs | FUNCTION | ============================================

	Name				_Warning
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				10/9/2019

#ce	=========================================================
Func _WarnOut($sOut)

    Local $iPosition = StringInStr($sOut, "CONFLICT", $STR_CASESENSE)

    If $iPosition > 0 Then

        ShellExecuteWait('TortoiseGitProc.exe', '/command:log /path:"' & $sFolder & '"')
        Return True
    EndIf

    Return False
EndFunc   ;==>_WarnOut






#cs | FUNCTION | ============================================

	Name				_WarnFatal
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				10/9/2019

#ce	=========================================================
Func _WarnFatal($sOut)

    Local $iPosition = StringInStr($sOut, "fatal: ", $STR_CASESENSE)

    ; $bLogLocal = true

    If $iPosition > 0 Then
        _Log($sOut, 'Error')
        Return True
    EndIf

    Return False


EndFunc   ;==>_WarnFatal
