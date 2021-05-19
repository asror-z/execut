#include-once
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <String.au3>
#include <MyUDFs\Log.au3>
#include <MyUDFs\TC.au3>
#include <MyUDFs\FileZ.au3>

#pragma compile(Out, c:\AsrorZ\TCU\MoveObject.exe)


#cs | INDEX | ===============================================

	Title				MoveObject
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				19.02.2018

#ce	=========================================================



Global $UDFName = 'MoveObject'
Global $sTargetDir = ''

Global $iType_Github = 1
Global $iType_Package = 2
Global $iType_Nuget = 3
Global $iType_CryptoCompare = 4
Global $iType_CryptoWallet = 5
Global $iType_Library = 6
Global $iType_Docker = 7

Global $iType = 0
#Region Example

    If @ScriptName = $UDFName & ".au3" Then

        ; T_MO_GithubArray()

        ;	__MO_PackagistArray()
    EndIf

#EndRegion Example


Global $bDebug  = False
Global $bClone  = False
Global $bMhtml = False


#cs | CURRENT | =============================================

	_MO_MoveObject($sDest)
	_MO_MoveToFolder()
	_MO_Help()
	__MO_GithubArray($sFileName)
	__MO_PackagistArray()
	_MO_FileToFolder()
	_MO_ProcessGithub()

#ce	=========================================================



#cs | CURRENT | =============================================

	_MO_MoveObject($sDest)
	_MO_MoveToFolder()
	_MO_Help()
	__MO_GithubArray($sFileName)
	_MO_FileToFolder()
	_MO_ProcessGithub()

#ce	=========================================================

; Opt("MustDeclareVars", 1)

#Region Declaration

    ; BK: Global
    Global $sParentDir,$aReview, $aName, $aTwitter, _
            $aWebsite, $aCountry, $aRating, $aCoins, $aDomain, $aURL, $aFollow

#EndRegion Declaration



#Region Compile

    #pragma compile(ExecLevel, none)
    #pragma compile(Compatibility, win7)
    #pragma compile(x64, true)

#EndRegion Compile


If $CmdLine[0] > 1 Then

    Local $iFilesLength = UBound($CmdLine) - 1
    Local $aSelItems[$iFilesLength - 1], $iCounter = 0

    For $i = $iFilesLength To 2 Step -1
        $aSelItems[$iCounter] = $CmdLine[$i]
        $iCounter += 1
    Next

    _Log('$aSelItems')

    $sParentDir = _FZ_Name($CmdLine[2], $eFZN_FileParentDir) & '\'
    _Log('$sParentDir')

    If Not $bDebug Then $s_TC_GetFocusItem	= _TC_ListB_GetFocus()

    Switch $CmdLine[1]


        #Region CmdLine

            Case 'A'
                _MO_MoveObject("Archive")


            Case 'O'
                _MO_MoveObject("@ Other")

            Case 'W'
                _MO_MoveObject("@ Weak")

            Case 'D'
                _MO_MoveObject("@ Dead")

            Case 'T'
                _MO_MoveObject("- Theory")

            Case 'I'
                _MO_MoveObject("Installer")

            Case 'P'
                _MO_MoveObject("Portable")

            Case 'E'
                _MO_MoveObject("Element")

            Case 'M'
                _MO_MoveObject("Manuals")

            Case 'S'
                _MO_MoveObject("Settings")

            Case 'R'
                _MO_MoveObject("Sources")

            Case 'U_F'
                _MO_FileToFolder()


            Case 'M_F'
                _MO_MoveToFolder()

            Case 'AS_A'
                _MO_Process()

            Case 'AS_Z'
                $bMhtml = True
                _MO_Process()

            Case 'AS_Q'
                $bClone = True
                _MO_Process()


            #EndRegion CmdLine



    EndSwitch

    If Not $bDebug Then _TC_ListB_SetFocus($s_TC_GetFocusItem)

    Exit
Else
    ;	_MO_Help()
    ; BK: SSS

    ; __MO_LibrariesArray()
    ;	__MO_NugetArray()
    ; __MO_GithubArray()
    ; $bClone = True
    _MO_ProcessItem()
    ;  __MO_PackagistArray()
EndIf




#cs | FUNCTION | ============================================

	Name				_MO_MoveObject
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func _MO_MoveObject($sDest)

    If MsgBox(52, "Warning", $sDest) = 6 Then

     ;   __MO_CloseNpp()
        $sDestFolder = $sParentDir & $sDest & '\'
        DirCreate($sDestFolder)

        For $vElement In $aSelItems
            $sDestFileLocation = $sDestFolder & _FZ_Name($vElement, $eFZN_FilenameFull)
            ; MsgBox(0, '$sDestFileLocation', $sDestFileLocation)

            If StringInStr(FileGetAttrib($vElement), "D") Then
                __MoveDir($vElement, $sDestFileLocation)
            Else
                __MoveFile($vElement, $sDestFileLocation)
            EndIf

        Next

    EndIf

