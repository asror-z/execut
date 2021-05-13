#include-once
; #INDEX# ====================================================================
; Title .........: _FireBird.au3
; Description ...: FireBird, Interbase dll udf.
; Author ........: Stephen Podhajecki (Eltorro)
; ==============================================================================

; #CURRENT# ======================================================================
;_FireBird_Check
;_FireBird_About
;_FireBird_SetDebug
;_FireBird_CreateDatabase
;_FireBird_SetPageBuffers
;_FireBird_ConnectEmbededDatabase
;_FireBird_ConnectDatabase
;_FireBird_DisConnectDatabase
;_FireBird_ExecuteBatch
;_FireBird_ExecuteSelect
;_FireBird_ExecuteStatement
;_FireBird_Help
; ================================================================================

; #INTERNAL_USE_ONLY# ============================================================
;__FireBird_GetBstr
; ================================================================================

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_Check
; Description ...: Test function returns the same value given.
; Syntax ........: _FireBird_Check($iCheck)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $iCheck - IN -
; Return values .: Success - $iCheck
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_Check($h_fbDll,$iCheck)
    Local $vRet = DllCall($h_fbDll, "int", "Check", "long", $iCheck)
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_Check

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_About
; Description ...: Shows about message
; Syntax ........: _FireBird_About()
; Parameters ....: $h_fbDll - Handle to firebird dll.
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_About($h_fbDll)
    Local $vRet = DllCall($h_fbDll, "none", "About")
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_About

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_SetDebug
; Description ...: Turns debugging on or off
; Syntax ........: _FireBird_SetDebug($xdebug)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $fDebug - IN True or false
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_SetDebug($h_fbDll,$fDebug)
    Local $vRet = DllCall($h_fbDll, "int", "SetDebug", "int", $fDebug)
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_SetDebug

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_CreateDatabase
; Description ...: Creates a database
; Syntax ........: _FireBird_CreateDatabase($sServerName, $sDBName, $sUsername, $sPassword, $iWriteMode = 1,$iDialect = 3)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sServerName - IN -
;                  $sDBName - IN -
;                  $sUsername - IN -
;                  $sPassword - IN -
;                  $iWriteMode - IN/OPTIONAL -
;                 $iDialect  - IN/OPTIONAL -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......: Overwrites existing database if it exists unless it is being used.
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_CreateDatabase($h_fbDll,$sServerName, $sDBName, $sUsername, $sPassword, $iWriteMode, $iDialect = 3)
    Local $tagfbCreate = "char[%d];char[%d];char[%d];char[%d]"
    $tagfbCreate = StringFormat($tagfbCreate, StringLen($sServerName) + 1, StringLen($sDBName) + 1, StringLen($sUsername) + 1, StringLen($sPassword) + 1, $iWriteMode = 1, $iDialect = 3)
    Local $t_fbCreate = DllStructCreate($tagfbCreate)
    DllStructSetData($t_fbCreate, 1, $sServerName)
    DllStructSetData($t_fbCreate, 2, $sDBName)
    DllStructSetData($t_fbCreate, 3, $sUsername)
    DllStructSetData($t_fbCreate, 4, $sPassword)
    Local $vRet = DllCall($h_fbDll, "int", "CreateDatabase", "ptr", DllStructGetPtr($t_fbCreate, 1), "ptr", DllStructGetPtr($t_fbCreate, 2), "ptr", DllStructGetPtr($t_fbCreate, 3), "ptr", DllStructGetPtr($t_fbCreate, 4), "int", $iWriteMode, "int", $iDialect)
    $t_fbCreate = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_CreateDatabase

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_SetPageBuffers
; Description ...: Sets the page buffers when creating a database.
; Syntax ........: _FireBird_SetPageBuffers($a)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $iSize - IN -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_SetPageBuffers($h_fbDll, $iSize)
    Local $vRet = DllCall($h_fbDll, "int", "SetPageBuffers", "int", $iSize)
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_SetPageBuffers

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_ConnectDatabase
; Description ...: Connect to an embeded database.
; Syntax ........: _FireBird_ConnectDatabase($sDBName, $sUsername, $sPassword)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sDBName - IN -
;                  $sUsername - IN -
;                  $sPassword - IN -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......: Only dialect 3 database supported
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_ConnectEmbededDatabase($h_fbDll, $sDBName, $sUsername, $sPassword)
    Local $tagfbCreate = "char[%d];char[%d];char[%d]"
    $tagfbCreate = StringFormat($tagfbCreate, StringLen($sDBName) + 1, StringLen($sUsername) + 1, StringLen($sPassword) + 1)
    Local $t_fbCreate = DllStructCreate($tagfbCreate)
    DllStructSetData($t_fbCreate, 1, $sDBName)
    DllStructSetData($t_fbCreate, 2, $sUsername)
    DllStructSetData($t_fbCreate, 3, $sPassword)
    Local $vRet = DllCall($h_fbDll, "int", "ConnectDatabase", "ptr", DllStructGetPtr($t_fbCreate, 1), "ptr", DllStructGetPtr($t_fbCreate, 2), "ptr", DllStructGetPtr($t_fbCreate, 3))
    $t_fbCreate = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_ConnectEmbededDatabase
