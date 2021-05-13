#include <MyUDFs\DriveInfo.au3>
#include <MyUDFs\Log.au3>
#include <MyUDFs\Dict.au3>
#include <MyUDFs\ShortFileSize.au3>
#include <Array.au3>
#include-once


Global $UDFName = 'HDDInfo.au3'


Global $aDiskDrive


#cs | CURRENT | =============================================

	HInfo_GetList()
	HInfo_GetFixedDrives()
	HInfo_IsExist($sLabelName)
	HInfo_IsExist_Run()

#ce	=========================================================



#cs | INDEX | ===============================================

	Title				HDDInfo
	Description	 		HDDInfo

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				5/16/2016

#ce	=========================================================

#Region Example

    If @ScriptName = $UDFName Then

        ; THInfo_GetList()
        ; THInfo_GetFixedDrives()
        THInfo_IsExist()

    EndIf

#EndRegion Example




#cs | FUNCTION | ============================================

	Name				HInfo_GetList
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func HInfo_GetList()

    _DriveGetDiskDrive($aDiskDrive)

    Local $iMaxCount	=	UBound($aDiskDrive)

    Local $aDriveList[$iMaxCount]

    For $i = 0 To $iMaxCount-1
        $oDict = Dict()

        $oDict('InterfaceType') = 	$aDiskDrive[$i][17]		; IDE
        $oDict('MediaType') 	= 	$aDiskDrive[$i][23]
        $oDict('Size') 			= 	$aDiskDrive[$i][39]
        $oDict('Model') 		= 	$aDiskDrive[$i][25]

        $aDriveList[$i] = $oDict

    Next

    Return $aDriveList

EndFunc   ;==>HInfo_GetList


#cs | TESTING | =============================================

	Name				THInfo_GetList

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func THInfo_GetList()

    Local $aDriveList	=	HInfo_GetList()
    _Log($aDriveList, '$aDriveList')

EndFunc   ;==>THInfo_GetList




#cs | FUNCTION | ============================================

	Name				HInfo_GetFixedDrives
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func HInfo_GetFixedDrives()

    Local $aDiskDrive 	=	DriveGetDrive("FIXED")

    Local $sDriveLetter, $bIsSSD

    Local $aDriveList[$aDiskDrive[0]+1]
    $aDriveList[0]	=	$aDiskDrive[0]

    For $i = 1 To $aDiskDrive[0]

        $sDriveLetter			=	$aDiskDrive[$i] & "\"
        $oDict = Dict()

        $bIsSSD		=	DriveGetType($sDriveLetter, $DT_SSDSTATUS)

        $oDict('Drive Label')	= 	DriveGetLabel($sDriveLetter)
        $oDict('Drive Type')	= 	DriveGetType($sDriveLetter)
        $oDict('Drive Bus') 	= 	DriveGetType($sDriveLetter, $DT_BUSTYPE) & (($bIsSSD) ? ' SSD' : '')
        $oDict('File System') 	= 	DriveGetFileSystem($sDriveLetter)

        $oDict('Total Space')	= 	ShortFileSizeMB(DriveSpaceTotal($sDriveLetter))
        $oDict('Free Space')	= 	ShortFileSizeMB(DriveSpaceFree($sDriveLetter))

        $aDriveList[$i] = $oDict

    Next

    Return $aDriveList


EndFunc   ;==>HInfo_GetFixedDrives


#cs | TESTING | =============================================

	Name				THInfo_GetFixedDrives

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func THInfo_GetFixedDrives()

    _Log("HInfo_GetFixedDrives()")

EndFunc   ;==>THInfo_GetFixedDrives




#cs | FUNCTION | ============================================

	Name				HInfo_IsExist
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func HInfo_IsExist($sLabelName)

    Local $aAllDrives	=	HInfo_GetFixedDrives()
    Local $bIsExist		=	False

    For $i = 1 To $aAllDrives[0]
	
        ; $bLogPauser	=	True
        If Dict_Get($aAllDrives[$i], 'Drive Label') = $sLabelName Then
            $bIsExist	=	True
            $bLogPauser	=	False
			
			ExitLoop
        EndIf

    Next
	
    _Log('Drive is ' & (($bIsExist) ? ' Exist!' : ' Not Exist' ))
    
    Return $bIsExist

EndFunc   ;==>HInfo_IsExist


#cs | TESTING | =============================================

	Name				THInfo_IsExist

	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func THInfo_IsExist()

    _Log("HInfo_IsExist('CanvioOsNE')")
    _Log("HInfo_IsExist('CanvioONE')")

EndFunc   ;==>THInfo_IsExist


