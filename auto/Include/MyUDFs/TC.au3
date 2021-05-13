#include-once
#include <MsgBoxConstants.au3>
#include <GuiListBox.au3>
#include <GuiConstantsEx.au3>
#include <File.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\SysConsts.au3>


Global $UDFName 	= 	'TC'

; Global $LogToBoth	=	True


#cs | CURRENT | =============================================

	$cTC_MyListBox_Left
	$cTC_MyListBox_Rigth
	$cTC_PathPanel_Left
	$cTC_PathPanel_Right
	$cTC_MyListBox_Left_Nm
	$cTC_MyListBox_Rigth_Nm

	_TC_Execute
	_TC_ListB_SetFocus
	_TC_ListB_GetFocus
	_TC_ListB_GetHandle
	_TC_ListB_ExtractText
	_TC_ListB_GetCount
	_TC_ListB_GetAllItems
	_TC_ListB_GetTextUnderCaret
	_TC_ListB_GetSelectedItems
	_TC_PathP_GetText
	_TC_PathP_GetHandle

#ce	=========================================================




#Region Variable

    ; BK: Variable

    Global Const $cTC_MyListBox_Left  = '[CLASSNN:TMyListBox2]'
    Global Const $cTC_MyListBox_Rigth  = '[CLASSNN:TMyListBox1]'

    Global Const $cTC_PathPanel_Left  = '[CLASSNN:TPathPanel1]'
    Global Const $cTC_PathPanel_Right  = '[CLASSNN:TPathPanel2]'



    Global Const $cTC_MyListBox_Left_Wn  = '[CLASSNN:LCLListBox2]'
    Global Const $cTC_MyListBox_Rigth_Wn  = '[CLASSNN:LCLListBox1]'

    Global Const $cTC_PathPanel_Left_Wn  = '[CLASSNN:Window13]'
    Global Const $cTC_PathPanel_Right_Wn  = '[CLASSNN:Window18]'
		

#EndRegion Variable


#Region Example

    If @ScriptName = $UDFName & '.au3' Then

       ; T_TC_Win_IsActive()

         T_TC_ListB_GetFocus()
        ;    T_TC_ListB_GetAllItems()
        ; ; T_TC_ListB_GetCount()
      ;  T_TC_PathP_GetText()
       ; T_TC_ListB_GetSelectedItems()
        ;     T_TC_ListB_GetTextUnderCaret()

    EndIf

#EndRegion Example







#cs | TESTING | =============================================

	Name				T_TC_ListB_SetFocus
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================



Func T_TC_ListB_SetFocus()
    

    $s_TC_ListB_GetFocusItem	= _TC_ListB_GetFocus()
    _TC_ListB_SetFocus($cTC_PathPanel_Left)


EndFunc   ;==>T_TC_ListB_SetFocus

#cs | FUNCTION | ============================================

	Name				_TC_ListB_SetFocus

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _TC_ListB_SetFocus ($vCtrlHandle)
    

    _TC_Win_Activate()

    If Not ControlFocus(_TC_Win_GetHandle(), "", $vCtrlHandle) Then
        ExitBox('Cannot Set Focus to ' & $vCtrlHandle)
    Else
        _Log('Set Focus to: ' & $vCtrlHandle)
    EndIf

EndFunc   ;==>_TC_ListB_SetFocus





#cs | TESTING | =============================================

	Name				T_TC_ListB_GetFocus
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_TC_ListB_GetFocus()
    

    Mbox(_TC_ListB_GetFocus())
    Mbox(_TC_PathP_GetText())

EndFunc   ;==>T_TC_ListB_GetFocus

#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetFocus

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _TC_ListB_GetFocus ()
    

    $sFocusedHandle = ControlGetFocus(_TC_Win_GetHandle())

	; Mbox($sFocusedHandle)
    If $sFocusedHandle = '' Then
        ExitBox('Nothing Focused Now! ' & @CRLF & 'Please switch to TC')

    EndIf

	$sFocusedHandle = '[CLASSNN:'& $sFocusedHandle &']'
    _Log('Focused Handle: ' & $sFocusedHandle)
	
    Return $sFocusedHandle

EndFunc   ;==>_TC_ListB_GetFocus





#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetHandle

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_GetHandle ()
    
    Local $hLB = ControlGetHandle(_TC_Win_GetHandle(), "", _TC_ListB_GetFocus())
; Mbox($hLB)
    If @error Or Not $hLB Then ExitBox ('Cannot Get Control Handle')

    Return $hLB

EndFunc   ;==>_TC_ListB_GetHandle



#cs | TESTING | =============================================

	Name				T_TC_ListB_ExtractText
	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func T_TC_ListB_ExtractText()
    
    $sText = 'TC.au3	6 k	22.02.2016 21:53	-a--		'

    _TC_ListB_ExtractText($sText)

