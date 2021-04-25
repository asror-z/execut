#include <MyUDFs\Exit.au3>
#include <MyUDFs\EnvSetter.au3>
#include <MyUDFs\Reboot.au3>
#include <MyUDFs\_Append2Path.au3>

EnvSetter('CHANGE_TO_UPDATE', 'z')

EnvSetter('SysUser', 'asrorz')
EnvSetter('SysPass', 'password48')

EnvSetter('GPU_FORCE_64BIT_PTR', '0')
EnvSetter('GPU_MAX_ALLOC_PERCENT', '100')
EnvSetter('GPU_MAX_HEAP_SIZE', '100')
EnvSetter('GPU_SINGLE_ALLOC_PERCENT', '100')
EnvSetter('GPU_USE_SYNC_OBJECTS', '1')

EnvSetter('AU_Home', 'd:\Develop\Projects\execut\auto\')

EnvSetter('MSBuildZProject', 'D:\Develop\General\CS\Builders\MSBuild\Projects')
EnvSetter('COMPOSER_HOME', 'd:\Develop\Projects\caches')

_Append2Path('c:\Windows\SysWOW64\')
_Append2Path('c:\Windows\System32\')

_Append2Path('C:\Program Files\TortoiseGit\bin')

_Append2Path('C:\ProgramData\DockerDesktop\version-bin')
_Append2Path('C:\Program Files\Docker\Docker\Resources\bin')

_Append2Path('d:\Develop\Projects\execut\gits\cmd')
_Append2Path('d:\Develop\Projects\execut\cmd')
_Append2Path('d:\Develop\Projects\execut\app')
_Append2Path('d:\Develop\Projects\execut\pse')
_Append2Path('d:\Develop\Projects\execut\gits\cmd')
_Append2Path('d:\Develop\Projects\execut\flut\bin')


_Append2Path('d:\Develop\Projects\execut\nod\')


$question = MsgBox(4, "Question", "Do you want to restart now?")
If $question == 6 Then
  Reboot(20)
EndIf

Mbox('Ready')