EndFunc   ;==>_MO_MoveObject


#cs | TESTING | =============================================

	Name				T_MO_MoveObject

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_MO_MoveObject()

    _Log("_MO_MoveObject($sDest)")

EndFunc   ;==>T_MO_MoveObject




#cs | FUNCTION | ============================================

	Name				_MO_MoveToFolder
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				24.10.2016

#ce	=========================================================

Func _MO_MoveToFolder()

    $sFolderName = Inbox ('Enter New Folder Name')

    __MO_CloseNpp ()

    $sDestFolder = $sParentDir & $sFolderName & '\'
    DirCreate($sDestFolder)

    For $vElement In $aSelItems
        $sDestFileLocation = $sDestFolder & _FZ_Name($vElement, $eFZN_FilenameFull)

        If StringInStr(FileGetAttrib($vElement), "D") Then
            __MoveDir($vElement, $sDestFileLocation)
        Else
            __MoveFile($vElement, $sDestFileLocation)
        EndIf

    Next


EndFunc   ;==>_MO_MoveToFolder


#cs | TESTING | =============================================

	Name				T_MO_MoveToFolder

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_MO_MoveToFolder()

    _Log("_MO_MoveToFolder()")

EndFunc   ;==>T_MO_MoveToFolder




#cs | FUNCTION | ============================================

	Name				_MO_Help
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func _MO_Help()

    $sHelpStr = 'Alt+Shift+O- _MO_MoveObject("@ Other")'
    $sHelpStr &= @CRLF & 'Alt+Shift+W - _MO_MoveObject("@ Weak")'
    $sHelpStr &= @CRLF & 'Alt+Shift+T - _MO_MoveObject("- Theory")'
    $sHelpStr &= @CRLF & 'Alt+Shift+I - _MO_MoveObject("Installer")'
    $sHelpStr &= @CRLF & 'Alt+Shift+P - _MO_MoveObject("Portable")'
    $sHelpStr &= @CRLF & 'Alt+Shift+E - _MO_MoveObject("Element")'
    $sHelpStr &= @CRLF & 'Alt+Shift+M - _MO_MoveObject("Manuals")'
    $sHelpStr &= @CRLF & 'Alt+Shift+S - _MO_MoveObject("Settings")'
    $sHelpStr &= @CRLF & 'Alt+Shift+R - _MO_MoveObject("Sources")'

    $sHelpStr &= @CRLF

    $sHelpStr &= @CRLF &  'Alt+F - _MO_FileToFolder()'
    $sHelpStr &= @CRLF &  'Alt+Shift+F - _MO_MoveToFolder()'

    MsgBox($MB_OK + $MB_DEFBUTTON1, 'Warning !', $sHelpStr)

EndFunc   ;==>_MO_Help


#cs | TESTING | =============================================

	Name				T_MO_Help

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_MO_Help()

    _Log("_MO_Help()")

EndFunc   ;==>T_MO_Help




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_GithubArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================








#cs | FUNCTION | ============================================

	Name				__GitClone
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.07.2018

#ce	=========================================================
Func __GitClone($sURL)

    Local $sCmd	=	'git clone _URL_ --branch master --single-branch '
    $sCmd = StringReplace($sCmd, '_URL_', $sURL)
    _Log($sCmd, '$sCmd')

    $sCmdCm = @ComSpec & ' /c ' & $sCmd
    _Log($sCmdCm)

    RunWait($sCmdCm, '', @SW_MINIMIZE)

    If @error Then ExitBox('Error when executing Git Clone')

    _Log('Git Clone Master success completed!')

EndFunc   ;==>__GitClone

