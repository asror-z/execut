#include-once
#include <MyUDFs\Log.au3>


Global $UDFName = 'ShellAll.au3'


#cs | INDEX | ===============================================

	Title				_ShellAll.au3
	Description			Create an entry in the shell contextmenu when selecting a file and folder, includes the program icon as well.

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/18/2016

#ce	=========================================================



#cs | CURRENT | =============================================

	_ShellAll_Install($sText, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)
	_ShellAll_Uninstall($sName = @ScriptName, $fAllUsers = False)

#ce	=========================================================

#Region Example

	If @ScriptName = $UDFName Then 

		T_ShellAll_Install()
		T_ShellAll_Uninstall()

	EndIf                          

#EndRegion Example; None




#cs | FUNCTION | ============================================

	Name            _ShellAll_Install
	Description     Creates an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu, but only displays when selecting a file and folder 
	                 $iIcon = 0[, $fAllUsers = False[, $fExtended = False]]]]]])

	Parameters      $sText               - Text to be shown in the contextmenu 
	                 $sName               - [optional] Name of the program  Default is @ScriptName 
	                 $sFilePath           - [optional] Location of the program executable. Default is @ScriptFullPath.
	                 $sIconPath           - [optional] Location of the icon e.g. program executable or dll file. Default is @ScriptFullPath.
	                 $iIcon               - [optional] Index of icon to be used. Default is 0.
	                 $fAllUsers           - [optional] Add to Current Users (False) or All Users (True) Default is False.
	                 $fExtended           - [optional] Show in the Extended contextmenu using Shift + Right click. Default is False.

	Return values   Success - RegWrite() Return code 
	                 Failure - none

#ce	=========================================================

Func _ShellAll_Install($sText, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)
	

	Local $aArray[3] = [2, '*', 'Directory'], $i64Bit = ''

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
	For $i = 1 To $aArray[0]
		If $fAllUsers Then
			$aArray[$i] = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\' & $aArray[$i] & '\shell\'
		Else
			$aArray[$i] = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\' & $aArray[$i] & '\shell\'
		EndIf
	Next

	$sName = StringRegExpReplace($sName, '\.[^\.\\/]*$', '')
	If StringStripWS($sName, 8) = '' Or FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	_ShellAll_Uninstall($sName, $fAllUsers)

	For $i = 1 To $aArray[0]
		RegWrite($aArray[$i] & $sName, '', 'REG_SZ', $sText)
		RegWrite($aArray[$i] & $sName, 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
		RegWrite($aArray[$i] & $sName & '\command', '', 'REG_SZ', '"' & $sFilePath & '" "%1"')
		If $fExtended Then
			RegWrite($aArray[$i], 'Extended', 'REG_SZ', '')
		EndIf
	Next

	Return SetError(@error, 0, @error)

EndFunc


#cs | TESTING | =============================================

	Name				T_ShellAll_Install

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/18/2016

#ce	=========================================================

Func T_ShellAll_Install()

	_Log('_ShellAll_Install($sText, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)')

EndFunc   ;==>_ShellAll_Install




#cs | FUNCTION | ============================================

	Name            _ShellAll_Uninstall
	Description     Deletes an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu 

	Parameters      $sName               - [optional] Name of the Program  Default is @ScriptName 
	                 $fAllUsers           - [optional] Was it added to Current Users (False) or All Users (True) Default is False.

	Return values   Success - Returns 2D Array of registry entries 
	                 Failure - Returns 0 and sets @error to non-zero.

#ce	=========================================================

Func _ShellAll_Uninstall($sName = @ScriptName, $fAllUsers = False)
	

	Local $aArray[3] = [2, '*', 'Directory'], $i64Bit = ''

	If $sName = Default Then
		$sName = @ScriptName
	EndIf
	If @OSArch = 'X64' Then
		$i64Bit = '64'
	EndIf
	For $i = 1 To $aArray[0]
		If $fAllUsers Then
			$aArray[$i] = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\' & $aArray[$i] & '\shell\'
		Else
			$aArray[$i] = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\' & $aArray[$i] & '\shell\'
		EndIf
	Next

	$sName = StringRegExpReplace($sName, '\.[^\.\\/]*$', '')
	If StringStripWS($sName, 8) = '' Then
		Return SetError(1, 0, 0)
	EndIf

	Local $aFinal[1][5] = [[0, 5]], $aReturn = 0, $sDelete = ''
	For $i = 1 To $aArray[0]
		$aReturn = __ShellAll_RegistryGet($aArray[$i])

		If $aReturn[0][0] > 0 Then
			For $j = 1 To $aReturn[0][0]
				If $aReturn[$j][0] = $sName And $sDelete <> $aReturn[$j][1] Then
					$sDelete = $aReturn[$j][1]
					RegDelete($sDelete)
				EndIf
			Next

			ReDim $aFinal[$aFinal[0][0] + $aReturn[0][0] + 1][$aReturn[0][1]]
			For $j = 1 To $aReturn[0][0]
				$aFinal[0][0] += 1
				For $k = 0 To $aReturn[0][1] - 1
					$aFinal[$aFinal[0][0]][$k] = $aReturn[$j][$k]
				Next
			Next
			$aFinal[0][1] = $aReturn[0][1]
		EndIf
	Next

	Return $aFinal

EndFunc


#cs | TESTING | =============================================

	Name				T_ShellAll_Uninstall

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/18/2016

#ce	=========================================================

Func T_ShellAll_Uninstall()

	_Log('_ShellAll_Uninstall($sName = @ScriptName, $fAllUsers = False)')

EndFunc   ;==>_ShellAll_Uninstall
; #INTERNAL_USE_ONLY#============================================================================================================




#cs | INTERNAL FUNCTION | ===================================

	Name				__ShellAll_RegistryGet
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/18/2016

#ce	=========================================================

Func __ShellAll_RegistryGet($sRegistryKey)
	

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
				$iDimension = ($aArray[0][0] + 1) * 2
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

EndFunc   ;==>__ShellAll_RegistryGet

