
call cmd-stop.cmd

net stop %ServiceName%
net stop %ServiceName%
nssm stop %ServiceName%
nssm stop %ServiceName%

call cmd-stop.cmd