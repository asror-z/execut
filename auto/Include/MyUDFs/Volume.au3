#include <WinAPI.au3>
#include <GuiSlider.au3>
#include <MyUDFs\Log.au3>
#include-once


Global $UDFName = 'Volume.au3'


OnAutoItExitRegister('__VL_VolControl_Close')


#cs | INDEX | ===============================================

	Title				Volume.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/10/2016

#ce	=========================================================



#cs | CURRENT | =============================================

	_VL_Master_Get()
	_VL_Master_Set($Vol)
	_VL_Master_Mute()
	_VL_Get($hWnd)
	_VL_Set($hWnd, $Vol)
	_VL_Mute($hWnd)
	_VL_Enumerate()

#ce	=========================================================

Global $_iECArray2ndDim, $_aECWinList, $_vECControl, $_sECTitle, $_sECClass, $_bECGetTitle, $_iECTitleMatchMode

Global $_VolMix = 'Микшер громкости'

Global $iOldMasterVolume, $bIsMuted = False




#Region Example

    If @ScriptName = $UDFName Then

       ; T_VL_Master_Get()
       ; T_VL_Master_Set()
        T_VL_Master_Mute()
       ; T_VL_Set()
       ; T_VL_Get()
       ; T_VL_Mute()
       ; T_VL_Enumerate()

    EndIf

#EndRegion Example





#cs | INTERNAL FUNCTION | ===================================

	Name				__VL_VolControl_Close

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/11/2016

#ce	=========================================================

Func __VL_VolControl_Close()
    

    If WinClose($_VolMix) Then _Log('VolControl Closed!')

EndFunc   ;==>__VL_VolControl_Close




#cs | INTERNAL FUNCTION | ===================================

	Name				__VL_VolControl_Open
						Opens or closes the Volume Mixer

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/11/2016

#ce	=========================================================

Func __VL_VolControl_Open()
    

    If Not ProcessExists('SndVol.exe') Then Run('SndVol.exe')

    WinWait($_VolMix, '', 20)

    If Not WinActivate($_VolMix) Then
        ExitBox('Cannot activate VolControl Window')
    Else
        _Log('VolControl opened!')
    EndIf

EndFunc   ;==>__VL_VolControl_Open




#cs | FUNCTION | ============================================

	Name            _VL_Master_Get
	Description     Gets the master volume

	Parameters      None

	Return values   Success      - Returns current master volume, 0 to 100
				   Failure      - None...?

	Remarks

#ce	=========================================================

Func _VL_Master_Get()
    

    __VL_VolControl_Open()

    Local $Tmp = __VL_EnumChildWindows($_VolMix)
    $hWnd = ControlGetHandle($_VolMix, '', $Tmp[$Tmp[0][0] - 3][1] & $Tmp[$Tmp[0][0] - 3][3])

    Local $iVolume	=	100 - _GUICtrlSlider_GetPos($hWnd)
    _Log('Get Volume Master | ' & $iVolume)

	__VL_VolControl_Close()
    Return ($iVolume)

EndFunc   ;==>_VL_Master_Get


#cs | TESTING | =============================================

	Name				T_VL_Master_Get

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Master_Get()

    ;Open the Volume Mixer.
    __VL_VolControl_Open()


    ;Example 1, Working with the master volume.
    $OldMaster = _VL_Master_Get()
    For $i = 0 To 100 Step 20
        _VL_Master_Set($i)
        _Log(_VL_Master_Get() & @CRLF)
    Next
    Sleep(840)
    _VL_Master_Set($OldMaster)

EndFunc   ;==>T_VL_Master_Get




#cs | FUNCTION | ============================================

	Name				_VL_Master_Set
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func _VL_Master_Set($Vol)
    

    __VL_VolControl_Open()

    Local $Tmp = __VL_EnumChildWindows($_VolMix)
    Local $hWnd = ControlGetHandle($_VolMix, '', $Tmp[$Tmp[0][0] - 3][1] & $Tmp[$Tmp[0][0] - 3][3])

    Local $iVolume	=	100 - $Vol
    _Log('Set Volume Master | ' & $iVolume)

    _GUICtrlSlider_SetPos($hWnd, $iVolume)

    ControlSend($_VolMix, '', $hWnd, '{Down}{Up}')

    __VL_VolControl_Close()

