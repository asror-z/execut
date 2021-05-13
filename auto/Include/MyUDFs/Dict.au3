#include-once
#include <MyUDFs\Log.au3>


Global $UDFName = 'Dict.au3'



#cs | INDEX | ===============================================

	Title				Dict.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/25/2016

#ce	=========================================================



#cs | CURRENT | =============================================

	Dict($iMode = 1)
	Dict_Add($oDict, $vKey, $vValue = "")
	Dict_Get($oDict, $vKey)
	Dict_Set($oDict, $vKey, $vValue)
	Dict_Exists($oDict, $vKey)
	Dict_Rename($oDict, $vKey, $vNewKey)
	Dict_Delete($oDict, $vKey)
	Dict_DeleteAll($oDict)
	Dict_Count($oDict)
	Dict_Keys($oDict)
	Dict_Values($oDict)
	Dict_Sort(ByRef $oDict, $iSort=$Sort_Key, $iOrder=$Sort_Asc)
	Dict_FromArr(ByRef $aArray)
	Dict_ToArray(ByRef $oDict)

#ce	=========================================================

#Region Variables

    Global Const $Sort_Key  = 0
    Global Const $Sort_Item = 1
    Global Const $Sort_Asc 	= 0
    Global Const $Sort_Desc = 1

    Global $oDict

#EndRegion Variables



#Region Example

    If @ScriptName = $UDFName Then

		TDict_TwoDArray()
	
       ; TDict()
       ; TDict_Add()
       ; TDict_Get()
       ; TDict_Set()
       ; TDict_Exists()
       ; TDict_Rename()
       ; TDict_Delete()
       ; TDict_DeleteAll()
       ; TDict_Count()
       ; TDict_Keys()
       ; TDict_Values()
       ; TDict_Sort()
       ; TDict_FromArr()
       ; TDict_ToArray()

    EndIf

#EndRegion Example


#cs | FUNCTION | ============================================

	Name            Dict
	Description     Create a new Dictionary Object

	Parameters      [$iMode] - Mode to use for comparing keys
	                 |0 - (Default) Binary - case sensitive
	                 |1 - Text - not case sensitive
	                 |2 - Database

	Return values   Success - Returns a Scripting Dictionary object

	Remarks         http//msdn microsoft com/en-us/library/x4k5wbx4(VS 85) aspx
	                 "A Dictionary object is the equivalent of a PERL associative array. Items can be any form of data, and are
	                 stored in the array. Each item is associated with a unique key. The key is used to retrieve an individual
	                 item and is usually an integer or a string, but can be anything except an array."
	                 +Dict_Values

#ce	=========================================================

Func Dict($iMode = 1)

    
    $oDict = ObjCreate("Scripting.Dictionary")
    If @error Then ConsoleWrite('Cannot Create Scripting.Dictionary')

    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object!')
    If Not IsInt($iMode) Then ConsoleWrite('Invalid $iMode - Not an integer')
    If Not ($iMode >= 0) And ($iMode <= 2) Then ConsoleWrite('Invalid $iMode - Out of range')

    $oDict.CompareMode = $iMode

    ; _Log('New Scripting.Dictionary Created! Compare Mode is : ' & $iMode)

    Return $oDict

EndFunc   ;==>Dict


#cs | TESTING | =============================================

	Name				TDict

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict()

    
    $oDict = Dict()

    $oDict('Asror') = '111111111'
    $oDict('Asror2') = '2222222222'

    _Log('$oDict')

EndFunc   ;==>TDict




#cs | FUNCTION | ============================================

	Name            Dict_Add
	Description     Add a new Key/Value pair

	Parameters      $oDict  - Dictionary object, created with Dict()
	                 $vKey   - Dictionary key, typically a string, must be unique.
	                 $vValue - The value you want to store, can not be an object.

	Return values   Success - Returns True

	Remarks         http//msdn microsoft com/en-us/library/5h92h863(VS 85) aspx

#ce	=========================================================

