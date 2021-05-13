#include-once
#include <MyUDFs\ArrayDump.au3>
#include <MyUDFs\Exit.au3>

Global $UDFName = 'VarDump'


#cs | INDEX | ===============================================

	Title				VarDump
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				15.02.2016

#ce	=========================================================




#cs
# FUNCTION # =====================================================================

	Name				_VarDump
	Description	 		Debug any type of variable
	Syntax		 		_VarDump($vVar)

	Parameters			$vVar 	- 	Given Variable

	Return values 		Success 	- 	Debugging string
						Failure 	- 	Returns 0 and sets @Error

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2016

==================================================================================
#ce




#Region Example

    If StringInStr(@ScriptName, $UDFName) Then
        T_VarDump()

    EndIf

#EndRegion Example






#cs | TESTING | =============================================

	Name				T_VarDump
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_VarDump()
    Global $test_6[5] = [True, 123, 'string', Binary('0xDD'), WinGetHandle('')]
    Local  $test_2[2] = [True, $test_6]
    
    Local $sDeli = ' "c:/cache" "c:/config"'

    ConsoleWrite('$sDeli: ' &  _VarDump($sDeli) & @CRLF)
    Local $tStruct = DllStructCreate("wchar[256]")
    ConsoleWrite('$sDeli: ' &  _VarDump($tStruct) & @CRLF)
    ConsoleWrite('$sDeli: ' &  _VarDump($test_2) & @CRLF)

    Global $aArray[3] = ['adada', 'adada', 'adadad']



EndFunc   ;==>T_VarDump










Func _VarDump($vVariable)

    Local $sVarTypeDelimiter = '# '
    Local $bIsArray, $sVarCommentDLL

    Local $sVarComment = VarGetType($vVariable)

    Select

        Case $vVariable = Null
            $vVariable = 'Null'

        Case IsString($vVariable)
            $sVarComment &= '(' & StringLen($vVariable) & ')'
            $vVariable = StringReplace($vVariable, "'", "''")
            $vVariable = StringReplace($vVariable, @CRLF, "' & @CRLF & '")
            $vVariable = StringReplace($vVariable, @CR, "' & @CR & '")
            $vVariable = StringReplace($vVariable, @LF, "' & @LF & '")
            $vVariable = "'" & $vVariable & "'"

        Case IsArray($vVariable)
            $vVariable = $sVarComment & ' => ' & @TAB & @CRLF & _Array_Dump($vVariable)
            $bIsArray	=	True


        Case IsKeyword($vVariable)
        Case IsNumber($vVariable)
        Case IsBool($vVariable)
        Case IsBinary($vVariable)
            $sVarComment &= '(' & BinaryLen($vVariable) & ')'
            $vVariable = "Binary('" & $vVariable & "')"

        Case IsFunc($vVariable)
            $vVariable = FuncName($vVariable)

        Case IsObj($vVariable)
            $sVarComment &= '|name:' & ObjName($vVariable, 1)
            $sVarComment &= '|Description:' & ObjName($vVariable, 2)
            $sVarComment &= '|ProgID:' & ObjName($vVariable, 3)
            $sVarComment &= '|File:' & ObjName($vVariable, 4)
            $sVarComment &= '|Module name:' & ObjName($vVariable, 5)
            $sVarComment &= '|CLSID:' & ObjName($vVariable, 6)
            $sVarComment &= '|IID:' & ObjName($vVariable, 7)
            $vVariable = "'" & $vVariable & "'"

        Case IsHWnd($vVariable)
            $vVariable = "HWnd('" & $vVariable & "')"

        Case IsPtr($vVariable)
            $vVariable = "Ptr('" & $vVariable & "')"

        Case IsDllStruct($vVariable)
            $sVarCommentDLL &= 'Ptr:' & DllStructGetPtr($vVariable)
            $sVarCommentDLL &= '|Size:' & DllStructGetSize($vVariable)
            $vVariable = "'" & $sVarCommentDLL & "'"


        Case Else
            $vVariable = "'" & $vVariable & "'"

    EndSelect

    $vVariable = StringReplace($vVariable, " & ''", '')
    $vVariable = StringReplace($vVariable, "'' & ", '')

    Local $iValueLength = StringLen($vVariable)

    If $bIsArray Then Return $vVariable

    Return $vVariable & @TAB & @TAB & @TAB & $sVarTypeDelimiter &  $sVarComment
    ; Return $sRelease
EndFunc   ;==>_VarDump
