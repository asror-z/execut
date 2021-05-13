



#cs | FUNCTION | ============================================

	Name				ProcessCloseReal
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				24.12.2017

#ce	=========================================================
Func _ProcessCloseReal($sProcess)

    If ProcessExists($sProcess) Then
        If ProcessClose($sProcess) = 1 Then
            Return True
        Else
            Return False
        EndIf
    Else
        Return True
    EndIf

EndFunc   ;==>ProcessCloseReal

