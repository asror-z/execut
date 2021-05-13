#include-once

Global $UDFName = 'IniToArray'

#cs | INDEX | ===============================================

	Title				IniToArray
	Description	 		This script write a single array[i] or bi-dimensional array[i][j] into a ini file's section.

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				29.01.2016



 Script Function:
	This script write a single array[i] or bi-dimensional array[i][j] into a ini file's section.
	Each column is separated by '|' and if string contain a '|', it was changed to string '<%Separator%>'.

	If a single array[i], is a traditional way... not changing...
	_ArrayToIni($IniNameFile, $IniSectionName, $ArrayName)
	$config[3] = ["optionA", "optionB", "optionC"]
	_ArrayToIni("config.ini", "config", $config)
	In the ini:
	[config]
	0=optionA
	1=optionB
	2=optionC

	If a bi-dimensional array[i][j] has some diferences...
	$colors[3][2] = [["green","verde"],["red","vermelho"],["blue","azul"]]
	_ArrayToIni("config.ini", "colors", $colors)
	In the Ini:
	[colors#2#|#<%Separator%>]
	0=green|verde
	1=red|vermelho
	2=blue|azul

	A columns number, the character separator (|) and long string to separator has include in the section name's ini.

	To read a ini file to array, you must have declare a array will be receved a data's array.
	You must be passed a name like string, not variable.

	Global (or Local) $colors
	_IniToArray("config.ini", "colors");correct
	_IniToArray("config.ini", $colors);wrong

	The script read all sections from ini file.
	And if exist the section in parameters funcion, all data's from section ini file will be loaded in the variable array.

	You can pass multiples arrays:
	Global $config
	Global $users
	Global $banned
	_IniToArray("config.ini", "colors,users,banned")
	If exist all sections in ini file, all must be load in respective array.

	If not exist a section ini file requested, the variable array is not changed.
	If someone add more columns in a existent line, this data will not be read.
	If someone delete any columns from existent line, the rest of datas will be null or "".

#ce	=========================================================

#include <String.au3>
#include <Array.au3>
#include <Misc.au3>


#cs | CURRENT | =============================================

_IniToArray
_ArrayToIni

#ce	=========================================================









Global $defaultSeparator = Opt("GUIDataSeparatorChar", "|")
Global $defaultSeparatorString = "<%Separator%>"





#Region Example

    If @ScriptName = $UDFName & '.au3' Then


        Local $config[3] = ["optionA", "optionB", "optionC"]
        Local $ZConfig[3]

		_ArrayToIni("Settings.ini", "ZConfig", $config)

        _IniToArray("Settings.ini", "ZConfig")
        _ArrayDisplay($ZConfig)


    EndIf
#EndRegion Example







#cs | FUNCTION | ============================================

	Name				_ArrayToIni

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _ArrayToIni($hFile, $sSection, $aName)
    Local $iLines = UBound($aName)
    Switch UBound($aName, 2)
        Case 0
            Local $sTemp = ""
            For $ii = 0 To $iLines - 1
                $aName[$ii] = StringReplace($aName[$ii], @LF, "At^LF")
                $sTemp &= $ii & "=" & $aName[$ii] & @LF
            Next
            IniWriteSection($hFile, $sSection, $sTemp, 0)
        Case Else
            Local $aTemp[1], $sString = "", $iColumns = UBound($aName, 2)
            For $ii = 0 To $iLines - 1
                For $jj = 0 To $iColumns - 1
                    $aName[$ii][$jj] = StringReplace($aName[$ii][$jj], $defaultSeparator, $defaultSeparatorString)
                    $sString &= $aName[$ii][$jj] & $defaultSeparator
                Next
                _ArrayAdd($aTemp, StringTrimRight($sString, 1))
                $sString = ""
            Next
            _ArrayDelete($aTemp, 0)
            _ArrayToIni($hFile, $sSection & "#" & $iColumns & "#" & $defaultSeparator & "#" & $defaultSeparatorString, $aTemp)
    EndSwitch
EndFunc   ;==>_ArrayToIni



#cs | FUNCTION | ============================================

	Name				_IniToArray

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _IniToArray($hFile, $sArrays = 0)
    If $sArrays == 0 Then Return
    $sArrays = StringSplit($sArrays, ",", 2)
    Local $aSection = IniReadSectionNames($hFile)
    _ArrayDelete($aSection, 0)
    If @error Then
        Return 0
    Else
        Local $aProperties[UBound($aSection)][4]
        For $ii = 0 To UBound($aSection) - 1
            Local $aData = StringSplit($aSection[$ii], "#")
            If @error Then
                If Not (_ArraySearch($sArrays, $aSection[$ii]) == -1) Then
                    Local $sTemp = IniReadSection($hFile, $aSection[$ii]), $aTemp[1]
                    For $jj = 1 To $sTemp[0][0]
                        _ArrayAdd($aTemp, $sTemp[$jj][1])
                    Next
                    _ArrayDelete($aTemp, 0)
                    If IsDeclared($aSection[$ii]) Then Assign($aSection[$ii], $aTemp)
                EndIf
            Else
                Local $iCounter = 0
                For $sEach In $aData
                    If Not ($iCounter == 0) Then $aProperties[$ii][$iCounter - 1] = $sEach
                    $iCounter += 1
                Next
                If Not (_ArraySearch($sArrays, $aProperties[$ii][0]) == -1) Then
                    Local $sTemp = IniReadSection($hFile, $aSection[$ii]), $aTemp[1]
                    For $jj = 1 To $sTemp[0][0]
                        _ArrayAdd($aTemp, $sTemp[$jj][1])
                    Next
                    _ArrayDelete($aTemp, 0)
                    Local $aTemp2[UBound($aTemp)][$aProperties[$ii][1]], $sTemp
                    For $xx = 0 To UBound($aTemp) - 1
                        $sTemp = StringSplit($aTemp[$xx], $aProperties[$ii][2], 2)
                        For $yy = 0 To _Iif(UBound($sTemp) > $aProperties[$ii][1], $aProperties[$ii][1], UBound($sTemp)) - 1
                            ;$aTemp2[$xx][$yy] = StringReplace($aName[$ii], @LF, "At^LF")
                            $aTemp2[$xx][$yy] = StringReplace($sTemp[$yy], $aProperties[$ii][3], $aProperties[$ii][2])
                        Next
                    Next
                    If IsDeclared($aProperties[$ii][0]) Then Assign($aProperties[$ii][0], $aTemp2)
                EndIf
            EndIf
        Next
    EndIf
EndFunc   ;==>_IniToArray
