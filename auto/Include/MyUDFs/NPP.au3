#include-once
#include <WindowsConstants.au3>
#include <SendMessage.au3>
#include <MyUDFs\FileZ.au3>


Global $UDFName = 'Npp'


#cs | INDEX | ===============================================

	Title				Npp
	Description	 		Interacts with Notepad++ UDF

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				4/6/2016

#ce	=========================================================


#cs | CURRENT | =============================================

	_NPP_Get_CurrentPath
	_NPP_Get_CurrentFileName
	_NPP_Get_CursorPos
	_NPP_Get_Text
	_NPP_Set_CursorPos
	_NPP_Set_Text
	_NPP_Command

#ce	=========================================================



#Region Const | Main

    Global Const $NPPM_GETCURRENTLINE = 4024 + 8
    Global Const $NPPM_MENUCOMMAND = 2024 + 48

    Global Const $IDM = 40000
    Global Const $IDM_EDIT = ($IDM + 2000)
    Global Const $IDM_FILE = ($IDM + 1000)
    Global Const $IDM_SEARCH = ($IDM + 3000)
    Global Const $IDM_VIEW = ($IDM + 4000)
    Global Const $IDM_FORMAT = ($IDM + 5000)
    Global Const $IDM_LANG = ($IDM + 6000)
    Global Const $IDM_ABOUT = ($IDM + 7000)
    Global Const $IDM_SETTING = ($IDM + 8000)

#EndRegion Const | Main


#Region Const | File

    Global Const $IDM_FILE_NEW = ($IDM_FILE + 1)
    Global Const $IDM_FILE_OPEN = ($IDM_FILE + 2)
    Global Const $IDM_FILE_CLOSE = ($IDM_FILE + 3)
    Global Const $IDM_FILE_CLOSEALL = ($IDM_FILE + 4)
    Global Const $IDM_FILE_CLOSEALL_BUT_CURRENT = ($IDM_FILE + 5)
    Global Const $IDM_FILE_SAVE = ($IDM_FILE + 6)
    Global Const $IDM_FILE_SAVEALL = ($IDM_FILE + 7)
    Global Const $IDM_FILE_SAVEAS = ($IDM_FILE + 8)
    Global Const $IDM_FILE_ASIAN_LANG = ($IDM_FILE + 9)
    Global Const $IDM_FILE_PRINT = ($IDM_FILE + 10)
    Global Const $IDM_FILE_PRINTNOW = 1001
    Global Const $IDM_FILE_EXIT = ($IDM_FILE + 11)
    Global Const $IDM_FILE_LOADSESSION = ($IDM_FILE + 12)
    Global Const $IDM_FILE_SAVESESSION = ($IDM_FILE + 13)
    Global Const $IDM_FILE_RELOAD = ($IDM_FILE + 14)
    Global Const $IDM_FILE_SAVECOPYAS = ($IDM_FILE + 15)
    Global Const $IDM_FILE_DELETE = ($IDM_FILE + 16)
    Global Const $IDM_FILE_RENAME = ($IDM_FILE + 17)

    Global Const $IDM_OPEN_ALL_RECENT_FILE = ($IDM_EDIT + 40)
    Global Const $IDM_CLEAN_RECENT_FILE_LIST = ($IDM_EDIT + 41)

#EndRegion Const | File


#Region Const | Edit

    Global Const $IDM_EDIT_CUT = ($IDM_EDIT + 1)
    Global Const $IDM_EDIT_COPY = ($IDM_EDIT + 2)
    Global Const $IDM_EDIT_UNDO = ($IDM_EDIT + 3)
    Global Const $IDM_EDIT_REDO = ($IDM_EDIT + 4)
    Global Const $IDM_EDIT_PASTE = ($IDM_EDIT + 5)
    Global Const $IDM_EDIT_DELETE = ($IDM_EDIT + 6)
    Global Const $IDM_EDIT_SELECTALL = ($IDM_EDIT + 7)

    Global Const $IDM_EDIT_INS_TAB = ($IDM_EDIT + 8)
    Global Const $IDM_EDIT_RMV_TAB = ($IDM_EDIT + 9)
    Global Const $IDM_EDIT_DUP_LINE = ($IDM_EDIT + 10)
    Global Const $IDM_EDIT_TRANSPOSE_LINE = ($IDM_EDIT + 11)
    Global Const $IDM_EDIT_SPLIT_LINES = ($IDM_EDIT + 12)
    Global Const $IDM_EDIT_JOIN_LINES = ($IDM_EDIT + 13)
    Global Const $IDM_EDIT_LINE_UP = ($IDM_EDIT + 14)
    Global Const $IDM_EDIT_LINE_DOWN = ($IDM_EDIT + 15)
    Global Const $IDM_EDIT_UPPERCASE = ($IDM_EDIT + 16)
    Global Const $IDM_EDIT_LOWERCASE = ($IDM_EDIT + 17)

    Global Const $IDM_EDIT_BLOCK_COMMENT = ($IDM_EDIT + 22)
    Global Const $IDM_EDIT_STREAM_COMMENT = ($IDM_EDIT + 23)
    Global Const $IDM_EDIT_TRIMTRAILING = ($IDM_EDIT + 24)

    Global Const $IDM_EDIT_RTL = ($IDM_EDIT + 26)
    Global Const $IDM_EDIT_LTR = ($IDM_EDIT + 27)
    Global Const $IDM_EDIT_SETREADONLY = ($IDM_EDIT + 28)
    Global Const $IDM_EDIT_FULLPATHTOCLIP = ($IDM_EDIT + 29) ; Отправить полный путь в буфер обмена
    Global Const $IDM_EDIT_FILENAMETOCLIP = ($IDM_EDIT + 30) ; Отправить имя файла в буфер обмена
    Global Const $IDM_EDIT_CURRENTDIRTOCLIP = ($IDM_EDIT + 31)

    Global Const $IDM_EDIT_CLEARREADONLY = ($IDM_EDIT + 33)
    Global Const $IDM_EDIT_COLUMNMODE = ($IDM_EDIT + 34)
    Global Const $IDM_EDIT_BLOCK_COMMENT_SET = ($IDM_EDIT + 35)
    Global Const $IDM_EDIT_BLOCK_UNCOMMENT = ($IDM_EDIT + 36)

    Global Const $IDM_EDIT_AUTOCOMPLETE = (50000 + 0)
    Global Const $IDM_EDIT_AUTOCOMPLETE_CURRENTFILE = (50000 + 1)
    Global Const $IDM_EDIT_FUNCCALLTIP = (50000 + 2)

