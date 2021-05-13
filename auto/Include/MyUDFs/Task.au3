#include-once
#include <Array.au3>
#include <Misc.au3>
#include <MyUDFs\Exit.au3>

Global $UDFName = 'Task.au3'


#cs | INDEX | ===============================================

	Title				Task.au3
	Description
	Type				UDF
	AutoIt Version		3.3.14.0

	Author				Asror Zakirov (aka Asror.Z)
	E-Mail			 	Asror.ZK@gmail.com
	Created				31.01.2018

#ce	=========================================================




#Region Variables


    Global $wbemFlagReturnImmediately = 0x10
    Global $wbemFlagForwardOnly = 0x20

    Const $VT_EMPTY = 0
    Const $VT_NULL = 1




    ;	$iTriggerEvent            => http://msdn.microsoft.com/en-us/library/aa383898%28v=VS.85%29.aspx

    Const $TRIGGER_TIME = 1			; Triggers the task at a specific time of day.
    Const $TRIGGER_DAILY = 2		; Triggers the task on a daily schedule. For example, the task starts at a specific time every day, every-other day, every third day, and so on.
    Const $TRIGGER_WEEKLY = 3		; Triggers the task on a weekly schedule. For example, the task starts at 8:00 AM on a specific day every week or other week.
    Const $TRIGGER_MONTHLY = 4		; Triggers the task on a monthly schedule. For example, the task starts on specific days of specific months.
    Const $TRIGGER_MONTHLYDOW = 5	; Triggers the task on a monthly day-of-week schedule. For example, the task starts on a specific days of the week, weeks of the month, and months of the year.
    Const $TRIGGER_IDLE = 6			; Triggers the task when the computer goes into an bIdle state.
    Const $TRIGGER_REGISTRATION = 7	; Triggers the task when the task is registered.
    Const $TRIGGER_BOOT = 8			; Triggers the task when the computer boots. => Needs Admin-Rights!
    Const $TRIGGER_LOGON = 9		; Triggers the task when a specific user logs on. => Needs Admin-Rights!
    Const $TRIGGER_SESSION_STATE_CHANGE = 11		; Triggers the task when a specific session state changes. => Needs Admin-Rights!





    ;	$iMultiinst				=> Optional int Default is 0

    Const $MULTIINST_ALWAYS_RUNS = 0 	;	0: run while task is running
    Const $MULTIINST_PUT_QUEUE = 1		;	1: put new task in queu to start after running task has finished
    Const $MULTIINST_DONT_START = 2		;	2: do not start if running
    Const $MULTIINST_STOP_RUNNING = 3	;	3: stop running task on start



    Const $RUNLEVEL_LOWEST = 0
    Const $RUNLEVEL_HIGHEST = 1



    ;	$iLogonType
    ;	http://msdn.microsoft.com/en-us/library/aa382075%28v=VS.85%29.aspx

    Const $LOGON_SAVE_PASSWORD = 1			;	1= Save sPassword;
    Const $LOGON_LOGON_S4U = 2				;	2 = TASK_LOGON_S4U / Independant from an userlogin sPassword not saved only local resources;
    Const $LOGON_ALREADY_LOGON = 3			;	3 = User must already be logged in


#EndRegion Variables



#Region Example

    If @ScriptName = $UDFName Then


        T_TaskAdd()

        ;   T_TaskFolderCreate()
        ;   T_TaskFolderDelete()
        ;   T_TaskFolderExists()
        ;   T_TaskExists()
        ;   T_TaskStop()
        ;   T_TaskEnable()
        ;   T_TaskDisable()
        ;   T_TaskIsEnabled()
        ;   T_TaskStart()
        ;   T_TaskIsRunning()
        T_TaskDelete()
        ;   T_TaskListAll()
        ; T_TaskCreate()
        ;   T_TaskSchedulerAutostart()
        ;   T_TaskIsValidPlatfrom()

    EndIf

#EndRegion Example




#cs | FUNCTION | ============================================

	Name				_TaskAdd
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

	$iTriggerEvent            => http://msdn.microsoft.com/en-us/library/aa383898%28v=VS.85%29.aspx

		Const $TRIGGER_BOOT = 8			; Triggers the task when the computer boots. => Needs Admin-Rights!
		Const $TRIGGER_LOGON = 9		; Triggers the task when a specific user logs on. => Needs Admin-Rights!


	$iLogonType               	
	;	http://msdn.microsoft.com/en-us/library/aa382075%28v=VS.85%29.aspx

		Const $LOGON_SAVE_PASSWORD = 1			;	1= Save sPassword;
		Const $LOGON_LOGON_S4U = 2				;	2 = TASK_LOGON_S4U / Independant from an userlogin sPassword not saved only local resources;
		Const $LOGON_ALREADY_LOGON = 3			;	3 = User must already be logged in	




#ce	=========================================================

