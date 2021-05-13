


#cs | FUNCTION | ============================================

	Name				IsDir
	Desc				
							
	Author				Asror Zakirov (aka Asror.Z)
	Created				25.01.2018

#ce	=========================================================

Func IsDir($sFilePath)
    Return StringInStr(FileGetAttrib($sFilePath), "D") > 0
EndFunc   ;==>IsDir