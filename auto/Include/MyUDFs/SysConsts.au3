#include-once

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <TrayConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <ProcessConstants.au3>
#include <DirConstants.au3>
#include <DateTimeConstants.au3>
#include <ColorConstants.au3>


Global $UDFName = 'SysConsts'





#cs | INDEX | ===============================================

	Title				SysConsts
	Description	 		

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				26.01.2018

#ce	=========================================================


;	Booleans

Global	$bIsWorkPC = (@ComputerName = 'MWI_2000') Or (@ComputerName = 'WorkPC') 
Global	$bIsHomePC = (@ComputerName = 'HomePC') Or (@ComputerName = 'EngPC')

Global	$bIsAsrorPC = $bIsHomePC Or $bIsWorkPC
Global	$bIsAsrorPCNotCompiled = Not @Compiled And $bIsAsrorPC


Global	$bIsNotWorkPC = Not $bIsWorkPC
Global	$bIsNotHomePC = Not $bIsHomePC

Global	$bIsNotAsrorPC = Not $bIsAsrorPC



Global	$scriptExit = @ScriptDir & '\App-Exit.cmd'
Global	$scriptRun = @ScriptDir & '\App-Run.cmd'

Global	$backupFolder = @ScriptDir & '\Backups'


Global	$ffsapp = 'd:\Develop\Projects\execut\app\ffsapp.ffs_batch'

;	Main Processor

AutoItWinSetTitle('')

If $bIsNotAsrorPC Then
    Opt("TrayIconHide", 1)
    Opt("TrayAutoPause", 0)
EndIf



If @ScriptName = $UDFName & '.au3' Then

    ConsoleWrite($bIsAsrorPC)

EndIf

