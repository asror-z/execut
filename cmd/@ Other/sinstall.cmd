
REM    -----------------------------------------------------------
REM    You need set AppName !!!

Set AppPath=%~dp0
Set AppExe="%AppPath%\%AppName%.exe"

Set ServiceName=%AppName%
Set DisplayName=%AppName%
Set Description=%AppName%




REM    -----------------------------------------------------------

nssm stop %ServiceName%
nssm remove %ServiceName% confirm

nssm install %ServiceName% %AppExe%
nssm set %ServiceName% AppDirectory %AppPath%
 
nssm set %ServiceName% DisplayName %DisplayName%
nssm set %ServiceName% Description %Description%

nssm set %ServiceName% ObjectName LocalSystem

sc start %ServiceName%

pause