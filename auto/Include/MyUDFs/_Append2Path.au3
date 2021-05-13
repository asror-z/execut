
Func _Append2Path($Path2Append)
	Const $RegPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
	Local $sSep = ";", $sType = "REG_SZ", $nPathLocal, $oPath = RegRead($RegPath, "PATH")
	
	If @extended = 7 Then
		$sSep = @LF
		$sType = "REG_MULTI_SZ"
	EndIf
	
	If StringInStr($oPath, $Path2Append) < 1 Then
		$nPath = $oPath & $sSep & $Path2Append
		RegWrite($RegPath, "PATH", $sType, $nPath)
	EndIf
	
EndFunc   ;==>_Append2Path
