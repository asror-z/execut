#include-once
#include <Array.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Log.au3>
#include <MyUDFs\AppPath.au3>
#RequireAdmin

; Global $LogToBoth	=	True

#cs | INDEX | ===============================================

	Title				RegSZ
	Description	 		Register Seven ZIP

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				15.02.2016

#ce	=========================================================


$sRootDir = 'd:\Develop\Projects\execut\tcm\TotalBin'
$sSGoDir = 'd:\Develop\Projects\execut\tcm\Utilities\EsGoApp'


$sFileName = _AppPath_Write($sRootDir & '\TotalCmd64.exe')
$sFileName86 = _AppPath_Write($sRootDir & '\TotalCmd.exe')

ShellExecute($sSGoDir & '\EsGo.exe')

If _AppPath_IsExist($sFileName) And _AppPath_IsExist($sFileName86) Then Mbox('Registered')


; $sLNKOne = @AppDataDir & '\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\Total Commander.lnk'

; FileCreateShortcut($sRootDir & "\TotalCmd.exe", $sLNKOne)



#cs | CURRENT | =============================================

	_AppPath_Register
	_AppPath_Remove	
	_AppPath_Locate
	_AppPath_IsExist

#ce	=========================================================





