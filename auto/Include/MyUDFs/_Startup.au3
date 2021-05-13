#include-once
#include <StringConstants.au3>
#include <MyUDFs\Log.au3>



Global $UDFName = 'Startup.au3'


#cs | INDEX | ===============================================

	Title				Startup.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				01.02.2018

#ce	=========================================================




#Region Variables

	Global Enum $STARTUP_RUN = 0, $STARTUP_RUNONCE, $STARTUP_RUNONCEEX


#EndRegion Variables


#cs | CURRENT | =============================================
	_StartupFolder_Exists($sName = @ScriptName, $bAllUsers = True)
	_StartupFolder_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = True)
	_StartupFolder_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True)
	_StartupRegistry_Exists($sName = @ScriptName, $bAllUsers = True, $iRunOnce = $STARTUP_RUN)
	_StartupRegistry_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = True, $iRunOnce = $STARTUP_RUN)
	_StartupRegistry_InstallUser($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = False, $iRunOnce = $STARTUP_RUN)
	_StartupRegistry_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True, $iRunOnce = $STARTUP_RUN)

#ce	=========================================================

#Region Example

	If @ScriptName = $UDFName Then

	    T_StartupFolder_Exists()
	    T_StartupFolder_Install()
	    T_StartupFolder_Uninstall()
	    T_StartupRegistry_Exists()
	    T_StartupRegistry_Install()
	    T_StartupRegistry_Uninstall()

	EndIf

#EndRegion Example

; #GLOBAL VARIABLES# ============================================================================================================
; #CURRENT# =====================================================================================================================
; _StartupFolder_Exists: Checks if an entry exits in the 'All Users/Current Users' startup folder.
; _StartupFolder_Install: Creates an entry in the 'All Users/Current Users' startup folder.
; _StartupFolder_Uninstall: Deletes an entry in the 'All Users/Current Users' startup folder.
; _StartupRegistry_Exists: Checks if an entry exits in the 'All Users/Current Users' registry.
; _StartupRegistry_Install: Creates an entry in the 'All Users/Current Users' registry.
; _StartupRegistry_Uninstall: Deletes the entry in the 'All Users/Current Users' registry.
; ===============================================================================================================================
; #INTERNAL_USE_ONLY#============================================================================================================
; See below.
; ===============================================================================================================================




#cs | FUNCTION | ============================================

	Name            _StartupFolder_Exists
	Description     Checks if an entry exits in the 'All Users/Current Users' startup folder

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $bAllUsers           - [optional] Add to Current Users (False) or All Users (True) Default is False.

	Return values   Success - True
	                 Failure - False

#ce	=========================================================

Func _StartupFolder_Exists($sName = @ScriptName, $bAllUsers = True)

	Local $sFilePath = Default
	__Startup_Format($sName, $sFilePath)

	Return FileExists(__StartupFolder_Location($bAllUsers) & '\' & $sName & '.lnk')

EndFunc   ;==>_StartupFolder_Exists


#cs | TESTING | =============================================

	Name				T_StartupFolder_Exists

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupFolder_Exists()

	_Log("_StartupFolder_Exists($sName = @ScriptName, $bAllUsers = True)")

EndFunc   ;==>T_StartupFolder_Exists




#cs | FUNCTION | ============================================

	Name            _StartupFolder_Install
	Description     Creates an entry in the 'All Users/Current Users' startup folder
	                 $bAllUsers = True]]]])

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $sFilePath           - [optional] Location of the program executable. Default is @ScriptFullPath.
	                 $sCommandline        - [optional] Commandline arguments to be passed to the application. Default is ''.
	                 $bAllUsers           - [optional] Add to Current Users (False) or All Users (True) Default is False.

	Return values   Success - True
	                 Failure - False & sets @error to non-zero

#ce	=========================================================

Func _StartupFolder_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = True)

	Return __StartupFolder_Uninstall(True, $sName, $sFilePath, $sCommandline, $bAllUsers)

EndFunc   ;==>_StartupFolder_Install


#cs | TESTING | =============================================

	Name				T_StartupFolder_Install

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupFolder_Install()

	_Log("_StartupFolder_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = True)")

EndFunc   ;==>T_StartupFolder_Install




#cs | FUNCTION | ============================================

	Name            _StartupFolder_Uninstall
	Description     Deletes an entry in the 'All Users/Current Users' startup folder

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $sFilePath           - [optional] Location of the program executable. Default is @ScriptFullPath.
	                 $bAllUsers           - [optional] Was it added to Current Users (False) or All Users (True) Default is False.

	Return values   Success - True
	                 Failure - False & sets @error to non-zero

#ce	=========================================================

Func _StartupFolder_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True)

	Return __StartupFolder_Uninstall(False, $sName, $sFilePath, Default, $bAllUsers)

EndFunc   ;==>_StartupFolder_Uninstall


#cs | TESTING | =============================================

	Name				T_StartupFolder_Uninstall

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupFolder_Uninstall()

	_Log("_StartupFolder_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True)")

EndFunc   ;==>T_StartupFolder_Uninstall




