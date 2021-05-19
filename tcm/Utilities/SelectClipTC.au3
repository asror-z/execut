#include <TrayConstants.au3>

#include <MyUDFs\TC.au3>
#include <MyUDFs\HotKeySetEx.au3>
#include <MyUDFs\FileZ.au3>

#pragma compile(Out, c:\AsrorZ\TCU\SelectClipTC.exe)

TraySetState($TRAY_ICONSTATE_SHOW)
TraySetToolTip('Selection to Clipboard')

_Translate()


#cs | FUNCTION | ============================================

	Name				_Translate

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.03.2016

#ce	=========================================================

Func _Translate ()

    Local $sReturn = 'Core', $sReturnData
    Local $aSelected = _TC_ListB_GetSelectedItems()
    Local $sUnderCaret = _TC_ListB_GetTextUnderCaret()


    If $aSelected[0] <> 0 Then

        For $i = 1 To $aSelected[0]

            $sFileName = $aSelected[$i]

            If ($i = $aSelected[0]) Then
                $sReturnData &= $sFileName
            Else
                $sReturnData &= $sFileName & @CRLF
            EndIf

        Next

        ClipPut($sReturnData)

        $sReturn = $sReturnData

        _Log('Return: ' & $sReturnData)


    Elseif ($sUnderCaret <> '') Then

        ClipPut($sUnderCaret)

        $sReturn = $sUnderCaret

    Else

        $sReturn = "There is no text selection to copy!"

    EndIf
    TrayTip("SelectClipTC", $sReturn, 0, $TIP_ICONASTERISK)

EndFunc   ;==>_Translate