EndFunc   ;==>_VL_Master_Set


#cs | TESTING | =============================================

	Name				T_VL_Master_Set

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Master_Set()

    __VL_VolControl_Open()

    ;Example 1, Working with the master volume.
    $OldMaster = _VL_Master_Get()
    _VL_Master_Set(0)
    Sleep(2000)
    _VL_Master_Set($OldMaster)

EndFunc   ;==>T_VL_Master_Set




#cs | FUNCTION | ============================================

	Name            _VL_Master_Mute
	Description     Mutes the master volume

	Parameters      None

	Return values   Success      - None   ?
				   Failure      - None...?

	Remarks

#ce	=========================================================

Func _VL_Master_Mute()
    

    __VL_VolControl_Open()

    Local $Tmp = __VL_EnumChildWindows($_VolMix)
    Local $hWnd = ControlGetHandle($_VolMix, '', $Tmp[$Tmp[0][0] - 2][1] & $Tmp[$Tmp[0][0] - 2][3])

    If ControlClick($_VolMix, '', $hWnd) Then _Log('Muted')

    __VL_VolControl_Close()

EndFunc   ;==>_VL_Master_Mute


#cs | TESTING | =============================================

	Name				T_VL_Master_Mute

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Master_Mute()

    _Log('_VL_Master_Mute()')

EndFunc   ;==>T_VL_Master_Mute




#cs | FUNCTION | ============================================

	Name            _VL_Get
	Description     Get the volume of a specific program

	Parameters      $hWnd - Window title or handle to a Volume Bar control returned by _VL_Enumerate ([n][2])

	Return values   Success      - Returns current volume, 0 to 100
				   Failure      - Returns 0 and sets @error to 1.

	Remarks

#ce	=========================================================

Func _VL_Get($hWnd)
    

    If Not IsHWnd($hWnd) Then $hWnd = __VL_FindControl($hWnd)
    If $hWnd = 0 Then Return SetError(1, 0, 0)

    Local $iVolume	=	100 - _GUICtrlSlider_GetPos($hWnd)
    __VL_VolControl_Close()

    Return $iVolume


EndFunc   ;==>_VL_Get




#cs | FUNCTION | ============================================

	Name            _VL_Master_Get
	Description     Gets the master volume

	Parameters      None

	Return values   Success      - Returns current master volume, 0 to 100
				   Failure      - None...?

	Remarks

#ce	=========================================================





#cs | FUNCTION | ============================================

	Name            _VL_Set
	Description     Set the volume of a specific program

	Parameters      $hWnd - Window title or handle to a Volume Bar control returned by _VL_Enumerate ([n][2])
				   $Vol  - Volume to be set, should be between 0 to 100.

	Return values   Success      - Returns 1
				   Failure      - Returns 0 and sets @error to 1.

	Remarks

#ce	=========================================================

Func _VL_Set($hWnd, $Vol)
    

    If Not IsHWnd($hWnd) Then $hWnd = __VL_FindControl($hWnd)

    If $hWnd = 0 Then Return SetError(1, 0, 0)
    $Vol = 100 - $Vol
    _GUICtrlSlider_SetPos($hWnd, $Vol)
    ControlSend($_VolMix, '', $hWnd, '{Down}{Up}')

    __VL_VolControl_Close()

EndFunc   ;==>_VL_Set


#cs | TESTING | =============================================

	Name				T_VL_Set

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Set()

    


    ;Example 2, working with a specific program.
    $Sys = _VL_Get('System Sounds')
    _VL_Set('System Sounds', 50)
    Sleep(840)
    _VL_Set('System Sounds', $Sys)

EndFunc   ;==>T_VL_Set


#cs | TESTING | =============================================

	Name				T_VL_Get

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Get()

    _Log('_VL_Get($hWnd)')

