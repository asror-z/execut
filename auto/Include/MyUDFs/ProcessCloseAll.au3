



#cs | FUNCTION | ============================================

	Name				ProcessCloseAll
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				23.01.2018

#ce	=========================================================
Func ProcessCloseAll($sName)

    Local $process = ProcessList($sName)
    For $i = 1 To $process[0][0]
        ProcessClose($process[$i][1])
    Next

EndFunc ;==>ProcessCloseAll