#EndRegion Const | Edit


#Region Const | Search

    Global Const $IDM_SEARCH_FIND = ($IDM_SEARCH + 1) ; Вызывает диалог поиска
    Global Const $IDM_SEARCH_FINDNEXT = ($IDM_SEARCH + 2)
    Global Const $IDM_SEARCH_REPLACE = ($IDM_SEARCH + 3) ; Вызывает диалог замены
    Global Const $IDM_SEARCH_GOTOLINE = ($IDM_SEARCH + 4)
    Global Const $IDM_SEARCH_TOGGLE_BOOKMARK = ($IDM_SEARCH + 5)
    Global Const $IDM_SEARCH_NEXT_BOOKMARK = ($IDM_SEARCH + 6)
    Global Const $IDM_SEARCH_PREV_BOOKMARK = ($IDM_SEARCH + 7)
    Global Const $IDM_SEARCH_CLEAR_BOOKMARKS = ($IDM_SEARCH + 8)
    Global Const $IDM_SEARCH_GOTOMATCHINGBRACE = ($IDM_SEARCH + 9)
    Global Const $IDM_SEARCH_FINDPREV = ($IDM_SEARCH + 10)
    Global Const $IDM_SEARCH_FINDINCREMENT = ($IDM_SEARCH + 11)
    Global Const $IDM_SEARCH_FINDINFILES = ($IDM_SEARCH + 13)
    Global Const $IDM_SEARCH_VOLATILE_FINDNEXT = ($IDM_SEARCH + 14)
    Global Const $IDM_SEARCH_VOLATILE_FINDPREV = ($IDM_SEARCH + 15)
    Global Const $IDM_SEARCH_CUTMARKEDLINES = ($IDM_SEARCH + 18)
    Global Const $IDM_SEARCH_COPYMARKEDLINES = ($IDM_SEARCH + 19)
    Global Const $IDM_SEARCH_PASTEMARKEDLINES = ($IDM_SEARCH + 20)
    Global Const $IDM_SEARCH_DELETEMARKEDLINES = ($IDM_SEARCH + 21)
    Global Const $IDM_SEARCH_MARKALLEXT1 = ($IDM_SEARCH + 22)
    Global Const $IDM_SEARCH_UNMARKALLEXT1 = ($IDM_SEARCH + 23)
    Global Const $IDM_SEARCH_MARKALLEXT2 = ($IDM_SEARCH + 24)
    Global Const $IDM_SEARCH_UNMARKALLEXT2 = ($IDM_SEARCH + 25)
    Global Const $IDM_SEARCH_MARKALLEXT3 = ($IDM_SEARCH + 26)
    Global Const $IDM_SEARCH_UNMARKALLEXT3 = ($IDM_SEARCH + 27)
    Global Const $IDM_SEARCH_MARKALLEXT4 = ($IDM_SEARCH + 28)
    Global Const $IDM_SEARCH_UNMARKALLEXT4 = ($IDM_SEARCH + 29)
    Global Const $IDM_SEARCH_MARKALLEXT5 = ($IDM_SEARCH + 30)
    Global Const $IDM_SEARCH_UNMARKALLEXT5 = ($IDM_SEARCH + 31)
    Global Const $IDM_SEARCH_CLEARALLMARKS = ($IDM_SEARCH + 32)

#EndRegion Const | Search


