#include-once
#include <Array.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Log.au3>

#RequireAdmin

Global $UDFName = 'AppPath'

#cs | INDEX | ===============================================

	Title				AppPath
	Description	 		Windows App Paths UDF

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				15.02.2016

#ce	=========================================================


#Region Variables

    Global $sRegURL, $sFileName, $sFilePath, $sFileType, $sFileOpenDialog, $sFullFilePath, $sFileNameNew

    Global $sRegPathHKCU = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\'
    Global $sRegPathHKLM = 'HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\'

#EndRegion Variables




#cs | CURRENT | =============================================

	_AppPath_Write
	_AppPath_Delete	
	_AppPath_Locate
	_AppPath_IsExist

#ce	=========================================================


#Region Example


    If @ScriptName = $UDFName & '.au3' Then

        T_AppPath_Write()
        ; T_AppPath_Locate()
        ; T_AppPath_IsExist()

    EndIf



#EndRegion Example









#cs | TESTING | =============================================

	Name				T_AppPath_Write
	Author				Asror Zakirov (aka Asror.Z)
	Created				26.02.2016

#ce	=========================================================

Func T_AppPath_Write()

    $sFileName = "c:\Program Files (x86)\NVIDIA Corporation\NvTelemetry\NvTelemetry.exe"

    ; _Log('_AppPath_Write(@ScriptFullPath)')
    _Log('_AppPath_Write($sFileName)')

    _AppPath_Delete($sFileName)





EndFunc   ;==>T_AppPath_Write

#cs | FUNCTION | ============================================

	Name				_AppPath_Write

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _AppPath_Write ($sFullFilePath = '')

    If $sFullFilePath = '' Then
        $sFullFilePath = __AppPath_GetExePath()
    EndIf


    ; 	Set File name

    ; $sFileName 	=	__AppPath_SetAlias($sFullFilePath)

    $sFileName	=	_FZ_Name($sFullFilePath, $eFZN_FilenameNoExt)
    $sFileName &= '.exe'

    $sFilePath	=	_FZ_Name($sFullFilePath, $eFZN_FileParentDir)


    ; Write to HKLM

    $sRegURL = $sRegPathHKLM & $sFileName

    If Not RegWrite($sRegURL, "", "REG_SZ", $sFullFilePath) Then ExitBox ('RegWrite HKLM Error' & @CRLF & $sRegURL)
    If Not RegWrite($sRegURL, "Path", "REG_SZ", $sFilePath) Then ExitBox ('RegWrite HKLM Error' & @CRLF & $sRegURL & ' | Path')
    If Not RegWrite($sRegURL, "useURL", "REG_SZ", "1") Then  ExitBox ('RegWrite HKLM Error' & @CRLF & $sRegURL & ' | useURL')

    If _AppPath_IsExist($sFullFilePath, True) Then
        _Log('OK  |  Written to HKLM: ' & $sFileName)
    Else
        _Log('Error  |  Cannot Write to HKCU: ' & $sFileName)
    EndIf



    ; Write to HKCU

    $sRegURL = $sRegPathHKCU & $sFileName

    If Not RegWrite($sRegURL, "", "REG_SZ", $sFullFilePath) Then ExitBox ('RegWrite HKCU Error' & @CRLF & $sRegURL)
    If Not RegWrite($sRegURL, "Path", "REG_SZ", $sFilePath) Then ExitBox ('RegWrite HKCU Error' & @CRLF & $sRegURL & ' | Path')
    If Not RegWrite($sRegURL, "useURL", "REG_SZ", "1") Then  ExitBox ('RegWrite HKCU Error' & @CRLF & $sRegURL & ' | useURL')

    If _AppPath_IsExist($sFullFilePath, False) Then
        _Log('OK  |  Written to HKCU: ' & $sFileName)
    Else
        _Log('Error  |  Cannot Write to HKCU: ' & $sFileName)
    EndIf



    Return $sFileName

EndFunc   ;==>_AppPath_Write





#cs | TESTING | =============================================

	Name				T_AppPath_Locate
	Author				Asror Zakirov (aka Asror.Z)
	Created				26.02.2016

#ce	=========================================================

