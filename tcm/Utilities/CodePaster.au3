#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\ClipGetHTML.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\TC.au3>
#include <MyUDFs\Config.au3>


#pragma compile(Out, c:\AsrorZ\TCU\CodePaster.exe)


#Region Compile

    #pragma compile(ExecLevel, none)
    #pragma compile(Compatibility, win7)
    #pragma compile(x64, true)

#EndRegion Compile




#Region Variables

    Global $sCP_ParentDir

    Global Enum $e_PHP, $e_PS, $e_AU3, $e_JStoPHP, $e_CS, $e_Cmd, $e_LUA, $e_None



#EndRegion Variables



#cs | CURRENT | =============================================

	$eFZA_Normal, _
	$eFZA_Hidden, _
	$eFZA_System, _
	$eFZA_ReadOnly, _
	$eFZA_Hidden_System_RO, _
	$eFZA_ClearAll

	$eFZN_Drive, _
	$eFZN_FilenameFull, _
	$eFZN_FilenameNoExt, _
	$eFZN_Extension, _
	$eFZN_FileParentDir, _
	$eFZN_FolderParentDir
	$eFZN_FileNameIncrement, _
	$eFZN_AppProgramFilesDir

	$eFZC_IsDirectory, _
	$eFZC_SizeIs1MB, _
	$eFZC_SizeIs10MB

	_FZ_Attr
	_FZ_Delete
	_FZ_Copy
	_FZ_FileRead
	_FZ_FileWrite
	_FZ_Check
	_FZ_IsExist
	_FZ_Name
	_FZ_Replace
	_FZ_Rename
	_FZ_Search
	_FZ_SearchRec

	Mbox
	ExitBox
	_Log

#ce	=========================================================


; MBox($CmdLineRaw)

If $CmdLine[0] > 1 Then

    $sCP_ParentDir	= _FZ_Name($CmdLine[2], $eFZN_ParentDir)
    $sCP_ParentDirName	= _FZ_Name($CmdLine[2], $eFZN_ParentDirName)


    #Region CMD Switch

        Switch $CmdLine[1]
            Case 'T'
                _CP_PasteTXT()

            Case 'A'
                _CP_PasteCode($e_None)

            Case 'P'
                _CP_PasteCode($e_PHP)

            Case 'Z'
                _CP_PasteCode($e_JStoPHP)

            Case 'I'
                _CP_PasteCode($e_CS)

            Case 'L'
                _CP_PasteCode($e_LUA)

            Case 'B'
                _CP_PasteCmd()

            Case 'Q'
                _CP_PasteCode($e_CS)

            Case 'H'
                _CP_PasteHTM()

            Case 'E'
                _CP_PasteLNK()

            Case 'D'
                $bDialog = True
                _CP_PasteLNK()

        EndSwitch

    #EndRegion CMD Switch


    Exit
Else
    ; $sCLipContent = _FZ_FileRead('Samples\1.js')

    ;_Log('$sCLipContent')
    $sCLipContent = __CP_GetHostNameFromURL()

    _Log('$sCLipContent')

EndIf






#cs | INTERNAL FUNCTION | ===================================

	Name				__CP_JStoPHP
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.03.2018

#ce	=========================================================

Func __CP_JStoPHP($sStr)

    $sStr = StringReplace($sStr, 'option =', '$aOptions =')
    $sStr = StringReplace($sStr, '{', '[')
    $sStr = StringReplace($sStr, '}', ']')

    $sStr = StringReplace($sStr, '"''', '"')
    
    $sStr = StringRegExpReplace($sStr, '(\w*?): ?', "'\1'" & ' => ')
    $sStr = StringReplace($sStr, '[[', '[' & @CRLF & @TAB & '[')
    $sStr = StringReplace($sStr, ']]', ']' & @CRLF & @TAB & ']')
    
    $sStr = StringReplace($sStr, "'https' => //", 'https://')
    $sStr = StringReplace($sStr, "'http' => //", 'http://')

    Return $sStr

EndFunc   ;==>__CP_JStoPHP





#cs | FUNCTION | ============================================

	Name				__CP_GetHostNameFromURL

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016

#ce	=========================================================

