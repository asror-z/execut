#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>

Global $g_idMemo

Example()

Func Example()
	Local $hGUI, $hFile, $hEdit, $hHelp, $hMain
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idExit, $e_idCut, $e_idCopy, $e_idPaste, $e_idAbout

	; Create GUI
	$hGUI = GUICreate("Menu", 400, 300)

	; Create File menu
	$hFile = _GUICtrlMenu_CreateMenu()
	_GUICtrlMenu_InsertMenuItem($hFile, 0, "&New", $e_idNew)
	_GUICtrlMenu_InsertMenuItem($hFile, 1, "&Open", $e_idOpen)
	_GUICtrlMenu_InsertMenuItem($hFile, 2, "&Save", $e_idSave)
	_GUICtrlMenu_InsertMenuItem($hFile, 3, "", 0)
	_GUICtrlMenu_InsertMenuItem($hFile, 4, "E&xit", $e_idExit)

	; Create Edit menu
	$hEdit = _GUICtrlMenu_CreateMenu()
	_GUICtrlMenu_InsertMenuItem($hEdit, 0, "&Cut", $e_idCut)
	_GUICtrlMenu_InsertMenuItem($hEdit, 1, "C&opy", $e_idCopy)
	_GUICtrlMenu_InsertMenuItem($hEdit, 2, "&Paste", $e_idPaste)

	; Create Help menu
	$hHelp = _GUICtrlMenu_CreateMenu()
	_GUICtrlMenu_InsertMenuItem($hHelp, 0, "&About", $e_idAbout)

	; Create Main menu
	$hMain = _GUICtrlMenu_CreateMenu()
	_GUICtrlMenu_InsertMenuItem($hMain, 0, "&File", 0, $hFile)
	_GUICtrlMenu_InsertMenuItem($hMain, 1, "&Edit", 0, $hEdit)
	_GUICtrlMenu_InsertMenuItem($hMain, 2, "&Help", 0, $hHelp)

	; Set window menu
	_GUICtrlMenu_SetMenu($hGUI, $hMain)

	; Create memo control
	$g_idMemo = GUICtrlCreateEdit("", 2, 2, 396, 276, 0)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	; Set New menu item to have a bitmap
	_GUICtrlMenu_SetItemBmp($hFile, 0, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 11, 11))
	MemoWrite("Item bitmap handle: 0x" & Hex(_GUICtrlMenu_GetItemBmp($hFile, 0)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Write message to memo
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