Func _TaskAdd($sTaskName, $sTaskFolder, $sTaskDescription, $sProgram, $sArguments, $sUsername, $sPassword, $iTriggerEvent, $iLogonType)

    $iRunLevel = $RUNLEVEL_HIGHEST
    $iMultiinst = $MULTIINST_DONT_START

    $sRepetitionInterval = 'PT1H'
    $bRepetitionEnabled = True
    $bRunOnlyIfNetworkAvailable = False
    $bActive = True
    $bNobatstart = False
    $bStoponBat = False
    $bHidden = True
    $bIdle = False
    $bWakeToRun = True
    $sTimelimit = 'P100D'
    $iPriority = 0
    $sDuration = ""
    $sWorkingDirectory = ''
    $bStartWhenAvailable = True

    $sStartTrigger = ''
    $sEndTrigger = ''
    $iDaysOfWeek = ''
    $iDaysOfMonth = ''
    $iMonthOfYear = ''
    $iWeeksOfMonth = 0
    $iDaysInterval = 0

#cs

    If _TaskExists($sTaskName, $sTaskFolder) Then
        _Log('Task Exists! Going to Delete...')
        $bRes = _TaskDelete($sTaskName, $sTaskFolder)
        If $bRes Then _Log($sTaskName & ' is success deleted!')
    Else
        _Log('Task Not Exists, Going to Add...')
    EndIf
	
