#RequireAdmin
#include-once
#include <MyUDFs\FileZ.au3>

Global $UDFName = 'RegBackup'


#cs | INDEX | ===============================================

	Title				RegBackup
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				17.03.2016

#ce	=========================================================


#Region Example

    If @ScriptName = $UDFName & '.au3' Then

        T_RB_Export()
        T_RB_Import()

    EndIf

#EndRegion Example








#cs | TESTING | =============================================

	Name				T_RB_GUI
	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func T_RB_GUI()
	

	_Log('_RB_GUI()')	

EndFunc


#cs | FUNCTION | ============================================

	Name				_RB_GUI
	Desc				
							
	Author				Asror Zakirov (aka Asror.Z)
	Created				21.04.2016

#ce	=========================================================

Func _RB_GUI ()
	

	
	

EndFunc 









#cs | TESTING | =============================================

	Name				T_RB_Export
	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func T_RB_Export()
    

    $sFileName = @ScriptDir & '\Hello.reg'
    $sPath = 'HKEY_CURRENT_USER\Software\uvSoftium'

    _RB_Export($sPath, $sFileName)

EndFunc   ;==>T_RB_Export



#cs | FUNCTION | ============================================

	Name				_RB_Export

	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func _RB_Export ($sRegPath, $sFileName)
    

    Local $sFileNameFull = _FZ_Name($sFileName, $eFZN_FilenameFull)

    If FileExists($sFileName) Then
        _Log($sFileNameFull & ' is exists! Hence we are going to delete it...')
        If FileDelete($sFileName) Then _Log($sFileNameFull & ' is successfully deleted!')
    EndIf

    Local $sRegeditCmd = 'regedit.exe /E "'& $sFileName &'" "'& $sRegPath &'"'

    _Log($sRegeditCmd, '$sRegeditCmd')
    RunWait($sRegeditCmd)

	
	
    If FileExists($sFileName) And FileGetSize($sFileName) > 0 Then _Log('Export successfully completed!')

	_Eol()
EndFunc   ;==>_RB_Export






#cs | TESTING | =============================================

	Name				T_RB_Import
	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func T_RB_Import()
    

    $sFileName = @ScriptDir & '\Hello.reg'

    _RB_Import($sFileName)

EndFunc   ;==>T_RB_Import


#cs | FUNCTION | ============================================

	Name				_RB_Import

	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func _RB_Import ($sFileName)
    

    Local $sFileNameFull = _FZ_Name($sFileName, $eFZN_FilenameFull)

	_Log('Importing Registry File: ' & $sFileNameFull)
	
    If Not FileExists($sFileName) Then ExitBox('File '& $sFileName &' Not Found!')
	
    Local $sRegeditCmd = 'regedit.exe /S "'& $sFileName &'"'

    _Log($sRegeditCmd, '$sRegeditCmd')
    RunWait($sRegeditCmd)
	_Log('Import successfully completed!')
	_Eol()

EndFunc   ;==>_RB_Import