Func T_AppPath_Locate()


    _Log('_AppPath_Locate(@ScriptFullPath)')
    _Log('_AppPath_Locate("AppPath")')
    _Log('_AppPath_Locate("AppPath.exe")')
    _Log('_AppPath_Locate("AppPaths.exe")')

EndFunc   ;==>T_AppPath_Locate

#cs | FUNCTION | ============================================

	Name				_AppPath_Locate

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _AppPath_Locate ($sFileName, $HKLM = True)

    If $HKLM Then
        $sRegPath = $sRegPathHKLM
    Else
        $sRegPath = $sRegPathHKCU
    EndIf

    Select
        Case StringInStr($sFileName, '\') > 0
            $sFileName = _FZ_Name($sFileName, $eFZN_FilenameNoExt)
            $sRegURL = $sRegPath & $sFileName & '.exe'

        Case StringInStr($sFileName, '.exe') > 0
            $sRegURL = $sRegPath & $sFileName

        Case Else
            $sRegURL = $sRegPath & $sFileName & '.exe'

    EndSelect
    Local $sRRead	=	RegRead($sRegURL, '')

    If Not @error And $sRRead <> '' Then
        _Log($sRegURL, 'OK  |  App Located: ' & $sFileName & '  |  $sRegURL: ' & $sRegURL)
        Return $sRRead
    Else
        _Log('Error  |  Nothing Located for ' & $sFileName)
        Return SetError(@error, @extended, False)
    EndIf



EndFunc   ;==>_AppPath_Locate









#cs | TESTING | =============================================

	Name				T_AppPath_IsExist
	Author				Asror Zakirov (aka Asror.Z)
	Created				26.02.2016

#ce	=========================================================

Func T_AppPath_IsExist()


    _Log('_AppPath_IsExist(@ScriptFullPath)')

EndFunc   ;==>T_AppPath_IsExist

#cs | FUNCTION | ============================================

	Name				_AppPath_IsExist

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _AppPath_IsExist ($sFileName, $HKLM = True)

    If _AppPath_Locate($sFileName, $HKLM) Then Return True

    Return False

EndFunc   ;==>_AppPath_IsExist





#cs | FUNCTION | ============================================

	Name				_AppPath_Delete

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _AppPath_Delete ($sFileName)

	; Delete From HKLM

    $sRegURL = $sRegPathHKLM & $sFileName

    If RegDelete($sRegURL) = 1 Then
        _Log('Delete OK  |  Deleted: ' & $sRegURL)
    Else
        _Log('Delete Error | '  & @CRLF & $sRegURL)
    EndIf
	
	
	; Delete From HKCU

    $sRegURL = $sRegPathHKCU & $sFileName

    If RegDelete($sRegURL) = 1 Then
        _Log('Delete OK  |  Deleted: ' & $sRegURL)
    Else
        _Log('Delete Error | '  & @CRLF & $sRegURL)
    EndIf
	
EndFunc   ;==>_AppPath_Delete





#cs | FUNCTION | ============================================

	Name				__AppPath_GetExePath

	Author				Asror Zakirov (aka Asror.Z)
	Created				09.03.2016

#ce	=========================================================

Func __AppPath_GetExePath ()


    Local Const $sMessage = "Choose Program Executable"

    $sFileType = "Executables (*.exe;*.a3x;*.au3)"

    $sFileOpenDialog = FileOpenDialog($sMessage, @ScriptDir, $sFileType, $FD_FILEMUSTEXIST)

    If @error Then ExitBox('No file is selected')

    Return $sFileOpenDialog

EndFunc   ;==>__AppPath_GetExePath





#cs | INTERNAL FUNCTION | ===================================

	Name				__AppPath_SetAlias

	Author				Asror Zakirov (aka Asror.Z)
	Created				09.03.2016

#ce	=========================================================

Func __AppPath_SetAlias ($sFullFilePath)

    $sFileName	=	_FZ_Name($sFullFilePath, $eFZN_FilenameNoExt)

    $sFileNameNew	=	InputBox ( "Set Alias to execute Exe", "Set Alias to execute Exe", $sFileName)

    If $sFileNameNew <> '' Then
        $sFileName = $sFileNameNew
    EndIf

    $sFileName &= '.exe'

    _Log('SetAlias | Result Filename: ' & $sFileName)

    Return $sFileName

EndFunc   ;==>__AppPath_SetAlias

