#include-once
#include <Array.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Log.au3>
#include <MyUDFs\RunCmdRead.au3>
#include <WinAPI.au3>
#include <Constants.au3>

Global $UDFName = 'Git.au3'


#cs | INDEX | ===============================================

	Title				Git
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				21.04.2016

#ce	=========================================================

#Region Example

    If @ScriptName = $UDFName Then

        ;  T_Git_Clone_Master()
        ;   T_Git_Add()

    EndIf

#EndRegion Example


#cs | CURRENT | =============================================

	_Git_Clone_Master($sFolderName)
	_Git_Add($sFolderName)
	_Git_Commit()

#ce	=========================================================



#cs | TESTING | =============================================

	Name				T_Git_Clone_Master

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_Git_Clone_Master()


    _Git_Clone_Master(@ScriptDir & '\Fl')

EndFunc   ;==>T_Git_Clone_Master




#cs | FUNCTION | ============================================

	Name				_MakeLNK
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/13/2020

#ce	=========================================================
Func _MakeLNK($app, $name = '')

	If $name = '' Then
		$name = _FZ_Name($app, $eFZN_FilenameNoExt)
	Endif

    $users = _SystemUsers(1)

    For $user In $users
        
    $lnk = 'c:\Users\'& $user &'\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\' & $name &'.lnk'
    FileCreateShortcut($app, $lnk)
    
    $lnk = 'c:\Users\'& $user &'\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\' & $name &'.lnk'
    FileCreateShortcut($app, $lnk)
    
    $lnk = 'c:\Users\'& $user &'\Desktop\' & $name &'.lnk'
    FileCreateShortcut($app, $lnk)
    
    $lnk = 'c:\Users\'& $user &'\Favorites\' & $name &'.lnk'
    FileCreateShortcut($app, $lnk)
    
    $lnk = 'c:\Users\'& $user &'\AppData\Roaming\OpenShell\Pinned\' & $name &'.lnk'
    FileCreateShortcut($app, $lnk)
	
    Next

EndFunc   ;==>_MakeLNK






#cs | INTERNAL FUNCTION | ===================================

	Name				_Get_Users
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/12/2020

#ce	=========================================================

Func _Get_Users()

    Local $colUsers, $sTmp, $Array[1] = ["user"]

    $colUsers = ObjGet("WinNT://" & @ComputerName)

    If IsObj($colUsers) Then
        $colUsers.Filter = $Array
        For $objUser In $colUsers
            $sTmp &= $objUser.Name & @LF
        Next
    EndIf

    Return $sTmp;

EndFunc   ;==>_Get_Users

; _PinToMenu(@WindowsDir & '\notepad.exe', 'Start')
; _PinToMenu('C:\Program Files (x86)\Internet Explorer\iexplore.exe', 'Task') ; Pin Item
;~ _PinToMenu('C:\Program Files\CCleaner\CCleaner.exe', 'Task', 0) ; Unpin Item

Func _PinToMenu($File, $Bar = 'Task', $Pin = True)
    If @OSBuild < 7600 Then Return SetError(1) ; Windows 7 only
    If Not FileExists($File) Then Return SetError(2)
    Local $sFolder = StringRegExpReplace($File, "(^.*\\)(.*)", "$1")
    Local $sFile = StringRegExpReplace($File, "^.*\\", '')
    $ObjShell = ObjCreate("Shell.Application")
    $objFolder = $ObjShell.Namespace($sFolder)
    $objFolderItem = $objFolder.ParseName($sFile)
    For $Val In $objFolderItem.Verbs()
        Select
            Case StringInStr($Bar, 'Task')
                If StringInStr($val(), "Tas&kBar") Then
                    $Val.DoIt()
                    Return
                EndIf
            Case StringInStr($Bar, 'Start')
                If StringInStr($val(), "Start Men&u") Then
                    $Val.DoIt()
                    Return
                EndIf
        EndSelect
    Next
EndFunc   ;==>_PinToMenu


Func _PinTaskbar($File, $Pin = True)
    If @OSBuild < 7600  Then Return SetError(1) ; Windows 7 only
    If Not FileExists($File) Then Return SetError(2)

    Local $sFolder = StringRegExpReplace($File, "(^.*\\)(.*)", "\1")
    Local $sFile = StringRegExpReplace($File, "^.*\\", "")

    Local $oShell     = ObjCreate("Shell.Application")
    Local $oFolder            = $oShell.NameSpace($sFolder)
    Local $oFolderItem        = $oFolder.ParseName($sFile)
    Local $oFolderItemVerbs   = $oFolderItem.Verbs
    Local $hInstance = _WinAPI_LoadLibraryEx("shell32.dll", $LOAD_LIBRARY_AS_DATAFILE)
    Local $DoVerb = ''

    If $hInstance Then
        If $Pin = 1 Then
            Local $DoVerb = _WinAPI_LoadString($hInstance, 5386)
        Else
            Local $DoVerb = _WinAPI_LoadString($hInstance, 5387)
        EndIf
        _WinAPI_FreeLibrary($hInstance)
    EndIf

    If $DoVerb = '' Then Return SetError(3) ; $DoVerb string couldn't received

    For $i = 0 To $oFolderItemVerbs.Count - 1
        If $oFolderItemVerbs.Item($i).Name = $DoVerb Then
            $oFolderItemVerbs.Item($i).DoIt
            Return
        EndIf
    Next
    Return SetError(4) ; $DoVerb string not in menu

