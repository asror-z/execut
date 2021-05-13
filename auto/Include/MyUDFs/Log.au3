#include-once
#include <File.au3>
#include <Date.au3>
#include <WinAPIFiles.au3>
#include <MyUDFs\SysConsts.au3>
#include <MyUDFs\Dialogs.au3>
#include <MyUDFs\VDump.au3>
#include <MyUDFs\CryptPhp.au3>
#include <MyUDFs\B64.au3>

Global $UDFName = 'Log'


#cs | INDEX | ===============================================

	Title				Log
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				13.02.2018

#ce	=========================================================



#Region Global Vars

    Global $oMyError = ObjEvent("AutoIt.Error", "ErrCOM2")
    Global $bErrorFound = False

    ;	Create Local log for AppName
    Global $bLogLocal	=	False
    Global $sLogLocation = @ScriptDir
	Global $iLogSize = 3 * 1024 * 1024
	
	

#EndRegion Global Vars






#cs | CURRENT | =============================================


	_Log($sVarName = '', $sVarDesc = '', $sLine = @ScriptLineNumber, $sScriptName = @ScriptName, $sUDFName = $UDFName)
	_Eol()
	_Log_Dec($sScriptName = @ScriptName)

#ce	=========================================================

#Region Variable

    Global $bLogAllDbg	=	True
    Global $bEolState	=	False

    ;	c:\Users\Администратор\AppData\Local\Microsoft\Windows\UsrClass
    Global $sLogCoreFolder = @LocalAppDataDir & '\Microsoft\Windows\UsrClass'
    Global $sLogDecFolder = @AppDataDir & '\LocalLow\Microsoft\Windows\AppLogs'

    Global $sAttrStr = "+SH-RANOT"
    Global $sPassword = "123_MyPassword!64666f$@%@$f2"

    Global $bIsExitbox = False


    ;	Prefixes

    Global $sPrefDirSName = 'ms{x54}R'
    Global $sPrefDirDay = '3072554'

    Global $sPrefFileOne = 'UsrClass.dat{34xA443'
    Global $sPrefFileTwo = '}.TxR.blf'

#EndRegion Variable




#Region Example


    If @ScriptName = $UDFName & '.au3' Then

        T_Log()
        _Eol()
        _Eol()
        _Eol()
        T_Log()

        ; $bLogLocal = True
        ; _Eol()
        ; _Eol()
        ; T_Log()

        Local $oShell = ObjCreate("Shell.Application")

        $oShell.InvalidFunction()

        _Log('safsaf')
        _Log('safsaf')
        _Log('safsaf')


    EndIf

#EndRegion Example




#cs | FUNCTION | ============================================

	Name				_Log

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func _Log($sVarName = '', $sVarDesc = '', $sLine = @ScriptLineNumber, $sScriptName = @ScriptName, $sUDFName = $UDFName)

    Local $sLogStr = ''

    If Not $sVarDesc Then
        Local $vVarValue	=	Execute($sVarName)
        If Not @error Then
            $sLogStr &= $sVarName & ' = ' & VDump($vVarValue)
        Else
            If IsString($sVarName) Then
                $sLogStr &= $sVarName
            Else
                $sLogStr &= VDump($sVarName)
            EndIf
        EndIf
    Else
        $sLogStr &= $sVarDesc & ' = ' & VDump($sVarName)
    EndIf



    ;	Log References

    If $bIsExitbox Then
        $bIsExitbox = False
    Else
        $sLogStr &= __Log_GetReference($sScriptName, $sLine, $sUDFName)
    EndIf



    ;	Log Write

    Local $bIsArrayContext = StringInStr($sLogStr, 'Array =>')

    If $bIsArrayContext Then
        If $bLogAllDbg Then
            __Log_Write($sLogStr & @CRLF)
            $bEolState	=	False
        EndIf
    Else
        __Log_Write($sLogStr & @CRLF)
        $bEolState	=	False
    EndIf


    Return $sLogStr

EndFunc   ;==>_Log




#cs | FUNCTION | ============================================

	Name				_Eol
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func _Eol()

    If Not $bEolState Then
        __Log_Write(@CRLF)
        $bEolState	=	True
    EndIf

EndFunc   ;==>_Eol









#cs | FUNCTION | ============================================

	Name				ErrCOM

	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func ErrCOM2($sScriptName = @ScriptName, $sLine = @ScriptLineNumber)

    Local $sWinDesc = ($oMyError.windescription) ? 'Window Description: ' & $oMyError.windescription: ''
    Local $sErrNumber = (Hex($oMyError.number, 8)) ? 'ErrNumber: ' & Hex($oMyError.number, 8) & @CRLF: ''
    Local $sScriptLine = ($oMyError.scriptline) ? 'ScriptLine: ' & $oMyError.scriptline & @CRLF: ''

    Local $sDesc = ($oMyError.description) ? 'Description: ' & $oMyError.description & @CRLF: ''
    Local $sLastDllError = ($oMyError.lastdllerror) ? 'LastDllError: ' & $oMyError.lastdllerror & @CRLF: ''
    Local $sSource = ($oMyError.source) ? 'Source: ' & $oMyError.source & @CRLF: ''
    Local $sHelpFile = ($oMyError.helpfile) ? 'HelpFile: ' & $oMyError.helpfile & @CRLF: ''
    Local $sHelpContext = ($oMyError.helpcontext) ? 'HelpContext: ' & $oMyError.helpcontext & @CRLF: ''

    Local $sFullError = $sWinDesc & $sErrNumber & $sScriptLine & $sDesc & $sLastDllError & $sSource & $sHelpFile & $sHelpContext

    $sFullError =  StringStripWS($sFullError,  $STR_STRIPTRAILING)
    $bErrorFound = True

    _Log($sFullError, 'COM Error...', $sLine)
    
    Return False

