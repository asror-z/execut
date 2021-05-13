#include-once
#include <MyUDFs\Log.au3>


Global $UDFName = 'TTS'


#cs | INDEX | ===============================================

	Title				TTS
	Description	 		Text To Speech

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				02.03.2016

#ce	=========================================================


Global $bIsAsync = False


; #FUNCTION# ====================================================================================================================
; Name...........: _StartTTS
; Description ...: Creates a object to be used with Text-to-Speak Functions.
; Syntax.........: _StartTTS()
; Parameters ....:
; Return values .: Success - Returns a object
; Author ........: bchris01

; Example .......: Yes
; ===============================================================================================================================
Func _TTS()
    Return ObjCreate("SAPI.SpVoice")
EndFunc   ;==>_TTS

; #FUNCTION# ====================================================================================================================
; Name...........: _SetRate
; Description ...: Sets the rendering rate of the voice. (How fast the voice talks.)
; Syntax.........: _SetRate(ByRef $Object, $iRate)
; Parameters ....: $Object        - Object returned from _StartTTS().
;                  $iRate         - Value specifying the speaking rate of the voice. Supported values range from -10 to 10
; Return values .:	None
; Author ........: bchris01
; Example .......: Yes
; ===============================================================================================================================
Func _TTS_SetRate(ByRef $Object, $iRate); Rates can be from -10 to 10
    $Object.Rate = $iRate
EndFunc   ;==>_TTS_SetRate

; #FUNCTION# ====================================================================================================================
; Name...........: _SetVolume
; Description ...: Sets the volume of the voice.
; Syntax.........: _SetVolume(ByRef $Object, $iVolume)
; Parameters ....: $Object        - Object returned from _StartTTS().
;                  $iVolume       - Value specifying the volume of the voice. Supported values range from 0-100. Default = 100
; Return values .:	None
; Author ........: bchris01
; Example .......: Yes
; ===============================================================================================================================
Func _TTS_SetVolume(ByRef $Object, $iVolume);Volume
    $Object.Volume = $iVolume
EndFunc   ;==>_TTS_SetVolume

; #FUNCTION# ====================================================================================================================
; Name...........: _SetVoice
; Description ...: Sets the identity of the voice used for text synthesis.
; Syntax.........: _SetVoice(ByRef $Object, $sVoiceName)
; Parameters ....: $Object        - Object returned from _StartTTS().
;                  $sVoiceName    - String matching one of the voices installed.
; Return values .:	Success - Sets object to voice.
;					Failure - Sets @error to 1
; Author ........: bchris01
; Example .......: Yes
; ===============================================================================================================================
Func _TTS_SetVoice(ByRef $Object, $sVoiceName)

    Local $VoiceNames, $VoiceGroup = $Object.GetVoices
    Local $sDesc, $bIsInStr, $bIsEqual

	
    For $VoiceNames In $VoiceGroup
        ; _Log($VoiceNames, 'VoiceNames')

        $sDesc = $VoiceNames.GetDescription()

        $bIsInStr = StringInStr($sDesc, $sVoiceName) > 1
        $bIsEqual = ($sDesc = $sVoiceName)

        ; _Log($VoiceNames.GetDescription(), '$VoiceNames.GetDescription()')

        If $bIsEqual Or $bIsInStr Then
            $Object.Voice = $VoiceNames
            ExitLoop
        EndIf
    Next

    If @error Or (Not $bIsEqual And Not $bIsInStr) Then ExitBox($sVoiceName & ' is Not installed')

EndFunc   ;==>_TTS_SetVoice

; #FUNCTION# ====================================================================================================================
; Name...........: _GetVoices
; Description ...: Retrives the currently installed voice identitys.
; Syntax.........: _GetVoices(ByRef $Object[, $Return = True])
; Parameters ....: $Object        - Object returned from _StartTTS().
;                  $bReturn    	  - String of text you want spoken.
;				   |If $bReturn = True then a 0-based array is returned.
;				   |If $bReturn = False then a string seperated by delimiter "|" is returned.
; Return values .:	Success - Returns an array or string containing installed voice identitys.
; Author ........: bchris01
; Example .......: Yes
; ===============================================================================================================================
Func _TTS_GetVoices(ByRef $Object, $bReturn = True)
    Local $sVoices, $VoiceGroup = $Object.GetVoices
    For $Voices In $VoiceGroup
        $sVoices &= $Voices.GetDescription() & '|'
    Next
    If $bReturn Then Return StringSplit(StringTrimRight($sVoices, 1), '|', 2)
    Return StringTrimRight($sVoices, 1)
EndFunc   ;==>_TTS_GetVoices

; #FUNCTION# ====================================================================================================================
; Name...........: _Speak
; Description ...: Speaks the contents of the text string.
; Syntax.........: _Speak(ByRef $Object, $sText)
; Parameters ....: $Object        - Object returned from _StartTTS().
;                  $sText    	  - String of text you want spoken.
; Return values .:	Success - Speaks the text.
; Author ........: bchris01
; Example .......: Yes
; ===============================================================================================================================
Func _TTS_Speak(ByRef $Object, $sText)

    If $bIsAsync Then
        $Object.Speak($sText, 1)
    Else
        $Object.Speak($sText)
    EndIf
    
EndFunc   ;==>_TTS_Speak





#cs | TESTING | =============================================

	Name				T_TTS_SetAsync
	Author				Asror Zakirov (aka Asror.Z)
	Created				02.03.2016

#ce	=========================================================

Func T_TTS_SetAsync()
    

    _TTS_SetAsync()
    

EndFunc   ;==>T_TTS_SetAsync

#cs | FUNCTION | ============================================

	Name				_TTS_SetAsync

	Author				Asror Zakirov (aka Asror.Z)
	Created				02.03.2016

#ce	=========================================================

Func _TTS_SetAsync ($bAsyncType = True)
    
    
    $bIsAsync = $bAsyncType

EndFunc   ;==>_TTS_SetAsync



#Region Example

    If StringInStr(@ScriptName, $UDFName) Then
        T_SpeechSalli ()
        ;  T_GetVoices ()
    EndIf

#EndRegion Example





Func T_GetVoices ()

    $Default = _TTS()
    If Not IsObj($Default) Then
        MsgBox(0, 'Error', 'Failed create object')
        Exit
    EndIf

    MsgBox(0, 'Voices installed', StringReplace(_TTS_GetVoices($Default, False), '|', @CRLF))

    $aVoiceSelection = _TTS_GetVoices($Default)

    _Log($aVoiceSelection)

EndFunc   ;==>T_GetVoices


Func T_SpeechSalli ()

    $oSally = _TTS()
    _TTS_SetVoice($oSally, 'Salli')
    _TTS_Speak($oSally, 'Hello my name is Mike.')
    _TTS_SetRate($oSally, 5)
    _TTS_Speak($oSally, 'This is Sam talking really really fast.')
    _TTS_SetRate($oSally, -5)
    _TTS_Speak($oSally, 'This is Sam talking slow.')

EndFunc   ;==>T_SpeechSalli




Func T_Async ()

    $Mike = _TTS()
	_TTS_SetAsync()
    _TTS_SetVoice($Mike, 'Kimberly')
    _TTS_Speak($Mike, 'Hello my name is Mike.')
	

EndFunc 