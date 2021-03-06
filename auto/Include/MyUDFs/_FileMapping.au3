#include-once
#include <File.au3>
#include <WinAPI.au3>
#include <_FileEx.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _FM_GetFileMapping
; Description ...: Get file map via Defragmentation API
; Syntax ........: _FM_GetFileMapping($sPath[, $fGetPhysical = True])
; Parameters ....: $sPath               - Path to target file.
;                  $fGetPhysical        - [optional] Get physical disk offsets for each extent. This is required to recover the
;                                         file contents with _FM_ReadMapToFile
; Return values .: Success				- Array of file map info (see below)
;                  Failure              - Sets @error, but returns as much information as possible
;                                       | 1 - $sPath does not exist
;                                       | 2 - $sPath is a directory
;                                       | 3 - Failed to open $sPath
;                                       | 4 - 0 file extents found; returns volume sector and cluster size
;                                             This likely means the file is small enough to be stored wholly in the MFT,
;                                             or the drive is FAT / FAT32
;                                       | 5 - Failed to open volume to determine physical offsets; returns extent info
;                                       | 6 - Some errors getting physical offsets, @extended holds the number of errors;
;                                             returns all available info
;                                       | 7 - Failed to get disk sector size
;                                       | 8 - Failed to get disk cluster size
; Author ........: Erik Pilsits
; Modified ......:
; Remarks .......: NOTE: LCN values of -1 are expected for compressed and sparse files, and are not reported as errors.
;                  These extents will not have any associated physical offsets.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _FM_GetFileMapping($sPath, $fGetPhysical = False)
	#cs
	; return array of info:
	;
	; [0][0] = # of extents
	; [0][1] = volume sector size (in bytes)
	; [0][2] = volume cluster size (in bytes)
	; [0][3] = file size in bytes
	;
	; n = extent #
	; [n][0] = VCN
	; [n][1] = LCN
	; [n][2] = cluster count
	; [n][3] = if available, array of physical disk numbers and physical offsets, otherwise empty:
	;          [0][0] = # of physical offsets
	;          [i][0] = physical disk #
	;          [i][1] = physical offset (in bytes)
	;          ...
	#ce
	Local $aReturn[1][4] = [[0,0,0,0]]
    ; expand and relative paths
	_FM_FixPath($sPath)
	; open file
	Local $hFile = _FileEx_CreateFile($sPath, $GENERIC_READ, $FILE_SHARE_READ, $OPEN_EXISTING, 0)
	If @error Then Return SetError(3, 0, 0)
	$aReturn[0][3] = _WinAPI_GetFileSizeEx($hFile)
	; get drive letter and volume info
	Local $sDrive = _FileEx_PathGetRoot($sPath)
	Local $iSectorSize = _FileEx_GetDiskSectorSize($sDrive)
    If @error Then Return SetError(7, 0, 0)
	$aReturn[0][1] = $iSectorSize
	Local $iClusterSize = _FileEx_GetDiskClusterSize($sDrive)
    If @error Then Return SetError(8, 0, 0)
	$aReturn[0][2] = $iClusterSize
	;
	; walk file map
	;
	Local $tagRETRIEVAL_POINTERS_BUFFER = "dword ExtentCount;int64 StartingVcn;struct;int64 NextVcn;int64 Lcn;endstruct"
	; FILE_DEVICE_FILE_SYSTEM, 28,  METHOD_NEITHER, FILE_ANY_ACCESS
	Local Const $FSCTL_GET_RETRIEVAL_POINTERS = _FM_CTL_CODE(0x00000009, 28, 3, 0)
	Local $RPB = DllStructCreate($tagRETRIEVAL_POINTERS_BUFFER)
	Local $iError, $inputVcn = 0
	Local Const $NO_ERROR = 0
	Local Const $ERROR_MORE_DATA = 234
	Local Const $ERROR_HANDLE_EOF = 38
	Do
		; call DeviceIoControl to get the file map, request one extent based on size of output structure
		; loop until done
		DllCall("kernel32.dll", "bool", "DeviceIoControl", "handle", $hFile, "dword", $FSCTL_GET_RETRIEVAL_POINTERS, "int64*", $inputVcn, "dword", 8, _
				"ptr", DllStructGetPtr($RPB), "dword", DllStructGetSize($RPB), "dword*", 0, "ptr", 0)
		$iError = _WinAPI_GetLastError()
		Switch $iError
			Case $ERROR_HANDLE_EOF
				; no data - file is probably contained wholly in MFT
			Case $ERROR_MORE_DATA
				; more data available
				; set input Vcn for next call
				$inputVcn = DllStructGetData($RPB, "NextVcn")
				; fall through
				ContinueCase
			Case $NO_ERROR
				; done, valid data
				$aReturn[0][0] += 1
				ReDim $aReturn[$aReturn[0][0] + 1][4]
				$aReturn[$aReturn[0][0]][0] = DllStructGetData($RPB, "StartingVcn")
				$aReturn[$aReturn[0][0]][1] = DllStructGetData($RPB, "Lcn")
				$aReturn[$aReturn[0][0]][2] = DllStructGetData($RPB, "NextVcn") - DllStructGetData($RPB, "StartingVcn")
			Case Else
				; some other error
		EndSwitch
	Until ($iError <> $ERROR_MORE_DATA)
	_WinAPI_CloseHandle($hFile)
	;
	; if 0 extents, return GetLastError
	;
	If $aReturn[0][0] = 0 Then
		Return SetError(4, $iError, $aReturn)
	ElseIf Not $fGetPhysical Then
		Return $aReturn
	Else
		;
		; get physical cluster offsets
		;
		; IOCTL_VOLUME_BASE, 8, METHOD_BUFFERED, FILE_ANY_ACCESS
		Local Const $IOCTL_VOLUME_LOGICAL_TO_PHYSICAL = _FM_CTL_CODE(0x00000056, 8, 0, 0)
		; the array is a set of VOLUME_PHYSICAL_OFFSET structs = "ulong DiskNumber;int64 Offset"
		; make room for 8 structs / physical disks
		Local $tagVOLUME_PHYSICAL_OFFSETS = "ulong NumberOfPhysicalOffsets"
		For $m = 1 To 8
			$tagVOLUME_PHYSICAL_OFFSETS &= ";struct;ulong DiskNumber" & $m & ";int64 Offset" & $m & ";endstruct"
		Next
		; VOLUME_LOGICAL_OFFSET = "int64 LogicalOffset"
		;
		; reset error value
		$iError = 0
		; open the volume
        ; make sure $sDrive is a drive letter and not a network share, etc
        ; we can only open local volumes
        If Not StringRegExp(StringLeft($sDrive, 1), "(?i)[a-z]") Then Return SetError(5, 0, $aReturn)
		Local $hVolume = _FileEx_CreateFile("\\.\" & StringLeft($sDrive, 1) & ":", $GENERIC_READ, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0)
		; error opening volume, return what info we have
		If @error Then Return SetError(5, 0, $aReturn)
		;
		Local $VPO = DllStructCreate($tagVOLUME_PHYSICAL_OFFSETS)
		Local $aRet, $aPhyInfo[1][2]
		;
		; iterate each extent and get physical offset info
		;
		For $i = 1 To $aReturn[0][0]
			; check for LCN = -1, this is probably a sparse or compressed file
			; if so, skip it, don't report as error
			If $aReturn[$i][1] = -1 Then ContinueLoop
			;
			; convert logical offset of extent to physical offset on disk
			; logical byte offset = LCN * cluster size
			$aRet = DllCall("kernel32.dll", "bool", "DeviceIoControl", "handle", $hVolume, "dword", $IOCTL_VOLUME_LOGICAL_TO_PHYSICAL, _
					"int64*", $aReturn[$i][1] * $iClusterSize, "dword", 8, _
					"ptr", DllStructGetPtr($VPO), "dword", DllStructGetSize($VPO), "dword*", 0, "ptr", 0)
			If @error Or (Not $aRet[0]) Or (Not $aRet[7]) Then
				$iError += 1
				ContinueLoop
			EndIf
			; store offset information in an array
			$aPhyInfo[0][0] = DllStructGetData($VPO, "NumberOfPhysicalOffsets")
			ReDim $aPhyInfo[$aPhyInfo[0][0] + 1][2]
			For $j = 1 To $aPhyInfo[0][0]
				$aPhyInfo[$j][0] = DllStructGetData($VPO, "DiskNumber" & $j)
				$aPhyInfo[$j][1] = DllStructGetData($VPO, "Offset" & $j)
			Next
			; save new array as a sub-array in the return array
			$aReturn[$i][3] = $aPhyInfo
		Next
		_WinAPI_CloseHandle($hVolume)
		;
		If $iError Then
			Return SetError(6, $iError, $aReturn)
		Else
			Return $aReturn
		EndIf
	EndIf
EndFunc   ;==>_FM_GetFileMapping

#region UTILITY FUNCTIONS
Func _FM_PrintMapInfo(Const ByRef $aMAP)
	If Not IsArray($aMAP) Then Return SetError(1, 0, 0)
	;
	ConsoleWrite("Extent count: " & $aMAP[0][0] & @CRLF)
	ConsoleWrite("Sector size: " & $aMAP[0][1] & @CRLF)
	ConsoleWrite("Cluster size: " & $aMAP[0][2] & @CRLF)
	ConsoleWrite("File size (bytes): " & $aMAP[0][3] & @CRLF)
	Local $aPO
	; walk the output array, processing each extent
	For $i = 1 To $aMAP[0][0]
		ConsoleWrite("==========" & @CRLF)
		ConsoleWrite("VCN: " & $aMAP[$i][0] & @CRLF)
		ConsoleWrite("LCN: " & $aMAP[$i][1] & @CRLF)
		ConsoleWrite("Cluster count: " & $aMAP[$i][2] & @CRLF)
		$aPO = $aMAP[$i][3]
		If IsArray($aPO) Then
			ConsoleWrite("!    ==========" & @CRLF)
			ConsoleWrite("!    # of Physical offsets: " & $aPO[0][0] & @CRLF)
			For $j = 1 To $aPO[0][0]
				ConsoleWrite("!    Physical disk: " & $aPO[$j][0] & @CRLF)
				ConsoleWrite("!    Physical offset: " & $aPO[$j][1] & @CRLF)
			Next
		EndIf
	Next
	;
	Return 1
EndFunc   ;==>_FM_PrintMapInfo

Func _FM_ReadMapToFile(Const ByRef $aMAP, $sDest, $fSetSize = True)
	If Not IsArray($aMAP) Then Return SetError(1, 0, 0)
	If $aMAP[0][0] = 0 Then Return SetError(2, 0, 0)
	;
	Local $aPO, $hDrive, $iByRef
	; create cluster sized buffer
	Local $tBuf = DllStructCreate("byte[" & $aMAP[0][2] & "]")
	; create new file
	Local $hNew = _FileEx_CreateFile($sDest, $GENERIC_WRITE, 0, $CREATE_ALWAYS, 0)
	; walk the output array, processing each extent
	For $i = 1 To $aMAP[0][0]
		$aPO = $aMAP[$i][3]
		If IsArray($aPO) Then
			; only read from one physical disk
			; move file pointer and read it
			; FILE_FLAG_RANDOM_ACCESS
			$hDrive = _FileEx_CreateFile("\\.\PhysicalDrive" & $aPO[1][0], $GENERIC_READ, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0x10000000)
			If @error Then ContinueLoop
			DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hDrive, "int64", $aPO[1][1], "int64*", 0, "dword", 0)
			; read/write in cluster chunks
			For $k = 1 To $aMAP[$i][2]
				_WinAPI_ReadFile($hDrive, DllStructGetPtr($tBuf), DllStructGetSize($tBuf), $iByRef)
				_WinAPI_WriteFile($hNew, DllStructGetPtr($tBuf), DllStructGetSize($tBuf), $iByRef)
			Next
			_WinAPI_CloseHandle($hDrive)
		EndIf
	Next
	If $fSetSize Then
		; set final size of file
		DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hNew, "int64", $aMAP[0][3], "ptr", 0, "dword", 0)
		_WinAPI_SetEndOfFile($hNew)
	EndIf
	_WinAPI_CloseHandle($hNew)
	Return 1