Func Dict_Add($oDict, $vKey, $vValue = "")

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')
    If Dict_Exists($oDict, $vKey) Then ConsoleWrite('Invalid $vKey  - Already exists')

    $oDict.Add($vKey, $vValue)
    If @error Then ConsoleWrite('Unable to create key/value pair')

    ;_Log('New item: ' & @TAB & $vKey & ' = ' & $vValue & ' is added!  Type is: ' & VarGetType($vValue))

    Return True

EndFunc   ;==>Dict_Add


#cs | TESTING | =============================================

	Name				TDict_Add

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Add()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'NewAsrtor', '124241421')
    Dict_Add($oDict, 'NewAsrtor2', MsgBox)

EndFunc   ;==>TDict_Add




#cs | FUNCTION | ============================================

	Name            Dict_Get
	Description     Get the value associated with a key

	Parameters      $oDict - Dictionary object, created with Dict()
	                 $vKey  - Dictionary key, typically a string, must be unique.

	Return values   Success - Returns the value associated with $vKey
	                 Failure - Returns False, and sets @error:
	                 |1 - Invalid $oDict - Not an object

	Remarks         http//msdn microsoft com/en-us/library/84k9x471(VS 85) aspx
	                 "If key is not found when changing an item, a new key is created with the specified newitem. If key is not
	                 found when attempting to return an existing item, a new key is created and its corresponding item is left
	                 empty."

#ce	=========================================================

Func Dict_Get($oDict, $vKey)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    Local $vValue = $oDict.Item($vKey)
    ; _Log('Get Key Value '&@TAB&' | Index: ' & $vKey & ' | Value is: ' & $vValue)

    Return $vValue

EndFunc   ;==>Dict_Get


#cs | TESTING | =============================================

	Name				TDict_Get

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Get()

    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'NewAsrtor', '124241421')
    Dict_Add($oDict, 'NewAsrtor2', MsgBox)

    Dict_Get($oDict, 'Asror')
    Dict_Get($oDict, 'Asror2')

EndFunc   ;==>TDict_Get




#cs | FUNCTION | ============================================

	Name            Dict_Set
	Description     Set the value of a key

	Parameters      $oDict  - Dictionary object, created with Dict()
	                 $vKey   - Dictionary key, typically a string, must be unique.
	                 $vValue - The value you want to store, can not be an object.

	Return values   Success - Returns True

	Remarks         http//msdn microsoft com/en-us/library/84k9x471(VS 85) aspx
	                 "If key is not found when changing an item, a new key is created with the specified newitem. If key is not
	                 found when attempting to return an existing item, a new key is created and its corresponding item is left
	                 empty."

#ce	=========================================================

Func Dict_Set($oDict, $vKey, $vValue)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    $oDict.Item($vKey) = $vValue

    ; _Log('Set Key Value '&@TAB&' | Index:' & $vKey & ' | Value is: ' & $vValue)


    Return True

EndFunc   ;==>Dict_Set


#cs | TESTING | =============================================

	Name				TDict_Set

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Set()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')

    Local $vVar = Dict_Get($oDict, 'Asror')
    _Log($vVar, '$vVar')

    Dict_Set($oDict, 'Asror', 'JeasfaaFAF')

    Local $vVar = Dict_Get($oDict, 'Asror')
    _Log($vVar, '$vVar')

EndFunc   ;==>TDict_Set




#cs | FUNCTION | ============================================

	Name            Dict_Exists
	Description     Check whether a named key exists

	Parameters      $oDict - Dictionary object, created with Dict()
	                 $vKey  - Dictionary key, typically a string, must be unique.

	Return values   Success
	                 |True   - Found
	                 |False  - Not found

	Remarks         http//msdn microsoft com/en-us/library/57hdf10z(VS 85) aspx

#ce	=========================================================

Func Dict_Exists($oDict, $vKey)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    Local $bIsExists = $oDict.Exists($vKey)

    Return $bIsExists

EndFunc   ;==>Dict_Exists


#cs | TESTING | =============================================

	Name				TDict_Exists

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Exists()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'NewAsrtor', '124241421')
    Dict_Add($oDict, 'NewAsrtor2', MsgBox)

    Dict_Exists($oDict, 'Asror')
    Dict_Exists($oDict, 'Asror3')

