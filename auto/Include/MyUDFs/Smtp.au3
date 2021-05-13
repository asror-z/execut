#include-once
#include <File.au3>
#include <MyUDFs\Exit.au3>
#include <MyUDFs\Log.au3>


Global $UDFName = 'Smtp'


#cs | INDEX | ===============================================

	Title				Smtp.au3
	Description

	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				13.02.2018

#ce	=========================================================



#cs | CURRENT | =============================================

	_SMTP_Google($sToAddress, $sSubject, $sBody, $sAttachFiles)
	_SMTP_Google_Your($sSubject, $sBody, $sAttachFiles)
	_SMTP_SendEmail($s_SmtpServer, $s_Username, $s_Password, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = '', $s_Importance = "High", $i_IPPort = 465, $b_SSL = True, $b_IsHTMLBody = True, $i_DSNOptions = $g__cdoDSNDefault, $sEMLPath_SaveBefore = '', $sEMLPath_SaveAfter = '')
	_SMTP_SaveMessageToFile(ByRef $oMessage, $sFileFullPath, $sCharset = "US-ASCII")

#ce	=========================================================

#Region Variables

	Global Enum _
	        $SMTP_ERR_SUCCESS, _
	        $SMTP_ERR_FILENOTFOUND, _
	        $SMTP_ERR_SEND, _
	        $SMTP_ERR_OBJECTCREATION

	Global Const $g__cdoSendUsingPickup = 1 ; Send message using the local SMTP service pickup directory.
	Global Const $g__cdoSendUsingPort = 2 ; Send the message using the network (SMTP over the network). Must use this to use Delivery Notification

	
	
	;	Auth Type

	Global Const $g__cdoAnonymous = 0 ; Do not authenticate
	Global Const $g__cdoBasic = 1 ; basic (clear-text) authentication
	Global Const $g__cdoNTLM = 2 ; NTLM

	

	; Delivery Status Notifications
	
	Global Const $g__cdoDSNDefault = 0 ; None
	Global Const $g__cdoDSNNever = 1 ; None
	Global Const $g__cdoDSNFailure = 2 ; Failure
	Global Const $g__cdoDSNSuccess = 4 ; Success
	Global Const $g__cdoDSNDelay = 8 ; Delay
	Global Const $g__cdoDSNSuccessFailOrDelay = 14 ; Success, failure or delay

#EndRegion Variables




#Region Example

	If @ScriptName = $UDFName Then

	    T_SMTP_Google()
		
	    ; T_SMTP_SendEmail()
	    ; T_SMTP_Send_ALL()
	    ; T_SMTP_SaveMessageToFile()

	EndIf

#EndRegion Example




#cs | FUNCTION | ============================================

	Name				_SMTP_Google
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func _SMTP_Google($sToAddress, $sSubject, $sBody, $sAttachFiles)

	Local $sSmtpServer = "smtp.gmail.com"
	Local $sUsername = "mytestemailcom@gmail.com"
	Local $sPassword = "testpass33"
	Local $sFromName = "Test Mail Sender"
	Local $sFromAddress = "mytestemailcom@gmail.com"

	Local $bResult = _SMTP_SendEmail($sSmtpServer, $sUsername, $sPassword, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles)

	_Log($bResult, 'Mail Status For ' & $sToAddress & ': ')

	Return $bResult

EndFunc   ;==>_SMTP_Google


#cs | TESTING | =============================================

	Name				T_SMTP_Google

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func T_SMTP_Google()

	Local $sToAddress = "asror.zk@gmail.com"
	Local $sSubject = "3333 Userinfo Test"
	Local $sBody = "Some text/html to send as body part <br> <table><tr><td>safasf</td><td>safasf</td></tr></table>"
	Local $sAttachFiles = @ScriptFullPath & '|' & @ScriptFullPath
	
	_SMTP_Google($sToAddress, $sSubject, $sBody, $sAttachFiles)

EndFunc   ;==>T_SMTP_Google




#cs | FUNCTION | ============================================

	Name				_SMTP_Google_Your
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				14.02.2018

#ce	=========================================================

Func _SMTP_Google_Your($sSubject, $sBody, $sAttachFiles)

	Local $sToAddress = "yourtestemailcom@gmail.com"
	
	_SMTP_Google($sToAddress, $sSubject, $sBody, $sAttachFiles)

EndFunc


#cs | TESTING | =============================================

	Name				T_SMTP_Google_Your

	Author				Asror Zakirov (aka Asror.Z)
	Created				14.02.2018

#ce	=========================================================

Func T_SMTP_Google_Your()

	_SMTP_Google_Your('adad', 'adadadada', @ScriptFullPath)

EndFunc 