#cs | FUNCTION | ============================================

	Name            _StartupRegistry_Exists
	Description    Checks if an entry exits in the 'All Users/Current Users' registry

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $bAllUsers           - [optional] Add to Current Users (False) or All Users (True) Default is False.
	                 $iRunOnce            - [optional] Always run at system startup $STARTUP_RUN (0), run only once before explorer is started $STARTUP_RUNONCE (1)
											  or run only once after explorer is started $STARTUP_RUNONCEEX (2). Default is $STARTUP_RUN (0).

	Return values   Success - True
	                 Failure - False

#ce	=========================================================

Func _StartupRegistry_Exists($sName = @ScriptName, $bAllUsers = True, $iRunOnce = $STARTUP_RUN)

	Local $sFilePath = Default
	__Startup_Format($sName, $sFilePath)
	RegRead(__StartupRegistry_Location($bAllUsers, $iRunOnce) & '\', $sName)

	Return @error = 0

EndFunc   ;==>_StartupRegistry_Exists


#cs | TESTING | =============================================

	Name				T_StartupRegistry_Exists

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupRegistry_Exists()

	$a = __StartupRegistry_Location(True, '')
	_Log($a)

EndFunc   ;==>T_StartupRegistry_Exists




#cs | FUNCTION | ============================================

	Name            _StartupRegistry_Install
	Description     Creates an entry in the 'All Users/Current Users' registry
	                 $bAllUsers = True[, $iRunOnce = $STARTUP_RUN]]]]])

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $sFilePath           - [optional] Location of the program executable. Default is @ScriptFullPath.
	                 $sCommandline        - [optional] Commandline arguments to be passed to the application. Default is ''.
	                 $bAllUsers           - [optional] Add to Current Users (False) or All Users (True) Default is False.
	                 $iRunOnce            - [optional] Always run at system startup $STARTUP_RUN (0), run only once before explorer is started $STARTUP_RUNONCE (1)
											  or run only once after explorer is started $STARTUP_RUNONCEEX (2). Default is $STARTUP_RUN (0).

	Return values   Success - True
	                 Failure - False & sets @error to non-zero

#ce	=========================================================

Func _StartupRegistry_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = True, $iRunOnce = $STARTUP_RUN)

	Return __StartupRegistry_Uninstall(True, $sName, $sFilePath, $sCommandline, $bAllUsers, $iRunOnce)

EndFunc   ;==>_StartupRegistry_Install




#cs | FUNCTION | ============================================

	Name				_StartupRegistry_InstallUser
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func _StartupRegistry_InstallUser($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = False, $iRunOnce = $STARTUP_RUN)

	Return __StartupRegistry_Uninstall(True, $sName, $sFilePath, $sCommandline, $bAllUsers, $iRunOnce)

EndFunc


#cs | TESTING | =============================================

	Name				T_StartupRegistry_InstallUser

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupRegistry_InstallUser()

	_Log("_StartupRegistry_InstallUser($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sCommandline = '', $bAllUsers = False, $iRunOnce = $STARTUP_RUN)")

EndFunc   ;==>_StartupRegistry_Install


#cs | TESTING | =============================================

	Name				T_StartupRegistry_Install

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupRegistry_Install()

	$sRet = _StartupRegistry_Install(@ScriptName, @ScriptFullPath, '', False)
	_Log($sRet)

EndFunc   ;==>T_StartupRegistry_Install




#cs | FUNCTION | ============================================

	Name            _StartupRegistry_Uninstall
	Description     Deletes the entry in the 'All Users/Current Users' registry
	                 $iRunOnce = Default]]]])

	Parameters      $sName               - [optional] Name of the program  Default is @ScriptName
	                 $sFilePath           - [optional] Location of the program executable. Default is @ScriptFullPath.
	                 $bAllUsers           - [optional] Was it added to the current users (0) or all users (1). Default is 0.
	                 $iRunOnce            - [optional] Was it run at system startup $STARTUP_RUN (0), run only once before explorer is started $STARTUP_RUNONCE (1)
											  or run only once after explorer is started $STARTUP_RUNONCEEX (2). Default is $STARTUP_RUN (0).

	Return values   Success - True
	                 Failure - False & sets @error to non-zero

#ce	=========================================================

Func _StartupRegistry_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True, $iRunOnce = $STARTUP_RUN)

	Return __StartupRegistry_Uninstall(False, $sName, $sFilePath, Default, $bAllUsers, $iRunOnce)

EndFunc   ;==>_StartupRegistry_Uninstall


#cs | TESTING | =============================================

	Name				T_StartupRegistry_Uninstall

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_StartupRegistry_Uninstall()

	_Log("_StartupRegistry_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $bAllUsers = True, $iRunOnce = $STARTUP_RUN)")

EndFunc   ;==>T_StartupRegistry_Uninstall

; #INTERNAL_USE_ONLY#============================================================================================================




