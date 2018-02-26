set "OKIBA_URL=https://github.com/neguse11/cm3d2_plugins_okiba/archive/%OKIBA_BRANCH%.zip"
set "OKIBA_FILE=%OKIBA_BRANCH%.zip"
set "OKIBA_DIR=cm3d2_plugins_okiba-%OKIBA_BRANCH%"

set "REIPATCHER_URL=https://mega.nz/#!21IV0YaS!R2vWnzeGXihjC3r7tRUe-m8rWtYoMPINa8UKJq7flmk"
set "REIPATCHER_7Z=ReiPatcher_0.9.0.8.7z"
set "REIPATCHER_PASSWD=byreisen"

set "UNITYINJECTOR_URL=https://mega.nz/#!jxBWXBpA!hzTpIK6OVjifmANK1N-E_NDFFbG48i363igcyaEc_XI"
set "UNITYINJECTOR_7Z=UnityInjector_1.0.4.0.7z"
set "UNITYINJECTOR_PASSWD=byreisen"

set "_7ZMSI_URL=http://sourceforge.net/projects/sevenzip/files/7-Zip/9.20/7z920.msi"
set "_7ZMSI_FILE=%TEMP%\7z920.msi"

set "REIPATCHER_INI=CM3D2%PLATFORM%.ini"
set "_7z=%ROOT%\_7z\7z.exe"
set "MEGADL=%ROOT%\%OKIBA_DIR%\scripts\megadl.exe"

set "INSTALL_PATH="
set "MOD_PATH="
set "SAME_PATH="


@rem
@rem �e���|�����p�̗����𐶐�
@rem
for /f "tokens=* USEBACKQ" %%F in (`powershell -Command "'' + $(Get-Date -format 'yyyyMMdd_HHmmss_') + $(Get-Random)"`) do (
  set TEMP_RAND=%%F
)


@rem
@rem
if not defined ROOT (
  echo "�G���[�F�C���X�g�[���[������s���Ă������� �i���ϐ� ROOT �����ݒ�j"
  exit /b 1
)

if not defined PLATFORM (
  echo "�G���[�F�C���X�g�[���[������s���Ă������� �i���ϐ� PLATFORM �����ݒ�j"
  exit /b 1
)

if not defined OKIBA_BRANCH (
  echo "�G���[�F�C���X�g�[���[������s���Ă������� �i���ϐ� OKIBA_BRANCH �����ݒ�j"
  exit /b 1
)


@rem
@rem �Ǘ��Ҍ������m�F
@rem
@rem http://stackoverflow.com/a/21295806/2132223
@rem
@rem 
@rem echo "�Ǘ��Ҍ������m�F���Ă��܂�..."
@rem 
@rem set "IS_ADMIN="
@rem sfc 2>&1 | find /i "/SCANNOW" >nul
@rem if not %errorLevel% == 0 (
@rem   echo.
@rem   echo "�G���[�F�Ǘ��Ҍ������������߁A���s�𒆎~���܂��B"
@rem   echo "�Q�[���{�̂̃C���X�g�[���[�����s�����ۂƓ������[�U�[�Ŏ��s���Ă��������B"
@rem   echo.
@rem   exit /b 1
@rem )
@rem set "IS_ADMIN=True"
@rem 
@rem echo "�Ǘ��Ҍ��������邱�Ƃ��m�F���܂����B"


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
  echo "�G���[�F.NET Framework 3.5 ��������܂���" 
  echo "�C���X�g�[����Ɏ��s���Ă�������" 
  exit /b 1
)

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