#cs | FUNCTION | ============================================

	Name            _SMTP_SendEmail
	Description
	                 $s_AttachFiles = ""[, $s_CcAddress = ""[, $s_BccAddress = ""[, $s_Importance = "Normal"[, $s_Username = ""[,
	                 $s_Password = ""[, $i_IPPort = 25[, $b_SSL = False[, $b_IsHTMLBody = False[, $i_DSNOptions = $g__cdoDSNDefault]]]]]]]]]]]])

	Parameters      $s_SmtpServer        - A string value  Address for the smtp-server to use  - REQUIRED
	                 $s_Username          - A string value  Username for the account used from where the mail gets sent - REQUIRED
	                 $s_Password          - A string value. Password for the account used from where the mail gets sent - REQUIRED
	                 $s_FromName          - A string value  Name from who the email was sent - REQUIRED
	                 $s_FromAddress       - A string value. Address from where the mail should come - REQUIRED
	                 $s_ToAddress         - A string value. Destination email address - REQUIRED
	                 $s_Subject           - [optional] A string value. Default is "". Subject from the email - can be anything you want it to be.
	                 $s_Body              - [optional] A string value. Default is "". The messagebody from the mail - can be left blank but then you get a blank mail.
	                 $s_AttachFiles       - [optional] A string value. Default is "". The file(s) you want to attach seperated with a 	(Semicolon) - leave blank if not needed.
	                 $s_CcAddress         - [optional] A string value. Default is "". Address for cc - leave blank if not needed.
	                 $s_BccAddress        - [optional] A string value. Default is "". Address for bcc - leave blank if not needed.
	                 $s_Importance        - [optional] A string value. Default is "Normal". Send message priority: "High", "Normal", "Low".
	                 $i_IPPort            - [optional] An integer value. Default is 465. TCP Port used for sending the mail
	                 $b_SSL               - [optional] A binary value. Default is True. Enables/Disables secure socket layer sending - set to True if using https.
	                 $b_IsHTMLBody        - [optional] A binary value. Default is False.
	                 $i_DSNOptions        - [optional] An integer value. Default is $g__cdoDSNDefault.

	Return values   None

	Remarks         This function is based on the function created by Jos (see link in related)

#ce	=========================================================

Func _SMTP_SendEmail($s_SmtpServer, $s_Username, $s_Password, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = '', $s_Importance = "High", $i_IPPort = 465, $b_SSL = True, $b_IsHTMLBody = True, $i_DSNOptions = $g__cdoDSNDefault, $sEMLPath_SaveBefore = '', $sEMLPath_SaveAfter = '')

	Local $oEmail = ObjCreate("CDO.Message")
	If Not IsObj($oEmail) Then ExitBox('SMTP_ERR_OBJECTCREATION')


	$oEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$oEmail.To = $s_ToAddress

	If $s_CcAddress <> "" Then $oEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $oEmail.Bcc = $s_BccAddress
	$oEmail.Subject = $s_Subject


	; Select whether or not the content is sent as plain text or HTM

	If $b_IsHTMLBody Then
	    $oEmail.HTMLBody = $s_Body
	Else
	    $oEmail.Textbody = $s_Body & @CRLF
	EndIf

	; Add Attachments
	If $s_AttachFiles <> "" Then
	    Local $S_Files2Attach = StringSplit($s_AttachFiles, "|")
	    For $x = 1 To $S_Files2Attach[0]
	        $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])

	        If FileExists($S_Files2Attach[$x]) Then
	            _Log('File attachment added: ' & $S_Files2Attach[$x])
	            $oEmail.AddAttachment($S_Files2Attach[$x])
	        Else
	            ExitBox('File not found to attach: ' & $S_Files2Attach[$x])
	        EndIf

	    Next
	EndIf



	; 	Set Email Configuration

	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = $g__cdoSendUsingPort
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	If Number($i_IPPort) = 0 Then $i_IPPort = 25
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $i_IPPort



	;	Authenticated SMTP

	If $s_Username <> '' Then


	    $oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = $g__cdoBasic



	    ;	User and Password

	    $oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
	    $oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password

	EndIf

	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = $b_SSL

	;Update Configuration Settings
	$oEmail.Configuration.Fields.Update

	; Set Email Importance
	Switch $s_Importance
	    Case "High", "Normal", "Low"
	        $oEmail.Fields.Item("urn:schemas:mailheader:Importance") = $s_Importance
	    Case Else
	        ; TODO
	EndSwitch

	; Set DSN options
	If $i_DSNOptions <> $g__cdoDSNDefault And $i_DSNOptions <> $g__cdoDSNNever Then
	    $oEmail.DSNOptions = $i_DSNOptions
	    $oEmail.Fields.Item("urn:schemas:mailheader:disposition-notification-to") = $s_FromAddress
	    $oEmail.Fields.Item("urn:schemas:mailheader:return-receipt-to") = $s_FromAddress
	EndIf

	; Update Importance and Options fields
	$oEmail.Fields.Update

	; Saving Message before sending
	If $sEMLPath_SaveBefore <> '' Then _SMTP_SaveMessageToFile($oEmail, $sEMLPath_SaveBefore)

	; Sent the Message
	$oEmail.Send
	If @error Then
	    Return SetError($SMTP_ERR_SEND, 0, False)
	EndIf

	; Saving Message after sending
	If $sEMLPath_SaveAfter <> '' Then _SMTP_SaveMessageToFile($oEmail, $sEMLPath_SaveAfter)

	; CleanUp
	$oEmail = Null


	Return True

