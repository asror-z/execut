@ECHO OFF
if defined PROGRAMFILES(X86) (
    echo Running GoodSync2Go on 64-bit system
    start x64\GoodSync2Go.exe
) else (
    echo Running GoodSync2Go on 32-bit system
    start x86\GoodSync2Go.exe
)
