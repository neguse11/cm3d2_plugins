@echo off && setlocal ENABLEEXTENSIONS && pushd "%~dp0" && call "%~dp0..\scripts\base.bat" || exit /b 1

set TYPE=/t:library
set OUT=%CM3D2_MOD_MANAGED_DIR%\CM3D2.ExternalSaveData.Managed.dll
set SRCS=ExSaveData.cs GameMainCallbacks.cs %OKIBA_LIB%\Helper.cs
set OPTS=

call "%~dp0..\scripts\csc-compile.bat" || exit /b 1
popd
