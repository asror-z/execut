#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIEx.au3>
#include <TrayConstants.au3>
#include <MsgBoxConstants.au3>
#include <MyUDFs\Startup.au3>
#include <Misc.au3>

#include <MyUDFs\Startup.au3>
#include <MyUDFs\Exit.au3>
#include <MyUDFs\Executer.au3>
#include <MyUDFs\ProcessCloseAll.au3>
#include <MyUDFs\FileZ.au3>

#pragma compile(FileDescription, 'RX Settings')
#pragma compile(ProductName, 'RX Settings')
#pragma compile(ProductVersion, 1.1.7601.22099)
#pragma compile(FileVersion,  1.1.7601, 6.1.7601.22099)
#pragma compile(LegalCopyright, '© AsrorZ Business Solutions. Все права защищены')
#pragma compile(LegalTrademarks, 'AsrorZ Business Solutions')
#pragma compile(CompanyName, 'AsrorZ Business Solutions')

_Singleton(@ScriptName)

$SF = _StartupFolder_Install()


;	Starting

$iMinDelay = 10

TraySetState($TRAY_ICONSTATE_SHOW)
TraySetToolTip('Executer! Execute Apps')

#Region Exec

    Executer(@ScriptDir & '\ALL')

    If $bIsAsrorPC Then
        Executer(@ScriptDir & '\FS')
        Executer(@ScriptDir & '\AZ')
    EndIf

    If $bIsHomePC Then Executer(@ScriptDir & '\HM')
    If $bIsWorkPC Then Executer(@ScriptDir & '\WR')

#EndRegion Exec