EndFunc   ;==>TDict_Exists




#cs | FUNCTION | ============================================

	Name            Dict_Rename
	Description     Rename a key, value follows

	Parameters      $oDict   - Dictionary object, created with Dict()
	                 $vKey    - Dictionary key, typically a string, must be unique.
	                 $vNewKey - The new key, replaces $vKey

	Return values   Success - Returns True

	Remarks         http//msdn microsoft com/en-us/library/1ex01tte(VS 85) aspx
	                 "If key is not found when changing a key, a new key is created and its associated item is left empty."

#ce	=========================================================

Func Dict_Rename($oDict, $vKey, $vNewKey)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    $oDict.Key($vKey) = $vNewKey

    ; _Log('Key Renamed!' & @TAB & 'Old name: '&$vKey &' | New name is: ' & $vNewKey)

    Return True

EndFunc   ;==>Dict_Rename


#cs | TESTING | =============================================

	Name				TDict_Rename

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Rename()

    
    $oDict = Dict()
    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Rename($oDict, 'Asror', 'Heeeeeee')

    _Log('$oDict')

EndFunc   ;==>TDict_Rename




#cs | FUNCTION | ============================================

	Name            Dict_Delete
	Description     Remove (delete) a key/value pair

	Parameters      $oDict - Dictionary object, created with Dict()
	                 $vKey  - Dictionary key, typically a string, must be unique.

	Return values   Success - True
	                 Failure - Returns False, and sets @error:
	                 |1 - Invalid $oDict - Not an object
	                 |2 -
	                 |3 -

	Remarks         http//msdn microsoft com/en-us/library/ywyayk03(VS 85) aspx

#ce	=========================================================

Func Dict_Delete($oDict, $vKey)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')
    If Not Dict_Exists($oDict, $vKey) Then ConsoleWrite('Invalid $vKey  - Doesnt exist')

    $oDict.Remove($vKey)
    If @error Then ConsoleWrite('Unable to delete key')

   ; _Log('Item Deleted!' & @TAB & 'Key: ' & $vKey)

    Return True

EndFunc   ;==>Dict_Delete


#cs | TESTING | =============================================

	Name				TDict_Delete

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Delete()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Delete($oDict, 'Asror')

    _Log('$oDict')

EndFunc   ;==>TDict_Delete




#cs | FUNCTION | ============================================

	Name            Dict_DeleteAll
	Description     Remove all key/value pairs

	Parameters      $oDict - Dictionary object, created with Dict
	                 $vKey  - Dictionary key, typically a string, must be unique.

	Return values   Success - Returns True

	Remarks         http//msdn microsoft com/en-us/library/45731e2w(VS 85) aspx

#ce	=========================================================

Func Dict_DeleteAll($oDict)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')
    $oDict.RemoveAll()

    If @error Then ConsoleWrite('Unable to delete all items from Array')

    ; _Log('All Items are Deleted from Array')

    Return True

EndFunc   ;==>Dict_DeleteAll


#cs | TESTING | =============================================

	Name				TDict_DeleteAll

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_DeleteAll()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'Asror2', 'Hello')
    Dict_DeleteAll($oDict)
    _Log('$oDict')

EndFunc   ;==>TDict_DeleteAll




#cs | FUNCTION | ============================================

	Name            Dict_Count
	Description     Determine how many keys exist

	Parameters      $oDict - Dictionary object, created with Dict()

	Return values   Success - The number of keys stored in the Dictionary object

	Remarks         http//msdn microsoft com/en-us/library/5t9h9579(VS 85) aspx

#ce	=========================================================

Func Dict_Count($oDict)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    Local $iCount = $oDict.Count

    ; _Log('Items count: ' & $iCount)

    Return $iCount

EndFunc   ;==>Dict_Count


#cs | TESTING | =============================================

	Name				TDict_Count

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Count()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'Asror2', 'Hello')
    Dict_Add($oDict, 'Asror3', 'Hello')

    Dict_Count($oDict)

