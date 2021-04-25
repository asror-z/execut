#include <MyUDFs\Exit.au3>
#include <MyUDFs\FileZ.au3>

if ($CmdLine[0] < 3) Then ExitBox('Arguments count error!')'')


$wait = $CmdLine[1]
$app = $CmdLine[2]
$cmd = $CmdLine[3]


if ($wait <> 0) Then
    $wait = $wait * 1000
EndIf

$cmdApp = $app & ' ' & $cmd

_Log('Execute Time: ' & $wait)
_Log('Execute Command: ' & $cmdApp)
_Eol()

_Eol()

Sleep(500)

While True
    RunCmdRead($cmdApp)
    _Eol()
    _Log('Waiting for next run')
    _Eol()
	
    if ($wait <> 0) Then
        Sleep($wait)
    EndIf

WEnd


; RunCmdRead('"t:\Message\VOIP\CallApp\Portable\yii2_callapp\asrorz.cmd" lost/run')
;

