#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\TC.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\MHTML.au3>
#include <MyUDFs\Log.au3>
#include-once
#RequireAdmin

Global $UDFName = 'Composer.au3'


#cs | INDEX | ===============================================

	Title				Composer.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				7/25/2016

#ce	=========================================================

#Region Example

    If @ScriptName = $UDFName Then


        Global $sFullPath = @ScriptDir & '\- Theory/okneloper_forms - Packagist.mhtml'
        Global $sFullPath = @ScriptDir & '\- Theory/openpp_push-notification-bundle - Packagist.mhtml'


    EndIf

#EndRegion Example


#cs | CURRENT | =============================================

	_MO_Help()
	_MO_Composer()

#ce	=========================================================



#cs | CURRENT | =============================================

	_MO_Help()
	_MO_Composer()

#ce	=========================================================


#Region Compile

    #pragma compile(ExecLevel, none)
    #pragma compile(Compatibility, win7)

#EndRegion Compile


If $CmdLine[0] > 1 Then

    Local $iFilesLength = UBound($CmdLine) - 1
    Local $aArray[$iFilesLength - 1], $iCounter = 0

    For $i = $iFilesLength To 2 Step -1
        $aArray[$iCounter] = $CmdLine[$i]
        $iCounter += 1
    Next

    $sParentDir = _FZ_Name($CmdLine[2], $eFZN_FileParentDir)
    ;  $s_TC_GetFocusItem	= _TC_ListB_GetFocus()

    Switch $CmdLine[1]


        #Region CmdLine

            Case 'Q'
                _MO_Move()

            Case 'W'
                _MO_Composer()

            #EndRegion CmdLine

    EndSwitch

    ;_TC_ListB_SetFocus($s_TC_GetFocusItem)

    Exit
Else

    ; 	_MO_Help()
EndIf



#cs | FUNCTION | ============================================

	Name				_MO_Help
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func _MO_Help()

    $sHelpStr = 'Alt+Q- Composer'
    MsgBox($MB_OK + $MB_DEFBUTTON1, 'Warning !', $sHelpStr)

EndFunc   ;==>_MO_Help


#cs | TESTING | =============================================

	Name				T_MO_Help

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MO_Help()

    _Log("_MO_Help()")

EndFunc   ;==>T_MO_Help




#cs | FUNCTION | ============================================

	Name				_MO_Composer
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================



Func _MO_RunCmd($sFullPath)

    If _MHT_CheckExt($sFullPath) Then

        $sFileName = _FZ_Name($sFullPath, $eFZN_FilenameFull)

        $sPackageFolder = _MHT_Get_PackageFolder($sFullPath)
        $sPackageRequire = _MHT_Get_PackageRequire($sFullPath)
        $sPackageRequire = StringLower($sPackageRequire)

        $sRunParentDir = _FZ_Name($sFullPath, $eFZN_FileParentDir)

        $sComposerJsonSource	=	@ScriptDir & '\composer.json'
        $sComposerJsonDest	=	$sRunParentDir & '\composer.json'
        FileCopy($sComposerJsonSource, $sComposerJsonDest)
        
        FileChangeDir($sRunParentDir)
        $sCmdRequire 	 = 	'/k composer require "' & $sPackageRequire & '" "*"'
        ShellExecute('cmd.exe', $sCmdRequire)
        
		#cs

			$sCmdRequire 	 = 	'composer require "' & $sPackageRequire & '" "*"'

			$sCmdRequireExec = 	$sRunParentDir & '\composer require.cmd'
			_FZ_FileWrite($sCmdRequireExec, $sCmdRequire)

			ShellExecute($sCmdRequireExec)


		#ce







    Else
        _Log('Nothingf')
    EndIf

EndFunc   ;==>_MO_RunCmd






Func _MO_Composer()

    If MsgBox(52, "Warning", 'Composer Execute') = 6 Then

        For $sFullPath In $aArray

            If _MHT_CheckExt($sFullPath) Then
                _MO_RunCmd($sFullPath)
            Else
                _Log('Nothingf')
            EndIf

        Next
    EndIf

EndFunc   ;==>_MO_Composer




Func _MO_Move()

    If MsgBox(52, "Warning", 'Composer Move') = 6 Then

        For $sFullPath In $aArray

            If _MHT_CheckExt($sFullPath) Then
                
                Mbox($sParentDir)
                
                $sFileName = _FZ_Name($sFullPath, $eFZN_FilenameFull)

                $sPackageFolder = _MHT_Get_PackageFolder($sFullPath)
                $sPackageRequire = _MHT_Get_PackageRequire($sFullPath)

                $sDestFolder = $sParentDir & '\' & $sPackageFolder
                $sDestFileLocation = $sDestFolder & '\' & $sFileName

                DirCreate($sDestFolder)
                FileMove($sFullPath, $sDestFileLocation)

                _MO_RunCmd($sDestFileLocation)

            Else
                _Log('Nothingf')
            EndIf



        Next
    EndIf

EndFunc   ;==>_MO_Move



#cs | TESTING | =============================================

	Name				T_MO_Composer

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MO_Composer()

    _Log("_MO_Composer()")

EndFunc   ;==>T_MO_Composer