#cs | FUNCTION | ============================================

	Name				__MO_GithubArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func __MO_PackagistArray($sFileName = '')

    Local $aReturn[3]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\daixianceng_yii2-echarts - Packagist'
    EndIf

    Local $sFileNameNoExt = _FZ_Name($sFileName, $eFZN_FilenameNoExt)

    $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)(.*?)_(.*?) - Packagist', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp, '__MO_NugetArray Array')
    If Not IsArray($aReturnTmp) Then Return False


    Local $sGitFirst = _StringTitleCase($aReturnTmp[0])
    Local $sGitSecond = _StringTitleCase($aReturnTmp[1])

    $aReturn[0] = $sGitFirst & '.' & $sGitSecond
    $aReturn[1] = $aReturnTmp[0] & '/' & $aReturnTmp[1]

    ;    $sFileName = 'd:\Develop\System\AutoIT\Element\Automat\Files\TC\MoveObject\Samples\ProcessPackagist\bubifengyun_yii2-echarts - Packagist.mhtml'

    Local $sText	=	_FZ_FileRead($sFileName)

    ;  $sText = 'github.com/force-components/FileSystem/issues'
    ;  $sText = 'github.com/force-components/FileSystem/tree'
    ;  $sText = 'github.com/force-components/FileSystem</a>'

    $sText = StringReplace($sText, '=' & @CRLF , '')

    $sPatternIssues = '(?i)github.com/(.*?)/(.*)/issues'
    $sPatternTree = '(?i)github.com/(.*?)/(.*)/tree'
    $sPatternTag = '(?i)github.com/(.*?)/(.*)</a>'

    $aReturnGit = StringRegExp($sText, $sPatternIssues, $STR_REGEXPARRAYMATCH)

    If Not IsArray($aReturnGit) Then $aReturnGit = StringRegExp($sText, $sPatternTree, $STR_REGEXPARRAYMATCH)
    If Not IsArray($aReturnGit) Then $aReturnGit = StringRegExp($sText, $sPatternTag, $STR_REGEXPARRAYMATCH)

    If Not IsArray($aReturnGit) Then Mbox('No aReturnGit - ' & $sFileName)

    $aReturn[2] = 'https://github.com/' & $aReturnGit[0] &'/' & $aReturnGit[1]

    _Log($aReturn, 'GitHub Array')

    Return $aReturn

EndFunc   ;==>__MO_PackagistArray






#cs | FUNCTION | ============================================

	Name				__MO_GithubArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func __MO_GithubArray($sFileName = '')

    Local $aReturn[2]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\GitHub - actions_example-gcloud_ An example workflow, using the GitHub Action, to deploy a static website to an existing Google Kubernetes Engine Cluster'
    EndIf


    _Log($sFileName)

    $aReturnTmp = StringRegExp($sFileName, '(?i)GitHub - (.*?)_(.*?)_ .*', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp, 'GitHub Array #1')

    If Not IsArray($aReturnTmp) Then
        $aReturnTmp = StringRegExp($sFileName, '(?i)GitHub - ?(.*?)_(.*)_.*', $STR_REGEXPARRAYMATCH)
        _Log($aReturnTmp, 'GitHub Array #2')
    EndIf

    If Not IsArray($aReturnTmp) Then

        $aReturnTmp = StringRegExp($sFileName, '(?i)(.*?)_(.*)_.*', $STR_REGEXPARRAYMATCH)

        _Log($aReturnTmp, 'GitHub Array #3')
    EndIf

    If Not IsArray($aReturnTmp) Then
        _Log($aReturnTmp, 'Return False')
        Return False
    EndIf


    Local $sGitFirst = _StringTitleCase($aReturnTmp[0])
    Local $sGitSecond = _StringTitleCase($aReturnTmp[1])

    $aReturn[0] = $sGitFirst & ' ' & $sGitSecond

    $aReturn[1] = 'https://github.com/' & $aReturnTmp[0] &'/' & $aReturnTmp[1]

    _Log($aReturn, 'GitHub Array $aReturn[0]')

    Return $aReturn

EndFunc   ;==>__MO_GithubArray




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_DockerArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				27.06.2018

#ce	=========================================================

