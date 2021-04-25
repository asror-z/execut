
chcp 65001

call nssm-inits.cmd

REM    -----------------------------------------------------------

nssm stop %ServiceName%
nssm remove %ServiceName% confirm

nssm install %ServiceName% %AppExe%
nssm set %ServiceName% AppDirectory %AppPath%
nssm set %ServiceName% AppParameters %AppCmd%

nssm set %ServiceName% DisplayName %ServiceName%
nssm set %ServiceName% Description %ServiceName%

nssm set %ServiceName% AppExit Default %AppExit%

nssm set %ServiceName% ObjectName %ObjectName% %ObjectPass%

call nssm-start.cmd