EndFunc   ;==>_PinTaskbar



#cs ===============================================================================
    Function:      _SystemUsers($AccountType = 0)
    Description:   Return an array with the local or domain username
    Parameter(s):  $AccountType: Local, domain or both username
        0 = Local and Domain usernames
        1 = Local usernames only
        2 = Domain usernames only
    Returns:       An array with the list of usernames - Succeeded
        @error 1 - Didn't query any username
        @error 2 - Failed to create Win32_SystemUsers object
        @error 3 - Invalid $AccountType

    Author(s):  Danny35d
#ce ===============================================================================
Func _SystemUsers($AccountType = 1)
    Local $aSystemUsers
    Local $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
    Local $colItems = "", $strComputer = "localhost"

    If Not StringRegExp($AccountType, '[012]') Then Return SetError(3, 3, '')
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SystemUsers", "WQL", _
            $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

    If IsObj($colItems) Then
        For $objItem In $colItems
            $Output = StringSplit($objItem.PartComponent, ',')
            If IsArray($Output) Then
                $Temp = StringReplace(StringTrimLeft($Output[2], StringInStr($Output[2], '=', 0, -1)), '"', '')
                If $AccountType = 0 Or ($AccountType = 1 And @ComputerName = $Temp) Then
                    $aSystemUsers &= StringReplace(StringTrimLeft($Output[1], StringInStr($Output[1], '=', 0, -1)), '"', '') & '|'
                ElseIf $AccountType = 2 And @ComputerName <> $Temp Then
                    $aSystemUsers &= StringReplace(StringTrimLeft($Output[1], StringInStr($Output[1], '=', 0, -1)), '"', '') & '|'
                EndIf
            EndIf
        Next
        $aSystemUsers = StringTrimRight($aSystemUsers, 1)
        If $aSystemUsers = '' Then Return(SetError(1, 1, $aSystemUsers))
        Return(SetError(0, 0, StringSplit($aSystemUsers, '|')))
    Else
        $aSystemUsers = ''
        Return(SetError(2, 2, $aSystemUsers))
    EndIf
EndFunc   ;==>_SystemUsers

#cs | FUNCTION | ============================================

	Name				_Conf_Set
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/28/2020

#ce	=========================================================
Func _Conf_Set()

    ConfBefore()

    If $perUser Then
        ;    $users = _Get_Users()

        $users = _SystemUsers(0)

        For $vElement In $users

            $configFolder = StringReplace($configPerUser, '{userName}', $vElement)
            _FZ_FFS($backupFolder, $configFolder)
            ; _FZ_Robo($backupFolder, $configFolder)

        Next

    Else
        ; _FZ_Robo($backupFolder, $configFolder)
        _FZ_FFS($backupFolder, $configFolder)
    EndIf

    If FileExists($scriptRun) Then ShellExecuteWait($scriptRun)

EndFunc   ;==>_Conf_Set





Func _UnlockDelete($sFullPath)

    ShellExecuteWait('LockHunter', '/kill /delete /delperm /exit"' & $sFullPath & '"')

EndFunc   ;==>_UnlockDelete


Func _CleanPerm($sFullPath)

    ShellExecuteWait('icacls', '"'& $sFullPath &'" /grant[:r] everyone:(OI)(CI)F /inheritancelevel:r  /T')

EndFunc   ;==>_CleanPerm





Func _Deleter($sFullPath)

    ConfBefore()

    $files = FileReadToArray($sFullPath)

    $users = _SystemUsers(1)

    For $File In $files

        For $vElement In $users

            $configFolder = StringReplace($File, '{userName}', $vElement)
            _CleanPerm($configFolder)
            ; _UnlockDelete($configFolder )
			

        Next
    Next

EndFunc   ;==>_Deleter

Func _Sync($iDelay)

    #Region Exec

        While True
            _FZ_FFS ($backupFolder, $configFolder)
            Sleep($iDelay)
        WEnd

    #EndRegion Exec

EndFunc   ;==>_Sync




Func _Reg_Set()

    If FileExists($scriptExit) Then ShellExecuteWait($scriptExit)

    $fileName = $backupFolder & '\Registry.reg'

    If FileExists($fileName) Then ShellExecuteWait($fileName)

    RegJump($regLocation)

    If FileExists($scriptRun) Then ShellExecuteWait($scriptRun)

EndFunc   ;==>_Reg_Set



Func AddCmd($fileName, $path)
    Run ('regedit.exe /E "'& $fileName &'" "'& $path &'"')
EndFunc   ;==>AddCmd



#cs | FUNCTION | ============================================

	Name				_RegGet
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/28/2020

#ce	=========================================================
Func _Reg_Get()

    ConfBefore()

    $fileName = $backupFolder & '\Registry.reg'

    AddCmd($fileName, $regLocation)

    _Git_CommitTime(@ScriptDir)



