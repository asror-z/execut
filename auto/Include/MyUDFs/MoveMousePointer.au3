#include <Misc.au3>
#include <MyUDFs\Log.au3>
#include-once



#include-once

Global $UDFName = 'MoveMousePointer'


#cs | INDEX | ===============================================

	Title				Move Mouse
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				08.03.2016

#ce	=========================================================



#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        _MMP_Hide()

    EndIf

#EndRegion Example


Func _MMP_Hide ()
    
	$iX_Pos	=	@DesktopWidth/2
    $iY_Pos	=	@DesktopHeight - 10	
	
    MouseMove($iX_Pos, $iY_Pos, 0)
EndFunc   ;==>_MMP_Hide