EndFunc   ;==>T_VL_Get




#cs | FUNCTION | ============================================

	Name            _VL_Mute
	Description     Mute a specific program

	Parameters      $hWnd - Window title or handle to a Mute button control returned by _VL_Enumerate ([n][3])

	Return values   Success      - Returns 1
				   Failure      - Returns 0 and sets @error to 1.

	Remarks

#ce	=========================================================

Func _VL_Mute($hWnd)
    

    If Not IsHWnd($hWnd) Then $hWnd = __VL_FindControl($hWnd, 1)
    ControlClick($_VolMix, '', $hWnd)

    __VL_VolControl_Close()

EndFunc   ;==>_VL_Mute


#cs | TESTING | =============================================

	Name				T_VL_Mute

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Mute()

    _Log('_VL_Mute($hWnd)')

EndFunc   ;==>T_VL_Mute




#cs | FUNCTION | ============================================

	Name            _VL_Enumerate
	Description     Get a list of all programs from the Volume Mixer window

	Parameters      None

	Return values   Success      - 	Returns a 2D array in the following format
		[0][0] = Total Programs.
		[n][0] = Full Window Title.
		[n][1] = Volume Bar control ID (msctls_trackbar321).
		[n][2] = Handle to Volume Track Bar Control (can be used with _VL_Set and _VL_Get)
		[n][3] = Mute button control ID (ToolbarWindow321).
		[n][4] = Current Volume.
				   Failure      - 0 and sets @Error to 1.

	Remarks

#ce	=========================================================

