#include <MsgBoxConstants.au3>
#include <GuiListBox.au3>
#include <GuiConstantsEx.au3>
#include <File.au3>
#include <Array.au3>
#include <MyUDFs\TC.au3>
#include <MyUDFs\Es2.au3>
#include <MyUDFs\Exit.au3>

#include-once


Global $UDFName 	= 	'EsMake'
$bDebug  = False


; TC Variables

Global $allItems

If Not $bDebug Then

    $sCurrentPath = _TC_PathP_GetText()
    $sOppositePath = _TC_PathP_GetText(False)

    $sSelectedItemName = _TC_ListB_GetTextUnderCaret()
    $allItems = _TC_ListB_GetSelectedItems()

Else


    $sOppositePath = 'd:\Develop\System\AutoIT\Element\Automat\Everything\EsMake\'

    $sCurrentPath = 'd:\Develop\MySQL\Installer\'
    $sSelectedItemName = '5_7_19'

    $sCurrentPath = 'd:\Platform\Platform\Windows\Element\Users\Auto Login\Netplwiz (Native)\'
    $sSelectedItemName = 'Turn Off'

EndIf

; _ArrayDisplay($allItems)

If UBound($allItems) > 1 Then
    
    
    For $i = 1 To Ubound($allItems) - 1
	
		$sSelectedItemName = $allItems[$i]
        $sSelectedItemFullPath = $sCurrentPath & $sSelectedItemName
        Process_Path($sSelectedItemFullPath)
    Next

    
Else
    $sSelectedItemFullPath = $sCurrentPath & $sSelectedItemName
    Process_Path($sSelectedItemFullPath)

EndIf






#cs | FUNCTION | ============================================

	Name				Process_Path
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				12/14/2020

#ce	=========================================================
Func Process_Path($sSelectedItemFullPath)

 ;   Mbox($sSelectedItemFullPath)

    ; BK: aParts

    $aParts = StringSplit($sSelectedItemFullPath, "\")

    _ArrayDelete($aParts, 0)
    _ArrayDelete($aParts, 0)
    _ArrayReverse($aParts)

    $iCount = Ubound($aParts) - 1



    ;	sKeywords

    $sKeywords = ''
    ; $sKeywords = '- Theory|Account	|AppsGUI|AppsIDE|Buyings|Pricings|Cheatsh|Element|Installer|Utilities|Learning|Manuals|Portable|Projects|Screens|Settings|Sources|Chrome|Mozilla|Activate|Cmdline|Problem|Framers|Manager|Identity|Cheater|Offlines|Services|Develop|Depend'

    $aKeywords = StringSplit($sKeywords, "|")




    ;	sOtherKeys

    $sOtherKeys = '@ Other|@ Weak|@ Dead'






    ;	CheckKeywords

    $bNoKeywords = True

    For $vElement In $aKeywords

        If StringInStr($sSelectedItemFullPath, $vElement) > 0 Then
            $bNoKeywords = False
        EndIf

    Next



    _Log($aParts)

    If $bNoKeywords Then

        ; BK: If Path DOES NOT CONTAIN keywords !
        _Log('If Path DOES NOT CONTAIN keywords !')

        $sString = '\ \' & $sSelectedItemName
        $bFirstItem = False
        $bFirstItemUsed = False




        For $i = 1 To $iCount
            $vElement = $aParts[$i]

            If $i = $iCount Then
                $bIsLastItem = True
            Else
                $bIsLastItem = False
            EndIf

            $bContainsOther = StringInStr($sOtherKeys, $vElement) > 0

            ;_Log('$vElement')
            ;_Log('$bIsLastItem')


            If Not $bContainsOther And Not $bIsLastItem And Not $bFirstItemUsed Then
                $bFirstItem = True

            EndIf

            If $bFirstItem Then
                $sString = $vElement & $sString

                $bFirstItem = False
                $bFirstItemUsed = True

                $sSelectedItemName = $vElement & ' - ' & $sSelectedItemName

            ElseIf $bIsLastItem Then

                $sString = '\' & $vElement & '\' & $sString
                $bIsLastItem = False

            ElseIf Not $bContainsOther Then

                $sString = ' \' & $sString

            EndIf



            $bIsElement = False

            If StringInStr($sKeywords, $vElement) > 0 Then

            ElseIf $bIsElement = True Then

                $sString = '\' & $vElement & '\' & $sString
                $bIsElement = False

            EndIf

            ;    _Log($vElement)

        Next


    Else


        _Log('If Path CONTAINS keywords !')


        $sString = '\ \' & $sSelectedItemName
        $bIsElement = False
        $bIsFirstElement = False


        ;	\Stardock Start10\Installer\ \1_11



        For $vElement In $aParts

            If StringInStr($sKeywords, $vElement) > 0  Then

                If Not $bIsFirstElement  Then
                    ;	Fixing Two Element words in Path

                    If Not $sSelectedItemName = $vElement Then
                        $sString = $vElement & $sString
                    EndIf

                    $bIsElement = True
                    $bIsFirstElement = True

                    _Log('StringInStr($sKeywords, $vElement) > 0 | ' & $vElement & @CRLF)
                    _Log($sString & @CRLF)

                EndIf

            ElseIf $bIsElement = True Then

                $sString = '\' & $vElement & '\' & $sString
                $sSelectedItemName = $vElement & ' - ' & $sSelectedItemName
                $bIsElement = False

                _Log('$bIsElement = True | ' & $vElement& @CRLF)
                _Log($sString & @CRLF)

            EndIf

            ; _Log($vElement)


        Next

    EndIf




    ;	Write To File

    $sFileName = $sOppositePath & $sSelectedItemName & '.go'

    $sString = StringReplace($sString, ' \ \', ' \')
    $sString = StringReplace($sString, '\\', '\')
    $sString = StringReplace($sString, ' \ \', ' \')
    $sString = StringReplace($sString, '  ', ' ')


    _FZ_FileWrite($sFileName, $sSelectedItemFullPath)
    _FZ_FileWrite($sFileName, $sString, @CRLF)


    If Not FileExists($sFileName) Then
        MBox('Cannot Write: ' & $sFileName)
    EndIf


    _Log('$starget')
    _Log('$sCurrentPath')
    _Log('$sString')


EndFunc   ;==>Process_Path