Func __MO_DockerArray($sFileName = '')

    Local $aReturn[3]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\akrambenaissi_docker-squid - Docker Hub.mhtml'
    EndIf

    Local $sFileNameNoExt = _FZ_Name($sFileName, $eFZN_FilenameNoExt)

    $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)(.*?)_(.*?) - Docker Hub', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp, '__MO_DockerArray Array #1')

    If Not IsArray($aReturnTmp) Then
        $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)(.*?) - Docker Hub', $STR_REGEXPARRAYMATCH)
        _Log($aReturnTmp, '__MO_DockerArray Array')

        Local $sGitFirst = _StringTitleCase($aReturnTmp[0])

        $aReturn[0] = $sGitFirst
        $aReturn[1] = $aReturnTmp[0]

    Else

        Local $sGitFirst = _StringTitleCase($aReturnTmp[0])
        Local $sGitSecond = _StringTitleCase($aReturnTmp[1])

        $aReturn[0] = $sGitFirst & '.' & $sGitSecond
        $aReturn[1] = $aReturnTmp[0] & '/' & $aReturnTmp[1]

    EndIf

    If Not IsArray($aReturnTmp) Then Return False

    ;    $sFileName = 'd:\Develop\System\AutoIT\Element\Automat\Files\TC\MoveObject\Samples\ProcessPackagist\bubifengyun_yii2-echarts - Packagist.mhtml'

    Local $sText	=	_FZ_FileRead($sFileName)

    ;  $sText = 'github.com/force-components/FileSystem/issues'
    ;  $sText = 'github.com/force-components/FileSystem/tree'
    ;  $sText = 'github.com/force-components/FileSystem</a>'

    $sText = StringReplace($sText, '=' & @CRLF , '')

    $sPatternIssues = '(?i)github.com/(.*?)/(.*)/issues'
    $sPatternTree = '(?i)github.com/(.*?)/(.*)/tree'
    $sPatternTag = '(?i)github.com/(.*?)/(.*)</a>'

    $aReturnGit = StringRegExp($sText, $sPatternIssues, $STR_REGEXPARRAYMATCH)

    If Not IsArray($aReturnGit) Then $aReturnGit = StringRegExp($sText, $sPatternTree, $STR_REGEXPARRAYMATCH)
    If Not IsArray($aReturnGit) Then $aReturnGit = StringRegExp($sText, $sPatternTag, $STR_REGEXPARRAYMATCH)

    If Not IsArray($aReturnGit) Then
        $aReturn[2] = ''
    Else
        $aReturn[2] = 'https://github.com/' & $aReturnGit[0] &'/' & $aReturnGit[1]
    EndIf

    _Log($aReturn, 'Docker Array')

    Return $aReturn

EndFunc   ;==>__MO_DockerArray




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_NugetArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				27.06.2018

#ce	=========================================================

Func __MO_NugetArray($sFileName = '')

    Local $aReturn[2]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\NuGet Gallery _ Pomelo.EntityFrameworkCore.MySql 2.0.1.mhtml'
    EndIf

    Local $sFileNameNoExt = _FZ_Name($sFileName, $eFZN_FilenameNoExt)

    $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)NuGet Gallery _ (.*?) .*', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp, '__MO_NugetArray Array')

    If Not IsArray($aReturnTmp) Then Return False


    $aReturn[0] = $aReturnTmp[0]
    Local $sText	=	_FZ_FileRead($sFileName)

    $sText = StringReplace($sText, '=' & @CRLF , '')
    $sText = StringReplace($sText, '3D' , '')

    $sPatternIssues = '(?i)"(http.*?)" data-track="outbound-project-url"'

    $aReturnGithub = StringRegExp($sText, $sPatternIssues, $STR_REGEXPARRAYMATCH)

    _Log($aReturnGithub, 'GitHub Array')

    If IsArray($aReturnGithub) Then
        $aReturn[1] = $aReturnGithub[0]
    EndIf

    _Log($aReturn, 'Return')

    Return $aReturn

EndFunc   ;==>__MO_NugetArray




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_CryptoArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				27.06.2018

#ce	=========================================================

Func __MO_CryptoArray($sFileName = '')

    Local $aReturn[2]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\NuGet Gallery _ Pomelo.EntityFrameworkCore.MySql 2.0.1.mhtml'
    EndIf

    Local $sFileNameNoExt = _FZ_Name($sFileName, $eFZN_FilenameNoExt)

    $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)NuGet Gallery _ (.*?) .*', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp, '__MO_NugetArray Array')

    If Not IsArray($aReturnTmp) Then Return False


    $aReturn[0] = $aReturnTmp[0]
    Local $sText	=	_FZ_FileRead($sFileName)

    $sText = StringReplace($sText, '=' & @CRLF , '')
    $sText = StringReplace($sText, '3D' , '')

    $sPatternIssues = '(?i)"(http.*?)" data-track="outbound-project-url"'

    $aReturnGithub = StringRegExp($sText, $sPatternIssues, $STR_REGEXPARRAYMATCH)

    _Log($aReturnGithub, 'GitHub Array')

    If IsArray($aReturnGithub) Then
        $aReturn[1] = $aReturnGithub[0]
    EndIf

    _Log($aReturn, 'Return')

    Return $aReturn

EndFunc   ;==>__MO_CryptoArray




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_LibrariesArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				27.06.2018

#ce	=========================================================