Func _VL_Enumerate()
    

    Local $aProgs[1][5] = [[0, 'Volume Bar control ID', 'Volume Bar Handle','Mute button control ID', 'Current Volume']], $Title = $_VolMix
    $Tmp = __VL_EnumChildWindows($Title)

    $U = UBound($aProgs)
    ReDim $aProgs[$U + 1][5]
    $aProgs[0][0] += 1
    $aProgs[$U][0] = 'Master Volume' ;This is superficial, do not try and call _VL_Set('Master Volume)!
    $aProgs[$U][1] = $Tmp[$Tmp[0][0] - 3][1] & $Tmp[$Tmp[0][0] - 3][3]
    $aProgs[$U][2] = ControlGetHandle($_VolMix, '', $aProgs[$U][1]) ;Handle to Volume Track Bar Control.
    $aProgs[$U][3] = $Tmp[$Tmp[0][0] - 2][1] & $Tmp[$Tmp[0][0] - 2][3]
    $aProgs[$U][4] = 100 - _GUICtrlSlider_GetPos(ControlGetHandle($_VolMix, '', $aProgs[$U][1]))

    For $x = 1 To $Tmp[0][0]
        If StringInStr($Tmp[$x][4], 'Volume for') Then
            $aProgs[0][0] += 1
            $U = $aProgs[0][0]
            ReDim $aProgs[$U + 1][5]
            $aProgs[$U][0] = $Tmp[$x - 1][4] ;Window title.
            $aProgs[$U][1] = $Tmp[$x + 1][1] & $Tmp[$x + 1][3] ;Volume Track Bar Control.
            $aProgs[$U][2] = ControlGetHandle($_VolMix, '', $aProgs[$U][1]) ;Handle to Volume Track Bar Control.
            $aProgs[$U][3] = $Tmp[$x + 2][1] & $Tmp[$x + 2][3] ;Mute button.
            $aProgs[$U][4] = 100 - _GUICtrlSlider_GetPos($aProgs[$U][2]) ;Current Volume (0 is max)
            $x += 2
        EndIf
    Next
    If $aProgs[0][0] = 0 Then ExitBox('There is nothing!')

    Return $aProgs

EndFunc   ;==>_VL_Enumerate


#cs | TESTING | =============================================

	Name				T_VL_Enumerate

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func T_VL_Enumerate()

    


    __VL_VolControl_Open()

    ;Example 3, working with all.
    $aProgs = _VL_Enumerate()
    For $i = 2 To $aProgs[0][0]
        _VL_Set($aProgs[$i][2], 50)  ;Set new volume.
        _Log($aProgs[$i][0] & ' - ' & _VL_Get($aProgs[$i][2]) & @CRLF)
    Next
    Sleep(840)
    For $i = 2 To $aProgs[0][0]
        _VL_Set($aProgs[$i][2], $aProgs[$i][4]) ;Reset to original.
        _Log($aProgs[$i][0] & ' - ' & _VL_Get($aProgs[$i][2]) & @CRLF)
    Next


EndFunc   ;==>T_VL_Enumerate




#cs | FUNCTION | ============================================

	Name            __VL_FindControl
	Description     Retrieves the handle for the Volume Bar control ID or Mute button control ID

	Parameters      $hWnd - Window title or class
					$T    - If set to 0 then will return the handle to the Volume Bar, otherwise it will return the handle to the Mute button for that program.

	Return values   Success      - Returns a handle

	Remarks         The volume mixer will not always contain the full titles of the program you're searching for

#ce	=========================================================

Func __VL_FindControl($WindowTitle, $T = 0)
    

    __VL_VolControl_Open()

    Local $Tmp = __VL_EnumChildWindows($_VolMix)
    For $x = 1 To $Tmp[0][0]
        If $Tmp[$x][4] = 'Volume for ' & $WindowTitle Then
            If Not $T = 0 Then $x += 1 ;Get mute button instead of track bar!
            __VL_VolControl_Close()
            Return ControlGetHandle($_VolMix, '', $Tmp[$x + 1][1] & $Tmp[$x + 1][3])
        EndIf
    Next

    ;If failed then get full window title and try again.
    $WindowTitle = WinGetTitle($WindowTitle)
    For $x = 1 To $Tmp[0][0]
        If $Tmp[$x][4] = 'Volume for ' & $WindowTitle Then
            If Not $T = 0 Then $x += 1 ;Get mute button instead of track bar!
            __VL_VolControl_Close()
            Return ControlGetHandle($_VolMix, '', $Tmp[$x + 1][1] & $Tmp[$x + 1][3])
        EndIf
    Next

    __VL_VolControl_Close()
    ExitBox('Cannot find control handle!')

EndFunc   ;==>__VL_FindControl




#cs | FUNCTION | ============================================

	Name				__VL_EnumChildWindows
		Credits to Ascend4nt for the following two functions, without them this UDF would not be possible!

	Function to Enumerate child windows using API call (and callback routine)

	- If $vControl is set to the Control Handle (NOT ID) of a Control, ONLY that item is searched for
	  (it will return the iteration and class, useful for identification in the future using [CLASSname	INSTANCE##]
	- If $sTitle is set, it will search for controls that return something on WinGetTitle() that match
	- If $sClass is set, it will only search for items of a given class. This can be combined with $sTitle, but
	  it's not recommended
	NOTE Iteration numbering is dependent on what is passed   See parameters
	$vWnd = Handle to window, or Title (see special definitions documentation for WinGetHandle())
	$vControl = (optional) Handle to control to find.  This will return only one match, but sets the iteration count and the rest
	$sTitle = (optional) Title to search for. This can be direct match, a substring, or a PCRE (see $iTitleMatchMode)
	NOTES: setting this to "" will make the routine search for windows *without* titles. Set to non-string (default) to match any
	  Also, no iteration count is kept for this unless $sClass is also set
	$sClass = (optional) Classname to look for   This WILL produce iteration counts
	$iTitleMatchMode = mode of matching title:
	0 = default match string (not case sensitive)
	1 = match substring
	2 = match regular expression
	$bAllIterationCounts = If True (default), get iteration counts for all classnames
	This will fail of course if $vControl, $sTitle, or $sClass is passed
	$bGetTitle = If True, grabs the title/text of the control/child window

	Returns:
	Success: An array set up as follows (also @extended=#of colummns)
		[0][0] = count of items (0 means nothing found), set up as follows:
		[$i][0] = Child Window/Control Handle
		[$i][1] = Class name
		[$i][2] = Control ID - This is good to have for sending/posting messages.
				  NOTE: This will be 0 for some controls, and -1 for others when they don't have an official ID #
		[$i][3] = Instance count (if applicable - see above)
	  Also, *IF* $bGetTitle=True, then:
		[$i][4] = Title/Text from control
	Failure: "" is returned with @error set:

#ce	=========================================================

Func __VL_EnumChildWindows($vWnd, $vControl = 0, $sTitle = 0, $sClass = 0, $iTitleMatchMode = 0, $bAllIterationCounts = True, $bGetTitle = True)
    

    $LoggerStop	=	True

    Local $hCBReg, $aWinArray, $iErr, $i, $iIn, $iIteration, $sTmpClass

    If Not IsHWnd($vWnd) Then $vWnd = WinGetHandle($vWnd)
    ; I don't know that there are empty-string classes, so for now, we'll treat empty strings as do-not-search
    If $sClass = "" Then $sClass = 0

    $_iECArray2ndDim = 4
    If $bGetTitle Then $_iECArray2ndDim += 1

    ; Setup the winlist array
    Dim $_aECWinList[10 + 1][$_iECArray2ndDim]
    $_aECWinList[0][0] = 0
    ; Current-array-size count (used in ReDim'ing array inside the callback)
    $_aECWinList[0][1] = 10

    ; Control Handle received? We will only find one match, so let's grab everything except the iteration count now
    If IsHWnd($vControl) Then
        ; Grab classname now
        If Not IsString($sClass) Then $sClass = _WinAPI_GetClassName($vControl)
        $_aECWinList[1][0] = $vControl
        $_aECWinList[1][1] = $sClass ; no need to repeat this
        ; Set the Control ID # (GWL_ID = -12)
        $_aECWinList[1][2] = _WinAPI_GetWindowLong($vControl, -12)
        $_aECWinList[1][3] = 0 ; Set the instance count (if searching for a specific handle)
        ; Set the title/text of control/window (ControlGetText is an option but won't work for non-control child windows..)
        If $bGetTitle Then $_aECWinList[1][4] = WinGetTitle($vControl) ; or ControlGetText($vWnd,"",$vControl)
    EndIf

    ; Set the required callback parameters (except $_iECArray2ndDim, set above due to initialization of array)
    $_bECGetTitle = $bGetTitle
    $_iECTitleMatchMode = $iTitleMatchMode
    $_sECClass = $sClass
    $_sECTitle = $sTitle
    $_vECControl = $vControl
    $_iECCtrlIteration = 0

    $hCBReg = DllCallbackRegister("__VL_EnumChildWinProc", "int", "hwnd;lparam")
    If $hCBReg = 0 Then ExitBox('error setting up callback proc (@extended= error # from DllCallbackRegister)')

    _Log("On entry, $vWnd:"&$vWnd&" $vControl:"&$vControl&" $sTitle: '"&$sTitle&"' $sClass: '"&$sClass&"'")

    ; BOOL EnumChildWindows(_in HWND hWndParent,_in WNDENUMPROC lpEnumFunc,_in LPARAM lParam);
    $aRet = DllCall("user32.dll", "int", "EnumChildWindows", "hwnd", $vWnd, "ptr", DllCallbackGetPtr($hCBReg), "lparam", 101)
    $iErr = @error
    DllCallbackFree($hCBReg)
    If $iErr Then ExitBox('Enumeration API call failed (@extended = error returned from DLLCall)')
    ReDim $_aECWinList[$_aECWinList[0][0] + 1][$_iECArray2ndDim]
    $aWinArray = $_aECWinList
    $aWinArray[0][1] = ""
    $_aECWinList = ""
    ; Set all iterations? *Only if $bAllIterationCounts=True, AND *ALL* child windows are enumerated.*
    If $bAllIterationCounts And $aWinArray[0][0] And $sClass = "" And Not IsString($sTitle) And Not IsHWnd($vControl) Then
        For $i = 0 To $aWinArray[0][0]
            ; Found an empty iteration count?
            If Not $aWinArray[$i][3] Then
                $iIteration = 1
                $aWinArray[$i][3] = 1
                $sTmpClass = $aWinArray[$i][1]
                For $iIn = $i + 1 To $aWinArray[0][0]
                    If $aWinArray[$iIn][1] = $sTmpClass Then
                        $iIteration += 1
                        $aWinArray[$iIn][3] = $iIteration
                    EndIf
                Next
            EndIf
        Next
    EndIf
    _Log("Child Window array size on exit:"&$aWinArray[0][0])
    $LoggerStop	=	False

    Return SetError(0, $_iECArray2ndDim, $aWinArray)

EndFunc   ;==>__VL_EnumChildWindows




#cs | FUNCTION | ============================================

	Name				__VL_EnumChildWinProc
	Desc				
						Do *NOT* call this directly!!
	MSDN:  BOOL CALLBACK EnumChildProc(_in HWND hwnd,_in LPARAM lParam)	

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/10/2016

#ce	=========================================================

Func __VL_EnumChildWinProc($hWnd, $lParam)
    

    Local $sClassname, $sTitle

    $LoggerStop	=	True

    $sClassname = _WinAPI_GetClassName($hWnd)
    _Log("hWnd found:"&$hWnd&" Classname:"&$sClassname&" Title:"&WinGetTitle($hWnd))

    ; No match for our classname? Keep searching
    If IsString($_sECClass) And $_sECClass <> $sClassname Then Return True

    ; Classname match AND we are searching for a handle?
    If IsHWnd($_vECControl) Then
        ; Keep this at 1 always
        $_aECWinList[0][0] = 1
        $_aECWinList[1][3] += 1 ; increment iteration/instance count
        ; Have we found it?!
        If $hWnd = $_vECControl Then Return False
        Return True
    EndIf

    If $_bECGetTitle Then $sTitle = WinGetTitle($hWnd) ; basically same as: ControlGetText($_hECMainWnd,"",$vControl)

    ; Either searching only by title, or by title and classname.. check to see if there's a match. If not, skip!

    If IsString($_sECTitle) Then
        ; Prevent duplicate title/text reads
        If Not $_bECGetTitle Then $sTitle = WinGetTitle($hWnd)
        ; If no match in any mode, then continue search (Return True)
        Switch $_iECTitleMatchMode
            Case 0
                If $_sECTitle <> $sTitle Then Return True
            Case 1
                If StringInStr($sTitle, $_sECTitle) = 0 Then Return True
            Case Else
                If StringRegExp($sTitle, $_sECTitle) = 0 Then Return True
        EndSwitch
    EndIf

    ; We are either grabbing all child windows, those matching a title, or a given classname..

    $_aECWinList[0][0] += 1
    If $_aECWinList[0][0] > $_aECWinList[0][1] Then
        $_aECWinList[0][1] += 10
        ReDim $_aECWinList[$_aECWinList[0][1] + 1][$_iECArray2ndDim]
        _Log("Resized array to "&$_aECWinList[0][1]&"+1 (count at bottom) elements, currently AT element #"&$_aECWinList[0][0])
    EndIf
    $_aECWinList[$_aECWinList[0][0]][0] = $hWnd
    $_aECWinList[$_aECWinList[0][0]][1] = $sClassname
    ; Set the Control ID # (GWL_ID = -12)
    $_aECWinList[$_aECWinList[0][0]][2] = _WinAPI_GetWindowLong($hWnd, -12)

    ; Keep iteration counts if looking at a specific classname
    If IsString($_sECClass) Then
        If $_aECWinList[0][0] > 1 Then
            $_aECWinList[$_aECWinList[0][0]][3] = $_aECWinList[$_aECWinList[0][0] - 1][3] + 1
        Else
            $_aECWinList[$_aECWinList[0][0]][3] = 1
        EndIf
    EndIf
    If $_bECGetTitle Then $_aECWinList[$_aECWinList[0][0]][4] = $sTitle

    $LoggerStop	=	False

    Return True

EndFunc   ;==>__VL_EnumChildWinProc