EndFunc   ;==>TDict_Count




#cs | FUNCTION | ============================================

	Name            Dict_Keys
	Description     Return an array of all key names

	Parameters      $oDict - Dictionary object, created with Dict()

	Return values   Success - Array of all key values

	Remarks         http//msdn microsoft com/en-us/library/etzd1tzc(VS 85) aspx

#ce	=========================================================

Func Dict_Keys($oDict)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    Local $aKeys = $oDict.Keys

    ; _Log($aKeys, 'An array of all key names: aKeys:')

    Return $aKeys

EndFunc   ;==>Dict_Keys


#cs | TESTING | =============================================

	Name				TDict_Keys

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Keys()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'Asror2', 'Hello')

    $aKeys = Dict_Keys($oDict)

EndFunc   ;==>TDict_Keys




#cs | FUNCTION | ============================================

	Name            Dict_Values
	Description     Return an array of all key values

	Parameters      $oDict - Dictionary object, created with Dict()

	Return values   Success - Array of all key values

	Remarks         http//msdn microsoft com/en-us/library/8aet97f2(VS 85) aspx

#ce	=========================================================

Func Dict_Values($oDict)

    
    If Not IsObj($oDict) Then ConsoleWrite('Invalid $oDict - Not an object')

    Local $aItems = $oDict.Items

    ; _Log($aItems, 'An array of all value names: aItems:')

    Return $aItems

EndFunc   ;==>Dict_Values


#cs | TESTING | =============================================

	Name				TDict_Values

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Values()

    
    $oDict = Dict()

    Dict_Add($oDict, 'Asror', 'Hello')
    Dict_Add($oDict, 'Asror2', 'Hello')

    $aItems = Dict_Values($oDict)

EndFunc   ;==>TDict_Values




#cs | FUNCTION | ============================================

	Name				Dict_Sort
	Desc				Sort an array by key or value and ascending or descending

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016
	$iSort  - 	$Sort_Key 	(sort the keys)
				$Sort_Item 	(sort the items)
	$iOrder - 	$Sort_Asc	(ascending 123, ABC)
				$Sort_Desc	(descending 321, CBA)

#ce	=========================================================

Func Dict_Sort(ByRef $oDict, $iSort=$Sort_Key, $iOrder=$Sort_Asc)

    $bLogPauser	=	True

    Dim $strDict[1][2]
    Dim $objKey
    Dim $strKey, $strItem
    Dim $X,$Y,$Z
    Local $dictItem = $Sort_Item
    Local $dictKey = $Sort_Key
    $Z = $oDict.Count()

    If $Z > 1 Then
        ReDim $strDict[$Z][2]
        $X = 0
        Dim $sKeys = Dict_Keys($oDict)

        For $i = 0 To UBound($sKeys)-1
            $objKey = $sKeys[$i]
            $strDict[$X][$dictKey]  = String($objKey)
            $strDict[$X][$dictItem] = String($oDict($objKey))
            $X = $X + 1
        Next

        If $iOrder = $Sort_Asc Then

            For $X = 0 to ($Z - 2)
                For $Y = $X to ($Z - 1)
                    If StringCompare($strDict[$X][$iSort],$strDict[$Y][$iSort],1) > 0 Then
                        $strKey  = $strDict[$X][$dictKey]
                        $strItem = $strDict[$X][$dictItem]
                        $strDict[$X][$dictKey]  = $strDict[$Y][$dictKey]
                        $strDict[$X][$dictItem] = $strDict[$Y][$dictItem]
                        $strDict[$Y][$dictKey]  = $strKey
                        $strDict[$Y][$dictItem] = $strItem
                    EndIf
                Next
            Next

        Else

            For $X = 0 to ($Z - 2)
                For $Y = $X to ($Z - 1)
                    If StringCompare($strDict[$X][$iSort],$strDict[$Y][$iSort],1) < 0 Then
                        $strKey  = $strDict[$X][$dictKey]
                        $strItem = $strDict[$X][$dictItem]
                        $strDict[$X][$dictKey]  = $strDict[$Y][$dictKey]
                        $strDict[$X][$dictItem] = $strDict[$Y][$dictItem]
                        $strDict[$Y][$dictKey]  = $strKey
                        $strDict[$Y][$dictItem] = $strItem
                    EndIf
                Next
            Next

        EndIf

        $oDict.RemoveAll()

        For $X = 0 to ($Z - 1)
            $oDict.Add($strDict[$X][$dictKey], $strDict[$X][$dictItem])
        Next

        $bLogPauser	=	False
        ; _Log($oDict, 'Sorted Array: ')

        Return 1

    EndIf

    Return 0