Func __MO_LibrariesArray($sFileName = '')

    Local $aReturn[2]

    If $sFileName = '' Then
        $sFileName = @ScriptDir & '\Samples\qsun_ParDiff-VPN - Libraries.io.mhtml'
    EndIf


    Local $sFileNameNoExt = _FZ_Name($sFileName, $eFZN_FilenameNoExt)


    $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)(.*?) .*? on NuGet - Libraries.io', $STR_REGEXPARRAYMATCH)

    _Log($aReturnTmp)
    If Not IsArray($aReturnTmp) Then
        $aReturnTmp = StringRegExp($sFileNameNoExt, '(?i)(.*?) - Libraries.io', $STR_REGEXPARRAYMATCH)

    EndIf



    If Not IsArray($aReturnTmp) Then Return False

    _Log($aReturnTmp, '__MO_NugetArray Array')

    $aReturn[0] = $aReturnTmp[0]

    Local $sText	=	_FZ_FileRead($sFileName)

    $sText = StringReplace($sText, '=' & @CRLF , '')
    $sText = StringReplace($sText, '3D' , '')

    $sPatternIssues = '(?i)<a rel="nofollow" href="(http.*?)">Homepage</a>'

    $aReturnGithub = StringRegExp($sText, $sPatternIssues, $STR_REGEXPARRAYMATCH)

    _Log($aReturnGithub, 'GitHub Array')

    If IsArray($aReturnGithub) Then
        $aReturn[1] = $aReturnGithub[0]
    EndIf

    _Log($aReturn, 'Return')

    Return $aReturn

EndFunc   ;==>__MO_LibrariesArray




#cs | TESTING | =============================================

	Name				T__MO_GithubArray

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T__MO_GithubArray()

    __MO_GithubArray('')

EndFunc   ;==>T__MO_GithubArray




#cs | INTERNAL FUNCTION | ===================================

	Name				__MoveFile
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				26.01.2018

#ce	=========================================================

Func __MoveFile($vElement, $sDestFileLocation)

    If FileExists($sDestFileLocation) Then
        $sNewName = _FZ_Name($sDestFileLocation, $eFZN_FileNameIncrement)
        FileMove($sDestFileLocation, $sNewName, $FC_OVERWRITE + $FC_CREATEPATH)
    EndIf

    $bRes = FileMove($vElement, $sDestFileLocation, $FC_OVERWRITE + $FC_CREATEPATH)
    If $bRes <> 1 Then ExitBox('Cannot Move File: ' & $vElement & ' to: ' & $sDestFileLocation)


EndFunc   ;==>__MoveFile




#cs | INTERNAL FUNCTION | ===================================

	Name				__MoveDir
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				26.01.2018

#ce	=========================================================

Func __MoveDir($vElement, $sDestFileLocation)

    $bRes = DirMove($vElement, $sDestFileLocation, $FC_OVERWRITE)
    If $bRes <> 1 Then ExitBox('Cannot Move Dir: ' & $vElement & ' to: ' & $sDestFileLocation)


EndFunc   ;==>__MoveDir




#cs | FUNCTION | ============================================

	Name				_MO_FileToFolder
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func _MO_FileToFolder()

    If MsgBox(52, "Warning", 'FileToFolder') = 6 Then
        For $vElement In $aSelItems

            Local $sFileNameExt = _FZ_Name($vElement, $eFZN_FilenameFull)
            Local $sFileNameNoExt = _FZ_Name($vElement, $eFZN_FilenameNoExt)


            Local $sMO_GetDir = $sParentDir & $sFileNameNoExt
            Local $sDestFileLocation = $sMO_GetDir & '\' & $sFileNameExt

            DirCreate($sMO_GetDir)

            If StringInStr(FileGetAttrib($vElement), "D") Then
                ContinueLoop
            Else
                __MoveFile($vElement, $sDestFileLocation)
            EndIf

        Next
    EndIf

EndFunc   ;==>_MO_FileToFolder


#cs | TESTING | =============================================

	Name				T_MO_FileToFolder

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_MO_FileToFolder()

    _Log("_MO_FileToFolder()")

EndFunc   ;==>T_MO_FileToFolder




#cs | FUNCTION | ============================================

	Name				_MO_FileToFolder
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================




#cs | FUNCTION | ============================================

	Name				_MO_Process
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				08.03.2018

#ce	=========================================================




Func _MO_Process()

    ;	For Testing
    ;	AS_Q "d:\Develop\System\AutoIT\Element\Automat\Files\TC\MoveObject\Samples\ProcessPackagist\bubifengyun_yii2-echarts - Packagist.mhtml"
    $sMs = 'Process Item'

    If $bClone Then $sMs &= ' + CLONE!'

    If $bMhtml = False Then
          If MsgBox(52, "Warning", $sMs) = 6 Then

            For $vElement In $aSelItems
                _MO_ProcessItem($vElement)
            Next

        EndIf
    Else
            For $vElement In $aSelItems
                _MO_ProcessItem($vElement)
            Next

      
    EndIf
EndFunc   ;==>_MO_Process




