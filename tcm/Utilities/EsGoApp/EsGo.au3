#include-once
#include <GUIConstantsEx.au3>
#include <MyUDFs\ShellFile.au3>
#include <MyUDFs\Es2.au3>
#include <MyUDFs\TC.au3>
#include <MyUDFs\Log.au3>




Global $UDFName = 'EsGo'


#cs | INDEX | ===============================================

	Title				EsGo
	Description	 		EsGo

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				03.03.2017

#ce	=========================================================




If @Compiled = 0 Then ExitBox('Please compile the program before testing')


_ShellFile_Install('Go to via ETH', 'go')


If $CmdLine[0] > 0 Then

    Local $sFilePath = $CmdLine[1]
    Local $aRetArray

    _FileReadToArray($sFilePath, $aRetArray)
    ; _ArrayDisplay($aRetArray)



    If $aRetArray[0] = 2 Then
        If FileExists($aRetArray[1]) Then
            $sItem = $aRetArray[1]
        Else
            $sItem = _ES_SearchFolderPath($aRetArray[2])
        EndIf

    Else
        $sFileContent = $aRetArray[1]
        $sItem = _ES_SearchFolderPath($sFileContent)
    EndIf



    If StringInStr($sFilePath, 'I:') > 0  Then

        $IPath = StringReplace($sItem, 'D:', 'I:')
        $sItem = $IPath

    EndIf

    ShellExecute('TotalCmd64.exe', '/O /R="' & $sItem & '"')
    Send('{TAB}')


    Switch True
        Case FileExists($sItem & '\Conf-Set.au3')
            ShellExecuteWait($sItem & '\Conf-Set.au3')

        Case FileExists($sItem & '\Readme.run')
            $array = FileReadToArray($sItem & '\Readme.txt')

            For $vElement In $array
				
				$file = $sItem & '\' & $vElement
			
                If FileExists($file) Then
                    ShellExecuteWait($file)
                EndIf
            Next

        Case FileExists($sItem & '\Reg-Set.au3')
            ShellExecuteWait($sItem & '\Reg-Set.au3')

        Case Not _FZ_Check($sItem, $eFZC_IsDirectory)
            ShellExecuteWait($sItem)

    EndSwitch


EndIf





