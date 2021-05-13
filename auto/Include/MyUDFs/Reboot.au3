#include <MsgBoxConstants.au3>
#include <MyUDFs\Exit.au3>

#RequireAdmin

Func Reboot($iSec)
    $command = ("C:\Windows\System32\shutdown.exe /r /t " & $iSec)
    Run ($command)
	
	MBox('Your PC will be restarted in ' & $iSec & ' seconds')
EndFunc


Func NotReboot()
    $command = ("C:\Windows\System32\shutdown.exe /a")
    Run ($command)
	
	MBox('PC restart is prevented ' )
EndFunc