EndFunc   ;==>Dict_Sort


#cs | TESTING | =============================================

	Name				TDict_Sort

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_Sort()

    
    $oDict = Dict()

    Dict_Add($oDict, '111', '1111')
    Dict_Add($oDict, '4444', '4444')
    Dict_Add($oDict, '2222', '2222')
    Dict_Add($oDict, '333', '333')

    Dict_Sort($oDict, $Sort_Key, $Sort_Asc)
    _Log('$oDict')

    Dict_Sort($oDict, $Sort_Key, $Sort_Desc)
    _Log('$oDict')

    Dict_Sort($oDict, $Sort_Item, $Sort_Asc)
    _Log('$oDict')

    Dict_Sort($oDict, $Sort_Item, $Sort_Desc)
    _Log('$oDict')

EndFunc   ;==>TDict_Sort




#cs | FUNCTION | ============================================

	Name				Dict_FromArr
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func Dict_FromArr(ByRef $aArray)
    

    $oDict = Dict()

    For $i = 0 To UBound($aArray)-1
        $oDict($i) = $aArray[$i]
    Next

    _Log($oDict, 'Create Dict From Array: ')

    Return $oDict

EndFunc   ;==>Dict_FromArr


#cs | TESTING | =============================================

	Name				TDict_FromArr

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_FromArr()

    

    Local $aArray[4] = ['adad1', 'adad2', 'adad3', 'adad4']

    Dict_FromArr($aArray)

EndFunc   ;==>TDict_FromArr




#cs | FUNCTION | ============================================

	Name				Dict_ToArray
	Desc				Create a normal array from an associative array

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name				Dict_ToArray
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func Dict_ToArray(ByRef $oDict)
    Local $aReturn[1]

    $bLogPauser	=	True
    $i = 0
    While 1

        If Dict_Exists($oDict, $i) Then

            ReDim $aReturn[$i+2]
            $aReturn[$i] = $oDict($i)

            $i+=1

        ElseIf Dict_Exists($oDict, String($i)) Then

            ReDim $aReturn[$i+2]
            $aReturn[$i] = $oDict(string($i))

            $i+=1

        Else
            ExitLoop
        EndIf

    WEnd

    If $i >= 1 Then
        ReDim $aReturn[$i]
    Else
        ReDim $aReturn[1]
    EndIf

    $bLogPauser	=	False
    _Log($aReturn, 'Create Array From Dict: ')

    Return $aReturn

EndFunc   ;==>Dict_ToArray


#cs | TESTING | =============================================

	Name				TDict_ToArray

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/25/2016

#ce	=========================================================

Func TDict_ToArray()

    $oDict = Dict()

    $oDict(0) = "val1"
    $oDict("1") = "val2"

    $aArray = Dict_ToArray($oDict)

EndFunc   ;==>TDict_ToArray




#cs | TESTING | =============================================

	Name				TTDict_TwoDArray
	Author				Asror Zakirov (aka Asror.Z)
	Created				5/16/2016

#ce	=========================================================

Func TDict_TwoDArray()
    

    Local $aDriveList[6]

    For $i = 0 To 5
        $oDict = Dict()

        $oDict('InterfaceType') = '11111'		; IDE
        $oDict('222222222') = '333333333'		; IDE
		
		$aDriveList[$i] = $oDict
		
    Next

	
	_Log($aDriveList, '$aDriveList')
	
	
EndFunc   ;==>TTDict_TwoDArray