; #FUNCTION# =====================================================================
; Name ..........: _FireBird_ConnectDatabase
; Description ...: Connect to a database.
; Syntax ........: _FireBird_ConnectDatabase($sDBName, $sUsername, $sPassword)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sServerName - IN -
;                  $sDBName - IN -
;                  $sUsername - IN -
;                  $sPassword - IN -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......: Only dialect 3 database supported
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_ConnectDatabase($h_fbDll, $sServerName, $sDBName, $sUsername, $sPassword)
    Local $tagfbCreate = "char[%d];char[%d];char[%d];char[%d]"
    $tagfbCreate = StringFormat($tagfbCreate, StringLen($sServerName) + 1, StringLen($sDBName) + 1, StringLen($sUsername) + 1, StringLen($sPassword) + 1)
    Local $t_fbCreate = DllStructCreate($tagfbCreate)
    DllStructSetData($t_fbCreate, 1, $sServerName)
    DllStructSetData($t_fbCreate, 2, $sDBName)
    DllStructSetData($t_fbCreate, 3, $sUsername)
    DllStructSetData($t_fbCreate, 4, $sPassword)
    Local $vRet = DllCall($h_fbDll, "int", "ConnectDatabase", "ptr", DllStructGetPtr($t_fbCreate, 1), "ptr", DllStructGetPtr($t_fbCreate, 2), "ptr", DllStructGetPtr($t_fbCreate, 3), "ptr", DllStructGetPtr($t_fbCreate, 4))
    $t_fbCreate = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_ConnectDatabase

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_DisConnectDatabase
; Description ...: Disconnect from the database
; Syntax ........: _FireBird_DisConnectDatabase()
; Parameters ....: $h_fbDll - Handle to firebird dll.
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_DisConnectDatabase($h_fbDll)
    Local $vRet = DllCall($h_fbDll, "int", "DisConnectDatabase")
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_DisConnectDatabase

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_ExecuteBatch
; Description ...: Do a batch execution of statements
; Syntax ........: _FireBird_ExecuteBatch($sCmd)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sCmd - IN -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_ExecuteBatch($h_fbDll, $sCmd)
    Local $t_ExeBatch = DllStructCreate("char[" & StringLen($sCmd) + 1 & "]")
    DllStructSetData($t_ExeBatch, 1, $sCmd)
    Local $vRet = DllCall($h_fbDll, "int", "ExecuteBatch", "ptr", DllStructGetPtr($t_ExeBatch))
    $t_ExeBatch = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_ExecuteBatch

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_ExecuteSelect
; Description ...: Executes an SQL query.
; Syntax ........: _FireBird_ExecuteSelect($sCmd, ByRef $sResult)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sCmd - IN -
;                  $sResult - IN/OUT -
; Return values .: Success - Record count
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_ExecuteSelect($h_fbDll, $sCmd, ByRef $sResult)
    Local $t_ExeSelect = DllStructCreate("char[" & StringLen($sCmd) + 1 & "];uint;uint")
    DllStructSetData($t_ExeSelect, 1, $sCmd)
    Local $vRet = DllCall($h_fbDll, "int", "ExecuteSelect", "ptr", DllStructGetPtr($t_ExeSelect, 1), "ptr", DllStructGetPtr($t_ExeSelect, 2), "ptr", DllStructGetPtr($t_ExeSelect, 3))
    $sResult = __FireBird_GetBstr(DllStructGetData($t_ExeSelect, 2), DllStructGetData($t_ExeSelect, 3))
    $t_ExeSelect = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_ExecuteSelect

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_ExecuteStatement
; Description ...: Execute an SQL statement
; Syntax ........: _FireBird_ExecuteStatement($sCmd)
; Parameters ....: $h_fbDll - Handle to firebird dll.
;                  $sCmd - IN -
; Return values .: Success - 1
;                  Failure - 0 and @error to 1
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_ExecuteStatement($h_fbDll, $sCmd)
    Local $t_ExeStatement = DllStructCreate("char[" & StringLen($sCmd) + 1 & "]")
    DllStructSetData($t_ExeStatement, 1, $sCmd)
    Local $vRet = DllCall($h_fbDll, "int", "ExecuteStatement", "ptr", DllStructGetPtr($t_ExeStatement, 1))
    $t_ExeStatement = 0
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_ExecuteStatement

; #FUNCTION# =====================================================================
; Name ..........: _FireBird_Help
; Description ...: Shows help dialog
; Syntax ........: _FireBird_Help()
; Parameters ....: $h_fbDll - Handle to firebird dll.
; Return values .:
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; Example .......: [yes/no]
; ================================================================================
Func _FireBird_Help($h_fbDll)
    Local $vRet = DllCall($h_fbDll, "none", "Help")
    Return SetError($vRet[0] <> 0, 0, $vRet[0])
EndFunc   ;==>_FireBird_Help

; #INTERNAL_USE_ONLY# ============================================================
; Name ..........: __FireBird_GetBstr
; Description ...:
; Syntax ........: __FireBird_GetBstr($ptr, $len)
; Parameters ....: $ptr - IN -
;                  $len - IN -
; Return values .:
; Author ........: Stephen Podhajecki (eltorro)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://fbdll4vb.sourceforge.net/
; ================================================================================
Func __FireBird_GetBstr($ptr, $len)
    Local $t_ret = DllStructCreate("char[" & $len & "]", $ptr)
    Local $vRet = DllStructGetData($t_ret, 1)
    $t_ret = 0
    ;ConsoleWrite($vRet)
    Return $vRet
EndFunc   ;==>__FireBird_GetBstr