EndFunc   ;==>_FM_ReadMapToFile
#endregion UTILITY FUNCTIONS

#region INTERNAL FUNCTIONS
Func _FM_CTL_CODE($DeviceType, $Function, $Method, $Access)
	Return BitOR(BitShift($DeviceType, -16), BitShift($Access, -14), BitShift($Function, -2), $Method)
EndFunc   ;==>_FM_CTL_CODE

Func _FM_FixPath(ByRef $sPath)
    ; check for drive and make sure it ends in \
    If StringRight($sPath, 1) = ":" Then
        $sPath &= "\"
    Else
		; expand any relative path components
		; _PathFull follows same rules as FileExists
        $sPath = _PathFull($sPath)
    EndIf
EndFunc   ;==>_FM_FixPath

; while the _Test function below is the *proper* way to get the sector size, it has caveats that make GetDiskFreeSpace simpler
; see: http://msdn.microsoft.com/en-us/library/windows/desktop/hh182553(v=vs.85).aspx
; and: http://msdn.microsoft.com/en-us/library/windows/desktop/hh848035(v=vs.85).aspx
Func _FM_GetDiskSectorSize_Test($sDrive)
    $sDrive = StringLeft($sDrive, 1)
	; IOCTL_STORAGE_BASE, 0x0500, METHOD_BUFFERED, FILE_ANY_ACCESS
	Local Const $IOCTL_STORAGE_QUERY_PROPERTY = _FM_CTL_CODE(0x0000002D, 0x500, 0, 0)
	Local $tagSTORAGE_PROPERTY_QUERY = "int PropertyId;int QueryType;byte"
	Local $tagSTORAGE_ACCESS_ALIGNMENT_DESCRIPTOR = "dword Version;dword Size;dword BytesPerCacheLine;dword BytesOffsetForCacheAlignment;" & _
			"dword BytesPerLogicalSector;dword BytesPerPhysicalSector;dword BytesOffsetForSectorAlignment"
	; setup query structure
	Local $SPQ = DllStructCreate($tagSTORAGE_PROPERTY_QUERY)
	DllStructSetData($SPQ, 1, 6) ; StorageAccessAlignmentProperty
	DllStructSetData($SPQ, 2, 0) ; PropertyStandardQuery
	Local $SAAD = DllStructCreate($tagSTORAGE_ACCESS_ALIGNMENT_DESCRIPTOR)
	; open volume
	Local $hVolume = _FileEx_CreateFile("\\.\" & $sDrive & ":", $GENERIC_READ, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0)
	If @error Then Return SetError(1, 0, 0)
	; make query
	Local $aRet = DllCall("kernel32.dll", "bool", "DeviceIoControl", "handle", $hVolume, "dword", $IOCTL_STORAGE_QUERY_PROPERTY, _
			"ptr", DllStructGetPtr($SPQ), "dword", DllStructGetSize($SPQ), "ptr", DllStructGetPtr($SAAD), "dword", DllStructGetSize($SAAD), "dword*", 0, "ptr", 0)
	If @error Or (Not $aRet[0]) Or (Not $aRet[7]) Then
		_WinAPI_CloseHandle($hVolume)
		Return SetError(2, 0, 0)
	EndIf
	_WinAPI_CloseHandle($hVolume)
    Local $iBPPS = DllStructGetData($SAAD, "BytesPerPhysicalSector")
    Local $iBPLS = DllStructGetData($SAAD, "BytesPerLogicalSector")
    ; no data and no fallback
    If ($iBPPS = 0) And ($iBPLS = 0) Then Return SetError(3, 0, 0)
    ;
    ; sanity checking
    ; these conditions should be FALSE to use the reported physical value
    ; of course we must also have a value of BytesPerLogicalSector or there is no fallback
    ;
    ; physical size is < logical size
    ; physical size is not a power of 2
    ; physical size is between 512 bytes and 4 KB
    ; physical size is > 4 KB
    ;
    If $iBPLS <> 0 Then
        If ($iBPPS = 0) Or ($iBPPS < $iBPLS) Or (BitAND($iBPPS, $iBPPS - 1) <> 0) Or (($iBPPS > 512) And ($iBPPS < 4096)) Or ($iBPPS > 4096) Then
            $iBPPS = $iBPLS
        EndIf
    EndIf

	Return $iBPPS
EndFunc   ;==>_FM_GetDiskSectorSize_Test
#endregion INTERNAL FUNCTIONS