EndFunc   ;==>_SMTP_SendEmail


#cs | TESTING | =============================================

	Name				T_SMTP_SendEmail

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func T_SMTP_SendEmail()

	Local $sSmtpServer = "smtp.gmail.com"
	Local $sUsername = "mytestemailcom@gmail.com"
	Local $sPassword = "testpass33"
	Local $sFromName = "Test Mail"
	Local $sFromAddress = "mytestemailcom@gmail.com"
	Local $sToAddress = "asror.zk@gmail.com"
	Local $sSubject = "2222 Userinfo Test"
	Local $sBody = "Some text/html to send as body part <br> <table><tr><td>safasf</td><td>safasf</td></tr></table>"
	Local $sAttachFiles = @ScriptFullPath

	Local $bResult = _SMTP_SendEmail($sSmtpServer, $sUsername, $sPassword, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles)

	_Log($bResult)

EndFunc   ;==>T_SMTP_SendEmail


#cs | TESTING | =============================================

	Name				T_SMTP_SendEmail_ALL

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func T_SMTP_Send_ALL()

	Local $sSmtpServer = "smtp.gmail.com"
	Local $sUsername = "mytestemailcom@gmail.com"
	Local $sPassword = "testpass33"
	Local $sFromName = "Test Mail"
	Local $sFromAddress = "mytestemailcom@gmail.com"
	Local $sToAddress = "asror.zk@gmail.com"
	Local $sSubject = "2222 Userinfo Test"
	Local $sBody = "Some text/html to send as body part <br> <table><tr><td>safasf</td><td>safasf</td></tr></table>"
	Local $sAttachFiles = @ScriptDir & '\File.txt|' & @ScriptDir & '\Sample-02.au3'
	Local $sCcAddress = "asror.z@yandex.com"
	Local $sBccAddress = "asror.z@nasvyazi.uz"
	Local $sImportance = "High"



	Local $iIPPort = 465
	Local $bSSL = True
	; Local $iIPPort = 465 ; GMAIL port used for sending the mail
	; Local $bSSL = True ; GMAIL enables/disables secure socket layer sending - set to True if using https

	Local $bIsHTMLBody = True

	Local $iDSNOptions = $g__cdoDSNDefault

	Local $bResult = _SMTP_SendEmail($sSmtpServer, $sUsername, $sPassword, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $sAttachFiles, $sCcAddress, $sBccAddress, $sImportance, $iIPPort, $bSSL, $bIsHTMLBody, $iDSNOptions, @ScriptDir & '\aa.eml')
	_Log($bResult)


EndFunc   ;==>T_SMTP_Send_ALL




#cs | FUNCTION | ============================================

	Name            _SMTP_SaveMessageToFile
	Description

	Parameters      $oMessage            - [in/out] an object
	                 $sFileFullPath       - A string value.
	                 $sCharset            - [optional] a string value. Default is "US-ASCII".

	Return values   None

	Remarks

#ce	=========================================================

Func _SMTP_SaveMessageToFile(ByRef $oMessage, $sFileFullPath, $sCharset = "US-ASCII")

	Local $oStream = ObjCreate("ADODB.Stream")
	$oStream.Open
	$oStream.Type = 2 ; adTypeText
	$oStream.Charset = $sCharset

	$oMessage.DataSource.SaveToObject($oStream, "_Stream")

	; https://msdn.microsoft.com/en-us/library/windows/desktop/ms676152(v=vs.85).aspx
	$oStream.SaveToFile($sFileFullPath, 2) ; adSaveCreateOverWrite = 2

	; CleanUp
	$oStream = Null

EndFunc   ;==>_SMTP_SaveMessageToFile


#cs | TESTING | =============================================

	Name				T_SMTP_SaveMessageToFile

	Author				Asror Zakirov (aka Asror.Z)
	Created				13.02.2018

#ce	=========================================================

Func T_SMTP_SaveMessageToFile()

EndFunc   ;==>T_SMTP_SaveMessageToFile




