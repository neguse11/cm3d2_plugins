@echo off && setlocal ENABLEEXTENSIONS && pushd "%~dp0" && call "%~dp0..\scripts\base.bat" || exit /b 1

if not exist "%CM3D2_MOD_MANAGED_DIR%\CM3D2.ExternalSaveData.Managed.dll" (
  echo �G���[�F�ˑ��t�@�C�� %CM3D2_MOD_MANAGED_DIR%\CM3D2.ExternalSaveData.Managed.dll �����݂��Ȃ����߁A�R���p�C�����ł��܂���
  echo ExternalSaveData�̃R���p�C�����Ɏ��s���Ă�������
  exit /b 1
)

set TYPE=/t:library
set OUT=%UNITY_INJECTOR_DIR%\CM3D2.PersonalizedEditSceneSettings.Plugin.dll
set SRCS=PersonalizedEditSceneSettingsPlugin.cs %OKIBA_LIB%\Helper.cs
set OPTS=/r:CM3D2.ExternalSaveData.Managed.dll

call "%~dp0..\scripts\csc-compile.bat" || exit /b 1
popd
