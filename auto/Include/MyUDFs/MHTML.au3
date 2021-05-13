#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Log.au3>
#include-once



Global $UDFName = 'MHTML.au3'



#cs | INDEX | ===============================================

	Title				MHTML
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


        T_MHT_CheckExt()
        T_MHT_Get_PackageFolder()
        T_MHT_Get_PackageRequire()

    EndIf

#EndRegion Example





#cs | CURRENT | =============================================

	_MHT_CheckExt($sFullPath)
	_MHT_Get_PackageFolder($sFullPath)
	_MHT_Get_PackageRequire($sFullPath)
	_MHT_Get_Location($sFullPath)

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name				_MHT_CheckExt
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func _MHT_CheckExt($sFullPath)

    ; _Log('_')

    $bIsMHT	=	_FZ_Name($sFullPath, $eFZN_Extension) = '.mht'
    $bIsMHTML	=	_FZ_Name($sFullPath, $eFZN_Extension) = '.mhtml'

    If $bIsMHT Or $bIsMHTML Then
        Return True
    EndIf

    Return False

EndFunc   ;==>_MHT_CheckExt


#cs | TESTING | =============================================

	Name				T_MHT_CheckExt

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MHT_CheckExt()

    _Log("_MHT_CheckExt($sFullPath)")

EndFunc   ;==>T_MHT_CheckExt




#cs | FUNCTION | ============================================

	Name				_MHT_Get_PackageFolder
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func _MHT_Get_PackageFolder($sFullPath)

    Local $sText	=	    _FZ_Name($sFullPath, $eFZN_FilenameNoExt)

    ; _Log($sText, '$sText')

    $sText = StringReplace($sText, ' - Packagist', '')
    $sText = StringRegExpReplace($sText, '(?s)(.*)_(.*)', '\2 (\1)')

    If @error Then ExitBox('StringRegExp Error')

    Return $sText

EndFunc   ;==>_MHT_Get_PackageFolder


#cs | TESTING | =============================================

	Name				T_MHT_Get_PackageFolder

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MHT_Get_PackageFolder()

    _Log("_MHT_Get_PackageFolder($sFullPath)")

EndFunc   ;==>T_MHT_Get_PackageFolder




#cs | FUNCTION | ============================================

	Name				_MHT_Get_PackageRequire
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func _MHT_Get_PackageRequire($sFullPath)

    Local $sText	=	    _FZ_Name($sFullPath, $eFZN_FilenameNoExt)

    ; _Log($sText, '$sText')

    $sText = StringReplace($sText, ' - Packagist', '')
    $sText = StringRegExpReplace($sText, '(?s)(.*)_(.*)', '\1/\2')

    If @error Then ExitBox('StringRegExp Error: ' & @error)

    Return $sText

EndFunc   ;==>_MHT_Get_PackageRequire


#cs | TESTING | =============================================

	Name				T_MHT_Get_PackageRequire

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MHT_Get_PackageRequire()

    _Log("_MHT_Get_PackageRequire($sFullPath)")

EndFunc   ;==>T_MHT_Get_PackageRequire




#cs | FUNCTION | ============================================

	Name				_MHT_GetLocation
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name				_MHT_Get_Location
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func _MHT_Get_Location($sFullPath)

    Local $sText	=	_FZ_ReadFile($sFullPath)
    
    $sText = 'Content-Location: http://autoit-script.ru/index.php?topic=8796.0'

    $sFuncPattern = 'Content\-Location\: +(.*)'

    $aRes = StringRegExp($sText, $sFuncPattern , 3)
    If @error Then ExitBox('StringRegExp Error: ' & @error)
    

    Return $aRes[0]

EndFunc   ;==>_MHT_Get_Location


#cs | TESTING | =============================================

	Name				T_MHT_Get_Location

	Author				Asror Zakirov (aka Asror.Z)
	Created				7/25/2016

#ce	=========================================================

Func T_MHT_Get_Location()

    _Log("_MHT_Get_Location($sFullPath)")

EndFunc   ;==>T_MHT_Get_Location

