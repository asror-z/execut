



#cs | FUNCTION | ============================================

	Name				_SC_Start
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func _SC_Start($sServiceName)

	$sCmdFile = 'sc start "' & $sServiceName & '"'
	RunWait($sCmdFile, @TempDir, @SW_HIDE)

EndFunc   ;==>_SC_Start




#cs | FUNCTION | ============================================

	Name				_SC_Stop
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func _SC_Stop($sServiceName)

	$sCmdFile = 'sc stop "' & $sServiceName & '"'
	RunWait($sCmdFile, @TempDir, @SW_HIDE)

EndFunc


#cs | TESTING | =============================================

	Name				T_SC_Stop

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_SC_Stop()

	_Log("_SC_Stop($sServiceName)")

EndFunc   ;==>_SC_Start


#cs | TESTING | =============================================

	Name				T_SC_Start

	Author				Asror Zakirov (aka Asror.Z)
	Created				19.02.2018

#ce	=========================================================

Func T_SC_Start()

	_SC_Start('NvTelemetryContainer')

EndFunc   ;==>T_SC_Start

