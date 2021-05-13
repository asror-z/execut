#include-once
#include <Array.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Log.au3>
#RequireAdmin

Global $UDFName = 'Config'

#cs | INDEX | ===============================================

	Title				Config
	Description	 		Config Reader UDF

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				15.02.2016

#ce	=========================================================


Global $sRegURL = 'HKEY_CURRENT_USER\SOFTWARE\Config\'



#cs | CURRENT | =============================================

	_FZ_CreateFile
	_FZ_DeleteFile
	_FZ_GetDrive
	_FZ_GetAppProgramFiles
	_FZ_GetFNameNoExtension
	_FZ_GetFileExtension
	_FZ_GetFileName
	_FZ_GetParentDir
	_FZ_ReadFile
	_FZ_WriteFileAppend
	_FZ_WriteFileOverrite
	_FZ_FileNameIncrement

	__FZ_CheckAll
	_FZ_CheckEmpty
	_FZ_CheckExist

	Mbox
	ExitBox

#ce	=========================================================


#cs | CURRENT | =============================================

	_Config
	_CN_JumpRegistry

#ce	=========================================================


#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        
        _Config('Asrorbek', 'asfasfsaafasf')
        
        $sConf	=	_Config('Asrorbek')
        _LogV('$sConf')
        
        _CN_JumpRegistry('Asrorbek')
        
    EndIf

#EndRegion Example








#cs | FUNCTION | ============================================

	Name				_Config

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.02.2016

#ce	=========================================================

Func _Config ($sConfKey, $sConfValue = '')
    
    If $sConfValue <> '' Then
        If Not RegWrite($sRegURL, $sConfKey, "REG_SZ", $sConfValue) Then ExitBox ('RegWrite Error' & @CRLF & $sRegURL)
    Else
        Return RegRead($sRegURL, $sConfKey)
    EndIf

EndFunc   ;==>_Config







#cs | FUNCTION | ============================================

	Name				_CN_JumpRegistry

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.02.2016

#ce	=========================================================

Func _CN_JumpRegistry ($sConfKey)

    ShellExecute('regjump', $sRegURL)

EndFunc   ;==>_CN_JumpRegistry










#cs | FUNCTION | ============================================

	Name				__CN_RegExists

	Author				Asror Zakirov (aka Asror.Z)
	Created				16.02.2016

#ce	=========================================================

Func __CN_RegExists($sKeyName, $sValueName = '')

    RegRead($sKeyName, $sValueName)
    If $sValueName == '' Then
        Return Not (@error > 0)
    Else
        Return @error = 0
    EndIf

EndFunc   ;==>__CN_RegExists



