@echo off
set linker=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.24.28314\bin\Hostx64\x64\link.exe
nasm -fwin32 tetris.asm -g -Fcv8 -ltetris.lst
if errorlevel 1 exit 1
"%linker%" /INCREMENTAL:NO /nodefaultlib tetris.obj xdisp.lib /entry:main /subsystem:windows
if errorlevel 1 exit 1