#Region Const | View

    Global Const $IDM_VIEW_TOOLBAR_HIDE = ($IDM_VIEW + 1)
    Global Const $IDM_VIEW_TOOLBAR_REDUCE = ($IDM_VIEW + 2)
    Global Const $IDM_VIEW_TOOLBAR_ENLARGE = ($IDM_VIEW + 3)
    Global Const $IDM_VIEW_TOOLBAR_STANDARD = ($IDM_VIEW + 4)
    Global Const $IDM_VIEW_REDUCETABBAR = ($IDM_VIEW + 5)
    Global Const $IDM_VIEW_LOCKTABBAR = ($IDM_VIEW + 6)
    Global Const $IDM_VIEW_DRAWTABBAR_TOPBAR = ($IDM_VIEW + 7)
    Global Const $IDM_VIEW_DRAWTABBAR_INACIVETAB = ($IDM_VIEW + 8)
    Global Const $IDM_VIEW_POSTIT = ($IDM_VIEW + 9)
    Global Const $IDM_VIEW_TOGGLE_FOLDALL = ($IDM_VIEW + 10)
    Global Const $IDM_VIEW_USER_DLG = ($IDM_VIEW + 11)
    Global Const $IDM_VIEW_LINENUMBER = ($IDM_VIEW + 12)
    Global Const $IDM_VIEW_SYMBOLMARGIN = ($IDM_VIEW + 13)
    Global Const $IDM_VIEW_FOLDERMAGIN = ($IDM_VIEW + 14)
    Global Const $IDM_VIEW_FOLDERMAGIN_SIMPLE = ($IDM_VIEW + 15)
    Global Const $IDM_VIEW_FOLDERMAGIN_ARROW = ($IDM_VIEW + 16)
    Global Const $IDM_VIEW_FOLDERMAGIN_CIRCLE = ($IDM_VIEW + 17)
    Global Const $IDM_VIEW_FOLDERMAGIN_BOX = ($IDM_VIEW + 18)
    Global Const $IDM_VIEW_ALL_CHARACTERS = ($IDM_VIEW + 19)
    Global Const $IDM_VIEW_INDENT_GUIDE = ($IDM_VIEW + 20)
    Global Const $IDM_VIEW_CURLINE_HILITING = ($IDM_VIEW + 21)
    Global Const $IDM_VIEW_WRAP = ($IDM_VIEW + 22)
    Global Const $IDM_VIEW_ZOOMIN = ($IDM_VIEW + 23)
    Global Const $IDM_VIEW_ZOOMOUT = ($IDM_VIEW + 24)
    Global Const $IDM_VIEW_TAB_SPACE = ($IDM_VIEW + 25)
    Global Const $IDM_VIEW_EOL = ($IDM_VIEW + 26)
    Global Const $IDM_VIEW_EDGELINE = ($IDM_VIEW + 27)
    Global Const $IDM_VIEW_EDGEBACKGROUND = ($IDM_VIEW + 28)
    Global Const $IDM_VIEW_TOGGLE_UNFOLDALL = ($IDM_VIEW + 29)
    Global Const $IDM_VIEW_FOLD_CURRENT = ($IDM_VIEW + 30)
    Global Const $IDM_VIEW_UNFOLD_CURRENT = ($IDM_VIEW + 31)
    Global Const $IDM_VIEW_FULLSCREENTOGGLE = ($IDM_VIEW + 32)
    Global Const $IDM_VIEW_ZOOMRESTORE = ($IDM_VIEW + 33)
    Global Const $IDM_VIEW_ALWAYSONTOP = ($IDM_VIEW + 34)
    Global Const $IDM_VIEW_SYNSCROLLV = ($IDM_VIEW + 35)
    Global Const $IDM_VIEW_SYNSCROLLH = ($IDM_VIEW + 36)
    Global Const $IDM_VIEW_EDGENONE = ($IDM_VIEW + 37)
    Global Const $IDM_VIEW_DRAWTABBAR_CLOSEBOTTUN = ($IDM_VIEW + 38)
    Global Const $IDM_VIEW_DRAWTABBAR_DBCLK2CLOSE = ($IDM_VIEW + 39)
    Global Const $IDM_VIEW_REFRESHTABAR = ($IDM_VIEW + 40)
    Global Const $IDM_VIEW_WRAP_SYMBOL = ($IDM_VIEW + 41)
    Global Const $IDM_VIEW_HIDELINES = ($IDM_VIEW + 42)
    Global Const $IDM_VIEW_DRAWTABBAR_VERTICAL = ($IDM_VIEW + 43)
    Global Const $IDM_VIEW_DRAWTABBAR_MULTILINE = ($IDM_VIEW + 44)
    Global Const $IDM_VIEW_DOCCHANGEMARGIN = ($IDM_VIEW + 45)

    Global Const $IDM_VIEW_FOLD = ($IDM_VIEW + 50)
    Global Const $IDM_VIEW_FOLD_1 = ($IDM_VIEW_FOLD + 1)
    Global Const $IDM_VIEW_FOLD_2 = ($IDM_VIEW_FOLD + 2)
    Global Const $IDM_VIEW_FOLD_3 = ($IDM_VIEW_FOLD + 3)
    Global Const $IDM_VIEW_FOLD_4 = ($IDM_VIEW_FOLD + 4)
    Global Const $IDM_VIEW_FOLD_5 = ($IDM_VIEW_FOLD + 5)
    Global Const $IDM_VIEW_FOLD_6 = ($IDM_VIEW_FOLD + 6)
    Global Const $IDM_VIEW_FOLD_7 = ($IDM_VIEW_FOLD + 7)
    Global Const $IDM_VIEW_FOLD_8 = ($IDM_VIEW_FOLD + 8)

    Global Const $IDM_VIEW_UNFOLD = ($IDM_VIEW + 60)
    Global Const $IDM_VIEW_UNFOLD_1 = ($IDM_VIEW_UNFOLD + 1)
    Global Const $IDM_VIEW_UNFOLD_2 = ($IDM_VIEW_UNFOLD + 2)
    Global Const $IDM_VIEW_UNFOLD_3 = ($IDM_VIEW_UNFOLD + 3)
    Global Const $IDM_VIEW_UNFOLD_4 = ($IDM_VIEW_UNFOLD + 4)
    Global Const $IDM_VIEW_UNFOLD_5 = ($IDM_VIEW_UNFOLD + 5)
    Global Const $IDM_VIEW_UNFOLD_6 = ($IDM_VIEW_UNFOLD + 6)
    Global Const $IDM_VIEW_UNFOLD_7 = ($IDM_VIEW_UNFOLD + 7)
    Global Const $IDM_VIEW_UNFOLD_8 = ($IDM_VIEW_UNFOLD + 8)


    Global Const $IDM_VIEW_GOTO_ANOTHER_VIEW = 10001
    Global Const $IDM_VIEW_CLONE_TO_ANOTHER_VIEW = 10002
    Global Const $IDM_VIEW_GOTO_NEW_INSTANCE = 10003
    Global Const $IDM_VIEW_LOAD_IN_NEW_INSTANCE = 10004

    Global Const $IDM_VIEW_SWITCHTO_OTHER_VIEW = ($IDM_VIEW + 72)

