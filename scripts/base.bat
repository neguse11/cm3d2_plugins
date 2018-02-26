if not exist "%~dp0..\config.bat" (
  echo �G���[�Fconfig.bat �����ݒ�̂��߁A�������I�����܂��B
  echo �ڂ����� README.md ���Q�Ƃ��Ă�������
  exit /b 1
)

pushd "%~dp0"
call "..\config.bat" || exit /b 1
popd

@rem
@rem INSTALL_PATH�Ƀ��W�X�g�����̃C���X�g�[���p�X������
@rem
set "INSTALL_PATH_REG_KEY=HKCU\Software\KISS\�J�X�^�����C�h3D2"
set "INSTALL_PATH_REG_VALUE=InstallPath"
set "INSTALL_PATH="

@rem http://stackoverflow.com/questions/445167/
for /F "usebackq skip=2 tokens=1-2*" %%A in (`REG QUERY %INSTALL_PATH_REG_KEY% /v %INSTALL_PATH_REG_VALUE% 2^>nul`) do (
    set "INSTALL_PATH=%%C"
)

if not exist "%INSTALL_PATH%\GameData\csv.arc" (
    set "INSTALL_PATH="
)

if defined INSTALL_PATH (
    @rem http://stackoverflow.com/a/19923522/2132223
    for %%a in ("%INSTALL_PATH%\.") do set "INSTALL_PATH=%%~fa"
)


if not defined CM3D2_VANILLA_DIR (
    set "CM3D2_VANILLA_DIR=INSTALL_PATH"
)



if not defined CM3D2_VANILLA_DIR (
  echo �G���[�Fconfig.bat����CM3D2_VANILLA_DIR��ݒ肵�Ă��������B
  exit /b 1
)

if not defined CM3D2_MOD_DIR (
  echo �G���[�Fconfig.bat����CM3D2_MOD_DIR��ݒ肵�Ă��������B
  exit /b 1
)

if not defined CM3D2_PLATFORM (
  echo �G���[�Fconfig.bat����CM3D2_PLATFORM��ݒ肵�Ă��������B
  exit /b 1
)

set "CM3D2_VANILLA_DATA_DIR=%CM3D2_VANILLA_DIR%\CM3D2%CM3D2_PLATFORM%_Data"
set "CM3D2_VANILLA_MANAGED_DIR=%CM3D2_VANILLA_DATA_DIR%\Managed"

set "CM3D2_MOD_DATA_DIR=%CM3D2_MOD_DIR%\CM3D2%CM3D2_PLATFORM%_Data"
set "CM3D2_MOD_MANAGED_DIR=%CM3D2_MOD_DATA_DIR%\Managed"

set "REIPATCHER_DIR=%CM3D2_MOD_DIR%\ReiPatcher"
set "UNITY_INJECTOR_DIR=%CM3D2_MOD_DIR%\UnityInjector"

set "OKIBA_LIB=..\Lib"

set "RF=%TEMP%\temp.rsp"

@rem
@rem CSC��csc.exe�̃p�X������
@rem
@rem https://gist.github.com/asm256/8f5472657c1675bdc77a
@rem https://support.microsoft.com/en-us/kb/318785
set "CSC_REG_KEY=HKLM\SoftWare\Microsoft\NET Framework Setup\NDP\v3.5"
set "CSC_REG_VALUE=InstallPath"
for /F "usebackq skip=2 tokens=1-2*" %%A in (`REG QUERY "%CSC_REG_KEY%" /v "%CSC_REG_VALUE%" 2^>nul`) do (
    set "CSC_PATH=%%C"
)

set "CSC=%CSC_PATH%\csc.exe"

if not exist "%CSC%" (
  echo ".NET Framework 3.5 ��������܂���" 
  echo "�C���X�g�[����Ɏ��s���Ă�������" 
  exit /b 1
)


if not exist "%CM3D2_VANILLA_DIR%" (
  echo �G���[�Fconfig.bat����CM3D2_VANILLA_DIR�������t�H���_�[�u"%CM3D2_VANILLA_DIR%"�v�����݂��܂���
  exit /b 1
)

if not exist "%CM3D2_MOD_DIR%" (
  echo �G���[�Fconfig.bat����CM3D2_MOD_DIR�������t�H���_�[�u"%CM3D2_MOD_DIR%"�v�����݂��܂���
  exit /b 1
)

if not exist "%REIPATCHER_DIR%" (
  echo �G���[�FReiPatcher�t�H���_�[�u"%REIPATCHER_DIR%"�v�����݂��܂���
  exit /b 1
)

if not exist "%CM3D2_MOD_MANAGED_DIR%\UnityInjector.dll" (
  echo �G���[�FUnityInjector.dll���t�H���_�[�u"%CM3D2_MOD_MANAGED_DIR%"�v���ɑ��݂��܂���
  exit /b 1
)

if not exist "%UNITY_INJECTOR_DIR%" (
  echo �G���[�FUnityInjector�t�H���_�[�u"%UNITY_INJECTOR_DIR%"�v�����݂��܂���
  exit /b 1
)

if not exist "%CSC%" (
  echo �G���[�FC# �R���p�C���[�ucsc.exe�v�����݂��܂���
  exit /b 1
)


@rem
@rem �o�j���̃o�[�W�����`�F�b�N
@rem
@rem �X�V���̒��ӁFx64, x86 �ł̂݃o�[�W�����`�F�b�N���s���B
@rem �X�V���̒��ӁF��L�ȊO�̃v���b�g�t�H�[���̓o�[�W���������K�����Ⴄ���߃`�F�b�N�Ώۂɂ��Ȃ�����
@rem �i2015/12/27 �p�~�j�X�V���̒��ӁFmaster�u�����`�̃o�[�W�����`�F�b�N�́u�Ή��m�F�����Ă���o�[�W�����v�����o���邱��
@rem �X�V���̒��ӁFdevelop�u�����`�̃o�[�W�����`�F�b�N�́u�Ή����Ă��Ȃ��o�[�W�����v�����o���邱��
@rem �X�V���̒��ӁFdevelop�u�����`�ł́A�����̃o�[�W�����ɂ��Ă̓��[�U�[���`�������W����]�n���c������
@rem �X�V���̒��ӁFinstaller.bat���̃o�[�W�����`�F�b�N���X�V���邱��
@rem
set "VERSION_CHECK="
if "%CM3D2_PLATFORM%" == "x64" set VERSION_CHECK=1
if "%CM3D2_PLATFORM%" == "x86" set VERSION_CHECK=1

set "BAD_VERSION="
if defined VERSION_CHECK (
  if defined CM3D2_VANILLA_DIR (
    if exist "%CM3D2_VANILLA_DIR%" (
      pushd "%CM3D2_VANILLA_DIR%"
      findstr /i /r "^CM3D2%PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll,10[0-9]$" Update.lst && set "BAD_VERSION=True"
      findstr /i /r "^CM3D2%PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll,11[0-5]$" Update.lst && set "BAD_VERSION=True"
      popd
      if defined BAD_VERSION (
        echo "��Ή��̃o�[�W������ CM3D2 ���C���X�g�[������Ă��܂��B"
        echo.
        echo "���݃C���X�g�[������Ă���o�[�W�����F"
        pushd "%CM3D2_VANILLA_DIR%"
        findstr /i /r "^CM3D2%CM3D2_PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll" Update.lst
        popd
        echo.
        echo "�ȉ���URL���Q�Ƃ��āA�Ή����Ă���o�[�W�������m�F���Ă�������"
        echo "https://github.com/neguse11/cm3d2_plugins_okiba/blob/%OKIBA_BRANCH%/INSTALL.md"
        echo.
        exit /b 1
      )
    )
  )
)


@rem
@rem �C���X�g�[������Ă���o�[�W�������擾���� VANILLA_VERSION �֊i�[
@rem
set "VANILLA_VERSION="
if defined CM3D2_VANILLA_DIR (
  if exist "%CM3D2_VANILLA_DIR%" (
    pushd "%CM3D2_VANILLA_DIR%"
    for /f "tokens=* USEBACKQ" %%F in (`findstr /i /r "^CM3D2%CM3D2_PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll," Update.lst`) do (
      set "VANILLA_VERSION=%%F"
    )
    popd
  )
)
if not defined VANILLA_VERSION (
  echo "%CM3D2_VANILLA_DIR% �ɃC���X�g�[������Ă���A"
  echo "��������CM3D2�̃o�[�W�����̊m�F���ł��܂���ł����B"
  echo "���K�̃C���X�g�[���[�ŃC���X�g�[����Ɏ��s���Ă�������" 
  exit /b 1
)


@rem
@rem �����ł̃o�[�W�������擾���� MOD_VERSION �֊i�[
@rem
set "MOD_VERSION="
set "MOD_BAD_VERSION="
if defined CM3D2_MOD_DIR (
  if exist "%CM3D2_MOD_DIR%" (
    pushd "%CM3D2_MOD_DIR%"
    for /f "tokens=* USEBACKQ" %%F in (`findstr /i /r "^CM3D2%CM3D2_PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll,.*$" Update.lst`) do (
      set "MOD_VERSION=%%F"
    )
    popd
  )
)
if not defined MOD_VERSION (
  echo "%CM3D2_MOD_DIR%�ɂ���A"
  echo "�����ł�CM3D2�̃o�[�W�����̊m�F���ł��܂���ł���"
  exit /b 1
)


@rem
@rem �o�j���Ɖ����ł̃o�[�W�����̓��ꐫ�`�F�b�N
@rem
if NOT "%MOD_VERSION%" == "%VANILLA_VERSION%" (
  echo "��������CM3D2�Ɖ����ł̃o�[�W�������قȂ�܂��B"
  echo "����̃o�[�W�����Ŏ��s���Ă��������B"
  echo "�������̃o�[�W�����F%VANILLA_VERSION%"
  echo "�����ł̃o�[�W�����F%MOD_VERSION%"
  exit /b 1
)
