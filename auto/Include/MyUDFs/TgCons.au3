#include-once
#include <MyUDFs\Dict.au3>

#include-once

Global $UDFName = 'TgCons'


#cs | INDEX | ===============================================

	Title				TgCons
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				23.01.2018

#ce	=========================================================




$TgToken = '280253273:AAG5oiNEFPvTpy8LdnX4RPL1reeZCVx4uKM'


$Log_Error 	=	'-275430294'
$Log_Warn 	=	'-244377155'
$Log_Info 		= 	'-304024896'

$sCRLF 			= 	'%0A'



Local $ChatMon[13]

$ChatMon[0]		=	'-275430294'

$ChatMon[1]		=	'-262552211'
$ChatMon[2]		=	'-260704028'
$ChatMon[3]		=	'-260460378'
$ChatMon[4]		=	'-190964257'
$ChatMon[5]		=	'-250481278'
$ChatMon[6]		=	'-305656647'
$ChatMon[7]		=	'-316935492'
$ChatMon[8]		=	'-255511773'
$ChatMon[9]		=	'-267607660'
$ChatMon[10]	=	'-316854875'
$ChatMon[11]	=	'-276009687'
$ChatMon[12]	=	'-310392374'






$aServer = Dict()

Dict_Add($aServer, 'WorkPC', 1)
Dict_Add($aServer, 'NSB-102', 2)
Dict_Add($aServer, 'NSB-11', 3)
Dict_Add($aServer, 'NSB-12', 4)
Dict_Add($aServer, 'NSB-13', 5)
Dict_Add($aServer, 'NSB-14', 6)
Dict_Add($aServer, 'NSB-15', 7)
Dict_Add($aServer, 'NSB-16', 8)
Dict_Add($aServer, 'NSB-17', 9)
Dict_Add($aServer, 'HomePC', 10)
Dict_Add($aServer, 'Home-11', 11)
Dict_Add($aServer, 'Home-12', 12)
Dict_Add($aServer, 'Home-13', 13)
Dict_Add($aServer, 'Home-14', 14)
Dict_Add($aServer, 'Home-15', 15)



Func _GetServer()

	$sPCName = @ComputerName
	$iNum =  $aServer($sPCName)
	
	If $iNum < 1 Then
		$iNum = 0	
	EndIf

	Return $iNum
	
EndFunc 


Func _GetUser()

	$sUsername = @UserName
	
	$sUsername = StringReplace($sUsername, 'Администратор', 'Admin-Ru')
	$sUsername = StringReplace($sUsername, 'СИСТЕМА', 'System-Ru')

	Return $sUsername
	
EndFunc 





If @ScriptName = $UDFName & '.au3' Then

    $iNum = _GetServer()
	_Log($iNum)
	
	_Log(_GetUser())

EndIf