EndFunc   ;==>_Reg_Get




#cs | INTERNAL FUNCTION | ===================================

	Name				ConfBefore
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/28/2020

#ce	=========================================================

Func ConfBefore()

    If Not MboxQ('Are You Sure') Then Exit

    If FileExists($scriptExit) Then ShellExecuteWait($scriptExit)

EndFunc   ;==>ConfBefore

Func ConfAfter()

    If FileExists($scriptRun) Then ShellExecuteWait($scriptRun)

    If $addGit Then _Git_CommitTime(@ScriptDir)

EndFunc   ;==>ConfAfter



#cs | INTERNAL FUNCTION | ===================================

	Name				_Conf_Get
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/28/2020

#ce	=========================================================

Func _Conf_Get()

	
	; ExitBox($configFolder)
	
    If Not FileExists($configFolder) Then ExitBox('Config folder is not exists')
	
    If _FZ_DirIsEmpty($configFolder) Then ExitBox('Config folder is empty')

    ConfBefore()
	


    _FZ_FFS ($configFolder, $backupFolder)

    ConfAfter()

EndFunc   ;==>_Conf_Get





#cs | INTERNAL FUNCTION | ===================================

	Name				_GoToDir
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/28/2020

#ce	=========================================================

Func _GoToDir()

    DirCreate($configFolder)

    ShellExecute('TotalCmd64.exe', ' /O /P=L /L="' & $configFolder  & '"')

EndFunc   ;==>_GoToDir








#cs | FUNCTION | ============================================

	Name				_Git_CommitTime
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				06.02.2018

#ce	=========================================================
Func _Git_CommitTime($sBackupFolder)

    $sCommit = @MDAY & '-' & @MON & '-' & @YEAR & '_' & @HOUR & '-' & @MIN & '-' & @SEC

    Local $sCmd = ' /c git init' & ' && ' & _
            'git add .' & ' && ' & _
            'git commit -m "'& $sCommit &'"'  & ' && ' & _
            'ping -n 3 127.0.0.1 > nul'

    FileChangeDir($sBackupFolder)

    Run(@ComSpec & $sCmd)


EndFunc   ;==>_Git_CommitTime


#cs | FUNCTION | ============================================

	Name				_Git_Clone_Master
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _Git_Clone_Master($sFolderName)


    _Log('We will begin Git Clone Master to ' & $sFolderName)

    If Not FileExists($sFolderName) Then
        _Log($sFolderName & ' is not exist! We will create it...')
        If DirCreate($sFolderName) Then _Log($sFolderName & ' is success created!')
    EndIf

    If FileChangeDir($sFolderName) Then _Log('Changed current directory to ' & $sFolderName)

    $sURL = Inbox('Enter the git repository URL', ClipGet())

    If $sURL = '' Then ExitBox('Remote Repository adress cannot be empty!')

    _Log('Remote Repository adress: ' & $sURL)


    Local $sCmd	=	'git clone _URL_ --branch master --single-branch '
    $sCmd = StringReplace($sCmd, '_URL_', $sURL)
    _Log($sCmd, '$sCmd')

    RunWait(@ComSpec & ' /c ' & $sCmd)

    If @error Then ExitBox('Error when executing Git Clone')
    _Log('Git Clone Master success completed!')
    _Eol()


EndFunc   ;==>_Git_Clone_Master




#cs | FUNCTION | ============================================

	Name				_Git_Add
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _Git_Add($sFolderName)


    _Log('We will begin Git Add to ' & $sFolderName)

    If Not FileExists($sFolderName) Then ExitBox($sFolderName & ' is not exist!')

    If FileChangeDir($sFolderName) Then _Log('Changed current directory to ' & $sFolderName)

    Local $sCmd	=	'git init & git add .'
    _Log($sCmd, '$sCmd')

    RunWait(@ComSpec & ' /c ' & $sCmd)

    If @error Then ExitBox('Error when executing Git Add')
    _Log('Git Add success completed!')

EndFunc   ;==>_Git_Add


#cs | TESTING | =============================================

	Name				T_Git_Add

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_Git_Add()

    _Log('_Git_Add(@ScriptDir & "\Nedd")')

EndFunc   ;==>T_Git_Add




#cs | FUNCTION | ============================================

	Name				_Git_Commit
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _Git_Commit()


    $sAppDataDir =	@UserProfileDir & '\*.git*'
    $sBackupDir = @ScriptDir & '\ConfBackup\'

    DirCreate($sBackupDir)

    _FZ_Copy($sAppDataDir, $sBackupDir)

    $sCommit = Inbox('Commit message')

    Local $sCmd = ' /c git add .' & ' && ' & _
            'git commit -m "'&$sCommit&'"'  & ' && ' & _
            
    Run(@ComSpec & $sCmd)


EndFunc   ;==>_Git_Commit


#cs | TESTING | =============================================

	Name				T_Git_Commit

	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_Git_Commit()

    _Log('_Git_Commit()')

EndFunc   ;==>T_Git_Commit

