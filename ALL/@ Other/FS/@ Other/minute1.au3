#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\FileZ.au3>
#include <MyUDFs\Git.au3>
#NoTrayIcon

$backupFolder = 'd:\Develop\Projects\asrorz\'
$configFolder = 'd:\Develop\Projects\history\minute1\'

$iDelay = 1 * 60 * 1000

_Sync($iDelay)
