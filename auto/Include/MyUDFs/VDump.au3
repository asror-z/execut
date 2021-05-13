#include-once

Global $UDFName = 'VDump.au3'


#cs | INDEX | ===============================================

	Title				VDump.au3
	Description			Functions for dumping variable information.  We used to be able to dump detailed information for structures (DllStruct) because their data was accessible via an array format, I did not realize this ability was taken out at some point and as such we can no longer retrieve that information, so now we just dump the structure size from DllStructGetSize().
	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/25/2016

#ce	=========================================================

#Region Example

    If @ScriptName = $UDFName Then

        ; T_VarDump()
        ; T__VDump_Array()
        ; T__VDump_Struct()
        ; T__VDump_Struct()

    EndIf

#EndRegion Example


#cs | CURRENT | =============================================

	VDump(ByRef $vVar, $sIndent = '')

#ce	=========================================================

#Region Variables

    Global	$sShortTab = @TAB & '=>' & @TAB
    Global	$sLongTab = @TAB & $sShortTab
    Global	$sLongTab = $sShortTab

#EndRegion Variables



#cs | FUNCTION | ============================================

	Name				VDump
	Desc				This function returns information about the variable given as well as it's contents (if applicable/available).

	Parameters     $vVar       - The variable to read
	                $vDumpType  - How to display the variable information. See Notes for keywords.
	                $sIndent    - Internal usage, please do not fill this parameter.

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func VDump(ByRef $vVar, $sIndent = '')
    

    Local $sVarDump
    Local $sVarType = VarGetType($vVar)


    Select

        Case $vVar = Null
            $sVarDump = 'Null'


        Case IsString($vVar)
            $sVarDump = 'String (' & StringLen($vVar) & ')' & @TAB & @TAB & $vVar


        Case IsArray($vVar)
            $sVarDump = 'Array (' & @CRLF & __VDump_Array($vVar, $sIndent & @TAB) & @CRLF & $sIndent & ')'


        Case IsBinary($vVar)
            $sVarDump = 'Binary (' & BinaryLen($vVar) & ')' & @TAB & @TAB & $vVar


        Case IsFunc($vVar)
            $sVarDump = 'Function' & @TAB & FuncName($vVar)
			
			
        Case IsObj($vVar) And ObjName($vVar, 1) = 'Dictionary'
            $sVarDump = 'Assoc Array (' & @CRLF & __VDump_Assoc($vVar, $sIndent & @TAB) & $sIndent & ')'


        Case IsObj($vVar)
            $sVarDump = 'Object (' & @CRLF & __VDump_Object($vVar, $sIndent & @TAB) & $sIndent & ')'

			
        Case IsHWnd($vVar)
            $sVarDump = 'WinHandle' & @TAB & @TAB & $vVar


        Case IsPtr($vVar)
            $sVarDump = 'Pointer' & @TAB & @TAB & $vVar


        Case IsDllStruct($vVar)
            $sVarDump = 'DllStruct (' & @CRLF & __VDump_Struct($vVar, $sIndent & @TAB) & $sIndent & ')'

        Case Else
            $sVarDump = $sVarType & @TAB & @TAB & $vVar

    EndSelect

    Return $sVarDump

EndFunc   ;==>VDump


#cs | TESTING | =============================================

	Name				TVDump

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TVDump()
    


    _Log("VDump(ByRef $vVar, $sIndent = '')")



EndFunc   ;==>TVDump




#cs | INTERNAL FUNCTION | ===================================

	Name				__VDump_Object
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func __VDump_Object(ByRef $oObject, $sIndent = '')
    

    If Not IsObj($oObject) Then ExitBox('Error: Non-Object variable given')

    Local $sDump

    $sDump &= $sIndent & '[Name]' & $sLongTab & ObjName($oObject, 1) & @CRLF
    $sDump &= $sIndent & '[Desc]' & $sLongTab & ObjName($oObject, 2) & @CRLF
    $sDump &= $sIndent & '[ProgID]' & $sShortTab & ObjName($oObject, 3) & @CRLF
    $sDump &= $sIndent & '[File]' & $sLongTab & ObjName($oObject, 4) & @CRLF
    $sDump &= $sIndent & '[Module]' & $sShortTab & ObjName($oObject, 5) & @CRLF
    $sDump &= $sIndent & '[CLSID]' & $sShortTab & ObjName($oObject, 6) & @CRLF
    $sDump &= $sIndent & '[IID]'  & $sLongTab & ObjName($oObject, 7) & @CRLF


    Return $sDump

EndFunc   ;==>__VDump_Object




#cs | INTERNAL FUNCTION | ===================================

	Name				__VDump_Assoc
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func __VDump_Assoc(ByRef $oDict, $sIndent = '')
    

    If Not IsObj($oDict) Then ExitBox('Error: Non-Object variable given')

    Local $sDump

    Local $aKeys = $oDict.Keys

    For $vElement In $aKeys
        $sDump &= $sIndent & '['& $vElement &']' & $sLongTab & $oDict.Item($vElement) & @CRLF
    Next
    Return $sDump


    Return $sDump