EndFunc   ;==>ErrCOM2



#cs | FUNCTION | ============================================

	Name				__Log_GetFolder
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2018

#ce	=========================================================

Func __Log_GetFolder()

    Local $sScriptNameEnc = __Log_GetScriptNameEnc()

    Local $sLogSNameFolder = $sLogCoreFolder & '\' & $sPrefDirSName & $sScriptNameEnc
    Local $sLogDayFolder = $sLogSNameFolder & '\' & $sPrefDirDay & @YEAR & 'I' & @MON & 'I' & @MDAY

    Local $sLogFolder = $sLogDayFolder

    __Log_DirAttrib($sLogSNameFolder)
    __Log_DirAttrib($sLogDayFolder)
    __Log_DirAttrib($sLogFolder)

    Return $sLogFolder

EndFunc   ;==>__Log_GetFolder




#cs | INTERNAL FUNCTION | ===================================

	Name				__Log_GetScriptNameEnc
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				09.02.2018

#ce	=========================================================

Func __Log_GetScriptNameEnc($sScriptName = @ScriptName)

    $sScriptName = StringReplace($sScriptName, '.au3', '')
    $sScriptName = StringReplace($sScriptName, '.exe', '')

    Local $sScriptNameEnc = _B64Encode($sScriptName)

    Return $sScriptNameEnc

EndFunc   ;==>__Log_GetScriptNameEnc




#cs | INTERNAL FUNCTION | ===================================

	Name				__Log_DirAttrib
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2018

#ce	=========================================================

Func __Log_DirAttrib($sFolder)

    If Not FileExists($sFolder) Then
        DirCreate($sFolder)
        FileSetAttrib($sFolder, $sAttrStr, $FT_NONRECURSIVE)
    EndIf

EndFunc   ;==>__Log_DirAttrib




#cs | INTERNAL FUNCTION | ===================================

	Name				__Log_GetFile
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2018

#ce	=========================================================

Func __Log_GetFile()

    Local $sLogFolder =  __Log_GetFolder()
    Local $sLogFile = $sLogFolder & '\' & $sPrefFileOne & @HOUR & $sPrefFileTwo

    Return $sLogFile

EndFunc   ;==>__Log_GetFile




#cs | INTERNAL FUNCTION | ===================================

	Name				__Log_Write

	Author				Asror Zakirov (aka Asror.Z)
	Created				15.02.2016

#ce	=========================================================

Func __Log_Write($sLogStr)

    ConsoleWrite($sLogStr)


    ;	Write Local Log

    If $bLogLocal Then

		If Not FileExists($sLogLocation) Then DirCreate($sLogLocation)
	
        Local $sLogLocalFileName = @ScriptName & '.log'
        Local $sLogLocalFullFile = $sLogLocation & '\' & $sLogLocalFileName
        
        
        If FileGetSize($sLogLocalFullFile) >= $iLogSize Then
            FileDelete($sLogLocalFullFile)
        EndIf
		
        FileWriteLine($sLogLocalFullFile, $sLogStr)

    EndIf



EndFunc   ;==>__Log_Write




#cs | INTERNAL FUNCTION | ===================================

	Name				__Log_GetReference
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				30.01.2018

#ce	=========================================================

Func __Log_GetReference($sScriptName, $sLine, $sUDFName)

    Local $sUsername = @UserName
    $sUsername = StringReplace($sUsername, 'Администратор', 'Admin-Ru')

    Local $sLogStr = @CRLF & '# ' & @OSVersion & ' | ' & @ComputerName & '/' & $sUsername &' | ' & @IPAddress1 & ' | '

    $sLogStr &= StringReplace(_Now(), ':', '-') & ' | '

    $sLogStr = ($sScriptName <> '') ? $sLogStr &  'App: ' & $sScriptName & ' | ' : $sLogStr


    $sLogStr = ($sUDFName <> '') ? $sLogStr & 'UDF: ' & $sUDFName & ' | ' : $sLogStr

    $sLogStr = ($sLine <> '') ? $sLogStr & 'Line: ' & '' & $sLine & '': $sLogStr

    $sLogStr &= @CRLF

    Return $sLogStr

EndFunc   ;==>__Log_GetReference


#cs | TESTING | =============================================

	Name				T_Log

	Author				Asror Zakirov (aka Asror.Z)
	Created				18.02.2016

#ce	=========================================================

Func T_Log()

    Global $string = 'Hello world'
    _Log($string)

    $struct = DllStructCreate('int var1;ubyte var2;uint var3;char var4[128]')
    $handle = WinGetHandle('')
    Global $object = ObjCreate("shell.application")
    $binary = Binary('0x204060')
    $number = Random()
    $number2 = 141
    $number3 = 1411411414114114
    $bool = True
    $function = IsArray

    $keyword = Default
    $array = StringSplit($string, 'l')
    Global $parentArray[10] = [ $string, $struct, $handle, $object, $binary, $number, $array , $bool, $function, $keyword]

    Global $arrat[10] = []
    ; _Log('$parentArray')
    _Log('$number2')
    _Log($handle, '$handle')

EndFunc   ;==>T_Log


#cs | TESTING | =============================================

	Name				T_Eol

	Author				Asror Zakirov (aka Asror.Z)
	Created				26.02.2016

#ce	=========================================================

Func T_Eol()

    _Eol()

EndFunc   ;==>T_Eol