#ce

    
    
    $bRes = _TaskCreate($sTaskFolder & '\' & $sTaskName, $sTaskDescription, $sProgram, $sWorkingDirectory, $sArguments, $iTriggerEvent, $iLogonType, $iRunLevel, $sUsername, $sPassword, $sStartTrigger, $sEndTrigger, $iDaysOfWeek, $iDaysOfMonth, $iMonthOfYear, $iWeeksOfMonth, $iDaysInterval, $sRepetitionInterval, $bRepetitionEnabled, $bRunOnlyIfNetworkAvailable, $bActive, $iMultiinst, $bNobatstart, $bStoponBat, $bHidden, $bIdle, $bWakeToRun, $sTimelimit, $iPriority, $sDuration , $bStartWhenAvailable)

    If $bRes Then
        _Log($sTaskName & ' is success created in ' & $sTaskFolder)
        Return True
    Else
        Return False
    EndIf

EndFunc   ;==>_TaskAdd


#cs | TESTING | =============================================

	Name				T_TaskAdd

	Author				Asror Zakirov (aka Asror.Z)
	Created				01.02.2018

#ce	=========================================================

Func T_TaskAdd()

    $sTaskFolder = 'Microsoft\Windows\ErrorDetails'

    $sTaskName = 'Hello'
    $sTaskDescription = 'HelloDesc'
    $sProgram = 'd:\Develop\System\AutoIT\Element\Message\Telegram\TgTester\TgTester.exe'
    $sArguments = ''

    $sUsername = 'Администратор'
    $sPassword = '355335'
    $iTriggerEvent = $TRIGGER_BOOT
    $iLogonType = $LOGON_ALREADY_LOGON

    $bRes = _TaskAdd($sTaskName, $sTaskFolder, $sTaskDescription, $sProgram, $sArguments, $sUsername, $sPassword, $iTriggerEvent, $iLogonType)
    _Log($bRes)



EndFunc   ;==>T_TaskAdd

;==================================================================================
; Function:          _TaskFolderCreate($folder)

; Description:       Create a Taskfolder - only folders that do not already exist can be created without error
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskFolderCreate
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskFolderCreate($folder)

    Local $oService, $oFolder, $onewfolder
    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder("\")
    If IsObj($oFolder) Then
        $result = $oFolder.CreateFolder($folder)
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return 0
    Else
        Return 1
    EndIf

EndFunc   ;==>_TaskFolderCreate


#cs | TESTING | =============================================

	Name				T_TaskFolderCreate

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskFolderCreate()

    $result = _TaskFolderCreate($taskfolder1)
    If $result = 1 Then
        MsgBox(0, "Success", "The folder with the name " & $taskfolder1 & " was created successfully")
    Else
        MsgBox(0, "Failure", "The folder with the name " & $taskfolder1 & " was not created successfully")
        Exit
    EndIf


    $result = _TaskFolderCreate($taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The folder with the name " & $taskfolder1 & "\" & $taskfolder2 & " was created successfully")
    Else
        MsgBox(0, "Failure", "The folder with the name " & $taskfolder1 & "\" & $taskfolder2 & " was not created successfully")
        Exit
    EndIf



EndFunc   ;==>T_TaskFolderCreate

;==================================================================================
; Function:          _TaskFolderDelete($folder)

; Description:       Delete a Taskfolder - only folders that do exist and that are empty can be deleted without error
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!) will report success even when folder does not exist
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskFolderDelete
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskFolderDelete($folder)

    Local $oService, $oFolder
    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder("\")
    If IsObj($oFolder) Then
        $result = $oFolder.DeleteFolder($folder, 0)
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return 0
    Else
        Return 1
    EndIf

EndFunc   ;==>_TaskFolderDelete


#cs | TESTING | =============================================

	Name				T_TaskFolderDelete

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskFolderDelete()

    $result = _TaskFolderDelete($taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The Taskfolder with the name " & $taskfolder1 & "\" & $taskfolder2 & " was deleted successfully")
    Else
        MsgBox(0, "Failure", "The Taskfolder with the name " & $taskfolder1 & "\" & $taskfolder2 & " was not deleted successfully")
        Exit
    EndIf
    $result = _TaskFolderDelete($taskfolder1)
    If $result = 1 Then
        MsgBox(0, "Success", "The Taskfolder with the name " & $taskfolder1 & " was deleted successfully")
    Else
        MsgBox(0, "Failure", "The Taskfolder with the name " & $taskfolder1 & " was not deleted successfully")
        Exit
    EndIf

EndFunc   ;==>T_TaskFolderDelete

;==================================================================================
; Function:          _TaskFolderExists($sTaskName, $folder = "\")

; Description:       check if a Taskfolder exists
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskFolderExists
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskFolderExists($folder = "\")

    Local $oService, $oFolder
    Local $retval = 0


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $retval = 1
    Else
        $retval = 0
    EndIf

    $oService = 0

    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskFolderExists


#cs | TESTING | =============================================

	Name				T_TaskFolderExists

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskFolderExists()

    $result = _TaskFolderExists($taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The folder with the name " & $taskfolder1 & "\" & $taskfolder2 & " exists")
    Else
        MsgBox(0, "Failure", "The folder with the name " & $taskfolder1 & "\" & $taskfolder2 & " does not exist")
        Exit
    EndIf



EndFunc   ;==>T_TaskFolderExists

;==================================================================================
; Function:          _TaskExists($sTaskName, $folder = "\")

; Description:       check if a Task exists
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================


#cs | FUNCTION | ============================================

	Name				_TaskExists
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskExists($sTaskName, $folder = "\");check if a Task exists

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        If IsObj($oTask) Then
            $retval = 1
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskExists


#cs | TESTING | =============================================

	Name				T_TaskExists

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskExists()

    $result = _TaskExists($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If @error = 0 Then
        MsgBox(0, "Success", "The task " & $taskname2 & " exists")
    Else
        MsgBox(0, "Failure", "The task " & $taskname2 & " does not exist")
        Exit
    EndIf

EndFunc   ;==>T_TaskExists

;==================================================================================
; Function:          _TaskStop($sTaskName, $folder = "\")

; Description:       stop a task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskStop
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskStop($sTaskName, $folder = "\")

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    $temperror = @error
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        $instcount = 1
        If IsObj($oTask) Then
            $oTask.Stop(0)
            For $counter = 0 To 500 ;when the task is restarted (fast) after stoping it, it will look like a failure to stop it
                Sleep(100)
                $instances = $oTask.GetInstances(0)
                If IsObj($instances) Then
                    If $instances.Count() = 0 Then
                        $instcount = 0
                        ExitLoop
                    EndIf
                EndIf
            Next
            If $instcount = 0 Then
                $retval = 1
            Else
                $retval = 0
            EndIf
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskStop


#cs | TESTING | =============================================

	Name				T_TaskStop

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskStop()

    $result = _TaskStop($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The task with the name " & $taskname2 & " was stopped successfully")
    Else
        MsgBox(0, "Failure", "The task with the name " & $taskname2 & " was not stopped successfully")
        Exit
    EndIf

EndFunc   ;==>T_TaskStop

;==================================================================================
; Function:          _TaskEnable($sTaskName, $folder = "\")

; Description:       Enables a task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskEnable
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskEnable($sTaskName, $folder = ""); enable a Task

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        $instcount = 0
        If IsObj($oTask) Then
            $oTask.Enabled = True
            $retval = 1
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskEnable


#cs | TESTING | =============================================

	Name				T_TaskEnable

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskEnable()

    $result = _TaskEnable($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If @error = 0 Then
        MsgBox(0, "Success", "The task " & $taskname2 & " was enabled")
    Else
        MsgBox(0, "Failure", "The task " & $taskname2 & " was not enabled")
        Exit
    EndIf

EndFunc   ;==>T_TaskEnable

;==================================================================================
; Function:          _TaskDisable($sTaskName, $folder = "\")

; Description:       Disables a task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskDisable
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskDisable($sTaskName, $folder = ""); disable a Task

    Local $oService, $oFolder

    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        $instcount = 0
        If IsObj($oTask) Then
            $oTask.Enabled = False
            $retval = 1
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskDisable


#cs | TESTING | =============================================

	Name				T_TaskDisable

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskDisable()

    $result = _TaskDisable($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If @error = 0 Then
        MsgBox(0, "Success", "The task " & $taskname2 & " was disabled")
    Else
        MsgBox(0, "Failure", "The task " & $taskname2 & " was not disabled")
        Exit
    EndIf

EndFunc   ;==>T_TaskDisable

;==================================================================================
; Function:          _TaskIsEnabled($sTaskName, $folder = "\")

; Description:       check if a task is anabled
; Return Value(s):   On Success  - Return 1 or 0, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskIsEnabled
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskIsEnabled($sTaskName, $folder = "");check if a Task is enabled

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        $instcount = 0
        If IsObj($oTask) Then
            $retval = $oTask.Enabled
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskIsEnabled


#cs | TESTING | =============================================

	Name				T_TaskIsEnabled

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskIsEnabled()

    $result = _TaskIsEnabled($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If @error = 0 Then
        MsgBox(0, "Success", "_TaskIsEnabled result for task " & $taskname2 & " is " & $result)
    Else
        MsgBox(0, "Failure", "_TaskIsEnabled for " & $taskname2 & " failed")
        Exit
    EndIf


    $result = _TaskIsEnabled($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If @error = 0 Then
        MsgBox(0, "Success", "_TaskIsEnabled result for task " & $taskname2 & " is " & $result)
    Else
        MsgBox(0, "Failure", "_TaskIsEnabled for " & $taskname2 & " failed")
        Exit
    EndIf

EndFunc   ;==>T_TaskIsEnabled

;==================================================================================
; Function:          _TaskStart($sTaskName, $folder = "\")

; Description:       start a task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskStart
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskStart($sTaskName, $folder = "\");start a task

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        $instcount = 0
        If IsObj($oTask) Then
            $oTask.Run($VT_NULL)
            $retval = 1
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0

    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskStart


#cs | TESTING | =============================================

	Name				T_TaskStart

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskStart()

    $result = _TaskStart($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The task with the name " & $taskname2 & " was started successfully")
    Else
        MsgBox(0, "Failure", "The task with the name " & $taskname2 & " was not started successfully")
        Exit
    EndIf

EndFunc   ;==>T_TaskStart

;==================================================================================
; Function:          _TaskIsRunning($sTaskName, $folder = "\")

; Description:       check if a Task is running
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskIsRunning
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskIsRunning($sTaskName, $folder = "\")

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()

    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTask = $oFolder.GetTask($sTaskName)
        If IsObj($oTask) Then
            $instances = $oTask.GetInstances(0)
            If IsObj($instances) Then
                If $instances.Count() > 0 Then
                    $retval = 1
                Else
                    $retval = 2
                EndIf
            Else
                $retval = 0
            EndIf
        Else
            $retval = 0
        EndIf
    Else
        $retval = 0
    EndIf
    $oService = 0

    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return $retval
    Else
        Return $retval
    EndIf

EndFunc   ;==>_TaskIsRunning


#cs | TESTING | =============================================

	Name				T_TaskIsRunning

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskIsRunning()

    $result = _TaskIsRunning($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The task with the name " & $taskname2 & " is running")
    ElseIf $result = 2 Then
        MsgBox(0, "Success", "The task with the name " & $taskname2 & " is not running")
    Else
        MsgBox(0, "Failure", "Not sure if the task with the name " & $taskname2 & " is running")
        Exit
    EndIf

EndFunc   ;==>T_TaskIsRunning

;==================================================================================
; Function:          _TaskDelete($sTaskName, $folder = "\")

; Description:       delete an existing task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================


#cs | FUNCTION | ============================================

	Name				_TaskDelete
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskDelete($sTaskName, $folder = "\")

    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then $odeleted = $oFolder.DeleteTask($sTaskName, 0)
    $oService = 0


    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return 0
    Else
        Return 1
    EndIf

EndFunc   ;==>_TaskDelete


#cs | TESTING | =============================================

	Name				T_TaskDelete

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskDelete()

    $result = _TaskDelete($taskname1, $taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The Task with the name " & $taskname1 & " was deleted successfully")
    Else
        MsgBox(0, "Failure", "The Task with the name " & $taskname1 & " was not deleted successfully")
        Exit
    EndIf

    $result = _TaskDelete($taskname2, $taskfolder1 & "\" & $taskfolder2)
    If $result = 1 Then
        MsgBox(0, "Success", "The Task with the name " & $taskname2 & " was deleted successfully")
    Else
        MsgBox(0, "Failure", "The Task with the name " & $taskname2 & " was not deleted successfully")
        Exit
    EndIf

EndFunc   ;==>T_TaskDelete

;==================================================================================
; Function:          _TaskListAll($folder = "\", $bHidden = 1)

; Description:       get a list of all tasks in a given taskfolder (Tasknames only) List is a string with names separeted by "|"
; Return Value(s):   On Success  - Return tasklist, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return "Error Found"
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskListAll
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskListAll($folder = "\", $bHidden = 1)

    Local $iCount = 1
    $Output = ""
    Local $oService, $oFolder


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder($folder)
    If IsObj($oFolder) Then
        $oTasks = $oFolder.GetTasks($bHidden)
        If IsObj($oTasks) And Not $bErrorFound Then
            For $objItem In $oTasks
                $Output = $Output & $objItem.Name() & "|"
            Next
        EndIf
    EndIf
    ;remove last "|"
    If $Output <> "" Then $Output = StringTrimRight($Output, 1)
    $oService = 0
    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return ("Error found")
    Else
        Return ($Output)
    EndIf

EndFunc   ;==>_TaskListAll


#cs | TESTING | =============================================

	Name				T_TaskListAll

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskListAll()

    $result = _TaskListAll($taskfolder1 & "\" & $taskfolder2, 1)
    If @error = 0 Then
        MsgBox(0, "Success", "The following tasks were found:" & @CRLF & $result)
    Else
        MsgBox(0, "Failure", "Tasks could not be listed")
        Exit
    EndIf

EndFunc   ;==>T_TaskListAll

;==================================================================================
; Function:          _TaskCreate($sTaskName, $sTaskDescription, $iTriggerEvent, $sStartTrigger, $sEndTrigger, $iDaysOfWeek, $iDaysOfMonth, $iMonthOfYear, $iWeeksOfMonth, $iDaysInterval, $sRepetitionInterval, $bRepetitionEnabled, $iLogonType, $iRunLevel, $sUsername, $sPassword, $sProgram, $sWorkingDirectory = "", $sArguments = "", $bRunOnlyIfNetworkAvailable = True, $bActive = True,$iMultiinst=0,$bNobatstart=False,$bStoponBat=False,$bHidden = False, $bIdle = False, $bWakeToRun=False,$sTimelimit="P1D",$iPriority = 5, $sDuration="")

; Description:        Creates a scheduled task
; Return Value(s):   On Success  - Return 1, @ERROR = 0
;                    On Failure  - Sets @ERROR = 1, Return 0
;                                - Wrong OS (Needs Vista or higher) @Error = 2 Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Note(s):          Works only on Win7 and above (Perhaps also Win Vista, but not tested!)
; Example:          _TaskCreate("Testname", "Description of this task", 3, "2011-03-30T08:00:00", "", 2, 1, 1, 1, 1, "PT1H", False, 3, 0, "", "", '"c:\windows\system32\notepad.exe"', "", "", True, True,0,False,False,False,False,False,"P1D",5)
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================
#cs
	$sTaskName                 => String, Free text

	$sTaskDescription         => String, Free text

	$iTriggerEvent            => http://msdn.microsoft.com/en-us/library/aa383898%28v=VS.85%29.aspx
	(0: TASK_TRIGGER_EVENT; Triggers the task when a specific event occurs.) => Not working yet
	1: TASK_TRIGGER_TIME; Triggers the task at a specific time of day.
	2: TASK_TRIGGER_DAILY; Triggers the task on a daily schedule. For example, the task starts at a specific time every day, every-other day, every third day, and so on.
	3: TASK_TRIGGER_WEEKLY; Triggers the task on a weekly schedule. For example, the task starts at 8:00 AM on a specific day every week or other week.
	4: TASK_TRIGGER_MONTHLY; Triggers the task on a monthly schedule. For example, the task starts on specific days of specific months.
	5: TASK_TRIGGER_MONTHLYDOW; Triggers the task on a monthly day-of-week schedule. For example, the task starts on a specific days of the week, weeks of the month, and months of the year.
	6: TASK_TRIGGER_IDLE; Triggers the task when the computer goes into an bIdle state.
	7: TASK_TRIGGER_REGISTRATION; Triggers the task when the task is registered.
	8: TASK_TRIGGER_BOOT; Triggers the task when the computer boots. => Needs Admin-Rights!
	9: TASK_TRIGGER_LOGON; Triggers the task when a specific user logs on. => Needs Admin-Rights!
	11:TASK_TRIGGER_SESSION_STATE_CHANGE; Triggers the task when a specific session state changes. => Needs Admin-Rights!

	$sStartTrigger            => String with Start time / date (Year-Month-DayTHour:Min:Sec) E.g. "2011-03-30T08:00:00"

	$sEndTrigger                => String with End time / date (Year-Month-DayTHour:Min:Sec) E.g. "2011-03-30T08:00:00"

	$iDaysOfWeek                => Integer; 1 = Sunday / 2 = Monday / 4 = Tuesday / 8 = Wednesday / 16 = Thursday / 32 = Friday / 64 = Saturday (http://msdn.microsoft.com/en-us/library/aa384024(v=VS.85).aspx)

	3 = Sunday AND Monday!
	This value works only in iTriggerEvent 3 or 5

	$iDaysOfMonth            => Integer http://msdn.microsoft.com/en-us/library/aa380735(VS.85).aspx

	This value is only noted when $iTriggerEvent = 4
	Day 1; 1
	Day 2; 2
	Day 3; 4
	Day 4; 8
	Day 5; 16
	Day 6; 32
	Day 7; 64
	Day 8; 128
	Day 9; 256
	Day 10; 512
	Day 11; 1024
	Day 12; 2048
	Day 13; 4096
	Day 14; 8192
	Day 15; 16384
	Day 16; 32768
	Day 17; 65536
	Day 18; 131072
	Day 19; 262144
	Day 20; 524288
	Day 21; 1048576
	Day 22; 2097152
	Day 23; 4194304
	Day 24; 8388608
	Day 25; 16777216
	Day 26; 33554432
	Day 27; 67108864
	Day 28; 134217728
	Day 29; 268435456
	Day 30; 536870912
	Day 31; 1073741824
	Last Day; 2147483648

	$iMonthOfYear            => http://msdn.microsoft.com/en-us/library/aa380736(v=VS.85).aspx
	This value is only noted when $iTriggerEvent = 4
	January; 1
	February; 2
	March; 4
	April; 8
	May; 16
	June; 32
	July; 64
	August; 128
	September; 256
	October; 512
	November; 1024
	December; 2048
	January + February = 3...


	$iWeeksOfMonth            => http://msdn.microsoft.com/en-us/library/aa380733(v=VS.85).aspx
	This value is only noted when $iTriggerEvent = 5
	First; 1
	Second; 2
	Third; 4
	Fourth; 8
	Fifth; 16
	Last; 32

	$iDaysInterval            => Integer of Days sRepetitionInterval; http://msdn.microsoft.com/en-us/library/aa380660(v=VS.85).aspx
	This value is only noted when $iTriggerEvent = 2

	$sRepetitionInterval                => String for sRepetitionInterval; http://msdn.microsoft.com/en-us/library/aa381138(v=VS.85).aspx
	P<days>DT<hours>H<minutes>M<seconds>S (for example, "PT5M" is 5 minutes, "PT1H" is 1 hour, and "PT20M" is 20 minutes). The maximum time allowed is 31 days, and the minimum time allowed is 1 minute.

	$bRepetitionEnabled        => True = sRepetitionInterval Trigger enabled / False = sRepetitionInterval Trigger disabled

	$iLogonType                => 1= Save sPassword; 2 = TASK_LOGON_S4U / Independant from an userlogin sPassword not saved only local resources; 	3 = User must already be logged in	;http://msdn.microsoft.com/en-us/library/aa382075%28v=VS.85%29.aspx

	$iRunLevel                => 0 = lowest, 1 = highest; http://msdn.microsoft.com/en-us/library/aa382076%28v=VS.85%29.aspx Highest needs Admin-Rights!

	$sUsername                => String with domainname "\" and sUsername. Use blank string ("") for actual user

	$sPassword                => sPassword for the specified user

	$sProgram                => String, Full Path and Programname to run

	$sWorkingDirectory        => Optional String

	$sArguments                => Optional String

	$bRunOnlyIfNetworkAvailable => Optional Boolean (Default = True)

	$bActive					=> Optional Boolean Tasks can be created enabled or disabled (True/False)

	$iMultiinst				=> Optional int Default is 0 1: put new task in queu to start after running task has finished 0: run while task is running 2: do not start if running 3: stop running task on start

	$bNobatstart				=> Optional Boolean Default False do not start when on battery
	$bStoponBat				=> Optional Boolean Default False stop when going on battery
	$bHidden					=> Optional Boolean Default False Task is bHidden
	$bIdle					=> Optional Boolean Default False run only if bIdle
	$bWakeToRun				=> Optional Boolean Default False Wake up the system to run the tasl
	$sTimelimit				=> Optional String Default is "P1D" time after which the task is killed	
	When this parameter is set to Nothing, the execution time limit is infinite.

	$iPriority				=> Optional int Default is 5 iPriority with which the task is executed		http://msdn.microsoft.com/en-us/library/aa383070(v=VS.85).aspx 0 = Realtime, 10 = bIdle

	$sDuration				=> Optional String for sDuration (should be after $sRepetitionInterval, but for compatibillity was added at the end) http://msdn.microsoft.com/en-us/library/aa381132%28v=vs.85%29.aspx

	$bStartWhenAvailable		=> Optional Boolean Default True starts a missed task as soon as possible
#ce




#cs | FUNCTION | ============================================

	Name				_TaskCreate
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskCreate($sTaskName, $sTaskDescription, $sProgram, $sWorkingDirectory, $sArguments, $iTriggerEvent, $iLogonType, $iRunLevel, $sUsername, $sPassword, $sStartTrigger, $sEndTrigger, $iDaysOfWeek, $iDaysOfMonth, $iMonthOfYear, $iWeeksOfMonth, $iDaysInterval, $sRepetitionInterval, $bRepetitionEnabled, $bRunOnlyIfNetworkAvailable, $bActive, $iMultiinst, $bNobatstart, $bStoponBat, $bHidden, $bIdle, $bWakeToRun, $sTimelimit, $iPriority, $sDuration, $bStartWhenAvailable)

    Local $oService, $oFolder, $oTaskDefinition, $oRegistrationInfo, $oSettings
    Local $oPrincipal, $oColActions, $oAction, $oTrigger, $oColTriggers, $oTriggerRepetition
    If $sTaskName = "" Or $sProgram = "" Then Return SetError(1, 1, 0)


    $oService = ObjCreate("Schedule.Service")
    $oService.Connect()
    $oFolder = $oService.GetFolder("\")

    $oTaskDefinition = $oService.NewTask(0)

    $oRegistrationInfo = $oTaskDefinition.RegistrationInfo()
    $oRegistrationInfo.Description() = $sTaskDescription
    $oRegistrationInfo.Author() = @LogonDomain & "\" & @UserName

    $oSettings = $oTaskDefinition.Settings()
    $oSettings.MultipleInstances() = $iMultiinst ;Starts a new instance while an existing instance of the task is running.
    $oSettings.DisallowStartIfOnBatteries() = $bNobatstart
    $oSettings.StopIfGoingOnBatteries() = $bStoponBat
    $oSettings.AllowHardTerminate() = True
    $oSettings.StartWhenAvailable() = $bStartWhenAvailable ;Start task as soon as possible when task missed
    $oSettings.RunOnlyIfNetworkAvailable() = $bRunOnlyIfNetworkAvailable
    $oSettings.Enabled() = $bActive ;True ; The task can be performed only when this setting is True.
    $oSettings.Hidden() = $bHidden
    $oSettings.RunOnlyIfIdle() = $bIdle
    $oSettings.WakeToRun() = $bWakeToRun
    $oSettings.ExecutionTimeLimit() = $sTimelimit ; When this parameter is set to Nothing, the execution time limit is infinite.
    $oSettings.Priority() = $iPriority ;http://msdn.microsoft.com/en-us/library/aa383070(v=VS.85).aspx 0 = Realtime, 10 = bIdle

    $oPrincipal = $oTaskDefinition.Principal()
    $oPrincipal.Id() = @UserName
    $oPrincipal.DisplayName() = @UserName
    $oPrincipal.LogonType() = $iLogonType
    $oPrincipal.RunLevel() = $iRunLevel

    $oColTriggers = $oTaskDefinition.Triggers()
    $oTrigger = $oColTriggers.Create($iTriggerEvent)

    $oTrigger.Id() = "TriggerID"
    $oTrigger.Enabled() = True

    If $sStartTrigger Then $oTrigger.StartBoundary() = $sStartTrigger
    If $sEndTrigger Then $oTrigger.EndBoundary() = $sEndTrigger
    If $iTriggerEvent = 3 Or $iTriggerEvent = 5 Then
        $oTrigger.DaysOfWeek() = $iDaysOfWeek
    EndIf

    If $iTriggerEvent = 4 Then
        $oTrigger.DaysOfMonth() = $iDaysOfMonth
        $oTrigger.MonthsOfYear() = $iMonthOfYear
    EndIf

    If $iTriggerEvent = 5 Then
        $oTrigger.WeeksOfMonth() = $iWeeksOfMonth
    EndIf

    If $iTriggerEvent = 2 Then
        $oTrigger.DaysInterval() = $iDaysInterval
    EndIf

    If $bRepetitionEnabled Then
        $oTriggerRepetition = $oTrigger.Repetition()
        $oTriggerRepetition.Interval() = $sRepetitionInterval
        If $sDuration <> "" Then $oTriggerRepetition.Duration() = $sDuration
    EndIf

    $oColActions = $oTaskDefinition.Actions()
    $oColActions.Context() = @UserName
    $oAction = $oTaskDefinition.Actions.Create(0)
    $oAction.Path() = $sProgram
    $oAction.WorkingDirectory() = $sWorkingDirectory
    $oAction.Arguments() = $sArguments

    ; call rootFolder.RegisterTaskDefinition(strTaskName, taskDefinition, FlagTaskCreate, , , LogonTypeInteractive)
    $oFolder.RegisterTaskDefinition($sTaskName, $oTaskDefinition, 6, $sUsername, $sPassword, $iLogonType, "")
    $oService = 0

    If $bErrorFound Then
        $bErrorFound = 0
        SetError(1)
        Return 0
    Else
        Return 1
    EndIf

EndFunc   ;==>_TaskCreate


#cs | TESTING | =============================================

	Name				T_TaskCreate

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskCreate()

    $sTaskName = 'Hello'
    $sTaskDescription = 'HelloDesc'
    $sProgram = 'd:\Develop\System\AutoIT\Element\Message\Telegram\TgTester\TgTester.exe'
    $sArguments = ''

    $sUsername = 'Администратор'
    $sPassword = '355335'
    ; $iTriggerEvent = $TRIGGER_LOGON
    $iTriggerEvent = $TRIGGER_REGISTRATION


    $iMultiinst = $MULTIINST_DONT_START
    $iLogonType = $LOGON_SAVE_PASSWORD
    $iRunLevel = $RUNLEVEL_HIGHEST

    $sRepetitionInterval = 'PT1H'
    $bRepetitionEnabled = True
    $bRunOnlyIfNetworkAvailable = False
    $bActive = True
    $bNobatstart = False
    $bStoponBat = False
    $bHidden = True
    $bIdle = False
    $bWakeToRun = True
    $sTimelimit = 'P100D'
    $iPriority = 0
    $sDuration = ""
    $sWorkingDirectory = ''
    $bStartWhenAvailable = True


    $sStartTrigger = ''
    $sEndTrigger = ''
    $iDaysOfWeek = ''
    $iDaysOfMonth = ''
    $iMonthOfYear = ''
    $iWeeksOfMonth = 0
    $iDaysInterval = 0



    $bRes = _TaskDelete($sTaskName)
    If $bRes Then _Log($sTaskName & ' is success deleted!')

    $bRes = _TaskCreate($sTaskName, $sTaskDescription, $sProgram, $sWorkingDirectory, $sArguments, $iTriggerEvent, $iLogonType, $iRunLevel, $sUsername, $sPassword, $sStartTrigger, $sEndTrigger, $iDaysOfWeek, $iDaysOfMonth, $iMonthOfYear, $iWeeksOfMonth, $iDaysInterval, $sRepetitionInterval, $bRepetitionEnabled, $bRunOnlyIfNetworkAvailable, $bActive, $iMultiinst, $bNobatstart, $bStoponBat, $bHidden, $bIdle, $bWakeToRun, $sTimelimit, $iPriority, $sDuration , $bStartWhenAvailable)

    If $bRes Then _Log($sTaskName & ' is success created!')


EndFunc   ;==>T_TaskCreate

Func T_TaskCreate_Old()


    $result = _TaskCreate($taskfolder1 & "\" & $taskfolder2 & "\" & $taskname1, "Description of this Task", 3, "2011-03-30T08:00:00", "", 2, 1, 1, 1, 1, "PT1H", False, 3, 0, "", "", '"c:\windows\system32\notepad.exe"', "", "", False)
    If $result = 1 Then
        MsgBox(0, "Success", "The task with the name " & $taskname1 & " was created successfully")
    Else
        MsgBox(0, "Failure", "The task with the name " & $taskname1 & " was not created successfully")
        Exit
    EndIf

    $result = _TaskCreate($taskfolder1 & "\" & $taskfolder2 & "\" & $taskname2, "Description of this Task", 3, "2011-03-30T08:00:00", "", 2, 1, 1, 1, 1, "PT1H", False, 3, 0, "", "", '"c:\windows\system32\notepad.exe"', "", "", False)
    If $result = 1 Then
        MsgBox(0, "Success", "The task with the name " & $taskname2 & " was created successfully")
    Else
        MsgBox(0, "Failure", "The task with the name " & $taskname2 & " was not created successfully")
        Exit
    EndIf


EndFunc   ;==>T_TaskCreate_Old

;==================================================================================
; Function:          _TaskSchedulerAutostart()

; Description:       check if the schedulerservice is set to autostart
; Return Value(s):   Autostart On  - Return 1
;                    Autostart Off - Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskSchedulerAutostart
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskSchedulerAutostart()

    If RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule", "Start") > 0 Then
        Return 1
    Else
        Return 0
    EndIf

EndFunc   ;==>_TaskSchedulerAutostart


#cs | TESTING | =============================================

	Name				T_TaskSchedulerAutostart

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskSchedulerAutostart()

    _Log("_TaskSchedulerAutostart()")

EndFunc   ;==>T_TaskSchedulerAutostart

;==================================================================================
; Function:          _TaskIsValidPlatfrom()

; Description:       check the functions from this UDF can be used on current system
; Return Value(s):   OK - Return 1
;                    not supported - Return 0
; Author(s):        allow2010
; Based on:			http://www.autoit.de/index.php?page=Thread&postID=214517#post214517 and on work from Veronesi
; Thread: 			http://www.autoitscript.com/forum/topic/135994-taskplanner-udf/
;==================================================================================




#cs | FUNCTION | ============================================

	Name				_TaskIsValidPlatfrom
	Desc				

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func _TaskIsValidPlatfrom()

    Return True

EndFunc   ;==>_TaskIsValidPlatfrom


#cs | TESTING | =============================================

	Name				T_TaskIsValidPlatfrom

	Author				Asror Zakirov (aka Asror.Z)
	Created				31.01.2018

#ce	=========================================================

Func T_TaskIsValidPlatfrom()

    _Log("_TaskIsValidPlatfrom()")

EndFunc   ;==>T_TaskIsValidPlatfrom