EndFunc   ;==>T_TC_ListB_ExtractText

#cs | FUNCTION | ============================================

	Name				_TC_ListB_ExtractText

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_ExtractText($sText)
    

    ; $sText = 'TC.au3	6 k	22.02.2016 21:53	-a--		'

    $sFuncPattern = '(.*?)\t.*'

    $aRes = StringRegExp($sText, $sFuncPattern , 3)

    If @error Then ExitBox('StringRegExp Error! sText: ' & $sText)
    _Log($aRes[0], 'Extracted Text' )

    Return $aRes[0]

EndFunc   ;==>_TC_ListB_ExtractText



#cs | TESTING | =============================================

	Name				T_TC_ListB_GetCount
	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func T_TC_ListB_GetCount()
    

    Mbox(_TC_ListB_GetCount())

EndFunc   ;==>T_TC_ListB_GetCount

#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetCount

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_GetCount ()
    

    Local $hLB		=	_TC_ListB_GetHandle()

    Local $iCnt = _GUICtrlListBox_GetCount($hLB)
    If $iCnt = -1 Then ExitBox('_GUICtrlListBox_GetCount Error')

    $iCnt = $iCnt - 1

    _Log($iCnt, 'Count of items: ')

    Return $iCnt
EndFunc   ;==>_TC_ListB_GetCount




#cs | TESTING | =============================================

	Name				T_TC_ListB_GetAllItems
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_TC_ListB_GetAllItems()
    

    _ArrayDisplay(_TC_ListB_GetAllItems ())
    _ArrayDisplay(_TC_ListB_GetAllItems (True))

EndFunc   ;==>T_TC_ListB_GetAllItems

#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetAllItems

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_GetAllItems ($bFullPath = False)
    

    Local $hLB		=	_TC_ListB_GetHandle()
    Local $iCnt = _TC_ListB_GetCount ()

    Local $aResult[$iCnt+1], $sTempText
    Local $sPP_Text	=	_TC_PathP_GetText()

    $aResult[0] = $iCnt

    For $i = 1 To $iCnt
        $sTempText	=	_GUICtrlListBox_GetText($hLB, $i)
        $sTempText = _TC_ListB_ExtractText($sTempText)

        If $bFullPath Then
            $aResult[$i] = $sPP_Text & $sTempText
        Else
            $aResult[$i] = $sTempText
        EndIf

    Next

    _Log($aResult, 'Gotten Texts')

    Return $aResult

EndFunc   ;==>_TC_ListB_GetAllItems






#cs | TESTING | =============================================

	Name				T_TC_ListB_GetTextUnderCaret
	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func T_TC_ListB_GetTextUnderCaret()
    

    Mbox(_TC_ListB_GetTextUnderCaret ())
    Mbox(_TC_ListB_GetTextUnderCaret (True))

EndFunc   ;==>T_TC_ListB_GetTextUnderCaret

#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetTextUnderCaret

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_GetTextUnderCaret ($bFullPath = False)
    

    Local $hLB		=	_TC_ListB_GetHandle()

    Local $iIndex 		= 	_GUICtrlListBox_GetCaretIndex($hLB)
    Local $sTempText	=	_GUICtrlListBox_GetText($hLB, $iIndex)
    Local $sPP_Text		=	_TC_PathP_GetText()

    $sTempText 	= 	_TC_ListB_ExtractText($sTempText)

    If Not $bFullPath Then Return $sTempText

    Return $sPP_Text & $sTempText

EndFunc   ;==>_TC_ListB_GetTextUnderCaret




#cs | TESTING | =============================================

	Name				T_TC_ListB_GetSelectedItems
	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func T_TC_ListB_GetSelectedItems()
    


    _ArrayDisplay(_TC_ListB_GetSelectedItems())
    _ArrayDisplay(_TC_ListB_GetSelectedItems(True))

EndFunc   ;==>T_TC_ListB_GetSelectedItems

#cs | FUNCTION | ============================================

	Name				_TC_ListB_GetSelectedItems

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_ListB_GetSelectedItems ($bFullPath = False)
    

    Local $hLB		=	_TC_ListB_GetHandle()
    Local $aArr = _GUICtrlListBox_GetSelItemsText ($hLB)

    Local $iCnt = UBound($aArr)

    Local $aResult[$iCnt], $sTempText
    Local $sPP_Text	=	_TC_PathP_GetText()

    $aResult[0] = $aArr[0]

    For $i = 1 To $iCnt-1
        $sTempText	=	$aArr[$i]
        $sTempText 	= 	_TC_ListB_ExtractText($sTempText)

        If $bFullPath Then
            $aResult[$i] = $sPP_Text & $sTempText
        Else
            $aResult[$i] = $sTempText
        EndIf
    Next

    _Log($aResult, 'Selected Items')

    Return $aResult

