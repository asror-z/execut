#include-once
#include <File.au3>
#include <WinAPIFiles.au3>
#include <MyUDFs\Exit.au3>


Global $UDFName = 'Tera'



#Region Enum | _FZ_Attr

    Global Enum _
            $eFZA_Normal, _
            $eFZA_Hidden, _
            $eFZA_System, _
            $eFZA_ReadOnly, _
            $eFZA_Hidden_System_RO, _
            $eFZA_ClearAll

#EndRegion Enum | _FZ_Attr

#Region Enum | _FZ_Name

    Global Enum _
            $eFZN_Drive, _
            $eFZN_FilenameFull, _
            $eFZN_FilenameNoExt, _
            $eFZN_Extension, _
            $eFZN_FileParentDir, _
            $eFZN_FolderParentDir, _
            $eFZN_ParentDirName, _
            $eFZN_ParentDir, _
            $eFZN_FileNameIncrement, _
            $eFZN_AppProgramFilesDir

#EndRegion Enum | _FZ_Name



#Region Enum | _FZ_Check

    Global Enum _
            $eFZC_IsDirectory, _
            $eFZC_SizeIs1MB, _
            $eFZC_SizeIs10MB

#EndRegion Enum | _FZ_Check


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
	$eFZN_ParentDir
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



#Region Example

    If StringInStr(@ScriptName, $UDFName) Then

        ;   T_FZ_Attr()
        ;   T_FZ_Delete()
        ;  T_FZ_Copy()
        T_FZ_Name()
        ;	  T_FZ_FileRead()
        ;   T_FZ_FileWrite()
        ;   T_FZ_Check()
        ;   T_FZ_IsExist()
        ;   T_FZ_Name()
        ; T_FZ_Rename()
        ;T_FZ_Replace()
        ;   T_FZ_Search()
        ;   T_FZ_SearchRec()

    EndIf

#EndRegion Example











































