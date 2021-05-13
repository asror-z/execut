#include-once
#include <MyUDFs\FileZ.au3>

Global $UDFName = 'ShellFolder'



#cs | INDEX | ===============================================

	Title				ShellFolder
	Description	 		Create an entry in the shell contextmenu when selecting a folder, includes the program icon as well.

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				15.02.2016

#ce	=========================================================




#cs | CURRENT | =============================================

	_SF_Install
	_SF_Uninstall
	_SF_UninstallByName

#ce	=========================================================


#cs | CURRENT | =============================================

	$eFZA_Normal, _
	$eFZA_Hidden, _
	$eFZA_System, _
	$eFZA_ReadOnly, _
	$eFZA_Hidden_System_RO, _
	$eFZA_ClearAll

	$eFZN_Drive, _
	$eFZN_FilenameFull, _
	$eFZN_FilenameNoExt, _
	$eFZN_Extension, _
	$eFZN_ParentDir, _
	$eFZN_FileNameIncrement, _
	$eFZN_AppProgramFilesDir

	$eFZC_IsDirectory, _
	$eFZC_SizeIs1MB, _
	$eFZC_SizeIs10MB

	_FZ_Attr
	_FZ_Delete
	_FZ_Copy
	_FZ_FileRead
	_FZ_FileWrite
	_FZ_Check
	_FZ_IsExist
	_FZ_Name
	_FZ_Replace
	_FZ_Rename
	_FZ_Search
	_FZ_SearchRec

	Mbox
	ExitBox
	_Log

#ce	=========================================================



#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

		T_SF_Install()

    EndIf

#EndRegion Example





#cs | TESTING | =============================================

	Name				T_SF_Install
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_SF_Install()

    _SF_Install('open In FS', @ScriptFullPath)
	Sleep(2000)
    _SF_Uninstall(@ScriptFullPath)

    If Ubound($CmdLine) > 1 Then _Log('$CmdLine')

EndFunc   ;==>T_SF_Install

#cs | FUNCTION | ============================================

	Name				_SF_Install

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _SF_Install ($sDescription, $sExeFullPath)
    
    
    Local $sExtension =	_FZ_Name($sExeFullPath, $eFZN_Extension)

    If $sExtension <> '.exe' Then ExitBox ('You can add only EXE files to folder shell !')

    _SF_Uninstall($sExeFullPath)

    Local $sFileName	=	_FZ_Name($sExeFullPath, $eFZN_FilenameFull)

    _SF_Install_Ex($sDescription, $sFileName, $sExeFullPath, $sExeFullPath, 0)
    _SF_Install_Ex($sDescription, $sFileName, $sExeFullPath, $sExeFullPath, 0, True)

EndFunc   ;==>_SF_Install






#cs | FUNCTION | ============================================

	Name				_SF_Uninstall

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _SF_Uninstall ($sExeFullPath)

    $sFileName	=	_FZ_Name($sExeFullPath, $eFZN_FilenameFull)
    _SF_UninstallByName($sFileName)

EndFunc   ;==>_SF_Uninstall





#cs | FUNCTION | ============================================

	Name				_SF_UninstallByName

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.02.2016

#ce	=========================================================

Func _SF_UninstallByName ($sFileName)

    _SF_Uninstall_Ex($sFileName)
    _SF_Uninstall_Ex($sFileName, True)

EndFunc   ;==>_SF_UninstallByName






#cs | FUNCTION | ============================================

	Name				_SF_Install_Ex

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================