EndFunc   ;==>_TC_ListB_GetSelectedItems












#cs | TESTING | =============================================

	Name				T_TC_PathP_GetText
	Author				Asror Zakirov (aka Asror.Z)
	Created				23.02.2016

#ce	=========================================================

Func T_TC_PathP_GetText()
    

    Mbox(_TC_PathP_GetText(), 'Active')
    Mbox(_TC_PathP_GetText())
    Mbox(_TC_PathP_GetText(False), 'Opposite')

EndFunc   ;==>T_TC_PathP_GetText

#cs | FUNCTION | ============================================

	Name				_TC_PathP_GetText

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_PathP_GetText ($bActive = True)

    

    Local $sText = ControlGetText(_TC_Win_GetHandle(), "", _TC_PathP_GetHandle($bActive))

    $sText = StringReplace($sText, "*.*", "")

    _Log($sText, (($bActive) ? 'Active' : 'Opposite') & ' Path Panel Text: ')

    Return $sText

EndFunc   ;==>_TC_PathP_GetText






#cs | INTERNAL FUNCTION | ===================================

	Name				_TC_PathP_GetHandle

	Author				Asror Zakirov (aka Asror.Z)
	Created				22.02.2016

#ce	=========================================================

Func _TC_PathP_GetHandle ($bActive = True)
    


    Local $hFocus	=	_TC_ListB_GetFocus()
    Local $hFocus	=	_TC_ListB_GetFocus()
    Local $sPP_HandleStr

    ; BK: _TC_PathP_GetHandle

    Select
        Case ControlGetHandle(_TC_Win_GetHandle(), '', $cTC_PathPanel_Left)

            Switch $hFocus
                Case $cTC_MyListBox_Left
                    $sPP_HandleStr = ($bActive) ? $cTC_PathPanel_Left : $cTC_PathPanel_Right

                Case $cTC_MyListBox_Rigth
                    $sPP_HandleStr = ($bActive) ? $cTC_PathPanel_Right : $cTC_PathPanel_Left

            EndSwitch


        Case ControlGetHandle(_TC_Win_GetHandle(), '', $cTC_PathPanel_Left_Wn)

            Switch $hFocus
                Case $cTC_MyListBox_Left_Wn
                    $sPP_HandleStr = ($bActive) ? $cTC_PathPanel_Left_Wn : $cTC_PathPanel_Right_Wn

                Case $cTC_MyListBox_Rigth_Wn
                    $sPP_HandleStr = ($bActive) ? $cTC_PathPanel_Right_Wn : $cTC_PathPanel_Left_Wn

            EndSwitch

        Case Else
            ExitBox('TC Application is not running!')
    EndSelect

    _Log($sPP_HandleStr, '$sPP_HandleStr')

    Local $hPP_Handle 	=	ControlGetHandle(_TC_Win_GetHandle(), '', $sPP_HandleStr)

    _Log($hPP_Handle, '$hPP_Handle')

    Return $hPP_Handle
EndFunc   ;==>_TC_PathP_GetHandle








#cs | FUNCTION | ============================================

	Name				_TC_Win_GetHandle

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _TC_Win_GetHandle ()
    
    Local $s_TC_Class	=	'[CLASS:TTOTAL_CMD]'

    If Not WinExists($s_TC_Class) Then ExitBox('TC Window Not Exists')

    Local $hTC_Handle	=	WinGetHandle($s_TC_Class)
    _Log($hTC_Handle, '$hTC_Handle')

	;	Mbox($hTC_Handle)
	
    Return $hTC_Handle
EndFunc   ;==>_TC_Win_GetHandle




#cs | FUNCTION | ============================================

	Name				_TC_Win_Activate

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _TC_Win_Activate ()
    

    If Not WinActivate(_TC_Win_GetHandle()) Then ExitBox('Cannot Activate TC Window')

    _Log('TC Win Activated')

EndFunc   ;==>_TC_Win_Activate





#cs | TESTING | =============================================

	Name				T_TC_Win_IsActive
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func T_TC_Win_IsActive()
    

    _TC_Win_IsActive()

EndFunc   ;==>T_TC_Win_IsActive

#cs | FUNCTION | ============================================

	Name				_TC_Win_IsActive

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _TC_Win_IsActive ()
    

    Local $bIsActive 	=	WinActive(_TC_Win_GetHandle())
    _Log($bIsActive, '$bIsActive')

    Return $bIsActive

EndFunc   ;==>_TC_Win_IsActive