#EndRegion Const | View

#Region Const | Encoding

    Global Const $IDM_FORMAT_TODOS = ($IDM_FORMAT + 1)
    Global Const $IDM_FORMAT_TOUNIX = ($IDM_FORMAT + 2)
    Global Const $IDM_FORMAT_TOMAC = ($IDM_FORMAT + 3)
    Global Const $IDM_FORMAT_ANSI = ($IDM_FORMAT + 4)
    Global Const $IDM_FORMAT_UTF_8 = ($IDM_FORMAT + 5)
    Global Const $IDM_FORMAT_UCS_2BE = ($IDM_FORMAT + 6)
    Global Const $IDM_FORMAT_UCS_2LE = ($IDM_FORMAT + 7)
    Global Const $IDM_FORMAT_AS_UTF_8 = ($IDM_FORMAT + 8)
    Global Const $IDM_FORMAT_CONV2_ANSI = ($IDM_FORMAT + 9)
    Global Const $IDM_FORMAT_CONV2_AS_UTF_8 = ($IDM_FORMAT + 10)
    Global Const $IDM_FORMAT_CONV2_UTF_8 = ($IDM_FORMAT + 11)
    Global Const $IDM_FORMAT_CONV2_UCS_2BE = ($IDM_FORMAT + 12)
    Global Const $IDM_FORMAT_CONV2_UCS_2LE = ($IDM_FORMAT + 13)

#EndRegion Const | Encoding