#cs | INTERNAL FUNCTION | ===================================

	Name				_MO_ProcessItem
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.07.2018

#ce	=========================================================

Func _MO_ProcessItem($vElement = '')


    $bMove = True
    If $vElement = '' Then

        ; $vElement = @ScriptDir & '\Samples\NuGet Gallery _ Pomelo.EntityFrameworkCore.MySql 2.0.1.mhtml'

        $vElement = @ScriptDir & '\Samples\nginx - Docker Hub.mhtml'

        ;  $vElement = @ScriptDir & '\Samples\Affecto.Configuration.Extensions 2.0.0 on NuGet - Libraries.io.mhtml'
        ;  $vElement = @ScriptDir & '\Samples\daixianceng_yii2-echarts - Packagist.mhtml'
        ; $vElement = @ScriptDir & '\Samples\GitHub - daixianceng_yii2-echarts_ ECharts widget for Yii2..mhtml'
        $sParentDir = _FZ_Name($vElement, $eFZN_FileParentDir) & '\'
        ; $bMove = False
    EndIf


    _Log('Starting')

    Local $aGitNames

    If Not FileExists($vElement) Then ExitBox('File Not Exists: ' & $vElement)

    Local $sFileNameFull = _FZ_Name($vElement, $eFZN_FilenameFull)
    Local $sFileNameNoExt = _FZ_Name($vElement, $eFZN_FilenameNoExt)
    Local $sFileExt = _FZ_Name($vElement, $eFZN_Extension)

    _Log($vElement, '$vElement')

    $sLnkUrl = ''
    $sGitUrl = ''
    $sTargetDir = ''


    Switch True

        Case ($sFileExt = '.mhtml' And $bMhtml = True)

            $sLnkUrl = __IS_GetMHTLocation($vElement)
            $sTargetDir = $sParentDir
            __CP_PasteLNK($sLnkUrl)


        Case StringInStr ($sFileNameNoExt, 'Docker Hub') > 0
            $iType = $iType_Docker
            $aGitNames = __MO_DockerArray($vElement)
            If Not IsArray($aGitNames) Then Return False

            _Log($aGitNames, '$aGitNames')

            $sTargetDir = $sParentDir & $aGitNames[0]
            $sLnkUrl = 'https://hub.docker.com/r/'&$aGitNames[1]

            $sGitUrl = $aGitNames[2]



        Case StringInStr ($sFileNameNoExt, 'Packagist') > 0
            $iType = $iType_Package
            $aGitNames = __MO_PackagistArray($vElement)
            If Not IsArray($aGitNames) Then Return False

            $sTargetDir = $sParentDir & $aGitNames[0]
            $sLnkUrl = 'https://packagist.org/packages/'&$aGitNames[1]

            $sGitUrl = $aGitNames[2]




            ; BK: Exchange

        Case StringInStr ($sFileNameNoExt, 'Exchange ') > 0
            $iType = $iType_CryptoCompare

            Local $sText	=	_FZ_FileRead($vElement)

            $sText = StringReplace($sText, '=' & @CRLF , '')
            $sText = StringReplace($sText, '3D' , '')



            ;	Starting

            $aWebsite = StringRegExp($sText, '(?is)Website.*?em.text"><a href="((?!https://twitter.com).*?)"', $STR_REGEXPARRAYMATCH)
            _Log('$aWebsite')

            If Not IsArray($aWebsite) Then Return False


            $aDomain = StringRegExp($aWebsite[0], 'https?://(www.)?([\w-_\.]*)/?' , $STR_REGEXPARRAYMATCH)
            _Log('$aDomain')



            ;	Processing

            $sDomain = $aDomain[1]
            $sDomain = _StringTitleCase($sDomain)

            $sTargetDir = $sParentDir & $sDomain
            DirCreate($sTargetDir)

            __CP_PasteLNK($aWebsite[0])
            __CP_PasteLNK('https://www.google.com/search?q=' & $aDomain[1] & '+reviews+scam')



            ;	Additional Name

            $aName = StringRegExp($sText, '(?i)https://www.cryptocompare.com/exchanges/(.*?)/overview', $STR_REGEXPARRAYMATCH)
            _Log('$aName')


            __CP_PasteLNK('https://www.cryptocompare.com/exchanges/'&$aName[0]&'/reviews')
            __CP_PasteLNK('https://www.cryptocompare.com/exchanges/'&$aName[0]&'/forum')
            __CP_PasteLNK('https://www.cryptocompare.com/exchanges/'&$aName[0]&'/influence')
            __CP_PasteLNK('https://www.cryptocompare.com/exchanges/'&$aName[0]&'/trades')



            ;	Full URL Address

            $aURL = StringRegExp($sText, '(?i)Content-Location: (https?://.*)', $STR_REGEXPARRAYMATCH)
            _Log('$aURL')

            $sLnkUrl = $aURL[0]




            ;	aTwitter

            $aTwitter = StringRegExp($sText, '(?i)href="(https://twitter.com/.*?)"', $STR_REGEXPARRAYMATCH)
            _Log('$aTwitter')

            __CP_PasteLNK($aTwitter[0])



            ;	aCountry

            $aCountry = StringRegExp($sText, '(?is)Country.*?em.text">(.*?)</div>', $STR_REGEXPARRAYMATCH)
            _Log('$aCountry')
            _CP_PasteTXT('Country - ' & $aCountry[0] )



            $aReview = StringRegExp($sText, '(?i)(\d*?)</span> user reviews?', $STR_REGEXPARRAYMATCH)
            _Log('$aReview')
            _CP_PasteTXT('Reviews - ' & $aReview[0]  & ' Count')


            $aRating = StringRegExp($sText, '(?i)<span itemprop="ratingValue" class="ng-binding">([\d.]*?)</span>', $STR_REGEXPARRAYMATCH)
            _Log('$aRating')
            _CP_PasteTXT('Ratings - ' & $aRating[0] & ' AVG' )


            $aCoins = StringRegExp($sText, '(?is)coins-total.*?(\d*)</span>.*?<span class="ng-binding">(\w*?)\*?</span>', $STR_REGEXPARRAYMATCH)
            _Log('$aCoins')

            _CP_PasteTXT('Coiners - ' & $aCoins[0] & ' ' & $aCoins[1] & ' Pairs' )


            $aFollow = StringRegExp($sText, '(?is)Total followers for this.*?(\d*)</div>', $STR_REGEXPARRAYMATCH)
            _Log('$aFollow')

            _CP_PasteTXT('Follows - ' & $aFollow[0] & ' Count' )









        Case StringInStr ($sFileNameNoExt, 'NuGet Gallery') > 0
            $iType = $iType_Nuget
            $aGitNames = __MO_NugetArray($vElement)
            If Not IsArray($aGitNames) Then Return False

            $sTargetDir = $sParentDir & $aGitNames[0]
            $sLnkUrl = 'https://nuget.org/packages/'&$aGitNames[0]

            $sGitUrl = $aGitNames[1]


        Case StringInStr ($sFileNameNoExt, 'Libraries.io') > 0
            $iType = $iType_Library
            $aGitNames = __MO_LibrariesArray($vElement)
            If Not IsArray($aGitNames) Then Return False

            $sTargetDir = $sParentDir & $aGitNames[0]
            $sLnkUrl = 'https://libraries.io/nuget/'&$aGitNames[0]&'/'
            $sLnkUrlTwo = 'https://nuget.org/packages/'&$aGitNames[0]&'/'

            DirCreate($sTargetDir)
            __CP_PasteLNK($sLnkUrl)
            __CP_PasteLNK($sLnkUrlTwo)

            $sGitUrl = $aGitNames[1]

            ; BK: GitHub

        Case StringInStr ($sFileNameNoExt, 'GitHub') > 0

            $iType = $iType_Github

            $aGitNames = __MO_GithubArray($sFileNameNoExt)
            If Not IsArray($aGitNames) Then Return False

            $sTargetDir = $sParentDir & $aGitNames[0]

            $sLnkUrl = $aGitNames[1]
            $sGitUrl = $sLnkUrl


        Case Else
            $iType = $iType_Github

            $aGitNames = __MO_GithubArray($sFileNameNoExt)
            If Not IsArray($aGitNames) Then Return False

            $sTargetDir = $sParentDir & $aGitNames[0]

            $sLnkUrl = $aGitNames[1]
            $sGitUrl = $sLnkUrl



    EndSwitch

