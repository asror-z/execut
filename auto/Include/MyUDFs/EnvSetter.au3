
Func EnvSetter($sName, $sValue)
	Const $RegPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
	
	Local $sSep = ";", $sType = "REG_SZ", $oPath = RegRead($RegPath, $sName)
	
	If StringInStr($oPath, $sValue) < 1 Then
		RegWrite($RegPath, $sName, $sType, $sValue)
	EndIf
	
EndFunc   ;==>_Append2Path