#Region Const | Syntax

    Global Const $IDM_LANGSTYLE_CONFIG_DLG = ($IDM_LANG + 1)
    Global Const $IDM_LANG_C = ($IDM_LANG + 2)
    Global Const $IDM_LANG_CPP = ($IDM_LANG + 3)
    Global Const $IDM_LANG_JAVA = ($IDM_LANG + 4)
    Global Const $IDM_LANG_HTML = ($IDM_LANG + 5)
    Global Const $IDM_LANG_XML = ($IDM_LANG + 6)
    Global Const $IDM_LANG_JS = ($IDM_LANG + 7)
    Global Const $IDM_LANG_PHP = ($IDM_LANG + 8)
    Global Const $IDM_LANG_ASP = ($IDM_LANG + 9)
    Global Const $IDM_LANG_CSS = ($IDM_LANG + 10)
    Global Const $IDM_LANG_PASCAL = ($IDM_LANG + 11)
    Global Const $IDM_LANG_PYTHON = ($IDM_LANG + 12)
    Global Const $IDM_LANG_PERL = ($IDM_LANG + 13)
    Global Const $IDM_LANG_OBJC = ($IDM_LANG + 14)
    Global Const $IDM_LANG_ASCII = ($IDM_LANG + 15)
    Global Const $IDM_LANG_TEXT = ($IDM_LANG + 16)
    Global Const $IDM_LANG_RC = ($IDM_LANG + 17)
    Global Const $IDM_LANG_MAKEFILE = ($IDM_LANG + 18)
    Global Const $IDM_LANG_INI = ($IDM_LANG + 19)
    Global Const $IDM_LANG_SQL = ($IDM_LANG + 20)
    Global Const $IDM_LANG_VB = ($IDM_LANG + 21)
    Global Const $IDM_LANG_BATCH = ($IDM_LANG + 22)
    Global Const $IDM_LANG_CS = ($IDM_LANG + 23)
    Global Const $IDM_LANG_LUA = ($IDM_LANG + 24)
    Global Const $IDM_LANG_TEX = ($IDM_LANG + 25)
    Global Const $IDM_LANG_FORTRAN = ($IDM_LANG + 26)
    Global Const $IDM_LANG_SH = ($IDM_LANG + 27)
    Global Const $IDM_LANG_FLASH = ($IDM_LANG + 28)
    Global Const $IDM_LANG_NSIS = ($IDM_LANG + 29)
    Global Const $IDM_LANG_TCL = ($IDM_LANG + 30)
    Global Const $IDM_LANG_LISP = ($IDM_LANG + 31)
    Global Const $IDM_LANG_SCHEME = ($IDM_LANG + 32)
    Global Const $IDM_LANG_ASM = ($IDM_LANG + 33)
    Global Const $IDM_LANG_DIFF = ($IDM_LANG + 34)
    Global Const $IDM_LANG_PROPS = ($IDM_LANG + 35)
    Global Const $IDM_LANG_PS = ($IDM_LANG + 36)
    Global Const $IDM_LANG_RUBY = ($IDM_LANG + 37)
    Global Const $IDM_LANG_SMALLTALK = ($IDM_LANG + 38)
    Global Const $IDM_LANG_VHDL = ($IDM_LANG + 39)
    Global Const $IDM_LANG_CAML = ($IDM_LANG + 40)
    Global Const $IDM_LANG_KIX = ($IDM_LANG + 41)
    Global Const $IDM_LANG_ADA = ($IDM_LANG + 42)
    Global Const $IDM_LANG_VERILOG = ($IDM_LANG + 43)
    Global Const $IDM_LANG_AU3 = ($IDM_LANG + 44) ; Включает синтаксис AutoIt3
    Global Const $IDM_LANG_MATLAB = ($IDM_LANG + 45)
    Global Const $IDM_LANG_HASKELL = ($IDM_LANG + 46)
    Global Const $IDM_LANG_INNO = ($IDM_LANG + 47)
    Global Const $IDM_LANG_CMAKE = ($IDM_LANG + 48)
    Global Const $IDM_LANG_YAML = ($IDM_LANG + 49)

    Global Const $IDM_LANG_EXTERNAL = ($IDM_LANG + 50)
    Global Const $IDM_LANG_EXTERNAL_LIMIT = ($IDM_LANG + 79)

    Global Const $IDM_LANG_USER = ($IDM_LANG + 80) ; 46080
    Global Const $IDM_LANG_USER_LIMIT = ($IDM_LANG + 110) ; 46110

#EndRegion Const | Syntax

#Region Const | Help

    Global Const $IDM_HOMESWEETHOME = ($IDM_ABOUT + 1)
    Global Const $IDM_PROJECTPAGE = ($IDM_ABOUT + 2)
    Global Const $IDM_ONLINEHELP = ($IDM_ABOUT + 3)
    Global Const $IDM_FORUM = ($IDM_ABOUT + 4)
    Global Const $IDM_PLUGINSHOME = ($IDM_ABOUT + 5)
    Global Const $IDM_UPDATE_NPP = ($IDM_ABOUT + 6)
    Global Const $IDM_WIKIFAQ = ($IDM_ABOUT + 7)
    Global Const $IDM_HELP = ($IDM_ABOUT + 8)

#EndRegion Const | Help

#Region Const | Preferences

    Global Const $IDM_SETTING_TAB_SIZE = ($IDM_SETTING + 1)
    Global Const $IDM_SETTING_TAB_REPLCESPACE = ($IDM_SETTING + 2)
    Global Const $IDM_SETTING_HISTORY_SIZE = ($IDM_SETTING + 3)
    Global Const $IDM_SETTING_EDGE_SIZE = ($IDM_SETTING + 4)
    Global Const $IDM_SETTING_IMPORTPLUGIN = ($IDM_SETTING + 5)
    Global Const $IDM_SETTING_IMPORTSTYLETHEMS = ($IDM_SETTING + 6)

    Global Const $IDM_SETTING_TRAYICON = ($IDM_SETTING + 8)
    Global Const $IDM_SETTING_SHORTCUT_MAPPER = ($IDM_SETTING + 9)
    Global Const $IDM_SETTING_REMEMBER_LAST_SESSION = ($IDM_SETTING + 10)
    Global Const $IDM_SETTING_PREFERENCES = ($IDM_SETTING + 11)

    Global Const $IDM_SETTING_AUTOCNBCHAR = ($IDM_SETTING + 15)

#EndRegion Const | Preferences

#Region Const | Macro

    Global Const $IDM_MACRO_STARTRECORDINGMACRO = ($IDM_EDIT + 18)
    Global Const $IDM_MACRO_STOPRECORDINGMACRO = ($IDM_EDIT + 19)
    Global Const $IDM_MACRO_PLAYBACKRECORDEDMACRO = ($IDM_EDIT + 21)
    Global Const $IDM_MACRO_SAVECURRENTMACRO = ($IDM_EDIT + 25)
    Global Const $IDM_MACRO_RUNMULTIMACRODLG = ($IDM_EDIT + 32)

    Global Const $IDM_EXECUTE = ($IDM + 9000)

#EndRegion Const | Macro



#Region
#EndRegion




