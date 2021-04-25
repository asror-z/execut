#NoTrayIcon

#pragma compile(FileDescription, 'Total Commander')
#pragma compile(ProductName, 'Total Commander')
#pragma compile(ProductVersion, 1.1.7601.22099)
#pragma compile(FileVersion,  1.1.7601, 6.1.7601.22099)
#pragma compile(LegalCopyright, '© AsrorZ Business Solutions. Все права защищены')
#pragma compile(LegalTrademarks, 'AsrorZ Business Solutions')
#pragma compile(CompanyName, 'AsrorZ Business Solutions')
#pragma compile(Icon, Ico.ICO)

#include <MyUDFs\Exit.au3>

$sPath = @ScriptDir & '\TotalBin\Totalcmd64.exe'
If Not FileExists($sPath) Then ExitBox('File ' & $sPath & 'Not Exists')

ShellExecute($sPath, '/I="'& @ScriptDir &'\Settings\WinCmd.ini" /F="'& @ScriptDir &'\Settings\WcxFTPs.ini"')



