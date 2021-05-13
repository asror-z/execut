#include<WinAPIEx.au3>
#include<APIConstants.au3>




Global Enum $eAppX64, $eAppX32



Global $UDFName = 'GetProgramFiles'


If @ScriptName = $UDFName & '.au3' Then

    $ss	=	GetProgramFiles($eAppX32)
    ConsoleWrite($ss & @CRLF)

    $ss	=	GetProgramFiles($eAppX64)
    ConsoleWrite($ss & @CRLF)


EndIf



Func GetProgramFiles($bAppArch)

    Switch @OSArch

        Case 'X64'
            If $bAppArch = $eAppX64 Then
                Return @HomeDrive & '\' & 'Program Files'
            Else
                Return @HomeDrive & '\' & 'Program Files (x86)'
            EndIf

        Case 'X86'
            Return @HomeDrive & '\' & 'Program Files'

    EndSwitch

EndFunc   ;==>GetProgramFiles