#cs



#ce


    If Not ($iType = $iType_Github And $bClone And Not $bMhtml) Then
        ;	Moving Main File

        DirCreate($sTargetDir)

        $sMOG_DestFile = $sTargetDir & '\' & $sFileNameFull

        _Log($sMOG_DestFile,'sMOG_DestFile')

        If $bMove Then
            If Not FileMove($vElement, $sMOG_DestFile, 1+8) Then ExitBox('Cannot Move File: ' & $vElement & ' to: ' & $sMOG_DestFile)
        EndIf

        __CP_PasteLNK($sLnkUrl)
    EndIf



    If $sGitUrl <> '' Then

        If $bClone Then

            ; BK: bClone
            If $iType = $iType_Github Then
                FileChangeDir($sParentDir)
            Else
                __CP_PasteLNK($sGitUrl)
                FileChangeDir($sTargetDir)
            EndIf

            __GitClone($sGitUrl)
        EndIf
    EndIf




EndFunc   ;==>_MO_ProcessItem




Func __IS_GetMHTLocation($sFullPath)

    Local $sText	=	_FZ_FileRead($sFullPath)

    ;  $sText = 'Content-Location: http://autoit-script.ru/index.php?topic=8796.0'
    $sFuncPattern = 'Content\-Location\: +(.*)'

    $aRes = StringRegExp($sText, $sFuncPattern , 3)

    If @error Then ExitBox('StringRegExp Error')

    _Log($aRes, '$aRes')

    Return $aRes[0]
