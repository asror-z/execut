#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\IniToArray.au3>
#include <MyUDFs\TC.au3>

#pragma compile(Out, c:\AsrorZ\TCU\ItemSearch.exe)



#Region Declaration

    Global Enum $eS_Google, _
            $eS_Assets, _
            $eS_Cracker, _
            $eS_Software, _
            $eS_AutoIt, _
            $eS_PHP, _
            $eS_R, _
            $eS_Develop

    Global 	$Google[10], _
            $Cracker[10], _
            $Software[10], _
            $AutoIt[10], _
            $Assets[10], _
            $PHP[10], _
            $Coiner[10], _
            $Develop[10]

    Global 	$sIniFile	=	@ScriptDir & '\Search.ini'

    Global 	$aSection

#EndRegion Declaration



#Region Compile

    #pragma compile(ExecLevel, none)
    #pragma compile(Compatibility, win7)

#EndRegion Compile


; _ArrayDisplay($CmdLine)


If $CmdLine[0] > 1 Then

    $sParentDir = _FZ_Name($CmdLine[2], $eFZN_ParentDir)

    $s_TC_GetFocusItem	= _TC_ListB_GetFocus()

    #Region Cmd Switch

        Switch $CmdLine[1]

            Case 'G'
                _IS_Search($eS_Google)

            Case 'S'
                _IS_Search($eS_Software)

            Case 'C'
                _IS_Search($eS_Cracker)

            Case 'R'
                _IS_Search($eS_Assets)

            Case 'U'
                _IS_Search($eS_AutoIt)

            Case 'X'
				_IS_Search($eS_Develop)

            Case 'M'
                _IS_GoMHT()


        EndSwitch

    #EndRegion Cmd Switch

    _TC_ListB_SetFocus($s_TC_GetFocusItem)

    Exit
Else
    ; ShellExecute(@ScriptFullPath, 'M "d:\Develop\System\AutoIT\Element\Automat\TC\ItemSearch\okneloper_forms - Packagist.mhtml"')

    ; _IS_Help()
EndIf




#Region Func | Search

    Func _IS_Search($sSystem = $eS_Google)

        Switch $sSystem

            Case $eS_Google
                _IniToArray($sIniFile, "Google")
                $aSection	=	$Google

            Case $eS_Develop
                _IniToArray($sIniFile, "Develop")
                $aSection	=	$Develop

            Case $eS_AutoIt
                _IniToArray($sIniFile, "AutoIt")
                $aSection	=	$AutoIt

            Case $eS_Cracker
                _IniToArray($sIniFile, "Cracker")
                $aSection	=	$Cracker
				
            Case $eS_Assets
                _IniToArray($sIniFile, "Assets")
                $aSection	=	$Assets
	
            Case $eS_R
                _IniToArray($sIniFile, "Coiner")
                $aSection	=	$Coiner

            Case $eS_Software
                _IniToArray($sIniFile, "Software")
                $aSection	=	$Software

            Case $eS_PHP
                _IniToArray($sIniFile, "PHP")
                $aSection	=	$PHP
        EndSwitch

        ;  _ArrayDisplay($aSection)

        For $i = 2 To UBound($CmdLine) - 1
            __IS_Execute_Search($CmdLine[$i], $sSystem)
        Next



    EndFunc   ;==>_IS_Search






    Func __IS_Execute_Search($sItem, $sSystem)


        If Not _FZ_Check($sItem, $eFZC_IsDirectory) Then
            $sFileNameNoExt = _FZ_Name($sItem, $eFZN_FilenameNoExt)
        Else
            $sFileNameNoExt = _FZ_Name($sItem, $eFZN_FilenameFull)
        EndIf

		
		If $sSystem = $eS_Assets Then
		;	$sFileNameNoExt = StringReplace($sFileNameNoExt, '.', ' ')
		EndIf	
		
        For $i = 0 To UBound($aSection) - 1

			
		
            $sSearchURL		=	StringReplace($aSection[$i], '%s', $sFileNameNoExt)

            If StringInStr($sSearchURL, 'google.com') > 0 Then Sleep(500)

            ShellExecute($sSearchURL, '', '', '', @SW_HIDE)

        Next


    EndFunc   ;==>__IS_Execute_Search








    Func _IS_GoMHT()

        Local $sFileContent, $aRes


        For $i = 2 To UBound($CmdLine) - 1
            __IS_Execute_MHT_Adress($CmdLine[$i])
        Next

        ; _ArrayDisplay($CmdLine)
    EndFunc   ;==>_IS_GoMHT





    Func __IS_Execute_MHT_Adress($sMHTFileName)

        $bIsMHT	=	_FZ_Name($sMHTFileName, $eFZN_Extension) = '.mht'
        $bIsMHTML	=	_FZ_Name($sMHTFileName, $eFZN_Extension) = '.mhtml'

        If $bIsMHT Or $bIsMHTML Then

            Local $sRes	=	__IS_GetMHTLocation($sMHTFileName)
            ; _ArrayDisplay($aRes, "флаг=3")

            If  $sRes <> '' Then	ShellExecute($sRes)

        EndIf

    EndFunc   ;==>__IS_Execute_MHT_Adress



    Func __IS_GetMHTLocation($sFullPath)

        Local $sText	=	_FZ_FileRead($sFullPath)

        ;  $sText = 'Content-Location: http://autoit-script.ru/index.php?topic=8796.0'
        $sFuncPattern = 'Content\-Location\: +(.*)'

        $aRes = StringRegExp($sText, $sFuncPattern , 3)

        If @error Then ExitBox('StringRegExp Error')

        _Log($aRes, '$aRes')

        Return $aRes[0]
    EndFunc   ;==>__IS_GetMHTLocation


#EndRegion Func | Search





Func _IS_Help ()

    $sHelpStr = 'Alt+G - Google'
    $sHelpStr &= @CRLF &  'Alt+S - Software'
    $sHelpStr &= @CRLF &  'Alt+C - Soft With Crack'
    $sHelpStr &= @CRLF &  'Alt+M - GoMHTAdress()'

    MsgBox($MB_OK + $MB_DEFBUTTON1, 'Warning !', $sHelpStr)

EndFunc   ;==>_IS_Help