@rem
@rem �o�j���̃o�[�W�����`�F�b�N
@rem
@rem �X�V���̒��ӁFx64, x86 �ł̂݃o�[�W�����`�F�b�N���s���B
@rem �X�V���̒��ӁF��L�ȊO�̃v���b�g�t�H�[���̓o�[�W���������K�����Ⴄ���߃`�F�b�N�Ώۂɂ��Ȃ�����
@rem �i2015/12/27 �p�~�j�X�V���̒��ӁFmaster�u�����`�̃o�[�W�����`�F�b�N�́u�Ή��m�F�����Ă���o�[�W�����v�����o���邱��
@rem �X�V���̒��ӁFdevelop�u�����`�̃o�[�W�����`�F�b�N�́u�Ή����Ă��Ȃ��o�[�W�����v�����o���邱��
@rem �X�V���̒��ӁFdevelop�u�����`�ł́A�����̃o�[�W�����ɂ��Ă̓��[�U�[���`�������W����]�n���c������
@rem �X�V���̒��ӁFbase.bat���̃o�[�W�����`�F�b�N���X�V���邱��
@rem
set "VERSION_CHECK="
if "%PLATFORM%" == "x64" set VERSION_CHECK=1
if "%PLATFORM%" == "x86" set VERSION_CHECK=1

set "BAD_VERSION="
if defined VERSION_CHECK (
  if defined INSTALL_PATH (
    if exist "%INSTALL_PATH%" (
      pushd "%INSTALL_PATH%"
      findstr /i /r "^CM3D2%PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll,10[0-9]$" Update.lst && set "BAD_VERSION=True"
      findstr /i /r "^CM3D2%PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll,11[0-5]$" Update.lst && set "BAD_VERSION=True"
      popd
      if defined BAD_VERSION (
        echo "�G���[�F��Ή��̃o�[�W������ CM3D2 ���C���X�g�[������Ă��܂��B"
        echo.
        echo "���݃C���X�g�[������Ă���o�[�W�����F"
        pushd "%INSTALL_PATH%"
        findstr /i /r "^CM3D2%PLATFORM%_Data\\Managed\\Assembly-CSharp\.dll" Update.lst
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
@rem MOD_PATH�ɉ����ł̃p�X������
@rem
set "MOD_PATH=%ROOT%"


@rem
@rem INSTALL_PATH��MOD_PATH�����ꂩ�ǂ����m�F���A���ʂ�SAME_PATH�ɓ����
@rem
if defined INSTALL_PATH (
  if defined MOD_PATH (
    echo.>"%INSTALL_PATH%\__cm3d2_okiba_dummy__file__"
    if exist "%ROOT%\__cm3d2_okiba_dummy__file__" (
      set "SAME_PATH=True"
    )
    del "%INSTALL_PATH%\__cm3d2_okiba_dummy__file__"
  )
)


if defined SAME_PATH (
  echo "�G���[�F�ʏ�̃Q�[�����C���X�g�[�����ꂽ�t�H���_�[�ł̎��s�͂ł��܂���" 
  echo "�����ŗp�̃t�H���_�[��ʂɍ��A�����Ŏ��s���Ă�������" 
  exit /b 1
)

if exist "%ROOT%\ReiPatcher" (
  echo "�G���[�FReiPatcher �����ɑ��݂��Ă��܂�"
  echo "�t�H���_�[�u%ROOT%\ReiPatcher�v�����݂��邽�߁A�����𒆎~���܂�" 
  echo.
  echo "���̃C���X�g�[���[�͐V�K�C���X�g�[���p�ł�"
  echo "���̃t�H���_�[���ړ��A���l�[�����邩�A�폜���Ă�����s���Ă�������"
  exit /b 1
)

if exist "%ROOT%\UnityInjector" (
  echo "�G���[�FUnityInjector �����ɑ��݂��Ă��܂�"
  echo "�t�H���_�[�u%ROOT%\UnityInjector�v�����݂��邽�߁A�����𒆎~���܂�"
  echo.
  echo "���̃C���X�g�[���[�͐V�K�C���X�g�[���p�ł�"
  echo "���̃t�H���_�[���ړ��A���l�[�����邩�A�폜���Ă�����s���Ă�������"
  exit /b 1
)


@rem
@rem ���S�ȃf�B���N�g�������ǂ������m�F
@rem
cd|findstr /R "[\^'%%]">"%TEMP%\cm3d2_okiba_bad_dir"
for /f %%i in ("%TEMP%\cm3d2_okiba_bad_dir") do set size=%%~zi
if %size% gtr 0 (
  echo "�G���[�F�t�H���_�[�����s�K�؂ł�"
  echo "�t�H���_�[�ɕs�K�؂ȕ������܂܂�Ă��邽�߁A�����𒆎~���܂�"
  echo.
  echo "�t�H���_�[���ɂ́u^�v�u'�v�u%%�v���܂߂邱�Ƃ͂ł��܂���"
  exit /b 1
)
del "%TEMP%\cm3d2_okiba_bad_dir"


@rem
@rem �V�K�f�B���N�g���̏ꍇ�Axcopy���s��
@rem
if exist "%ROOT%\CM3D2%PLATFORM%_Data" goto VANILLA_XCOPY_OK
echo "�o�j������̃R�s�[���s���܂�"
xcopy /e /y "%INSTALL_PATH%" "%ROOT%" || goto VANILLA_XCOPY_ERROR1
goto VANILLA_XCOPY_OK

:VANILLA_XCOPY_ERROR1
echo "�G���[�F�o�j������̃R�s�[�Ɏ��s���܂����B"
exit /b 1

:VANILLA_XCOPY_OK


@rem
@rem %TEMP%\_7z\ ���� 7zip ��W�J����
@rem
@rem todo �e���|�������폜����@�\�����邱��
@rem
set "TEMP7Z=%TEMP%\cm3d2_okiba_7z_%TEMP_RAND%"
rmdir /s /q _7z >nul 2>&1
mkdir _7z >nul 2>&1 || goto _7Z_DIR_ERROR1
rmdir /s /q "%TEMP7Z%" >nul 2>&1
mkdir "%TEMP7Z%" >nul 2>&1 || goto _7Z_DIR_ERROR2
goto _7Z_DIR_OK

:_7Z_DIR_ERROR1
echo "�G���[�F�f�B���N�g���u_7z�v�̐����Ɏ��s���܂����B" && exit /b 1

:_7Z_DIR_ERROR2
echo "�G���[�F�f�B���N�g���u%TEMP7Z%�v�̐����Ɏ��s���܂����B" && exit /b 1

:_7Z_DIR_OK

pushd _7z

if not exist "%_7ZMSI_FILE%" (
  echo "7z�̃A�[�J�C�u�u%_7ZMSI_URL%�v�̃_�E�����[�h��"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('%_7ZMSI_URL%', '%_7ZMSI_FILE%')"
  if not exist "%_7Z_FILE%" (
    echo "�G���[�F7z�̃A�[�J�C�u�u%_7ZMSI_URL%�v�̃_�E�����[�h�Ɏ��s���܂����B"
    exit /b 1
  )
)

rem ���̂T����78, 83
start /wait msiexec /quiet /a "%_7ZMSI_FILE%" targetdir="%TEMP7Z%"
if not exist "%TEMP7Z%\Files\7-Zip\7z.exe" (
  echo "�G���[�F7z�̃A�[�J�C�u�̓W�J�Ɏ��s���܂����B"
  exit /b 1
)

copy /y "%TEMP7Z%\Files\7-Zip\*.*" . >nul 2>&1
if not exist ".\7z.exe" (
  echo "�G���[�F7z�̃A�[�J�C�u�̓W�J��̃R�s�[�Ɏ��s���܂����B"
  exit /b 1
)

echo "7z�̃A�[�J�C�u�̓W�J����"
popd


@rem
@rem cm3d2_plugins_okiba�̃A�[�J�C�u���_�E�����[�h���A
@rem ROOT\cm3d2_plugins_okiba\ ���ɓW�J����
@rem

echo "�u%OKIBA_URL%�v����u%OKIBA_FILE%�v�̃_�E�����[�h��"

@rem:http://stackoverflow.com/a/20476904/2132223
powershell -Command "(New-Object Net.WebClient).DownloadFile('%OKIBA_URL%', '%OKIBA_FILE%')"
if not exist "%OKIBA_FILE%" (
  echo "�G���[�F�u%OKIBA_FILE%�v�̃_�E�����[�h�Ɏ��s���܂����B"
  exit /b 1
)

rmdir /s /q "%OKIBA_DIR%" >nul 2>&1

@rem http://www.howtogeek.com/tips/how-to-extract-zip-files-using-powershell/
@rem http://stackoverflow.com/questions/2359372/
"%_7z%" -y x "%OKIBA_FILE%" >nul 2>&1
if not exist "%OKIBA_DIR%\config.bat.txt" (
  echo "�G���[�F�u%OKIBA_FILE%�v�̓W�J�Ɏ��s���܂���"
  exit /b 1
)
del "%OKIBA_FILE%" >nul 2>&1

echo "�u%OKIBA_FILE%�v���t�H���_�[�u%ROOT%\%OKIBA_DIR%�v�ɓW�J���܂���"


@rem
@rem megadl �̃R���p�C��
@rem
del "%MEGADL%" >nul 2>&1
pushd "%ROOT%\%OKIBA_DIR%\scripts\"
"%CSC%" /nologo megadl.cs
popd
if not exist "%MEGADL%" (
  echo "�G���[�F�u%ROOT%\%OKIBA_DIR%\scripts\megadl.cs�v�̃R���p�C���Ɏ��s���܂���"
  exit /b 1
)


@rem
@rem ROOT\ ���� ReiPatcher ���_�E�����[�h
@rem
echo "�u%REIPATCHER_URL%�v���_�E�����[�h��"
if not exist "%REIPATCHER_7Z%" (
    "%MEGADL%" %REIPATCHER_URL% "%REIPATCHER_7Z%"
    if not exist "%REIPATCHER_7Z%" (
      echo "�G���[�F�u%REIPATCHER_URL%�v�̃_�E�����[�h�Ɏ��s���܂���"
      exit /b 1
    )
)


@rem
@rem ROOT\ ���� UnityInjector ���_�E�����[�h
@rem
echo "�u%UNITYINJECTOR_URL%�v���_�E�����[�h��"
if not exist "%UNITYINJECTOR_7Z%" (
    "%MEGADL%" %UNITYINJECTOR_URL% "%UNITYINJECTOR_7Z%"
    if not exist "%UNITYINJECTOR_7Z%" (
      echo "�G���[�F�u%UNITYINJECTOR_7Z%�v�̃_�E�����[�h�Ɏ��s���܂���"
      exit /b 1
    )
)


@rem
@rem ROOT\ReiPatcher\ ���� ReiPatcher ��W�J����
@rem
if not exist "%REIPATCHER_7Z%" (
  echo "�G���[�FReiPatcher�̃A�[�J�C�u�t�@�C���u%REIPATCHER_7Z%�v������܂���"
  echo "�A�[�J�C�u���_�E�����[�h���āA�u%ROOT%�v�ɔz�u���Ă�������"
  exit /b 1
)

echo "ReiPatcher�̃A�[�J�C�u�u%REIPATCHER_7Z%�v�̓W�J��"
rmdir /s /q ReiPatcher >nul 2>&1
mkdir ReiPatcher >nul 2>&1
pushd ReiPatcher
"%_7z%" -y x "..\%REIPATCHER_7Z%" -p%REIPATCHER_PASSWD% >nul 2>&1
mkdir Patches >nul 2>&1
echo ;Configuration file for ReiPatcher>"%REIPATCHER_INI%"
echo.>>"%REIPATCHER_INI%"
echo [ReiPatcher]>>"%REIPATCHER_INI%"
echo PatchesDir=Patches>>"%REIPATCHER_INI%"
<nul set /p=;@cm3d=>>"%REIPATCHER_INI%"
pushd ..
cd>>"ReiPatcher\%REIPATCHER_INI%"
popd
echo AssembliesDir=%%cm3d%%\CM3D2%PLATFORM%_Data\Managed>>"%REIPATCHER_INI%"
echo.>>"%REIPATCHER_INI%"
echo [Assemblies]>>"%REIPATCHER_INI%"
echo Assembly-CSharp=Assembly-CSharp.dll>>"%REIPATCHER_INI%"
echo.>>"%REIPATCHER_INI%"
echo [Launch]>>"%REIPATCHER_INI%"
echo Executable=>>"%REIPATCHER_INI%"
echo Arguments=>>"%REIPATCHER_INI%"
echo Directory=>>"%REIPATCHER_INI%"
echo.>>"%REIPATCHER_INI%"
echo [UnityInjector]>>"%REIPATCHER_INI%"
echo Class=SceneLogo>>"%REIPATCHER_INI%"
echo Method=Start>>"%REIPATCHER_INI%"
echo Assembly=Assembly-CSharp>>"%REIPATCHER_INI%"
popd
echo "ReiPatcher�̓W�J����"


@rem
@rem ROOT\UnityInjector\ ���� UnityInjector ��W�J����
@rem
if not exist "%UNITYINJECTOR_7Z%" (
  echo "�G���[�FUnityInjector�̃A�[�J�C�u�t�@�C���u%UNITYINJECTOR_7Z%�v������܂���"
  echo "�A�[�J�C�u���_�E�����[�h���āA�u%ROOT%�v�ɔz�u���Ă�������"
  exit /b 1
)

echo "UnityInjector�̃A�[�J�C�u�u%UNITYINJECTOR_7Z%�v�̓W�J��"
rmdir /s /q UnityInjector >nul 2>&1
mkdir UnityInjector >nul 2>&1
pushd UnityInjector
"%_7z%" -y x "..\%UNITYINJECTOR_7Z%" -p%UNITYINJECTOR_PASSWD% >nul 2>&1
copy /y "Managed\*.dll" "..\CM3D2%PLATFORM%_Data\Managed\" >nul 2>&1
copy /y "ReiPatcher\*.dll" "..\ReiPatcher\Patches\" >nul 2>&1
mkdir Config >nul 2>&1
set "DebugPluginIni=Config\DebugPlugin.ini"
echo [Config]>%DebugPluginIni%
echo ;Enables Debug Plugin>>%DebugPluginIni%
echo Enabled=True>>%DebugPluginIni%
echo ;Enables Mirroring to debug.log>>%DebugPluginIni%
echo Mirror=False>>%DebugPluginIni%
echo ;CodePage, -1 for System Default>>%DebugPluginIni%
echo CodePage=932>>%DebugPluginIni%
popd
echo "UnityInjector�̓W�J����"


if defined SAME_PATH (
  set "INSTALL_PATH="
  set "MOD_PATH="
)

set "TARGET=%ROOT%\%OKIBA_DIR%\config.bat"

echo.>"%TARGET%"
echo @rem �o�j���� CM3D2 �̈ʒu>>"%TARGET%"
if defined INSTALL_PATH (
  echo set "CM3D2_VANILLA_DIR=%INSTALL_PATH%">>"%TARGET%"
) else (
  echo set "CM3D2_VANILLA_DIR=">>"%TARGET%"
)
echo.>>"%TARGET%"
echo @rem �����ł� CM3D2 �̈ʒu>>"%TARGET%"
if defined MOD_PATH (
  echo set "CM3D2_MOD_DIR=%MOD_PATH%">>"%TARGET%"
) else (
  echo set "CM3D2_MOD_DIR=C:\KISS\CM3D2_KAIZOU">>"%TARGET%"
)
echo.>>"%TARGET%"
echo @rem 64bit/32bit �̑I�� (64bit�Ȃ�ux64�v�A32bit�Ȃ�ux86�v)>>"%TARGET%"
echo set "CM3D2_PLATFORM=%PLATFORM%">>"%TARGET%"
echo.>>"%TARGET%"
echo @rem ReiPatcher �� ini �t�@�C����>>"%TARGET%"
echo set "REIPATCHER_INI=CM3D2%PLATFORM%.ini">>"%TARGET%"
echo.>>"%TARGET%"
echo @rem cm3d2_plugins_okiba �̃u�����`��>>"%TARGET%"
echo set "OKIBA_BRANCH=%OKIBA_BRANCH%">>"%TARGET%"

echo.
echo "���Ƃ͈ȉ��̑�������邱�ƂŁA�������������܂�"
echo.
if defined INSTALL_PATH (
echo "1.�u%ROOT%\%OKIBA_DIR%\config.bat�v"
echo "   ���́uCM3D2_VANILLA_DIR�v�ƁuCM3D2_MOD_DIR�v���m�F���A"
echo "   �K�v�Ȃ���ɍ��킹�ď��������Ă�������"
) else (
echo "1.  ��������������������������������������������������"
echo "    ���@�@�C���X�g�[����񂪌�����܂���ł����@�@��"
echo "    ��������������������������������������������������"
echo.
echo "   �u%ROOT%\%OKIBA_DIR%\config.bat�v"
echo "   ���́uCM3D2_VANILLA_DIR�v�ƁuCM3D2_MOD_DIR�v��ݒ肵�Ă�������"
echo.
echo "   �Ⴆ�΁A�uX:\FOO\KISS\CM3D2�v���ɃC���X�g�[�����Ă���ꍇ�A"
echo "   �uset "CM3D2_VANILLA_DIR=X:\FOO\KISS\CM3D2"�v���w�肵�Ă�������"
echo.
)
echo.
echo "2. �u%ROOT%\%OKIBA_DIR%\compile-patch-and-go.bat�v"
echo "   �����s����ƁA�R���p�C���A�p�b�`���삪�s��ꂽ��A�Q�[�����N�����܂�"
echo.