EndFunc   ;==>__VDump_Assoc




#cs | FUNCTION | ============================================

	Name				__VDump_Array
	Desc				This function is primarily intended to be used by VDump to evaluate array contents, but you can use it by itself if you wish.

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func __VDump_Array(ByRef $aArray, $sIndent = '')
    

    If Not IsArray($aArray) Then ExitBox('Error: Non-array variable given.')

    Local $sDump
    Local $sArrayIndex, $sArrayRead, $bDone
    Local $iSubscripts = UBound($aArray, 0)
	
    If $iSubscripts < 1 Then
        Return $sIndent & '!! Array has 0 subscripts'
    EndIf

    Local $aUBounds[$iSubscripts]
    Local $aCounts[$iSubscripts]
    For $i = 0 To $iSubscripts - 1
        $aUBounds[$i] = UBound($aArray, $i + 1)
        $aCounts[$i] = 0
        If $aUBounds[$i] < 1 Then
            Return $sIndent & '!! Array subscript [' & $i + 1 & '] size is ' & $aUBounds[$i]
        EndIf
    Next

    While 1
        $bDone = True
        $sArrayIndex = ''
        For $i = 0 To $iSubscripts - 1
            $sArrayIndex &= '[' & $aCounts[$i] & ']'
            If $aCounts[$i] < $aUBounds[$i] - 1 Then $bDone = False
        Next
        $sArrayRead = Execute('$aArray' & $sArrayIndex)
        If @error Then
            $sDump &= $sIndent & $sArrayIndex & ' !! Error reading index'
            ExitLoop
        Else
            $sDump &= $sIndent & $sArrayIndex & $sLongTab & VDump($sArrayRead, $sIndent)
            If $bDone Then
                Return $sDump
            Else
                $sDump &= @CRLF
            EndIf
        EndIf

        For $i = $iSubscripts - 1 To 0 Step -1
            $aCounts[$i] += 1
            If $aCounts[$i] >= $aUBounds[$i] Then
                $aCounts[$i] = 0
            Else
                ExitLoop
            EndIf
        Next
    WEnd

    Return $sDump

EndFunc   ;==>__VDump_Array




#cs | FUNCTION | ============================================

	Name				__VDump_Struct
	Desc				This function is primarily intended to be used by VDump to evaluate DllStruct contents, but you can use it by itself if you wish.

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func __VDump_Struct(ByRef $tStruct, $sIndent = '')
    

    If Not IsDllStruct($tStruct) Then ExitBox('Error: Non-DllStruct variable given')

    Local $iElement = 1, $vRead, $vTest

    ; Do the initial $sDump contents - Standard fare for any struct
    Local $sDump = _
            $sIndent & '[Size]' & $sLongTab & DllStructGetSize($tStruct) & @CRLF & _
            $sIndent & '[Ptr]' & $sLongTab & DllStructGetPtr($tStruct) & @CRLF
    While 1
        $vRead = DllStructGetData($tStruct, $iElement)
        If @error = 2 Then ExitLoop ; If we've overstepped $iElement we're done

        $vTest = VarGetType($vRead)
        If $vTest = 'String' Or $vTest = 'Binary' Then
            ; Test the vartype for String or Binary, in which case we dump now because we already have the full contents
            $sDump &= $sIndent & '[' & $iElement & ']' & $sLongTab & VDump($vRead, $sIndent) & @CRLF
        Else
            ; Here we'll test to see if the element is an array by looking for an index of 2.
            DllStructGetData($tStruct, $iElement, 2)
            If @error Then
                ; @error means no index, which means no array, which means we can just dump the stored $vRead from above
                $sDump &= $sIndent & '[' & $iElement & ']' & $sLongTab & VDump($vRead, $sIndent) & @CRLF
            Else
                ; If we get no @error then that means that index 2 was valid, so we'll just start from 1 and work our way up til we @error again
                Local $sSubDump, $iIndex = 1, $iCount = 0, $iNonEmpties = 0
                While 1
                    $vRead = DllStructGetData($tStruct, $iElement, $iIndex)
                    If @error Then ExitLoop ; And that's the limit of this array, so we're done.
                    If $vRead Then
                        $sSubDump &= @TAB & $sIndent & '[' & $iIndex & ']' & $sLongTab & VDump($vRead) & @CRLF
                        $iNonEmpties += 1
                    EndIf
                    $iIndex += 1
                WEnd
                $sDump &= _
                        $sIndent & '[' & $iElement & '] => Array(' & @CRLF & _
                        $sIndent & @TAB & '> Showing ' & $iNonEmpties & '/' & ($iIndex-1) & ' non-empty indices' & @CRLF & _
                        $sSubDump & $sIndent & ')' & @CRLF
            EndIf
        EndIf
        $iElement += 1
    WEnd

    Return $sDump

EndFunc   ;==>__VDump_Struct