#cs | INTERNAL FUNCTION | ===================================

	Name				__FZC_FileCopy

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func __FZC_FileCopy ($sSource, $sDest, $sFileMask = '*.*')

    $sSource &= (StringRight($sSource, 1) = '\') ? '' : '\'
    _Log('$sSource & $sFileMask: ' & $sSource & $sFileMask)

    If Not FileCopy($sSource & $sFileMask, $sDest, $FC_OVERWRITE + $FC_CREATEPATH) Then ExitBox('Cannot Copy File By Mask')

    _Log('FileCopy OK: ' & $sSource & ' => ' & $sDest & ' | Files: ' & $sFileMask)
EndFunc   ;==>__FZC_FileCopy





#cs | INTERNAL FUNCTION | ===================================

	Name				__FZR_FileRename

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func __FZR_FileRename ($sParentDir, $sOldName, $sNewName)


    $sParentDir &= (StringRight($sParentDir, 1) = '\') ? '' : '\'
    $sOldName = $sParentDir &  '\' &$sOldName
    $sNewName = $sParentDir &  '\' &$sNewName


    If _FZ_Check($sOldName, $eFZC_IsDirectory) Then
        _Log('Folder Rename: ' & $sOldName & ' => ' & $sNewName)
        DirMove($sOldName, $sNewName, $FC_OVERWRITE)
    Else
        _Log('File Rename: ' & $sOldName & ' => ' & $sNewName)
        FileMove($sOldName, $sNewName, $FC_OVERWRITE + $FC_CREATEPATH)
    EndIf

EndFunc   ;==>__FZR_FileRename


#cs | INTERNAL FUNCTION | ===================================

	Name				__FZC_FileCopySingle

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func __FZC_FileCopySingle ($sSource, $sDest)


    If Not FileCopy($sSource, $sDest, $FC_OVERWRITE + $FC_CREATEPATH) Then ExitBox('Cannot Copy Single File')

    _Log('FileCopySingle OK: ' & $sSource & ' => ' & $sDest)
EndFunc   ;==>__FZC_FileCopySingle




#cs | FUNCTION | ============================================

	Name				__FZG_AppProgramFiles

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2016
#ce	=========================================================

Func __FZG_AppProgramFiles ($sAppPathPart)

    $sAppPathPart = (StringLeft($sAppPathPart, 1) = '\') ? $sAppPathPart : '\' & $sAppPathPart

    Select

        Case FileExists(EnvGet("ProgramFiles(x86)") & $sAppPathPart)
            Return	EnvGet("ProgramFiles(x86)") & $sAppPathPart

        Case FileExists(EnvGet("ProgramFiles") & $sAppPathPart)
            Return	EnvGet("ProgramFiles")  & $sAppPathPart

        Case Else
            Return SetError(1, @extended, '')
    EndSelect

EndFunc   ;==>__FZG_AppProgramFiles







#cs | FUNCTION | ============================================

	Name				__FZG_FileNameIncrement

	Author				Asror Zakirov (aka Asror.Z)
	Created				14.02.2016

#ce	=========================================================

Func __FZG_FileNameIncrement ($sFilePath)


    ; BK: __FZG_FileNameIncrement
    
    Local $sFileName	=	_FZ_Name($sFilePath, $eFZN_FilenameNoExt)
    Local $sParentDir	=	_FZ_Name($sFilePath, $eFZN_FileParentDir)
    Local $sFileExtension	=	_FZ_Name($sFilePath, $eFZN_Extension)

    Local $aFileList = _FileListToArray($sParentDir, $sFileName & "*")

    If @error = 4 Or Not IsArray($aFileList) Then Return $sFilePath
    
    _ArrayDelete($aFileList, 0)
    _ArraySort($aFileList, 1)

    Local $sLastItem	=	$aFileList[0]
    _Log($sLastItem, '$sLastItem')

    Local $sLastItemNum	=	StringReplace($sLastItem, $sFileName & '-', '')
    
    $sLastItemNum += 1

    $sLastItemNum =	(StringLen($sLastItemNum) = 1) ? '0' & $sLastItemNum : $sLastItemNum

    _Log($sLastItemNum, '$sLastItemNum')
    Local $sRelFileFullPath		=	$sParentDir &  '\' &$sFileName & '-' & $sLastItemNum & $sFileExtension

    Return $sRelFileFullPath
EndFunc   ;==>__FZG_FileNameIncrement





#cs | FUNCTION | ============================================

	Name				__FZC_FileSizeLimit

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func __FZC_FileSizeLimit ($sFilePath, $iLimitInMB)

    If FileExists ($sFilePath) Then
        If Not IsInt($iLimitInMB) Then ExitBox('$iLimitInMB is Not Correct')

        Local $iLimitInBytes	=	$iLimitInMB * 1024 * 1024

        If FileGetSize($sFilePath) > $iLimitInBytes Then
            Return True
        Else
            Return False
        EndIf

    EndIf

EndFunc   ;==>__FZC_FileSizeLimit





#cs | TESTING | =============================================

	Name				T_FZ_Attr
		Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================



Func T_FZ_Attr()

    Global $sT_TestFile	=	'c:\asror\adada\ad.txt'
    _Log('FileGetAttrib($sT_TestFile)')
    _Log('_FZ_Attr($sT_TestFile)')
    _FZ_Attr($sT_TestFile, $eFZA_ClearAll)
    _Log('_FZ_Attr($sT_TestFile)')
    _FZ_Attr($sT_TestFile, $eFZA_Hidden_System_RO)
    _Log('_FZ_Attr($sT_TestFile)')
    _FZ_Attr($sT_TestFile, $eFZA_Hidden)
    _Log('_FZ_Attr($sT_TestFile)')
    _FZ_Attr($sT_TestFile, $eFZA_Normal)
    _Log('_FZ_Attr($sT_TestFile)')

EndFunc   ;==>T_FZ_Attr




#cs | FUNCTION | ============================================

	Name				_FZ_Attr

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func _FZ_Attr ($sFilePath, $eAttrType = Default)

    If FileExists($sFilePath) Then

        If $eAttrType <> Default Then

            Local $sAttrStr

            Switch $eAttrType

                Case $eFZA_ClearAll
                    $sAttrStr = "-RASHOT+N"

                Case $eFZA_Normal
                    $sAttrStr = "-RASHOT+N"

                Case $eFZA_Hidden
                    $sAttrStr = "+H-RSANOT"

                Case $eFZA_System
                    $sAttrStr = "+S-RHANOT"

                Case $eFZA_ReadOnly
                    $sAttrStr = "+R-SHANOT"

                Case $eFZA_Hidden_System_RO
                    $sAttrStr = "+RSH-ANOT"


            EndSwitch

            ; _Log('_FZ_Attr: ' & $sAttrStr)

            If Not FileSetAttrib ($sFilePath, $sAttrStr, $FT_NONRECURSIVE) Then
                ExitBox('Cannot Set Attributes')
            Else
                _Log('Set Attributes OK. Attr: ' & $sAttrStr & ' | File: ' & $sFilePath )
                Return True
            EndIf
        Else
            Return FileGetAttrib ($sFilePath)
        EndIf
    Else
        _Log('_FZ_Attr: File Not Exists: ' & $sFilePath)
    EndIf

EndFunc   ;==>_FZ_Attr













#cs | TESTING | =============================================

	Name				T_FZ_Delete
		Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Delete()

    Global $sT_TestFile	=	'c:\asror\adada\ad222.txt'
    _FZ_FileWrite($sT_TestFile, '')
    ; Sleep(3000)
    _Log('_FZ_Delete($sT_TestFile)')

EndFunc   ;==>T_FZ_Delete

#cs | FUNCTION | ============================================

	Name				_FZ_Delete

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _FZ_Delete($sFilePath)


    If FileExists($sFilePath) Then

        _FZ_Attr($sFilePath, $eFZA_ClearAll)

        If _FZ_Check($sFilePath, $eFZC_IsDirectory) Then
            If Not DirRemove($sFilePath, $DIR_REMOVE ) Then ExitBox('Cannot Delete Dir: ' & $sFilePath)
        Else
            If Not FileDelete($sFilePath) Then ExitBox('Cannot Delete File: ' & $sFilePath)
        EndIf
        _Log('Deleted Successfully: ' & $sFilePath)
        Return True
    Else
        _Log('File Not Exists: ' & $sFilePath)
    EndIf
EndFunc   ;==>_FZ_Delete








#cs | TESTING | =============================================

	Name				T_FZ_Copy
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Copy()
    Local $sDest = 'C:\Asroradaaadad\Test'
    _FZ_Copy(@ScriptDir, $sDest)
    ; _FZ_Copy(@ScriptDir, $sDest, '*.au3')

EndFunc   ;==>T_FZ_Copy

#cs | FUNCTION | ============================================

	Name				_FZ_Copy

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func _FZ_Copy ($sSource, $sDest, $sFileMask = '')


    _FZ_IsExist($sSource)
    _FZ_Attr($sDest, $eFZA_ClearAll)

    Select
        Case _FZ_Check($sSource, $eFZC_IsDirectory)

            If $sFileMask <> '' Then
                __FZC_FileCopy($sSource, $sDest, $sFileMask)

            Else
                If Not DirCopy($sSource, $sDest, $FC_OVERWRITE) Then ExitBox('Cannot Copy Directory: From ' & $sSource & ' to ' & $sDest)
                _Log('DirCopy OK: ' & $sSource & ' => ' & $sDest)

            EndIf

        Case Else
            __FZC_FileCopySingle ($sSource, $sDest)

    EndSelect

    Return True
EndFunc   ;==>_FZ_Copy













#cs | TESTING | =============================================

	Name				T_FZ_FileRead
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_FileRead()

    _Log('_FZ_FileRead(@ScriptFullPath)')

EndFunc   ;==>T_FZ_FileRead

#cs | FUNCTION | ============================================

	Name				_FZ_FileRead

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _FZ_FileRead($sFullPath)


    _FZ_IsExist($sFullPath)

    Local $hFileOpen = FileOpen($sFullPath, $FO_READ + $FO_UTF8_NOBOM)

    If $hFileOpen = -1 Then Exit(MsgBox($MB_OK + $MB_ICONERROR, "Error", 'Cannot open File: ' & $sFullPath))

    Local $sFileRead = FileRead($hFileOpen)

    If FileClose($hFileOpen) Then _Log('FileRead OK: ' & $sFullPath)


    Return $sFileRead

EndFunc   ;==>_FZ_FileRead


















#cs | TESTING | =============================================

	Name				T_FZ_FileWrite
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_FileWrite()

    Global $sT_TestFile = 'C:\Asroradad\Test.txt'

    _FZ_FileWrite($sT_TestFile, 'как впывп 535 gddgd')
    _FZ_FileWrite($sT_TestFile, 'как впывп 535 gddgd')
    _FZ_FileWrite($sT_TestFile, 'как впывп 535 gddgd')
    _FZ_FileWrite($sT_TestFile, 'Hello', @CRLF & @CRLF)
    _Log('_FZ_FileRead($sT_TestFile)')
    _Log(_FZ_FileRead($sT_TestFile))

    Mbox(_FZ_FileRead($sT_TestFile))

EndFunc   ;==>T_FZ_FileWrite

#cs | FUNCTION | ============================================

	Name				_FZ_FileWrite

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _FZ_FileWrite($sFullPath, $sFileContent, $sAppendDelimiter = '')


    Local $iFOpen
    Select
        Case $sAppendDelimiter <> ''
            If FileExists($sFullPath) Then $sFileContent	=	$sAppendDelimiter & $sFileContent
            $iFOpen	=	$FO_APPEND + $FO_CREATEPATH + $FO_UTF8_NOBOM

        Case Else
            $iFOpen	=	$FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8_NOBOM

    EndSelect
    Local $hFileOpen = FileOpen($sFullPath, $iFOpen)

    If $hFileOpen = -1 Then ExitBox('Cannot open File: ' & $sFullPath)

    If Not FileWrite($hFileOpen, $sFileContent) Then ExitBox('Cannot Write To File' & $sFullPath)

    If FileClose($hFileOpen) Then _Log('FileWrite OK: ' & $sFullPath)

EndFunc   ;==>_FZ_FileWrite




#cs | FUNCTION | ============================================

	Name				_FZ_FileWriteUTF8_BOM

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2016

#ce	=========================================================

Func _FZ_FileWriteUTF8_BOM($sFullPath, $sFileContent, $sAppendDelimiter = '')


    Local $iFOpen
    Select
        Case $sAppendDelimiter <> ''
            If FileExists($sFullPath) Then $sFileContent	=	$sAppendDelimiter & $sFileContent
            $iFOpen	=	$FO_APPEND + $FO_CREATEPATH + $FO_UTF8

        Case Else
            $iFOpen	=	$FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8

    EndSelect
    Local $hFileOpen = FileOpen($sFullPath, $iFOpen)

    If $hFileOpen = -1 Then ExitBox('Cannot open File: ' & $sFullPath)

    If Not FileWrite($hFileOpen, $sFileContent) Then ExitBox('Cannot Write To File' & $sFullPath)

    If FileClose($hFileOpen) Then _Log('FileWrite OK: ' & $sFullPath)

EndFunc   ;==>_FZ_FileWriteUTF8_BOM
















#cs | TESTING | =============================================

	Name				T_FZ_Check
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Check()

    _Log('_FZ_Check(@ScriptDir, $eFZC_IsDirectory)')
    _Log('_FZ_Check(@ScriptFullPath, $eFZC_SizeIs1MB)')

EndFunc   ;==>T_FZ_Check




#cs | FUNCTION | ============================================

	Name				_FZ_Check

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func _FZ_Check ($sFullPath, $eCheckType)
    ;

    _FZ_IsExist($sFullPath)
    Switch $eCheckType

        Case $eFZC_IsDirectory
            Return (StringInStr(FileGetAttrib($sFullPath), "D")) ? True : False

        Case $eFZC_SizeIs10MB
            Return __FZC_FileSizeLimit ($sFullPath, 10)

        Case $eFZC_SizeIs1MB
            Return __FZC_FileSizeLimit ($sFullPath, 1)

    EndSwitch


EndFunc   ;==>_FZ_Check







#cs | TESTING | =============================================

	Name				T_FZ_IsExist
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================











Func T_FZ_IsExist()

    Global $sT_Dir	=	@ScriptDir
    Global $sT_File	=	@ScriptFullPath

    _Log('_FZ_IsExist($sT_Dir)')
    _Log('_FZ_IsExist($sT_File)')
    ; _Log('_FZ_IsExist($sT_File & "adad")')

    ; _FZ_IsExist('')

EndFunc   ;==>T_FZ_IsExist




#cs | FUNCTION | ============================================

	Name				_FZ_IsExist

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func _FZ_IsExist ($sFullPath, $sLine = @ScriptLineNumber)

    If $sFullPath = '' Then ExitBox('sFullPath is Empty !' & @CRLF & 'Check your variable', $sLine)

    If Not FileExists($sFullPath) Then ExitBox('File Not Exists: ' & $sFullPath, $sLine)
    Return True

EndFunc   ;==>_FZ_IsExist




#cs | TESTING | =============================================

	Name				T_FZ_Name
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Name()

    ; _Log('_FZ_Name(@ScriptFullPath & "aa.cmd", $eFZN_FileNameIncrement)')
    ; _Log('_FZ_Name(@ScriptFullPath, $eFZN_FilenameFull)')
    
    $sPDir = _FZ_Name(@ScriptFullPath, $eFZN_ParentDirName)
    _Log($sPDir)
    
    $sPDir = _FZ_Name(@ScriptFullPath, $eFZN_ParentDirName)
    ; _Log('_FZ_Name(@ScriptFullPath, $eFZN_FilenameNoExt)')
    ; _Log('_FZ_Name(@ScriptFullPath, $eFZN_ParentDir)')
    ; _Log('_FZ_Name(@ScriptFullPath, $eFZN_Extension)')
    ; _Log('_FZ_Name("AIMP3\!Backup\", $eFZN_AppProgramFilesDir )')
    ; _Log('_FZ_Name(@ScriptFullPath, 55)')
    
    ; _Log('_FZ_Name("c:\inetpub\", $eFZN_ParentDir)')
    

EndFunc   ;==>T_FZ_Name

#cs | FUNCTION | ============================================

	Name				_FZ_Name

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func _FZ_Name ($sFullPath, $eItemType)

    Local 	$sDrive, _
            $sDir, _
            $sFileName, _
            $sExtension

    _PathSplit($sFullPath, $sDrive, $sDir, $sFileName, $sExtension)

    Switch $eItemType

        Case $eFZN_Drive
            Return $sDrive

        Case $eFZN_Extension
            Return $sExtension

        Case $eFZN_FilenameFull
            Return $sFileName & $sExtension

        Case $eFZN_FilenameNoExt
            Return $sFileName

        Case $eFZN_FileNameIncrement
            Return __FZG_FileNameIncrement($sFullPath)

        Case $eFZN_AppProgramFilesDir
            Return __FZG_AppProgramFiles($sFullPath)

        Case $eFZN_FileParentDir
            Return StringTrimRight($sDrive & $sDir, 1)

        Case $eFZN_FolderParentDir
            Return _PathFull($sFullPath & "\..")
            
        Case $eFZN_ParentDirName
            
            $sPDirOne = _FZ_Name($sFullPath, $eFZN_ParentDir)
            $sPDirTwo = _FZ_Name($sPDirOne, $eFZN_ParentDir)
            
            $sParentDirName = StringReplace($sPDirOne, $sPDirTwo, '')
			$sParentDirName = StringTrimLeft($sParentDirName, 1)
            Return $sParentDirName
			

        Case $eFZN_ParentDir
            If _FZ_Check($sFullPath, $eFZC_IsDirectory) Then
                Return _FZ_Name($sFullPath, $eFZN_FolderParentDir)
            Else
                Return _FZ_Name($sFullPath, $eFZN_FileParentDir)
            EndIf

            
        Case Else
            ExitBox('Incorrect $eItemType')

    EndSwitch

EndFunc   ;==>_FZ_Name







#cs | TESTING | =============================================

	Name				T_FZ_Replace
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Replace()
    Local $sTestproject = @ScriptDir & '\SamplePR\.idea'

    _FZ_Replace ($sTestproject, 'XProject', 'AsrorPR', Default, Default)

EndFunc   ;==>T_FZ_Replace

#cs | FUNCTION | ============================================

	Name				_FZ_Replace

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2016

#ce	=========================================================

Func _FZ_Replace ($sFilePath, $sSearchString, $sReplaceString, $sMask = Default, $iCaseSensitive = Default)


    $sMask		=	($sMask = Default) ? "*" : $sMask
    $iCaseSensitive		=	($iCaseSensitive = Default) ? True : False

    $iCaseSensitive 	= 	($iCaseSensitive) ? $STR_CASESENSE : $STR_NOCASESENSE

    Local $aFiles = _FZ_SearchRec ($sFilePath, $sMask, $FLTAR_FILES)



    For $i = 0 To UBound($aFiles) - 1

        If _ReplaceStringInFile ($aFiles[$i], $sSearchString,$sReplaceString, $iCaseSensitive, 1) > 0 Then _Log('File Replace: ' & $sSearchString & ' => ' & $sReplaceString & ' | File: ' & $aFiles[$i])

        Switch @error
            Case 1
                ExitBox('File is read-only')
            Case 2
                ExitBox('Unable to open the file')
            Case 3
                ExitBox('Unable to write to the file')
        EndSwitch

    Next


EndFunc   ;==>_FZ_Replace






#cs | TESTING | =============================================

	Name				T_FZ_Rename
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Rename()

    Local $sXproject = @ScriptDir & '\XProject'
    Local $sXprojectIdea = $sXproject & '\.idea'
    Local $sTestproject = @ScriptDir & '\SamplePR\.idea'
    If FileExists($sTestproject) Then _FZ_Delete($sTestproject)
    Sleep(400)
    _FZ_Copy($sXprojectIdea, $sTestproject)

    _FZ_Rename($sTestproject, 'XProject', 'SamplePR')

    _FZ_Rename($sTestproject, 'mis', 'Heloo', Default, False, Default, Default)


EndFunc   ;==>T_FZ_Rename

#cs | FUNCTION | ============================================

	Name				_FZ_Rename

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func _FZ_Rename ($sFilePath, $sSearchName, $sReplaceName, $sMask = Default, $bMatchWholeWord = Default, $bIncludeFolders = Default, $iCaseSensitive = Default)


    Local $aFiles, $sFileName, $sExtension, $sParentDir, $sOldName, $sNewName

    $sMask		=	($sMask = Default) ? "*" : $sMask
    $bMatchWholeWord		=	($bMatchWholeWord = Default) ? True : False
    $bIncludeFolders		=	($bIncludeFolders = Default) ? True : False
    $iCaseSensitive		=	($iCaseSensitive = Default) ? True : False

    $iCaseSensitive 	= 	($iCaseSensitive) ? $STR_CASESENSE : $STR_NOCASESENSE

    $iReturn	=	($bIncludeFolders) ? $FLTAR_FILESFOLDERS + $FLTAR_NOHIDDEN + $FLTAR_NOSYSTEM : $FLTAR_FILES + $FLTAR_NOHIDDEN + $FLTAR_NOSYSTEM


    $aFiles = _FZ_SearchRec ($sFilePath, $sMask, $iReturn)

    _Log($aFiles, '_FZ_SearchRec')


    For $i = 0 To UBound($aFiles) - 1
        $sFileName 	= 	_FZ_Name($aFiles[$i], $eFZN_FilenameNoExt)
        $sExtension	=	_FZ_Name($aFiles[$i], $eFZN_Extension)
        $sParentDir	=	_FZ_Name($aFiles[$i], $eFZN_FileParentDir)

        $sOldName	=	$sFileName & $sExtension

        Select
            Case $bMatchWholeWord
                If StringCompare ($sFileName, $sSearchName, $iCaseSensitive) = 0 Then

                    $sNewName	= 	$sReplaceName & $sExtension
                    __FZR_FileRename($sParentDir, $sOldName, $sNewName)

                EndIf

            Case Else
                If StringInStr($sFileName, $sSearchName) > 0 Then

                    $sNewName	= 	StringReplace($sFileName, $sSearchName, $sReplaceName)

                    $sNewName &= $sExtension

                    __FZR_FileRename($sParentDir, $sOldName, $sNewName)

                EndIf
        EndSelect


    Next


EndFunc   ;==>_FZ_Rename





#cs | TESTING | =============================================

	Name				T_FZ_Search
Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_Search()

    _Log('_FZ_Search (@ScriptDir)')
    _Log('_FZ_Search (@ScriptDir, "*")')
    _Log('_FZ_Search (@ScriptDir, "*", $FLTA_FOLDERS)')
    _Log('_FZ_Search (@ScriptDir, "*", $FLTA_FILES)')
    _Log('_FZ_Search (@ScriptDir, "*", $FLTA_FILES, False)')

EndFunc   ;==>T_FZ_Search


#cs | FUNCTION | ============================================

	Name				_FZ_Search

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

	$FLTA_FILESFOLDERS
	$FLTA_FILES
	$FLTA_FOLDERS

#ce	=========================================================

Func _FZ_Search ($sFilePath, $sFilter = Default, $iFlag = Default, $bReturnPath = Default)



    $sFilter	=	($sFilter = Default) ? "*" : $sFilter
    $iFlag		=	($iFlag = Default) ? $FLTA_FILESFOLDERS : $iFlag
    $bReturnPath		=	($bReturnPath = Default) ? True : $bReturnPath

    Local $aFileList = _FileListToArray ($sFilePath, $sFilter, $iFlag, $bReturnPath)

    _ArrayDelete($aFileList, 0)
    Switch @error
        Case 1
            ExitBox('Folder Not found Or invalid')
        Case 2
            ExitBox('Invalid $sFilter')
        Case 3
            ExitBox('Invalid $iFlag')
        Case 4
            ExitBox('No File(s) Found')
    EndSwitch

    Return $aFileList

EndFunc   ;==>_FZ_Search






#cs | TESTING | =============================================

	Name				T_FZ_SearchRec
	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_FZ_SearchRec()

    _Log('_FZ_SearchRec (@ScriptDir)')
    _Log('_FZ_SearchRec (@ScriptDir, "*.au3")')
    _Log('_FZ_SearchRec (@ScriptDir, "*.au3", $FLTAR_FILES)')
    _Log('_FZ_SearchRec (@ScriptDir, "*.au3", $FLTAR_FILES, $FLTAR_NORECUR)')
    _Log('_FZ_SearchRec (@ScriptDir, "*.au3", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT )')

EndFunc   ;==>T_FZ_SearchRec

#cs | FUNCTION | ============================================

	Name				_FZ_SearchRec

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

	$iReturn 			Can accept:
							| $FLTAR_FILESFOLDERS		(Default)
							| $FLTAR_FILES
							| $FLTAR_FOLDERS
							| $FLTAR_NOHIDDEN			+ (Default)
							| $FLTAR_NOSYSTEM			+ (Default)
							| $FLTAR_NOLINK

	$iRecur 			Can accept:
							| $FLTAR_NORECUR
							| $FLTAR_RECUR		(Default)

	$iSort 				Can accept:
							| $FLTAR_NOSORT		(Default)
							| $FLTAR_SORT	
							| $FLTAR_FASTSORT

	$iReturnPath 		Can accept:
							| $FLTAR_NOPATH
							| $FLTAR_RELPATH
							| $FLTAR_FULLPATH 	(Default)

#ce	=========================================================

Func _FZ_SearchRec ($sFilePath, $sMask = Default, $iReturn = Default, $iRecur = Default, $iSort = Default, $iReturnPath = Default)


    $sMask			=	($sMask = Default) ? "*" : $sMask
    $iReturn			=	($iReturn = Default) ? $FLTAR_FILESFOLDERS + $FLTAR_NOHIDDEN + $FLTAR_NOSYSTEM : $iReturn
    $iSort			=	($iSort = Default) ? $FLTAR_NOSORT : $iSort
    $iRecur			=	($iRecur = Default) ? $FLTAR_RECUR : $iRecur
    $iReturnPath 	=	($iReturnPath = Default) ? $FLTAR_FULLPATH : $iReturnPath

    Local $aFileList = _FileListToArrayRec ($sFilePath, $sMask, $iReturn, $iRecur, $iSort, $iReturnPath)
    
    _ArrayDelete($aFileList, 0)
    
    Switch @error
        Case 1
            ExitBox('Folder Not found Or invalid')
        Case 2
            ExitBox('Invalid Include parameter')
        Case 3
            ExitBox('Invalid Exclude parameter')
        Case 4
            ExitBox('Invalid Exclude_Folders parameter')
        Case 5
            ExitBox('Invalid $iReturn parameter')
        Case 6
            ExitBox('Invalid $iRecur parameter')
        Case 7
            ExitBox('Invalid $iSort parameter')
        Case 8
            ExitBox('Invalid $iReturnPath parameter')
        Case 9
            ExitBox('No files/folders found')
    EndSwitch

    Return $aFileList

EndFunc   ;==>_FZ_SearchRec

