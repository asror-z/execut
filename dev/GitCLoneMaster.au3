#include-once
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\ShellFolder.au3>
#include <MyUDFs\AppPath.au3>
#include <MyUDFs\Config.au3>


#cs | CURRENT | =============================================

	_SF_Install
	_SF_Uninstall
	_SF_UninstallByName

	_CN_JumpRegistry
#ce	=========================================================

Global $sPST_Exe, $sPST_Cmd, $sPSTExePath

; _ArrayDisplay($CmdLine)


If $CmdLine[0] >= 1 Then

    Switch $CmdLine[1]

        Case 'U'
            _PST_Uninstall()

        Case Else
            _PST_Exec()

    EndSwitch

Else
    _PST_Install()
EndIf






#cs | FUNCTION | ============================================

	Name				_PST_Install

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _PST_Install()

    _SF_Install('GIT   |   Clone Master', @ScriptFullPath)
	Mbox('Installed')
EndFunc   ;==>_PST_Install




#cs | FUNCTION | ============================================

	Name				_PST_Exec
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/15/2016

#ce	=========================================================
Func _PST_Exec ()
    

    $sPST_Cmd = '"' & $CmdLine[1] & '"'

	FileChangeDir($CmdLine[1])
	
	$sURL = Inbox ('Enter the git repository URL', ClipGet())
	
	Local $sCmd	=	' /c git clone _URL_ --branch master --single-branch '
	
	
	$sCmd = StringReplace($sCmd, '_URL_', $sURL)
	
    Run(@ComSpec & $sCmd)
	
    ; ShellExecute('cmd.exe', $sPST_Cmd)


EndFunc   ;==>_PST_Exec





#cs | FUNCTION | ============================================

	Name				_PST_Uninstall

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.02.2016

#ce	=========================================================

Func _PST_Uninstall ()
    _Log('_PST_Uninstall')

    _SF_UninstallByName('PhpStorm.exe')
    _SF_UninstallByName('PhpStorm64.exe')

EndFunc   ;==>_PST_Uninstall






#cs | FUNCTION | ============================================

	Name				_PST_GetExePath

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _PST_GetExePath ()

    Local Const $sMessage = "Choose PHP Storm Executable"

    Local $sFileOpenDialog = FileOpenDialog($sMessage, @ScriptDir, "PHP Storm (PhpStorm.exe;PhpStorm64.exe)", $FD_FILEMUSTEXIST)

    If @error Then ExitBox('No file is selected')

    Return $sFileOpenDialog

EndFunc   ;==>_PST_GetExePath