#Region Variables

    Global Enum $eNGT_AllText, $eNGT_CurrentWord, $eNGT_CurrentLine

    Global Enum $eNST_AllText, $eNST_DocumentEnd, $eNST_CursorPosition


#EndRegion Variables


#Region Example

    If @ScriptName = $UDFName & '.au3' Then

        ;  T_NPP_Command()
        ; T_NPP_Get_CursorPos()
        ; T_NPP_Get_Text()
        ;  T_NPP_Get_CurrentPath()
        T_NPP_Set_CursorPos()
        ; T_NPP_Set_Text()
    EndIf

#EndRegion Example












#cs | TESTING | =============================================

	Name				T_NPP_Get_Text
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Get_Text()
    

    _Log('_NPP_Get_Text($eNGT_CurrentLine)')
    _Log('_NPP_Get_Text($eNGT_CurrentWord)')
    ; _Log('_NPP_Get_Text(2)')


EndFunc   ;==>T_NPP_Get_Text



#cs | FUNCTION | ============================================

	Name				_NPP_Get_Text
	Desc				Получить текст

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

	$eNGT				$eNGT_AllText
						$eNGT_CurrentLine
						$eNGT_CurrentWord

#ce	=========================================================

Func _NPP_Get_Text($eNGT = $eNGT_AllText)

    Local $HndCtrl_Cur, $s_Text, $wparam, $lparam, $aSel[2], $sReturn

    $HndCtrl_Cur = __NPP_Scin_Handle()

    $s_Text = ControlGetText(__NPP_Win_Handle(), '', __NPP_Scin_Handle())

    $s_Text = BinaryToString(StringToBinary($s_Text, 2), 1)
    If $s_Text Then
        If $eNGT = $eNGT_AllText Then
            _Log('OK  |  All Text  |  Length: ' & StringLen($s_Text))
            Return $s_Text
        Else
            $wparam = DllStructCreate("uint Start")
            $lparam = DllStructCreate("uint End")
            _SendMessage($HndCtrl_Cur, 0xB0, DllStructGetPtr($wparam), DllStructGetPtr($lparam), 0, "ptr", "ptr");$EM_GETSEL=0xB0
            $aSel[0] = DllStructGetData($wparam, "Start")
            $aSel[1] = DllStructGetData($lparam, "End")

            If $eNGT = $eNGT_CurrentWord And $aSel[1] > $aSel[0] Then
                $sReturn = StringMid($s_Text, $aSel[0] + 1, $aSel[1] - $aSel[0])
                _Log('OK  |  Current Word  |  ' & $sReturn)
                Return $sReturn
            EndIf

            Local $pattern = '[\r\n]'
            If $eNGT = $eNGT_CurrentWord Then $pattern = '(?i)[^a-zа-я0-9_@#$]'
            Local $sRet = '', $i, $char, $startPos = $aSel[1]
            For $i = $startPos + 1 To StringLen($s_Text)
                $char = StringMid($s_Text, $i, 1)
                If StringRegExp($char, $pattern) Then
                    ExitLoop
                Else
                    $sRet &= $char
                    $aSel[1] += 1
                EndIf
            Next
            For $i = $startPos To 1 Step -1
                $char = StringMid($s_Text, $i, 1)
                If StringRegExp($char, $pattern) Then
                    ExitLoop
                Else
                    $sRet = $char & $sRet
                    $aSel[0] -= 1
                EndIf
            Next
            If $eNGT = $eNGT_CurrentWord And $aSel[1] > $aSel[0] Then
                _SendMessage($HndCtrl_Cur, 0xB1, $aSel[0], $aSel[1])
            EndIf
            $sReturn = $sRet
            _Log('OK  |  Current Line  |  ' & $sReturn)
            Return $sReturn
        EndIf
    EndIf
    Return ''

EndFunc   ;==>_NPP_Get_Text






#cs | TESTING | =============================================

	Name				T_NPP_Get_CurrentPath
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Get_CurrentPath()
    

    _Log('_NPP_Get_CurrentPath()')

    $dd = _NPP_Get_CurrentPath()
    Mbox($dd)


EndFunc   ;==>T_NPP_Get_CurrentPath

#cs | FUNCTION | ============================================

	Name				_NPP_Get_CurrentPath
	Desc				Возвращает текущий полный путь используя буфер обмена

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func _NPP_Get_CurrentPath()
    Local $bak, $ret
    $bak = ClipGet()
    Sleep(100)
    ClipPut('')
    _NPP_Command($IDM_EDIT_FULLPATHTOCLIP)
    Sleep(50)
    $ret = ClipGet()
    Sleep(50)
    ClipPut($bak)
    _Log('OK  |  Current Path  | ' & $ret)
    Return $ret
EndFunc   ;==>_NPP_Get_CurrentPath



#cs | FUNCTION | ============================================

	Name				 _NPP_Get_CurrentFileName
	Desc				
							
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func _NPP_Get_CurrentFileName()
    Local $bak, $ret
    $bak = ClipGet()
    Sleep(100)
    ClipPut('')
    _NPP_Command($IDM_EDIT_FILENAMETOCLIP)
    Sleep(50)
    $ret = ClipGet()
    Sleep(50)
    ClipPut($bak)
    _Log('OK  |  Current File  | ' & $ret)
    Return $ret