EndFunc   ;==>__IS_GetMHTLocation


#cs | TESTING | =============================================

	Name				T_MO_ProcessGithub

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_MO_ProcessGithub()

    _Log("_MO_ProcessGithub()")

EndFunc   ;==>T_MO_ProcessGithub




#cs | INTERNAL FUNCTION | ===================================

	Name				__MO_CloseNpp

	Author				Asror Zakirov (aka Asror.Z)
	Created				11.03.2016

#ce	=========================================================

Func __MO_CloseNpp()

    ProcessClose('Notepad++.exe')
    WinWaitClose("[CLASS:Notepad++]")

EndFunc   ;==>__MO_CloseNpp




#cs | FUNCTION | ============================================

	Name				__CP_PasteLNK

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.03.2016

#ce	=========================================================


Func __CP_PasteLNK($sCLipContent)

    If $sCLipContent <> '' Then


        $sHostName =	__CP_GetHostNameFromURL($sCLipContent)

        $sHostName = StringLeft($sHostName, 70)

        Local $sFilePath = $sTargetDir & '\' & $sHostName &'.url'
        _Log('$sCP_ParentDir')

        $sSampleLnk = '[{000214A0-0000-0000-C000-000000000046}]' & @CRLF & _
                'Prop3=19,11' & @CRLF & _
                '[InternetShortcut]' & @CRLF & _
                'IDList=' & @CRLF & _
                'URL=_URL_' & @CRLF & _
                'IconIndex=13' & @CRLF & _
                'HotKey=0' & @CRLF & _
                'IconFile=C:\Windows\System32\SHELL32.dll'


        $sRelease = StringReplace($sSampleLnk, '_URL_', $sCLipContent)

        _FZ_Delete($sFilePath)
        _FZ_FileWrite($sFilePath, $sRelease)

    EndIf
EndFunc   ;==>__CP_PasteLNK







#cs | FUNCTION | ============================================

	Name				_CP_PasteTXT
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.07.2018

#ce	=========================================================
Func _CP_PasteTXT($sContent)

    Local $sFilePath = $sTargetDir & '\' & $sContent &'.txt'

    If Not FileExists($sFilePath) Then _FZ_FileWrite($sFilePath, '')

EndFunc   ;==>_CP_PasteTXT



#cs | FUNCTION | ============================================

	Name				__CP_GetHostNameFromURL

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016

#ce	=========================================================

Func __CP_GetHostNameFromURL($sURL = '')

    ; $sURL = 'https://megasoft.uzadad/adad/system/filemanagers/'

    If $sURL = '' Then
        $sURL = 'https://gabegasm.usitech-int.com/#aboutDistributor'
    EndIf

    $sURL = StringReplace($sURL, 'www.', '')
    $sURL = StringReplace($sURL, 'exchanges/', '')
    $sURL = StringReplace($sURL, 'search?q=', '')


    $aRes = StringRegExp($sURL, 'https?://([\w-_\.]*)(/.*)?' , 3)

    _Log($sURL, '$sURL')
    _Log($aRes, '$aRes')

    If @error Then Return SetError(1, @extended, 'Readme')

    $sLinkURL = $aRes[0]
    $sLinkURLAdd = $aRes[1]
    $sLinkURLAdd = StringReplace($sLinkURLAdd, '/', ' ')
    $sLinkURLAdd = StringReplace($sLinkURLAdd, '\', ' ')
    $sLinkURLAdd = StringReplace($sLinkURLAdd, '?', ' ')
    $sLinkURLAdd = StringReplace($sLinkURLAdd, ':', ' ')

    $sLinkURL &= $sLinkURLAdd

    _Log($sLinkURL)
    $sLinkURL = StringStripWS($sLinkURL,   $STR_STRIPTRAILING)

    _Log($sLinkURL)
    $sLinkURL = _StringTitleCase($sLinkURL)
    Return $sLinkURL

EndFunc   ;==>__CP_GetHostNameFromURL





