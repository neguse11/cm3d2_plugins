@echo off && setlocal ENABLEEXTENSIONS && pushd "%~dp0" && call "%~dp0..\scripts\base.bat" || exit /b 1

set SRC_URL=https://raw.githubusercontent.com/CM3D2-01/CM3D2.AddModsSlider.Plugin/f3510fcfe412a55b0089ab4bf1612ba8adff298e/CM3D2.AddModsSlider.Plugin.cs
set SRC_FILE=CM3D2.AddModsSlider.Plugin.cs

echo �u%SRC_URL%�v����u%SRC_FILE%�v���_�E�����[�h���܂�
powershell -Command "(New-Object Net.WebClient).DownloadFile('%SRC_URL%', '%SRC_FILE%')"

if not exist "%SRC_FILE%" (
  echo �_�E�����[�h�Ɏ��s���܂���
  exit /b 1
)

echo �_�E�����[�h����

popd
