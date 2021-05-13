#include-once
#include <MyUDFs\Exit.au3>

#cs
# INDEX # ========================================================================

	Title				ArrayDump
	Description	 		Dump All Types of Arrays

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				29.01.2016

==================================================================================
#ce


#cs
# VERSION HISTORY # ==============================================================

	1_1:		Some changes
	1_5:		Fixed Array index issue for multiodimensional arrays
	1_6:		Corrected sorting mechanism
	1_7:		Added variablee name parsing
	1_8:		Fixed dump function
	1_9:		Fixed ArrayName

==================================================================================
#ce

Global $UDFName = 'ArrayDump'


#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        Local $test_6[5] = [True, 123, 'string', Binary('0xDD'),WinGetHandle('')]
        Local $test_2[4] = [True, $test_6, 3543.46, $test_6]

        ConsoleWrite(_Array_Dump('StringSplit(123, "")') & @LF)
        ; TODO:  asfasf
        ConsoleWrite(_Array_Dump('$test_2') & @LF)
        ;   ConsoleWrite(_Array_Dump('$test_2', 'adadad') & @LF)
        ;	FileWrite(@ScriptDir & '\1.txt', _Array_Dump($test_2, 'test_2'))

    EndIf

#EndRegion Example




;=================================================================================

Func _Array_Dump($aArrayVar, $aArrayName = '', $sDelimTab = '   ')

    Local 	$result_after, _
            $size_string, _
            $aArray

    Select
        Case IsString($aArrayVar)
            $aArray 	=	Execute($aArrayVar)
            $aArrayName =	($aArrayName='') ? StringReplace($aArrayVar, "$", "") : $aArrayName


        Case IsArray($aArrayVar)
            $aArray 	=	$aArrayVar

        Case Else
            Return ExitBox('Problem Type')

    EndSelect

    Local Static $level = 0
    Local Static $result_before
    Local Static $var_count = 0

    Local $rang = UBound($aArray, 0)
    Local $count = 1
    For $i = 1 To $rang
        $count *= UBound($aArray, $i)
        $size_string &= '[' & UBound($aArray, $i) & ']'
    Next

    Local $result, $position, $size, $result_2, $value, $var_name, $return, $var_comment, $comment

    For $index = 0 To $count - 1
        $position = $index
        $result = ''
        For $i = $rang To 1 Step -1
            $size = UBound($aArray, $i)
            $result = '[' & Mod($position, $size) & ']' & $result
            $position = Floor($position / $size)
        Next

        $value = Execute('$aArray' & $result)

        If IsArray($value) Then
            $level += 1

            $var_name = $aArrayName & '_' & StringFormat('%02d', $var_count)
            $var_count += 1

            $result_2 = _Array_Dump($value, $var_name)
            $level -= 1

            $var_comment = StringRegExp($result_2, '(\[.+\])', 1);
            $comment = @TAB & @TAB & '; ' & VarGetType($value) & '' & $var_comment[0]
            $result_before &= $result_2 & @CRLF
            $result_after &= '      ' & '$' & $aArrayName & $result & ' = $' & $var_name & $comment & @CRLF
        Else


            $var_comment = __Array_Dump_Value($value)

            $comment = @TAB & @TAB & '# ' & $var_comment


            $return = '      ' & '$' & $aArrayName & $result & ' = ' & $value & $comment
            $result_after &= $return & @CRLF
        EndIf
    Next

    If $level = 0 Then
        Local $out = ''


        $out &= $result_after & @CRLF & $result_before


        $level = 0
        $result_before = ''
        $var_count = 0

        Return $out

    EndIf
    Return $result_after
    
    
EndFunc   ;==>_Array_Dump








#cs
# INTERNAL FUNCTION # ============================================================

	Name				
	Description	 		
	Syntax		 		__Array_Dump_Value($value)

	Parameters			$value 		- 	Array Item	

	Return values 		Success 	- 	Dumped values of array items
						Failure 	- 	Returns 0 and sets @Error

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2016

==================================================================================
#ce

Func  __Array_Dump_Value(ByRef $value)

    Local $var_comment = VarGetType($value)
    Select
        Case $value = Null
            $value = 'Null'
        Case IsString($value)
            $var_comment &= '(' & StringLen($value) & ')'
            $value = StringReplace($value, "'", "''")
            $value = StringReplace($value, @CRLF, "' & @CRLF & '")
            $value = StringReplace($value, @CR, "' & @CR & '")
            $value = StringReplace($value, @LF, "' & @LF & '")
            $value = "'" & $value & "'"
        Case IsKeyword($value)
        Case IsNumber($value)
        Case IsBool($value)
        Case IsBinary($value)
            $var_comment &= '(' & BinaryLen($value) & ')'
            $value = "Binary('" & $value & "')"
        Case IsFunc($value)
            $value = FuncName($value)
        Case IsObj($value)
            $var_comment &= ' Not Supported'
            $var_comment &= '|name:' & ObjName($value, 1)
            $var_comment &= '|Description:' & ObjName($value, 2)
            $var_comment &= '|ProgID:' & ObjName($value, 3)
            $var_comment &= '|File:' & ObjName($value, 4)
            $var_comment &= '|Module name:' & ObjName($value, 5)
            $var_comment &= '|CLSID:' & ObjName($value, 6)
            $var_comment &= '|IID:' & ObjName($value, 7)
            $value = "'" & $value & "'"
        Case IsHWnd($value)
            $value = "HWnd('" & $value & "')"
        Case IsPtr($value)
            $value = "Ptr('" & $value & "')"
        Case IsDllStruct($value)
            $var_comment &= ' Not Supported'
            $var_comment &= '|ptr:' & DllStructGetPtr($value)
            $var_comment &= '|size:' & DllStructGetSize($value)
            $value = "'" & $value & "'"
        Case Else
            $value = "'" & $value & "'"
    EndSelect
    $value = StringReplace($value, " & ''", '')
    $value = StringReplace($value, "'' & ", '')
    Return $var_comment

EndFunc   ;==>__Array_Dump_Value