Func _SF_Install_Ex($sText, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)

    Local $i64Bit = '', $sRegistryKey = ''

    If $iIcon = Default Then
        $iIcon = 0
    EndIf
    If $sFilePath = Default Then
        $sFilePath = @ScriptFullPath
    EndIf
    If $sIconPath = Default Then
        $sIconPath = @ScriptFullPath
    EndIf
    If $sName = Default Then
        $sName = @ScriptName
    EndIf
    If @OSArch = 'X64' Then
        $i64Bit = '64'
    EndIf
    If $fAllUsers Then
        $sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\Folder\shell\'
    Else
        $sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\Folder\shell\'
    EndIf

    $sName = StringLower(StringRegExpReplace($sName, '\.[^\.\\/]*$', ''))
    If StringStripWS($sName, 8) = '' Or FileExists($sFilePath) = 0 Then
        Return SetError(1, 0, False)
    EndIf

    _SF_Uninstall_Ex($sName, $fAllUsers)

    Local $iReturn = 0
    $iReturn += RegWrite($sRegistryKey & $sName, '', 'REG_SZ', $sText)
    $iReturn += RegWrite($sRegistryKey & $sName, 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
    $iReturn += RegWrite($sRegistryKey & $sName & '\command', '', 'REG_SZ', '"' & $sFilePath & '" "%L"')
    If $fExtended Then
        $iReturn += RegWrite($sRegistryKey & $sName, 'Extended', 'REG_SZ', '')
    EndIf
    Return $iReturn > 0
EndFunc   ;==>_SF_Install_Ex





#cs | FUNCTION | ============================================

	Name				_SF_Uninstall_Ex

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _SF_Uninstall_Ex($sName = @ScriptName, $fAllUsers = False)
    Local $i64Bit = '', $sRegistryKey = ''

    If $sName = Default Then
        $sName = @ScriptName
    EndIf
    If @OSArch = 'X64' Then
        $i64Bit = '64'
    EndIf
    If $fAllUsers Then
        $sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\Folder\shell\'
    Else
        $sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\Folder\shell\'
    EndIf

    $sName = StringLower(StringRegExpReplace($sName, '\.[^\.\\/]*$', ''))
    If StringStripWS($sName, 8) = '' Then
        Return SetError(1, 0, 0)
    EndIf

    Local $aReturn = __ShellFolder_RegistryGet($sRegistryKey), $iReturn = 0, $sNameDeleted = ''
    If $aReturn[0][0] Then
        For $i = 1 To $aReturn[0][0]
            If $aReturn[$i][0] = $sName And $sNameDeleted <> $aReturn[$i][1] Then
                $sNameDeleted = $aReturn[$i][1]
                $iReturn += RegDelete($sNameDeleted)
            EndIf
        Next
    EndIf
    $aReturn = 0
    Return $iReturn > 0
EndFunc   ;==>_SF_Uninstall_Ex





#cs | FUNCTION | ============================================

	Name				 __ShellFolder_RegistryGet

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func __ShellFolder_RegistryGet($sRegistryKey)
    Local $aArray[1][5] = [[0, 5]], $iCount_1 = 0, $iCount_2 = 0, $iDimension = 0, $iError = 0, $sRegistryKey_All = '', $sRegistryKey_Main = '', $sRegistryKey_Name = '', _
            $sRegistryKey_Value = ''

    While 1
        If $iError Then
            ExitLoop
        EndIf
        $sRegistryKey_Main = RegEnumKey($sRegistryKey, $iCount_1 + 1)
        If @error Then
            $sRegistryKey_All = $sRegistryKey
            $iError = 1
        Else
            $sRegistryKey_All = $sRegistryKey & $sRegistryKey_Main
        EndIf

        $iCount_2 = 0
        While 1
            $sRegistryKey_Name = RegEnumVal($sRegistryKey_All, $iCount_2 + 1)
            If @error Then
                ExitLoop
            EndIf

            If ($aArray[0][0] + 1) >= $iDimension Then
                $iDimension = Ceiling(($aArray[0][0] + 1) * 1.5)
                ReDim $aArray[$iDimension][$aArray[0][1]]
            EndIf

            $sRegistryKey_Value = RegRead($sRegistryKey_All, $sRegistryKey_Name)
            $aArray[$aArray[0][0] + 1][0] = $sRegistryKey_Main
            $aArray[$aArray[0][0] + 1][1] = $sRegistryKey_All
            $aArray[$aArray[0][0] + 1][2] = $sRegistryKey & $sRegistryKey_Main & '\' & $sRegistryKey_Name
            $aArray[$aArray[0][0] + 1][3] = $sRegistryKey_Name
            $aArray[$aArray[0][0] + 1][4] = $sRegistryKey_Value
            $aArray[0][0] += 1
            $iCount_2 += 1
        WEnd
        $iCount_1 += 1
    WEnd
    ReDim $aArray[$aArray[0][0] + 1][$aArray[0][1]]
    Return $aArray
EndFunc   ;==>__ShellFolder_RegistryGet