#cs | INTERNAL FUNCTION | ===================================

	Name				__Startup_Format
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func __Startup_Format(ByRef $sName, ByRef $sFilePath)

	If $sFilePath = Default Then
	    $sFilePath = @ScriptFullPath
	EndIf
	If $sName = Default Then
	    $sName = @ScriptName
	EndIf
	$sName = StringRegExpReplace($sName, '\.[^.\\/]*$', '') ; Remove extension.

	Return Not (StringStripWS($sName, $STR_STRIPALL) == '') And FileExists($sFilePath)

EndFunc   ;==>__Startup_Format




#cs | INTERNAL FUNCTION | ===================================

	Name				__StartupFolder_Location
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func __StartupFolder_Location($bAllUsers)

	Return $bAllUsers ? @StartupCommonDir : @StartupDir

EndFunc   ;==>__StartupFolder_Location




#cs | INTERNAL FUNCTION | ===================================

	Name				__StartupFolder_Uninstall
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func __StartupFolder_Uninstall($bIsInstall, $sName, $sFilePath, $sCommandline, $bAllUsers)

	If Not __Startup_Format($sName, $sFilePath) Then
	    Return SetError(1, 0, False) ; $STARTUP_ERROR_EXISTS
	EndIf
	If $bAllUsers = Default Then
	    $bAllUsers = True
	EndIf
	If $sCommandline = Default Then
	    $sCommandline = ''
	EndIf
	Local Const $sStartup = __StartupFolder_Location($bAllUsers)
	Local Const $hSearch = FileFindFirstFile($sStartup & '\' & '*.lnk')
	Local $vReturn = 0
	If $hSearch > -1 Then
	    Local Const $iStringLen = StringLen($sName)
	    Local $aFileGetShortcut = 0, _
	            $sFileName = ''
	    While 1
	        $sFileName = FileFindNextFile($hSearch)
	        If @error Then
	            ExitLoop
	        EndIf
	        If StringLeft($sFileName, $iStringLen) = $sName Then
	            $aFileGetShortcut = FileGetShortcut($sStartup & '\' & $sFileName)
	            If @error Then
	                ContinueLoop
	            EndIf
	            If $aFileGetShortcut[0] = $sFilePath Then
	                $vReturn += FileDelete($sStartup & '\' & $sFileName)
	            EndIf
	        EndIf
	    WEnd
	    FileClose($hSearch)
	ElseIf Not $bIsInstall Then
	    Return SetError(2, 0, False) ; $STARTUP_ERROR_EMPTY
	EndIf

	If $bIsInstall Then
	    $vReturn = FileCreateShortcut($sFilePath, $sStartup & '\' & $sName & '.lnk', $sStartup, $sCommandline) > 0
	Else
	    $vReturn = $vReturn > 0
	EndIf

	Return $vReturn

EndFunc   ;==>__StartupFolder_Uninstall




#cs | INTERNAL FUNCTION | ===================================

	Name				__StartupRegistry_Location
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func __StartupRegistry_Location($bAllUsers, $iRunOnce)

	If $iRunOnce = Default Then
	    $iRunOnce = $STARTUP_RUN
	EndIf
	Local $sRunOnce = ''
	Switch $iRunOnce
	    Case $STARTUP_RUNONCE
	        $sRunOnce = 'Once'
	    Case $STARTUP_RUNONCEEX
	        $sRunOnce = 'OnceEx'
	    Case Else
	        $sRunOnce = ''
	EndSwitch

	Return ($bAllUsers ? 'HKLM' : 'HKCU') & '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' & $sRunOnce
	        

EndFunc   ;==>__StartupRegistry_Location




#cs | INTERNAL FUNCTION | ===================================

	Name				__StartupRegistry_Uninstall
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func __StartupRegistry_Uninstall($bIsInstall, $sName, $sFilePath, $sCommandline, $bAllUsers, $iRunOnce)

	If Not __Startup_Format($sName, $sFilePath) Then
	    Return SetError(1, 0, False) ; $STARTUP_ERROR_EXISTS
	EndIf
	If $bAllUsers = Default Then
	    $bAllUsers = True
	EndIf
	If $sCommandline = Default Then
	    $sCommandline = ''
	EndIf
	Local Const $sRegistryKey = __StartupRegistry_Location($bAllUsers, $iRunOnce)
	Local $iInstance = 1, _
	        $sRegistryName = '', _
	        $vReturn = 0
	While 1
	    $sRegistryName = RegEnumVal($sRegistryKey & '\', $iInstance)
	    If @error Then
	        ExitLoop
	    EndIf

	    If ($sRegistryName = $sName) And StringInStr(RegRead($sRegistryKey & '\', $sRegistryName), $sFilePath, $STR_NOCASESENSEBASIC) Then
	        $vReturn += RegDelete($sRegistryKey & '\', $sName)
	    EndIf
	    $iInstance += 1
	WEnd

	If $bIsInstall Then
	
		$sCmdPath = $sFilePath
		If $sCommandline Then $sCmdPath &= ' ' & $sCommandline
	
	    $vReturn = RegWrite($sRegistryKey & '\', $sName, 'REG_SZ',  $sCmdPath) > 0
	Else
	    $vReturn = $vReturn > 0
	EndIf

	Return $vReturn

EndFunc   ;==>__StartupRegistry_Uninstall

