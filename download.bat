@echo off && setlocal ENABLEEXTENSIONS && pushd "%~dp0" && call "%~dp0scripts\base.bat" || exit /b 1

echo.& echo AddModsSlider && call AddModsSlider\download.bat || goto error

echo.& echo �����F�\�[�X�t�@�C���̃_�E�����[�h�ɐ������܂���

popd
goto end

:error

echo.& echo ���s�F�\�[�X�t�@�C���̃_�E�����[�h�Ɏ��s���܂���
exit /b 1

:end
