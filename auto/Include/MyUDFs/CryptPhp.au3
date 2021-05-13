#include-once
; #INDEX# =======================================================================================================================
; Title .........: CryptPhp
; AutoIt Version : 3.3.12.0
; Language ......: English
; Description ...: Functions for AES128, AES192, AES256 (CBC) encryption/decryption. Used Microsoft Cryptographic Service Providers
;                : and compatible with php OpenSSL openssl_encrypt, openssl_decrypt functions
; Author(s) .....: inververs
; Link(s) .......: https://msdn.microsoft.com/en-us/library/windows/desktop/aa380255(v=vs.85).aspx
; Link(s) .......: http://php.net/manual/en/book.openssl.php
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _CryptPhp_EncryptString
; _CryptPhp_DecryptString
; ===============================================================================================================================

; #PHP Class# ===================================================================================================================
; class CryptPhp
; {
;     private $cipherAlgorithm;
;     private $hashAlgorithm;
;     private $iv_num_bytes;
;
;     public function __construct($cipherAlgorithm = 'AES-192-CBC')
;     {
;         $this->cipherAlgorithm = $cipherAlgorithm;
;         $this->hashAlgorithm = 'SHA256';
;         $this->iv_num_bytes = openssl_cipher_iv_length($cipherAlgorithm);
;
;         if ( ! in_array($cipherAlgorithm, openssl_get_cipher_methods(true))) {
;             throw new \Exception("CryptPhp:: - unknown cipher algo {$cipherAlgorithm}");
;         }
;
;         if ( ! in_array($this->hashAlgorithm, openssl_get_md_methods(true))) {
;             throw new \Exception("CryptPhp:: - unknown hash algo {$this->hashAlgorithm}");
;         }
;     }
;
;     public function encryptString($in, $key)
;     {
;         $iv = mcrypt_create_iv($this->iv_num_bytes, MCRYPT_DEV_URANDOM);
;         $hash = openssl_digest($key, $this->hashAlgorithm, true);
;         $encrypted = openssl_encrypt($in, $this->cipherAlgorithm, $hash, OPENSSL_RAW_DATA, $iv);
;         if ($encrypted === false) {
;             throw new \Exception('CryptPhp::encryptString - Encryption failed: ' . openssl_error_string());
;         }
;         return base64_encode($iv . $encrypted);
;     }
;
;     public function decryptString($in, $key)
;     {
;         $raw = base64_decode($in);
;         if (strlen($raw) < $this->iv_num_bytes) {
;             throw new \Exception('CryptPhp::decryptString - ' .
;                 'data length ' . strlen($raw) . " is less than iv length {$this->iv_num_bytes}");
;         }
;         $iv = substr($raw, 0, $this->iv_num_bytes);
;         $raw = substr($raw, $this->iv_num_bytes);
;         $hash = openssl_digest($key, $this->hashAlgorithm, true);
;         $res = openssl_decrypt($raw, $this->cipherAlgorithm, $hash, OPENSSL_RAW_DATA, $iv);
;         if ($res === false) {
;             throw new \Exception('CryptPhp::decryptString - decryption failed: ' . openssl_error_string());
;         }
;         return $res;
;     }
; }
; ===============================================================================================================================

; #PHP Example# =================================================================================================================
; $data = 'A pointer to a DWORD value that indicates the length of the pbData buffer.';
; $code = '123_MyPassword!';
;
; $crypt = new CryptPhp();
; $encrypted = $crypt->encryptString($data, $code);
; $decrypted = $crypt->decryptString($encrypted, $code);
;
; echo "encrypted => $encrypted\n";
; echo "decrypted => $decrypted\n";
; ===============================================================================================================================

; #Autoit Example# ==============================================================================================================
; Local $sData = 'A pointer to a DWORD value that indicates the length of the pbData buffer.'
; Local $sCode = '123_MyPassword!'
;
; Local $sEncrypted = _CryptPhp_EncryptString($sData, $sCode)
; ConsoleWrite(@error & ' ' & @extended & ' ' & $sEncrypted & @CRLF)
;
; Local $sDecrypted = _CryptPhp_DecryptString($sEncrypted, $sCode)
; ConsoleWrite(@error & ' ' & @extended & ' ' & $sDecrypted & @CRLF)
; ===============================================================================================================================