Func __CP_GetHostNameFromURL($sURL = '')

    ; $sURL = 'https://megasoft.uzadad/adad/system/filemanagers/'

    If $sURL = '' Then
        $sURL = 'https://gabegasm.usitech-int.com/#aboutDistributor'
    EndIf

    $sURL = StringReplace($sURL, 'www.', '')
    $sURL = StringReplace($sURL, 'exchanges/', '')
    $sURL = StringReplace($sURL, 'search?q=', '')


    $sFuncPattern = 'https?://([\w-_\.]*)(/.*)?'

    $aRes = StringRegExp($sURL, $sFuncPattern , 3)

    _Log($sURL, '$sURL')
    _Log($aRes, '$aRes')

    If @error Then Return SetError(1, @extended, 'Readme')

    $sLinkURL = $aRes[0]
    $sLinkURLAdd = ''

    If UBound($aRes) > 1 Then
        $sLinkURLAdd = $aRes[1]
        $sLinkURLAdd = StringReplace($sLinkURLAdd, '/', ' ')
        $sLinkURLAdd = StringReplace($sLinkURLAdd, '#', '')
        $sLinkURLAdd = StringReplace($sLinkURLAdd, '\', ' ')
        $sLinkURLAdd = StringReplace($sLinkURLAdd, '?', ' ')
        $sLinkURLAdd = StringReplace($sLinkURLAdd, ':', ' ')

    EndIf




    $sLinkURL &= $sLinkURLAdd

    _Log($sLinkURL)
    $sLinkURL = StringStripWS($sLinkURL,   $STR_STRIPTRAILING)

    _Log($sLinkURL)

    $sLinkURL = _StringTitleCase($sLinkURL)

    Return $sLinkURL

EndFunc   ;==>__CP_GetHostNameFromURL




#cs | FUNCTION | ============================================

	Name				_CP_Help

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016

#ce	=========================================================

Func _CP_Help ()

    $sHelpStr =	'Alt+T - TXT'
    $sHelpStr &= @CRLF &  'Alt+A - AU3'
    $sHelpStr &= @CRLF &  'Alt+P - PHP'
    $sHelpStr &= @CRLF &  'Alt+J - JAVA'
    $sHelpStr &= @CRLF &  'Alt+Z - C#'
    $sHelpStr &= @CRLF &  'Alt+H - HTM'

    MsgBox($MB_OK + $MB_DEFBUTTON1, 'Warning !', $sHelpStr)

EndFunc   ;==>_CP_Help





#cs | FUNCTION | ============================================

	Name				__CP_PasteLNK

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.03.2016

#ce	=========================================================

Func _CP_PasteLNK ()

    $sSampleLnk = '[{000214A0-0000-0000-C000-000000000046}]' & @CRLF & _
            'Prop3=19,11' & @CRLF & _
            '[InternetShortcut]' & @CRLF & _
            'IDList=' & @CRLF & _
            'URL=_URL_' & @CRLF & _
            'IconIndex=13' & @CRLF & _
            'HotKey=0' & @CRLF & _
            'IconFile=C:\Windows\System32\SHELL32.dll'



    $sCLipContent = ClipGet()

    If $sCLipContent <> '' Then

        $sHostName =	__CP_GetHostNameFromURL($sCLipContent)

        $sHostName = StringLeft($sHostName, 70)


        If IsDeclared('bDialog') Then

            $sHostName = InputBox("Your preferred file name | LNK", "Your preferred file name", $sHostName)

            $sHostName = StringStripWS ($sHostName, 3)

            If $sHostName = '' Then ExitBox('Empty Name')
        EndIf

        Local $sFilePath = $sCP_ParentDir & '\' & $sHostName &'.url'
        _Log('$sCP_ParentDir')

        $sRelease = StringReplace($sSampleLnk, '_URL_', $sCLipContent)

        _FZ_Delete($sFilePath)
        _FZ_FileWrite($sFilePath, $sRelease)
        

    EndIf
EndFunc   ;==>_CP_PasteLNK





#cs | FUNCTION | ============================================

	Name				_CP_PasteCmd

	Author				Asror Zakirov (aka Asror.Z)
	Created				11.03.2016

#ce	=========================================================

Func _CP_PasteCmd ()


    $sCLipContent = ClipGet()

    If $sCLipContent <> '' Then



		#cs

        Local $iPosition = StringInStr($sCLipContent, ' ')
        Local $sLeft  = StringLeft($sCLipContent, $iPosition)
        Local $sRelText = StringReplace($sCLipContent, $sLeft, '')

		#ce




        $sAnswer = StringStripWS ($sCLipContent, 3)

        Local $sAnswer = InputBox("Your preferred file name", "Your preferred file name", $sCLipContent)

        $sAnswer = StringStripWS ($sAnswer, 3)

        $sCLipContent = 'chcp 65001' & @CRLF & @CRLF & $sCLipContent
        ;	$sCLipContent &= ' && pause > nul'

        If $sAnswer <> '' Then

            Local 	$sFilename 	=	$sCP_ParentDir & '\' & $sAnswer & '.cmd'

            _FZ_FileWrite(_FZ_Name($sFilename, $eFZN_FileNameIncrement), $sCLipContent)
            ClipPut('')

        EndIf

    Else
        Local 	$sFilename 	=	$sCP_ParentDir & '\' & '\RunCmd.cmd'

        If Not FileExists($sFilename) Then _FZ_FileWrite($sFilename, '')
    EndIf

EndFunc   ;==>_CP_PasteCmd





Func _CP_PastePs ()


    $sCLipContent = ClipGet()

    If $sCLipContent <> '' Then



		#cs

        Local $iPosition = StringInStr($sCLipContent, ' ')
        Local $sLeft  = StringLeft($sCLipContent, $iPosition)
        Local $sRelText = StringReplace($sCLipContent, $sLeft, '')

		#ce




        $sAnswer = StringStripWS ($sCLipContent, 3)

        Local $sAnswer = InputBox("Your preferred file name", "Your preferred file name", $sCLipContent)

        $sAnswer = StringStripWS ($sAnswer, 3)

        $sCLipContent &= @CRLF & @CRLF & 'Start-Sleep 10'

        If $sAnswer <> '' Then

            Local 	$sFilename 	=	$sCP_ParentDir & '\' & $sAnswer & '.ps1'

            _FZ_FileWriteUTF8_BOM(_FZ_Name($sFilename, $eFZN_FileNameIncrement), $sCLipContent)
            ClipPut('')

        EndIf

    Else
        Local 	$sFilename 	=	$sCP_ParentDir & '\' & 'RunPS.ps1'

        If Not FileExists($sFilename) Then _FZ_FileWriteUTF8_BOM($sFilename, '')
    EndIf

EndFunc   ;==>_CP_PastePs





#cs | FUNCTION | ============================================

	Name				_CP_CopyClip

	Author				Asror Zakirov (aka Asror.Z)
	Created				3/24/2016

#ce	=========================================================

Func _CP_CopyClip ()



EndFunc   ;==>_CP_CopyClip


#cs | FUNCTION | ============================================

	Name				_CP_PasteHTM

	Author				Asror Zakirov (aka Asror.Z)
	Created				14.02.2016

#ce	=========================================================

Func _CP_PasteHTM()

    $aHTMLData=_ClipGetHTML()

    If UBound ($aHTMLData) > 1 Then

        $sCLipContent 	=	BinaryToString($aHTMLData[0], 4)
        $sURL 	=	$aHTMLData[6]

        ;Mbox($sCLipContent)
        ; exit

        Local $sAnswer = InputBox("Your preferred file name", "Your preferred file name", '_Readme')
        $sAnswer = StringStripWS ($sAnswer, 3)
        If $sAnswer <> '' Then

            Local 	$sFilename 	=	$sCP_ParentDir & '\' & $sAnswer & '.htm'

            Local	$sDelimiter	= @CRLF & @CRLF &	'<br/><br/><hr/><br/><br/>' & @CRLF & @CRLF

            _FZ_FileWriteUTF8_BOM($sFilename, $sCLipContent, $sDelimiter)
            ClipPut('')

        EndIf

    Else
        If ClipGet() <> '' Then
            MsgBox(0, 'Error', 'You have to copy only HTML')
        EndIf

    EndIf

EndFunc   ;==>_CP_PasteHTM



#cs | FUNCTION | ============================================

	Name				_CP_PasteTXT

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016

#ce	=========================================================

Func _CP_PasteTXT()

    $sCLipContent = ClipGet()

    Local $sAnswer = InputBox("Your preferred file name", "Your preferred file name", 'Readme')
    $sAnswer = StringStripWS ($sAnswer, 3)
    If $sAnswer <> '' Then

        Local 	$sFilename 	=	$sCP_ParentDir & '\' & $sAnswer & '.txt'


        If ClipGet() = '' Then
            If Not FileExists($sFilename) Then _FZ_FileWrite($sFilename, '')
        Else
            Local $sDelimiter	= @CRLF & @CRLF &	'==================================================================================' & @CRLF & @CRLF

            _FZ_FileWrite($sFilename, $sCLipContent, $sDelimiter)

            ClipPut('')
        EndIf

    EndIf

EndFunc   ;==>_CP_PasteTXT






#cs | FUNCTION | ============================================

	Name				_CP_PasteCode

	Author				Asror Zakirov (aka Asror.Z)
	Created				14.02.2016

#ce	=========================================================

Func _CP_PasteCode ($iCodeType)

    $sCLipContent = ClipGet()

    If Not  $sCLipContent Then ExitBox('Clipboard Empty')

    $sClipOriginal = ''
    $sExtSearch = ''

    Switch $iCodeType
        Case $e_AU3
            $sExt = '.au3'

        Case $e_PHP
            $sExt = '.php'
            $sExtSearch = 'PHP'

        Case $e_JStoPHP
            $sExt = '.php'
            $sExtSearch = 'JsPHP'
            $sClipOriginal = $sCLipContent
            $sCLipContent = __CP_JStoPHP($sCLipContent)


        Case $e_CS
            $sExt = '.cs'

            $bMain = Not StringInStr($sCLipContent, 'void Main(') > 0
            $bZRun = Not StringInStr($sCLipContent, 'void ZRun(') > 0
            $bZnamespace = Not StringInStr($sCLipContent, 'namespace') > 0
            $bZclass = Not StringInStr($sCLipContent, 'class') > 0

            $bZVoid = StringInStr($sCLipContent, 'void') > 0

            If $bMain And $bZRun And $bZclass And $bZnamespace Then

                If $bZVoid Then
                    $sExtSearch = 'CSNoMethod'
                Else
                    $sExtSearch = 'CS'
                EndIf

            EndIf

        Case $e_LUA
            $sExt = '.lua'

        Case $e_Cmd
            $sExt = '.cmd'

        Case $e_None
            Local $sfExt = InputBox("ENTER THE FILE EXTENSION", "FILE EXTENSION", _Config('CodeExt'))
            _Config('CodeExt', $sfExt)

            $sExt = '.' & $sfExt

    EndSwitch






    Local $sAnswer = InputBox("Your preferred file name | " & $sExt, "Your preferred file name", $sCP_ParentDirName)
    $sAnswer = StringStripWS ($sAnswer, 3)


    If $sAnswer <> '' Then

        Local 	$sFilename 	=	$sCP_ParentDir & '\' & $sAnswer & $sExt
        $sFilename = _FZ_Name($sFilename, $eFZN_FileNameIncrement)


        If $sExtSearch <> '' Then
            $sSampleFile = @ScriptDir & '\Samples\' & $sExtSearch & '.txt'

            If FileExists($sSampleFile) Then
                $sTemplate = _FZ_FileRead($sSampleFile)
                $sCLipContent = StringReplace($sTemplate, '//[[$sContent]]', $sCLipContent)
                $sCLipContent = StringReplace($sCLipContent, '//[[$iRandom]]', Random(10, 100, 1))
            EndIf

        EndIf

        _FZ_FileWrite($sFilename, $sCLipContent)

        If $sClipOriginal Then
            _FZ_FileWrite(StringReplace($sFilename, '.php', '.js'), $sClipOriginal)
        EndIf

        ClipPut('')

    EndIf

EndFunc   ;==>_CP_PasteCode