EndFunc   ;==>_NPP_Get_CurrentPath





#cs | TESTING | =============================================

	Name				T_NPP_Get_CursorPos
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Get_CursorPos()
    

    _Log('_NPP_Get_CursorPos()')


EndFunc   ;==>T_NPP_Get_CursorPos


#cs | FUNCTION | ============================================

	Name				_NPP_Get_CursorPos
	Desc				Возвращает текущую позицию курсора

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func _NPP_Get_CursorPos()

    Local $HndCtrl_Cur, $aSel[2], $s_Text, $wparam, $lparam
    Dim $ar[2]

    $HndCtrl_Cur = __NPP_Scin_Handle()

    $s_Text = ControlGetText(__NPP_Win_Handle(), '', __NPP_Scin_Handle())

    $s_Text = BinaryToString(StringToBinary($s_Text, 2), 1)
    If $s_Text Then
        Local $NPPM_GETCURRENTLINE = 4024 + 8
        $ar[0] = _SendMessage(__NPP_Win_Handle(), $NPPM_GETCURRENTLINE, 0, 0) + 1
        $wparam = DllStructCreate("uint Start")
        $lparam = DllStructCreate("uint End")

        _SendMessage($HndCtrl_Cur, 0xB0, DllStructGetPtr($wparam), DllStructGetPtr($lparam), 0, "ptr", "ptr") 	;$EM_GETSEL=0xB0

        $aSel[0] = DllStructGetData($wparam, "Start")
        $aSel[1] = DllStructGetData($lparam, "End")
        $s_Text = StringLeft($s_Text, $aSel[1])
        $aSel = StringRegExp($s_Text, '([^\r\n]*)($|\r\n|\r|\n)', 3)
        If IsArray($aSel) Then
            $ar[1] = StringLen($aSel[2 * $ar[0]]) + 1
        EndIf
    EndIf
    ; 	$ar[1] = _SendMessage($Hnd_Cur, $NPPM_GETCURRENTCOLUMN, 0, 0);

    _Log('OK  |  Cursor Position  | Line: ' & $ar[0] & ', Column: ' & $ar[1])
    Return $ar
EndFunc   ;==>_NPP_Get_CursorPos









#cs | TESTING | =============================================

	Name				T_NPP_Set_Text
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Set_Text()
    

    ; _NPP_Set_Text('ada111111111111111dada', $eNST_CursorPosition)
    ;Sleep(1400)
    _NPP_Set_Text('ada111111111111111dada', $eNST_DocumentEnd)
    ; Sleep(1400)
    ; _NPP_Set_Text('ada111111111111111dada', $eNST_AllText)

EndFunc   ;==>T_NPP_Set_Text


#cs | FUNCTION | ============================================

	Name				_NPP_Set_Text
	Desc				Устанавливает текст

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

	$eNST				$eNST_AllText
						$eNST_CursorPosition
						$eNST_DocumentEnd

#ce	=========================================================

Func _NPP_Set_Text($s_Text, $eNST = $eNST_AllText)

    Local $HndCtrl_Cur = __NPP_Scin_Handle()

    If $s_Text Then
        $s_Text = StringToBinary($s_Text, 1)
        $s_Text &= StringRight('0000', Mod(StringLen($s_Text), 4) + 2)
        $s_Text = BinaryToString($s_Text, 2)
    EndIf


    Switch $eNST

        Case $eNST_AllText
            ControlSetText(__NPP_Win_Handle(), "", __NPP_Scin_Handle(), $s_Text)

        Case $eNST_CursorPosition
            _SendMessage($HndCtrl_Cur, 0xC2, True, $s_Text, 0, "wparam", "wstr")

        Case $eNST_DocumentEnd
            Local $iLength = _SendMessage($HndCtrl_Cur, 0x000E)
            _SendMessage($HndCtrl_Cur, 0xB1, $iLength, $iLength)
            _SendMessage($HndCtrl_Cur, 0xC2, True, $s_Text, 0, "wparam", "wstr")

    EndSwitch

    If @error Then ExitBox('Cannot Set Text')

EndFunc   ;==>_NPP_Set_Text








#cs | TESTING | =============================================

	Name				T_NPP_Set_CursorPos
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Set_CursorPos()
    

    _NPP_Set_CursorPos()
   Sleep(1400)
    _NPP_Set_CursorPos(689, 28)


EndFunc   ;==>T_NPP_Set_CursorPos


