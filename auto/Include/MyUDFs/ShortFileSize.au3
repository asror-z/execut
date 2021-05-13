#include-once
#include <MyUDFs\Log.au3>


Global $UDFName = 'ShortFileSize.au3'


#cs | INDEX | ===============================================

	Title				ShortFileSize.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				5/16/2016

#ce	=========================================================



#cs | CURRENT | =============================================

	ShortFileSize($iBytes)

#ce	=========================================================

#Region Example

    If @ScriptName = $UDFName Then

        TShortFileSize()

    EndIf

#EndRegion Example


; #FUNCTION# ;=================================================================================

; Function Name ...: ShortFileSize
; Description ........: The file size in bytes converts into short to 3 significant figures
; Syntax................: ShortFileSize($iBytes)
; Parameters:
;		$iBytes - Bytes
; Return values ....: A string containing the number
; Author(s) ..........: AZJIO
; Remarks ..........:
; ============================================================================================
; Имя функции ...: ShortFileSize
; Описание ........: Преобразует байты в число, округлённое до 3 знаков
; Синтаксис.......: ShortFileSize($iBytes)
; Параметры:
;		$iBytes - Число байт
; Возвращаемое значение: Строка, содержащая число с приставкой
; Автор ..........: AZJIO
; Примечания ..:
; ============================================================================================




#cs | FUNCTION | ============================================

	Name				ShortFileSize
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func ShortFileSize($iBytes)

    Switch $iBytes
        Case 10995116277760 To 109951162777600 ; 10 - 100 TB
            $iBytes = Round($iBytes / 1099511627776, 1) & ' TB'
        Case 1000000000000 To 10995116277759 ; 1000 GB - 10 TB
            $iBytes = Round($iBytes / 1099511627776, 2) & ' TB'
        Case 107374182400 To 999999999999 ; 100 - 999 GB
            $iBytes = Round($iBytes / 1073741824) & ' GB'
        Case 10737418240 To 107374182399 ; 10 - 100 GB
            $iBytes = Round($iBytes / 1073741824, 1) & ' GB'
        Case 1000000000 To 10737418239 ; 1000 MB - 10 GB
            $iBytes = Round($iBytes / 1073741824, 2) & ' GB'
        Case 104857600 To 999999999 ; 100 - 999 MB
            $iBytes = Round($iBytes / 1048576) & ' MB'
        Case 10485760 To 104857599 ; 10 - 100 MB
            $iBytes = Round($iBytes / 1048576, 1) & ' MB'
        Case 1000000 To 10485759 ; 1000 KB - 10 MB
            $iBytes = Round($iBytes / 1048576, 2) & ' MB'
        Case 102400 To 999999 ; 100 - 999 KB
            $iBytes = Round($iBytes / 1024) & ' KB'
        Case 10240 To 102399 ; 10 - 100 KB
            $iBytes = Round($iBytes / 1024, 1) & ' KB'
        Case 1000 To 10239 ; 1000 B - 10 KB
            $iBytes = Round($iBytes / 1024, 2) & ' KB'
        Case 0 To 999
            $iBytes &= ' B'
    EndSwitch

    Return $iBytes

EndFunc   ;==>ShortFileSize


#cs | TESTING | =============================================

	Name				TShortFileSize

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func TShortFileSize()

    $sRes = ShortFileSize(475) & @LF
    $sRes &= ShortFileSize(2345) & @LF
    $sRes &= ShortFileSize(10457) & @LF
    $sRes &= ShortFileSize(334987) & @LF
    $sRes &= ShortFileSize(4958283) & @LF
    $sRes &= ShortFileSize(67856785) & @LF
    $sRes &= ShortFileSize(5668769783) & @LF
    $sRes &= ShortFileSize(65786786443) & @LF
    $sRes &= ShortFileSize(876463256876) & @LF

    _Log($sRes)

EndFunc   ;==>TShortFileSize




#cs | FUNCTION | ============================================

	Name				ShortFileSizeMB
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================
Func ShortFileSizeMB($iSizeInMB)

    $iSizeInMB	*=	1024
    $iSizeInMB	*=	1024

    Return ShortFileSize($iSizeInMB)

EndFunc   ;==>ShortFileSizeMB