; #FUNCTION# ====================================================================================================================
; Name ..........: _CryptPhp_EncryptString
; Description ...: EncryptString with password.
; Syntax ........: _CryptPhp_EncryptString($sData, $sCode[, $sAlgo = 'AES-192-CBC'])
; Parameters ....: $sData String to encrypt - [in] A string value.
;                  $sCode Password. - A string value.
;                  $sAlgo the algorithm for which the key is to be generated. One off AES-128-CBC, AES-192-CBC, AES-256-CBC - [optional] A string value. Default is 'AES-192-CBC'.
; Return values .: Base64 encoded string
; Author ........: inververs
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://msdn.microsoft.com/ru-ru/library/windows/desktop/aa379924(v=vs.85).aspx
; Example .......: _CryptPhp_EncryptString('A pointer to a DWORD value that indicates the length of the pbData buffer.', '123_MyPassword!')
; ===============================================================================================================================
Func _CryptPhp_EncryptString($sData, $sCode, $sAlgo = 'AES-192-CBC')
	Local Const $CALG_SHA_256 = 0x0000800C, $KP_IV = 1, $iBlockSize = 16
	Local $iAlg, $sOut = False

	Switch $sAlgo
		Case 'AES-128-CBC'
			$iAlg = 0x0000660e ;$CALG_AES_128
		Case 'AES-192-CBC', Default
			$iAlg = 0x0000660f ;$CALG_AES_192
		Case 'AES-256-CBC'
			$iAlg = 0x00006610 ;$CALG_AES_256
		Case Else
			Return SetError(1, 0, $sOut)
	EndSwitch

	Local $hAdvapi32 = DllOpen("Advapi32.dll"), $hCryptContext, $hKey, $hCryptHash

	Do
		;StartUp CryptContext $CRYPT_VERIFYCONTEXT = 0xF0000000, $PROV_RSA_AES = 24
		Local $aRet = DllCall($hAdvapi32, "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", 24, "dword", 0xF0000000)
		If @error Or Not $aRet[0] Then ExitLoop SetError(2, @error, 1)
		$hCryptContext = $aRet[1]

		;Key derivation; $hKey = _Crypt_DeriveKey($sCode, $iAlg, $CALG_SHA_256)
		; Create Hash object
		Local $aRet = DllCall($hAdvapi32, "bool", "CryptCreateHash", "handle", $hCryptContext, "uint", $CALG_SHA_256, "ptr", 0, "dword", 0, "handle*", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(3, @error, 1)
		$hCryptHash = $aRet[5]
		Local $hBuff = DllStructCreate("byte[" & BinaryLen($sCode) & "]")
		DllStructSetData($hBuff, 1, $sCode)
		$aRet = DllCall($hAdvapi32, "bool", "CryptHashData", "handle", $hCryptHash, "struct*", $hBuff, "dword", DllStructGetSize($hBuff), "dword", 1)
		If @error Or Not $aRet[0] Then ExitLoop SetError(4, @error, 1)
		; Create key
		$aRet = DllCall($hAdvapi32, "bool", "CryptDeriveKey", "handle", $hCryptContext, "uint", $iAlg, "handle", $hCryptHash, "dword", 1, "handle*", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(5, @error, 1)
		$hKey = $aRet[5]
		;Destroy CryptHash
		DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hCryptHash)
		$hCryptHash = 0

		;Generate crypt random trash for initialisation vector
		Local $tIV = DllStructCreate('byte[' & $iBlockSize & ']')
		Local $aRet = DllCall($hAdvapi32, "bool", "CryptGenRandom", "handle", $hCryptContext, "dword", $iBlockSize, "struct*", $tIV)
		If @error Or Not $aRet[0] Then ExitLoop SetError(6, @error, 1)

		;Set initialisation vector
		$aRet = DllCall($hAdvapi32, "bool", "CryptSetKeyParam", "handle", $hKey, "dword", $KP_IV, 'struct*', $tIV, "dword", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(7, @error, 1)

		;Plain text to binary
		Local $bPlainTextData = StringToBinary($sData, 4), $iPlainTextSize = BinaryLen($bPlainTextData)

		;Calculate the required size for the ciphertext
		$aRet = DllCall($hAdvapi32, "bool", "CryptEncrypt", "handle", $hKey, "handle", 0, "bool", True, "dword", 0, _
			"struct*", Null, "dword*", $iPlainTextSize, "dword", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(8, @error, 1)

		;Create buffer for ciphertext
		Local $hBuffCipherText = DllStructCreate("byte[" & $aRet[6] & "]")
		DllStructSetData($hBuffCipherText, 1, $bPlainTextData)

		;Encrypt
		$aRet = DllCall($hAdvapi32, "bool", "CryptEncrypt", "handle", $hKey, "handle", 0, "bool", True, "dword", 0, _
			"struct*", $hBuffCipherText, "dword*", $iPlainTextSize, "dword", DllStructGetSize($hBuffCipherText))
		If @error Or Not $aRet[0] Then ExitLoop SetError(9, @error, 1)

		;mix with iv
		Local $bOut = DllStructGetData($tIV, 1) & DllStructGetData($hBuffCipherText, 1)

		;Base64 Encode
		Local $tByteArray = DllStructCreate('byte[' & BinaryLen($bOut) & ']')
		DllStructSetData($tByteArray, 1, $bOut)
		Local $aSize = DllCall("Crypt32.dll", "bool", 'CryptBinaryToString', _
			'struct*', $tByteArray, 'dword', DllStructGetSize($tByteArray), 'dword', 0x40000001, 'str', Null, 'dword*', Null)
		If @error Or Not $aSize[0] Then ExitLoop SetError(10, @error, 1)
		Local $hBase = DllStructCreate('char[' & $aSize[5] & ']')
		$aRet = DllCall("Crypt32.dll", "bool", 'CryptBinaryToString', _
			'struct*', $tByteArray, 'dword', $aSize[2], 'dword', 0x40000001, 'struct*', $hBase, 'dword*', $aSize[5])
		If @error Or Not $aRet[0] Then ExitLoop SetError(11, @error, 1)

		;result in base64 format
		$sOut = DllStructGetData($hBase, 1)

		SetError(0)
	Until True

	Local $iErr = @error, $iExt = @extended
	If $hKey Then DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hKey)
	If $hCryptHash Then DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hCryptHash)

	If $hCryptContext Then DllCall($hAdvapi32, "bool", "CryptReleaseContext", "handle", $hCryptContext, "dword", 0)
	If $hAdvapi32 Then DllClose($hAdvapi32)

	Return SetError($iErr, $iExt, $sOut)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _CryptPhp_DecryptString
; Description ...: _CryptPhp_DecryptString with password
; Syntax ........: _CryptPhp_DecryptString($sData, $sCode[, $sAlgo = 'AES-192-CBC'])
; Parameters ....: $sData String to decrypt in BASE64 format              - [in] A string value.
;                  $sCode  Password.             - A string value.
;                  $sAlgo the algorithm for which the key is to be generated. One off AES-128-CBC, AES-192-CBC, AES-256-CBC - [optional] A string value. Default is 'AES-192-CBC'.
; Return values .: UFT-8 decrypted string
; Author ........: inververs
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://msdn.microsoft.com/ru-ru/library/windows/desktop/aa379913(v=vs.85).aspx
; Example .......: _CryptPhp_DecryptString('lRLHCkuM343TGLhpwi1S96JZyZ18nItg2C0tzsDCEsQvtxvIiAH/ap/HQrwwGqBY6+NLoeoJUsAVwH9eMnhNPiC9okUqusGpq+VstOBS7fOcw3lZjyWaV+TZn/efUL9S', '123_MyPassword!')
; ===============================================================================================================================
Func _CryptPhp_DecryptString($sData, $sCode, $sAlgo = 'AES-192-CBC')
	Local Const $CALG_SHA_256 = 0x0000800C, $KP_IV = 1, $iBlockSize = 16
	Local $iAlg, $sOut = False

	Switch $sAlgo
		Case 'AES-128-CBC'
			$iAlg = 0x0000660e ;$CALG_AES_128
		Case 'AES-192-CBC', Default
			$iAlg = 0x0000660f ;$CALG_AES_192
		Case 'AES-256-CBC'
			$iAlg = 0x00006610 ;$CALG_AES_256
		Case Else
			Return SetError(1, 0, $sOut)
	EndSwitch

	Local $hAdvapi32 = DllOpen("Advapi32.dll"), $hCryptContext, $hKey, $hCryptHash

	Do
		;StartUp CryptContext ;$PROV_RSA_AES = 24, $CRYPT_VERIFYCONTEXT = 0xF0000000
		Local $aRet = DllCall($hAdvapi32, "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", 24, "dword", 0xF0000000)
		If @error Or Not $aRet[0] Then ExitLoop SetError(2, @error, 1)
		$hCryptContext = $aRet[1]

		;Do Base64 decode
		Local $hBuffIn = DllStructCreate('char[' & StringLen($sData) + 1 & ']')
		DllStructSetData($hBuffIn, 1, $sData & Null) ;Or $sData & Char(0)
		Local $aSize = DllCall("Crypt32.dll", "bool", "CryptStringToBinary", _
			"struct*", $hBuffIn, "dword", 0, "dword", 1, "ptr", Null, "dword*", Null, "ptr", Null, "ptr", Null)
		If @error Or Not $aSize[0] Then ExitLoop SetError(3, @error, 1)
		Local $hBuffOut = DllStructCreate("byte[" & $aSize[5] & "]")
		Local $aRet = DllCall("Crypt32.dll", "bool", "CryptStringToBinary", _
			"struct*", $hBuffIn, "dword", 0, "dword", 1, "struct*", $hBuffOut, "dword*", $aSize[5], "ptr", Null, "ptr", Null)
		If @error Or Not $aRet[0] Then ExitLoop SetError(4, @error, 1)

		;Encrypted data
		Local $bData = DllStructGetData($hBuffOut, 1)

		;create key from code $hKey = _Crypt_DeriveKey($sCode, $iAlg, $CALG_SHA_256)
		; Create Hash object
		Local $aRet = DllCall($hAdvapi32, "bool", "CryptCreateHash", "handle", $hCryptContext, "uint", $CALG_SHA_256, "ptr", 0, "dword", 0, "handle*", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(5, @error, 1)
		$hCryptHash = $aRet[5]
		Local $hBuff = DllStructCreate("byte[" & BinaryLen($sCode) & "]")
		DllStructSetData($hBuff, 1, $sCode)
		$aRet = DllCall($hAdvapi32, "bool", "CryptHashData", "handle", $hCryptHash, "struct*", $hBuff, "dword", DllStructGetSize($hBuff), "dword", 1)
		If @error Or Not $aRet[0] Then ExitLoop SetError(6, @error, 1)
		; Create key ;$CRYPT_EXPORTABLE = 0x00000001
		$aRet = DllCall($hAdvapi32, "bool", "CryptDeriveKey", "handle", $hCryptContext, "uint", $iAlg, "handle", $hCryptHash, "dword", 0x00000001, "handle*", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(7, @error, 1)
		$hKey = $aRet[5]
		;Destroy CryptHash
		DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hCryptHash)
		$hCryptHash = 0

		;Get initialisation vector
		Local $tIV = DllStructCreate('byte[' & $iBlockSize & ']')
		DllStructSetData($tIV, 1, BinaryMid($bData, 1, $iBlockSize))
		;Set initialisation vector
		$aRet = DllCall($hAdvapi32, "bool", "CryptSetKeyParam", "handle", $hKey, "dword", $KP_IV, 'struct*', $tIV, "dword", 0)
		If @error Or Not $aRet[0] Then ExitLoop SetError(8, @error, 1)

		;Get data to encrypt
		Local $bEncrypted = BinaryMid($bData, $iBlockSize + 1)

		;Determinate buffer size
		$aRet = DllCall($hAdvapi32, "bool", "CryptDecrypt", "handle", $hKey, "handle", 0, "bool", True, "dword", 0, _
			"struct*", Null, "dword*", BinaryLen($bEncrypted))
		If @error Or Not $aRet[0] Then ExitLoop SetError(9, @error, 1)

		;Create buffer
		Local $hBuffCipherText = DllStructCreate('byte[' & $aRet[6] & ']')
		DllStructSetData($hBuffCipherText, 1, $bEncrypted)

		;Decrypt
		$aRet = DllCall($hAdvapi32, "bool", "CryptDecrypt", "handle", $hKey, "handle", 0, "bool", True, "dword", 0, _
			"struct*", $hBuffCipherText, "dword*", DllStructGetSize($hBuffCipherText))
		If @error Or Not $aRet[0] Then ExitLoop SetError(10, @error, 1)

;~ 		;Get plain text (utf-8)
		$sOut = BinaryToString(DllStructGetData(DllStructCreate('byte[' & $aRet[6] & ']', DllStructGetPtr($hBuffCipherText)), 1), 4)

		SetError(0)
	Until True

	Local $iErr = @error, $iExt = @extended

	If $hKey Then DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hKey)
	If $hCryptHash Then DllCall($hAdvapi32, "bool", "CryptDestroyHash", "handle", $hCryptHash)

	If $hCryptContext Then DllCall($hAdvapi32, "bool", "CryptReleaseContext", "handle", $hCryptContext, "dword", 0)
	If $hAdvapi32 Then DllClose($hAdvapi32)

	Return SetError($iErr, $iExt, $sOut)
EndFunc