#cs | FUNCTION | ============================================

	Name				_NPP_Set_CursorPos (0-based)
	Desc				Устанавливает курсор в указанную строку и столбец

						$iLine - Номер строки
						$iPos - Номер столбца (количество символов от начала строки)				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func _NPP_Set_CursorPos($iLine = 0, $iPos = 0)
    
    $iLine 	-= 	1
    $iPos	-= 	1
    
    Local $HndCtrl_Cur, $str, $i, $iLength, $i_Line, $strLine

    Local $HndCtrl_Cur = __NPP_Scin_Handle()

    ; Если отрицательные значения, то      получаем длинну текста чтобы установить курсор в конец документа
    If $iLine < 0 Or $iPos < 0 Then
		
        $iLength = _SendMessage($HndCtrl_Cur, 0x000E);$__EDITCONSTANT_WM_GETTEXTLENGTH=0x000E
        _SendMessage($HndCtrl_Cur, 0xB1, $iLength, $iLength);$EM_SETSEL=0xB1
        _Log($iLength, '$iLength')

    Else
        Global $StopLogging	=	True
        $str = _NPP_Get_Text() ; Получает весь текст
        If $str Then
            $aStr = StringRegExp($str, '([^\r\n]*)($|\r\n|\r|\n)', 3) ; в мессив, чётные элементы - сами строки, нечётные - разделители, т.е. переносы строк
            If IsArray($aStr) Then ; если массив, то
                ;	_ArrayDisplay($aStr, 'Array')
                $i_Line = 0
                $strLine = ''
                For $i = 0 To UBound($aStr) - 1
                    If StringRegExp($aStr[$i], '[\r\n]+') Then ; если элемент массива содержит перенос, то
                        $i_Line += 1
                        $iLength += StringLen($aStr[$i])
                    Else
                        If $i_Line >= $iLine Then
                            $strLine = $aStr[$i]
                            ExitLoop
                        Else
                            $iLength += StringLen($aStr[$i])
                        EndIf
                    EndIf
                Next
                $i = StringLen($strLine)
                If $iPos + 1 > $i Then
                    If $i Then
                        $iLength += $i
                    EndIf
                Else
                    $iLength += $iPos
                EndIf
                _SendMessage($HndCtrl_Cur, 0xB1, $iLength, $iLength);$EM_SETSEL=0xB1
            Else
                MsgBox(0, 'Сообщение', $str)
                $i = StringLen($str)
                If $iPos + 1 > $i Then
                    If $i Then
                        $iLength += $i
                    EndIf
                Else
                    $iLength += $iPos
                EndIf
                _SendMessage($HndCtrl_Cur, 0xB1, $iLength, $iLength);$EM_SETSEL=0xB1
            EndIf
        EndIf
    EndIf
	
EndFunc   ;==>_NPP_Set_CursorPos









#cs | TESTING | =============================================

	Name				T_NPP_Command
	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func T_NPP_Command()
    

    _NPP_Command($IDM_LANG_AU3)
    _NPP_Command($IDM_FILE_OPEN)


EndFunc   ;==>T_NPP_Command



#cs | FUNCTION | ============================================

	Name				 _NPP_Command
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func _NPP_Command($sMenuCommand)
    

    If Not IsInt($sMenuCommand) Then ExitBox('NppCommand Incorrect')

    Local $aReturn = _SendMessage(__NPP_Win_Handle(), $NPPM_MENUCOMMAND, 0, $sMenuCommand)

    If @error Then ExitBox('SendMessage Error')

    Return $aReturn

EndFunc   ;==>_NPP_Command





















#cs | FUNCTION | ============================================

	Name				__NPP_Win_Handle

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func __NPP_Win_Handle ()

    Local $sNPP_WinClass 	=	 '[CLASS:Notepad++]'
    If Not WinExists($sNPP_WinClass) Then ExitBox('NPP Window Not Exists')

    Local $hNPP_Handle	=	WinGetHandle($sNPP_WinClass)
    Return $hNPP_Handle

EndFunc   ;==>__NPP_Win_Handle



#cs | FUNCTION | ============================================

	Name				__NPP_Scin_Handle
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func __NPP_Scin_Handle()

    Local $hScin = ControlGetHandle(__NPP_Win_Handle(), '', "[CLASSNN:Scintilla" & __NPP_Scin_GetInstanceNumber() & "]")

    If @error Then ExitBox('Cannot Get Scintilla Handle')

    Return $hScin

EndFunc   ;==>__NPP_Scin_Handle





#cs | FUNCTION | ============================================

	Name				__NPP_Scin_GetInstanceNumber
	Desc				Возвращает номер экземпляра Scintilla

	Author				Asror Zakirov (aka Asror.Z)
	Created				4/6/2016

#ce	=========================================================

Func __NPP_Scin_GetInstanceNumber()
    Local $HndCtrl_1 = ControlGetHandle('[CLASS:Notepad++]', "", "[CLASSNN:Scintilla1]")
    Local $HndCtrl_2 = ControlGetHandle('[CLASS:Notepad++]', "", "[CLASSNN:Scintilla2]")
    If Not $HndCtrl_1 Then Return ''
    Local $state1 = BitAND(WinGetState($HndCtrl_1), 2)
    Local $state2 = BitAND(WinGetState($HndCtrl_2), 2)
    If Not $state2 Then
        Return 1
    ElseIf Not $state1 Then
        Return 2
    ElseIf $state1 And $state2 Then
        Local $size1 = WinGetPos($HndCtrl_1)
        Local $size2 = WinGetPos($HndCtrl_2)
        If IsArray($size1) And IsArray($size2) Then
            If $size1[1] < $size2[1] Then
                Return 1
            Else
                Return 2
            EndIf
        EndIf
    EndIf
    Return ''
EndFunc   ;==>__NPP_Scin_GetInstanceNumber