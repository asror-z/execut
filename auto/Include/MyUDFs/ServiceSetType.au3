#include-once
#RequireAdmin

#include <MyUDFs\ServicesEngine.au3>
#include <MyUDFs\Log.au3>


Global $UDFName = 'ServiceSetType'


#cs | CURRENT | =============================================

	_SST_Auto
	_SST_Disable
	_SST_Manual

#ce	=========================================================


#cs | INDEX | ===============================================

	Title				ServiceSetType
	Description	 		ServiceSetType and log

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				06.03.2016

#ce	=========================================================


#Region Enum | _eSST

    Global Enum _
            $eSST_Disabled, _
            $eSST_Manual, _
            $eSST_Automate

#EndRegion Enum | _eSST


#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        ; T_SST_FromName()
        T_SST_FromList()

    EndIf

#EndRegion Example








#cs | TESTING | =============================================

	Name				T_SST_FromList
	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func T_SST_FromList()
    

    _SST_FromList(@ScriptDir & '\Configuration\Automate.txt', $eSST_Automate)
    Sleep(2000)
    _SST_FromList(@ScriptDir & '\Configuration\Disabled.txt', $eSST_Disabled)
    Sleep(2000)
    _SST_FromList(@ScriptDir & '\Configuration\Manuals.txt', $eSST_Manual)

EndFunc   ;==>T_SST_FromList


#cs | FUNCTION | ============================================

	Name				_SST_ProcessService

	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func _SST_FromList ($sListFile, $eStartType)
    

    If Not FileExists($sListFile) Then ExitBox('ListFile: ' & $sListFile & ' Not Exists')

    If FileGetSize($sListFile) = 0 Then ExitBox('ListFile is Empty')

    Local $aListArray = FileReadToArray($sListFile)

    _Log('Opened File: ' & $sListFile)
    _Log('Items Count: ' & UBound($aListArray))
    _Eol()
    
    For $sElement In $aListArray

        $sElement = StringStripWS($sElement, 3)
        _SST_FromName($sElement, $eStartType)

    Next
    _Eol()
	
EndFunc   ;==>_SST_FromList





#cs | TESTING | =============================================

	Name				T_SST_FromName
	Author				Asror Zakirov (aka Asror.Z)
	Created				17.03.2016

#ce	=========================================================

Func T_SST_FromName()
    

    $sServiceName = 'AraxisSnapshotService'
    _SST_FromName($sServiceName, $eSST_Automate)
    Sleep(2000)
    _SST_FromName($sServiceName, $eSST_Disabled)
    Sleep(2000)
    _SST_FromName($sServiceName, $eSST_Manual)

EndFunc   ;==>T_SST_FromName



#cs | FUNCTION | ============================================

	Name				_SST_FromName

	Author				Asror Zakirov (aka Asror.Z)
	Created				06.03.2016

#ce	=========================================================

Func _SST_FromName($serviceName, $eStartType)
    
    Local $sMsg, $sState

    If _Service_Exists($serviceName) Then

        Switch $eStartType

            Case $eSST_Automate
                $iMode =  $SERVICE_AUTO_START
                $sMsg = "AUTO_START"

            Case $eSST_Disabled
                $sMsg = "DISABLED"
                $iMode = $SERVICE_DISABLED
                _Service_Stop($serviceName)

            Case $eSST_Manual
                $sMsg = "MANUAL"
                $iMode = $SERVICE_DEMAND_START

            Case Else
                ExitBox('Incorrect $eStartType')

        EndSwitch
		
        $sST_Return = _Service_SetStartType($serviceName, $iMode)

        If $sST_Return Then
            $sMsg = $serviceName & " | Changed To | " & $sMsg
            $sState = 'OK'
        Else
            $sMsg = 'Cannot Perform ' & $sMsg &' for ' & $serviceName & '! Return: ' & $sST_Return
            $sState = 'Error'
        EndIf

    Else
        $sMsg = $serviceName & ' NOT exists!'
        $sState = 'Error'
    EndIf

    _Log($sState & '! ' & $sMsg)

EndFunc   ;==>_SST_FromName
