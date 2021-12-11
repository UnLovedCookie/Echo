::v5.5
::https://tinyurl.com/echolicence
@echo off
Mode 52,16
title EchoX
color fc

::Enable Delayed Expansion
setlocal EnableDelayedExpansion

::Begin Log
echo Begin Log >%temp%\EchoLog.txt
echo Begin Error Log >%temp%\EchoError.txt

::Get Admin Rights
if exist "%SystemDrive%\Windows\system32\adminrightstest" (rmdir %SystemDrive%\Windows\system32\adminrightstest >nul 2>&1)
mkdir %SystemDrive%\Windows\system32\adminrightstest >nul 2>&1
if %errorlevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "%SystemDrive%\Windows\system32\cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

::Run CMD in 32-Bit
set SystemPath=%SystemRoot%\System32
if not "%ProgramFiles(x86)%"=="" (if exist %SystemRoot%\Sysnative\* set SystemPath=%SystemRoot%\Sysnative)
if not %processor_architecture%==AMD64 (%SystemPath%\cmd.exe /c "%~s0" && exit /b)

::Choice Prompt Setup
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
set Inputln=/m "%BS%                        >:"%1

::Settings
echo Loading Settings [...]

::Nvidia Driver
cd "%SystemDrive%\Program Files\NVIDIA Corporation\NVSMI\" >nul 2>&1
(for /f "tokens=1" %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv') do set NvidiaDriverVersion=%%a) >nul 2>&1

if not exist "%SystemRoot%\System32\wbem\WMIC.exe" (
::WMI Settings
Reg add "HKCU\Software\Echo" /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile import-module Microsoft.PowerShell.Management;import-module Microsoft.PowerShell.Utility;^
$GPU = Get-WmiObject win32_VideoController ^| Select-Object -ExpandProperty Name;Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "GPU_NAME" -Type String -Value "$GPU";^
$mem = Get-WmiObject win32_operatingsystem ^| Select-Object -ExpandProperty TotalVisibleMemorySize;Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "mem" -Type String -Value "$mem";^
$ChassisTypes = Get-WmiObject win32_SystemEnclosure ^| Select-Object -ExpandProperty ChassisTypes;Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "ChassisTypes" -Type String -Value "$ChassisTypes";^
$Degrees = Get-WmiObject -Namespace "root/wmi" MSAcpi_ThermalZoneTemperature ^| Select-Object -ExpandProperty CurrentTemperature;Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "Degrees" -Type String -Value "$Degrees";^
$CORES = Get-WmiObject win32_processor ^| Select-Object -ExpandProperty NumberOfCores;Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "CORES" -Type String -Value "$CORES"
::Win Account
for /f %%i in ('powershell -NoProfile -Command "Get-LocalUser | Select-Object Name,PrincipalSource"') do set "str=%%i" & if "!str!" neq "!str:MicrosoftAccount=!" set Account=MS
) >nul 2>&1 else (
::Faster WMIC Settings
for /f "tokens=2 delims==" %%n in ('wmic os get TotalVisibleMemorySize /format:value') do set ram=%%n
for /f "tokens=2 delims==" %%n in ('wmic path Win32_VideoController get Name /format:value') do set GPU_NAME=%%n
for /f "tokens=2 delims={}" %%n in ('wmic path Win32_SystemEnclosure get ChassisTypes /format:value') do set /a ChassisTypes=%%n
for /f "skip=1 tokens=2 delims==" %%n in ('wmic /namespace:\\root\wmi path MSAcpi_ThermalZoneTemperature get CurrentTemperature /value') do set Degrees=%%n
for /f "tokens=2 delims==" %%n in ('wmic cpu get numberOfCores /format:value') do set CORES=%%n
for /f "delims=" %%n in ('"wmic path Win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution /format:value"') do set "%%n" >nul 2>&1
) >nul 2>&1
call:GrabSettings

::Nvidia Drivers
::if "%NvidiaDriverVersion%" neq "457.30" (
if 1 neq 1 (
call:EchoXLogo
echo.
echo        Recommended graphics driver not found:
choice /c:12 /n /m "%BS%               [1] Install  [2] Skip"
if !errorlevel!==1 (cls
echo Downloading Nvidia Driver [...]
if exist "%temp%\457.30x64Desktop.exe" del "%temp%\457.30x64Desktop.exe"
Reg query "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DCHUVen" >nul 2>&1
if !errorlevel! equ 0 (set "DL=https://onedrive.live.com/download?cid=91FD8D99AB112B7E&resid=91FD8D99AB112B7E%%21108&authkey=AHcg0GQ-iB6_-AM") else (set "DL=https://onedrive.live.com/download?cid=91FD8D99AB112B7E&resid=91FD8D99AB112B7E%%21106&authkey=AOw9OffeXfkCw8w")
powershell "wget '!DL!' -OutFile '%temp%\457.30x64Desktop.exe'" >nul 2>&1
echo Installing Nvidia Driver [...]
"%temp%\457.30x64Desktop.exe"
if !errorlevel! neq 0 (cls & echo Failed to install Nvidia Drivers [...] & echo You'll have to manually install Nvidia Driver 457.30) else (cls & echo Installed Nvidia Drivers [...])
pause & cls
)
)

::Check For Internet
Ping www.google.nl -n 1 -w 1000 >nul
if %errorlevel% neq 0 (
call:EchoXLogo
echo.
echo %BS%               No Internet Connection
echo %BS%          connect or press any key to skip
pause >nul
)

::Check For PowerShell
if not exist "%windir%\system32\WindowsPowerShell\v1.0\powershell.exe" (
call:EchoXLogo
echo.
echo %BS%               Missing PowerShell 1.0
echo %BS%          press any key to continue anyway
pause >nul
)

::Ask about Restore Points
if "%Restore%" equ "" (
call:EchoXLogo
echo.
echo           Let EchoX create Restore Points
echo        (Used to undo all changes after EchoX^)
choice /c:NY /n /m "%BS%                  [Y] Yes  [N] No"
Reg add "HKCU\Software\Echo" /v Restore /t Reg_DWORD /d "!errorlevel!" /f >nul
)

::MS Account
if "%Account%" equ "MS" (
call:EchoXLogo
echo.
echo     Microsoft Account Detected, Continue Anyway?
choice /c:NY /n /m "%BS%                  [Y] Yes  [N] No"
if !errorlevel! equ 1 exit /b
)

::Auto Detect Settings
if %ChassisTypes%0 GEQ 80 if %ChassisTypes%0 LSS 120 (
Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling /t Reg_DWORD /d "1" /f >nul
)

if "%CORES%" NEQ "%THREADS%" (
echo Hyper-Threading
)

if 0%Degrees% GEQ 03010 (
echo Overheating
)

:Home
::vcredist.exe /ai /passive

::start "Viox" /I cmd /c "@echo off & Mode 52,16 & color fc & echo hi & pause && call ^"%~s0^" && exit /b 0"
::exit /b 0

call:EchoXLogo
echo          [91m[[94m1[91m] Optimize  [[94m2[91m] Undo
echo                 [[94m3[91m] Settings  [[94m4[91m] Credits
echo.
choice /c:3421 /n /m "%BS%                                   >:"
set MenuItem=%errorlevel%

if "%MenuItem%"=="3" (
cls
echo How to revert changes:
echo.
echo 1. Hold shift and press restart
echo 2. Find Command Prompt
echo 3. Type Regedit.exe /s "Regbackup.Reg"
echo 3. Type bcdedit.exe /import "%SystemDrive%\bcdedit.bcd"
echo.
echo Press any key to go back to menu
pause >nul
goto :Home
)

if "%MenuItem%"=="2" (
echo [======================Credits======================]
echo             UnLovedCookie#6871 - Creator
echo           Zusier - Debloat + Network + More
echo            Couleur - App and Game Settings
echo              Uwe Sieber - Device Cleaner
echo               Melody - Pagefile and AMD
echo               Matishzz - AMD and Device
echo                EverythingTech - Helped
echo                AuraSide Inc. - Debloat
echo                 Orbmu2k - NVInspector
echo                 Mark Cranness - Mouse
echo                  mbk1969 - Timer Res
echo                  yungkkj - Powerplan
echo                    M2Teams - NSudo
echo                    Waffle - Helped
echo                      Vuk - Tweak
pause
goto :Home
)

if not "%MenuItem%"=="1" (goto :notSettings)
set SettingsPage=1
:Settings
set SettingsItem=
call:GrabSettings

cls
if "%SettingsPage%"=="1" (
echo                        POWER
echo.
if "%MaxPow%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m1[91m] Maximum Power Plan [32m!onoff![91m
echo Enable for more performance and heat
echo.
if "%Throttling%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m2[91m] Power-Throttling [32m!onoff![91m
echo Turn this on if you're on a laptop
echo.
if "%Idle%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m3[91m] Disable Idle [32m!onoff![91m
echo Can generate more heat but has more stable FPS
echo.
if "%pstates%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m4[91m] PStates 0 [32m!onoff![91m
echo Enable for more performance and heat
echo.
choice /c:1234NB /n /m "%BS%                [N] Next   [B] Back"
set SettingsItem=!errorlevel!
if "!SettingsItem!"=="5" (set SettingsPage=2)
cls
)

if "%SettingsItem%"=="1" if "%MaxPow%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v MaxPow /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v MaxPow /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="2" if "%Throttling%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="3" if "%Idle%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="4" if "%pstates%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v pstates /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v pstates /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

if "%SettingsPage%"=="2" (
echo                       ADVANCED
echo.
if "%Debloat%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m1[91m] ADVANCED Debloat [32m!onoff![91m
echo Removes Windows features and can cause BSOD
echo.
if "%BCD%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m2[91m] BCDEdit [32m!onoff![91m
echo Messes with BIOS can cause BSOD
echo.
if "%KBoost%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m3[91m] KBoost [32m!onoff![91m
echo Turn this off if your computer gets hot
echo.
if "%Restore%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m4[91m] Don't Create A Restore Point [32m!onoff![91m
echo Not recommended to turn this off
echo.
choice /c:1234NB /n /m "%BS%                [N] Next   [B] Back"
set SettingsItem=!errorlevel!
if "!SettingsItem!"=="5" (set SettingsPage=3)
cls
)

if "%SettingsItem%"=="1" if "%Debloat%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="2" if "%BCD%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="3" if "%KBoost%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="4" if "%Restore%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

if %SettingsPage%==3 (
echo                       OPTIONAL
echo.
if "%DisplayScaling%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m1[91m] Disable Display Scaling [32m!onoff![91m
echo Turn this on to disable display scaling
echo.
if "%Res%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m2[91m] Timer Resolution [32m!onoff![91m
echo Turn this on for older games
echo.
if "%Mouse%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m3[91m] Mouse Optimization [32m!onoff![91m
echo Turn this off if you use a trackpad or older mouse
echo.
if "%DSCP%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m4[91m] DSCP Value [32m!onoff![91m
echo Turn this on to prioritize your packets
echo.
choice /c:1234NB /n /m "%BS%                [N] Next   [B] Back"
set SettingsItem=!errorlevel!
if "!SettingsItem!"=="5" (set SettingsPage=4)
cls
)

if "%SettingsItem%"=="1" if "%DisplayScaling%"=="0x1" (Reg add "HKCU\Software\Echo" /v DisplayScaling /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v DisplayScaling /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="2" if "%Res%"=="0x1" (Reg add "HKCU\Software\Echo" /v Res /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v Res /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="3" if "%Mouse%"=="0x1" (Reg add "HKCU\Software\Echo" /v Mouse /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v Mouse /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="4" if "%DSCP%"=="0x1" (Reg add "HKCU\Software\Echo" /v DSCP /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v DSCP /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

if %SettingsPage%==4 (
echo                     OPTIONAL PG 2
echo.
if "%staticip%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m1[91m] Static IP [32m!onoff![91m
echo Turn this on to enable Static IP
echo.
if "%Animations%"=="0x1" (set onoff=on) else (set onoff=off)
if "%Animations%"=="" (set onoff=Unset)
echo [[94m2[91m] Disable Animations [32m!onoff![91m
echo Disable Windows Animations
echo.
echo.
echo.
echo.
echo.
echo.
echo.
choice /c:1234NB /n /m "%BS%                [N] Next   [B] Back"
set SettingsItem=!errorlevel!
if "!SettingsItem!"=="5" (set SettingsPage=1)
cls
)

if "%SettingsItem%"=="1" if "%staticip%"=="0x1" (Reg add "HKCU\Software\Echo" /v staticip /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v staticip /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="2" if "%Animations%"=="0x1" (Reg add "HKCU\Software\Echo" /v Animations /t Reg_DWORD /d "0" /f >nul ) else (Reg add "HKCU\Software\Echo" /v Animations /t Reg_DWORD /d "1" /f >nul )
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

goto :Settings
:notSettings

call:GrabSettings

if not "%NVCP%"=="0x1" (if "%NvidiaDriverVersion%" equ "457.30" (
if not exist "%temp%\EchoProfile.nip" (
echo Downloading Nvidia Nip [...]
if exist "%appdata%\.minecraft\options.txt" (set DL=https://cdn.discordapp.com/attachments/798190447117074473/880931795632271390/Minecraft.nip) else (set DL=https://cdn.discordapp.com/attachments/798190447117074473/891526556692938774/EchoProfile.nip)
set DL=https://cdn.discordapp.com/attachments/798190447117074473/880931795632271390/Minecraft.nip
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoProfile.nip") else (bitsadmin /transfer "" !DL! "%temp%\EchoProfile.nip")
)

if not exist "%temp%\EchoNvidia.exe" (
echo Downloading Nvidia Inspector [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143545083461672/EchoProfile.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoNvidia.exe") else (bitsadmin /transfer "" !DL! "%temp%\EchoNvidia.exe")
)
))

if not exist "%SystemDrive%\EchoRes.exe" (if "%Res%"=="0x1" (
echo Downloading Timer Resolution [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143531414749195/EchoRes.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%SystemDrive%\EchoRes.exe") else (bitsadmin /transfer "" !DL! "%SystemDrive%\EchoRes.exe")
))

if not exist "%temp%\EchoDevice.exe" (
echo Downloading Device Cleanup [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143551979028480/EchoDevice.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoDevice.exe") else (bitsadmin /transfer "" !DL! "%temp%\EchoDevice.exe") >nul 2>&1
)

if not exist "%temp%\EchoNSudo.exe" (
echo Downloading NSudo [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoNSudo.exe") else (bitsadmin /transfer "" !DL! "%temp%\EchoNSudo.exe") >nul 2>&1
)

if "%DSCP%"=="0x1" if not exist "%windir%\System32\gpedit.msc" (
echo Installing gpedit.msc [...]
cd %temp%
if exist "List.txt" (del "List.txt" >nul 2>&1)
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt 
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt 
>nul 2>&1 (for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i")
)

::Setup Nsudo
"%temp%\EchoNSudo.exe" -U:S -ShowWindowMode:Hide cmd /c "Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "3" /f"
"%temp%\EchoNSudo.exe" -U:S -ShowWindowMode:Hide cmd /c "sc start "TrustedInstaller""

::Registry Backup
if not exist "%SystemDrive%\Regbackup.Reg" (cls
echo Creating Registry Backup [...]
Regedit /e "%SystemDrive%\Regbackup.Reg" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
)

::BCD Backup
if not exist "%SystemDrive%\bcdbackup.bcd" (cls
echo Creating BCD Backup [...]
bcdedit /export "%SystemDrive%\bcdbackup.bcd" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
)

::Restore Point
if not "%Restore%"=="0x1" (cls
echo Creating System Restore Point [...]
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Echo Optimization' -RestorePointType 'MODIFY_SETTINGS'"
if !errorlevel! neq 0 cls & echo Failed to create a restore point! & echo. & echo Press any key to continue anyway & pause >nul
)

::Fix System Files
::sfc /scannow
::Dism /Online /Cleanup-Image /RestoreHealth

::Optimize Drives
::defrag /C /O

::Disable Process Mitigations
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
::powershell Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess
::echo Disabled Process Mitigations
) >>"%temp%\EchoLog.txt" 2>>nul

::https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::Disable Dma Remapping
::https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible') do set "str=%%i" & if "!str!" neq "!str:Services\=!" (
	Reg add "%%i" /v "DmaRemappingCompatible" /t Reg_DWORD /d "0" /f
) >>"%temp%\EchoLog.txt" 2>>nul
echo Disable DmaRemapping

::CPU
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::Static IP Credits: Zusier
if "%staticip%" equ "0x1" (
set dns1=1.1.1.1
for /f "tokens=4" %%i in ('netsh int show interface ^| find "Connected"') do set devicename=%%i
::for /f "tokens=2 delims=[]" %%i in ('ping -4 -n 1 %ComputerName%^| findstr [') do set LocalIP=%%i
for /f "tokens=3" %%i in ('netsh int ip show config name^="%devicename%" ^| findstr "IP Address:"') do set LocalIP=%%i
for /f "tokens=3" %%i in ('netsh int ip show config name^="%devicename%" ^| findstr "Default Gateway:"') do set DHCPGateway=%%i
for /f "tokens=2 delims=()" %%i in ('netsh int ip show config name^="Ethernet" ^| findstr "Subnet Prefix:"') do for /F "tokens=2" %%a in ("%%i") do set DHCPSubnetMask=%%a
netsh int ipv4 set address name="%devicename%" static %LocalIP% %DHCPSubnetMask% %DHCPGateway%
powershell -NoProfile -Command "Set-DnsClientServerAddress -InterfaceAlias "%devicename%" -ServerAddresses %dns1%"
) >>"%temp%\EchoLog.txt" 2>>nul
echo Static IP

::Disable SEHOP
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable SEHOP

::Disable ASLR
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt" 
echo Disable ASLR

::Disable Spectre And Meltdown
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t Reg_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t Reg_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disabled Spectre And Meltdown

::Disable CFG Lock
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable CFG Lock

:: Disable NTFS/ReFS and FS Mitigations
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable NTFS/ReFS and FS Mitigations

::Reliable Timestamp
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Timestamp Interval

::Enable Hardware Accelerated Scheduling
Reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t Reg_DWORD /d "2" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enable Hardware Accelerated Scheduling

::System responsiveness + Network throttling
::https:nit//cdn.discordapp.com/attachments/890128142075850803/890135598566895666/unknown.png
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t Reg_DWORD /d "10" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::PanTeR Said to use 14 (20 hexa)
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t Reg_DWORD /d "20" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo System Responsivness

::Wallpaper quality 100%
Reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t Reg_DWORD /d "100" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Wallpaper Quality

::Speedup Startup
Reg add "HKEY_CURRENT_USER\AppEvents\Schemes" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Speedup Startup

::Background Apps
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t Reg_DWORD /d "2" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt""
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt""
echo Disable Background Apps

::Storage Optimizations
if exist "%windir%\System32\fsutil.exe" (

::Raise the limit of paged pool memory
fsutil set memory query usage 2
::https://www.serverbrain.org/solutions-2003/the-mft-zone-can-be-optimized.html
fsutil behavior set mftzone 2
echo Memory Optimizations

::HDD + SSD
fsutil behavior set disabledeletenotify 0
fsutil behavior set encryptpagingfile 0
::https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security/
fsutil behavior set disable8dot3 1
::Disable NTFS compression
fsutil behavior set disablecompression 1
::Disable Last Access information on directories, performance/privacy
if "!storageType!" neq "!storageType:SSD=!" fsutil behavior set disableLastAccess 0
if "!storageType!" neq "!storageType:HDD=!" fsutil behavior set disableLastAccess 1
echo HDD + SSD Optimizations

) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::Optimize NTFS
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo NTFS Optimizations

::Disk Optimizations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "StartedComponents" /t Reg_DWORD /d "513347" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminDisable" /t Reg_DWORD /d "8704" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminEnable" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disk Optimizations

::Disable Prefetch
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Prefetch

::Disable Startup Apps
::del /f /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\*.*" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::echo Disable Start Up Programs

::Animations
if "%Animations%" equ "0x0" (
Reg delete "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /f >nul 2>&1
Reg delete "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9e3e078012000000" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enabled Animations
)
if "%Animations%" equ "0x1" (
Reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disabled Animations
)

::Disable FTH
Reg add "HKLM\Software\Microsoft\FTH\State" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg delete "HKLM\Software\Microsoft\FTH\State" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable FTH

::Power Plan
::Import Pow Under 8
powercfg /delete 88888888-8888-8888-8888-888888888888 >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 88888888-8888-8888-8888-888888888888 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg /setactive 88888888-8888-8888-8888-888888888888 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::Import Pow Under 9
powercfg /delete 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 99999999-9999-9999-9999-999999999999 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg /setactive 99999999-9999-9999-9999-999999999999 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg /delete 88888888-8888-8888-8888-888888888888 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg /changename scheme_current "EchoX" "For EchoX Optimizer (dsc.gg/EchoX) By UnLovedCookie & yungkkj" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Power Plan

::Simple Settings
::powercfg /powerthrottling disable /path "%temp%\EchoPow.pow" >nul 2>&1
POWERCFG -X -monitor-timeout-ac 0
POWERCFG -X -monitor-timeout-dc 0
POWERCFG -X -disk-timeout-ac 0
POWERCFG -X -disk-timeout-dc 0
POWERCFG -X -standby-timeout-ac 0
POWERCFG -X -standby-timeout-dc 0
POWERCFG -X -hibernate-timeout-ac 0
POWERCFG -X -hibernate-timeout-dc 0
echo Settings

::Require a password on wakeup: OFF
powercfg -setacvalueindex scheme_current sub_none 0E796BDB-100D-47D6-A2D5-F7D2DAA51F51 0

::Allow Throttle States: OFF
powercfg /setacvalueindex scheme_current sub_processor 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0

::USB 3 Link Power Management: OFF 
powercfg -setacvalueindex scheme_current 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0

::Device Idle Policy Power Savings
powercfg -setacvalueindex scheme_current sub_none 4faab71a-92e5-4726-b531-224559672d19 1 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::Device Idle Policy Performance
powercfg -setacvalueindex scheme_current sub_none 4faab71a-92e5-4726-b531-224559672d19 0 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

if "%Idle%"=="0x1" (
::Disable Idle
powercfg /setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Idle
) else (
::Enable Idle
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enable Idle
)

if "%Throttling%"=="0x1" (
::Enable Power Throttling
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enable Power Throttling
) else (
::Disable Power Throttling
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Power Throttling
)

if "%MaxPow%"=="0x1" (
::100/100 Promote Demote
powercfg -setacvalueindex scheme_current sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 100 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg -setacvalueindex scheme_current sub_processor 4b92d758-5a24-4851-a470-815d78aee119 100 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo 100/100 Promote Demote
::1/1 Increase Decrease
powercfg -setacvalueindex scheme_current sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg -setacvalueindex scheme_current sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo 1/1 Increase Decrease
powercfg /changename scheme_current "EchoX MAX" "For EchoX Optimizer (dsc.gg/EchoX) By UnLovedCookie & yungkkj" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
) else (
::60/40 Promote Demote
powercfg -setacvalueindex scheme_current sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 60 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg -setacvalueindex scheme_current sub_processor 4b92d758-5a24-4851-a470-815d78aee119 40 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo 60/40 Promote Demote
::30/10 Increase Decrease
powercfg -setacvalueindex scheme_current sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 30 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
powercfg -setacvalueindex scheme_current sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 10 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo 30/10 Increase Decrease
)

::Apply
powercfg -setactive scheme_current >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::MMCSS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t Reg_DWORD /d "4" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t Reg_DWORD /d "10000" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t Reg_SZ /d "False" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t Reg_DWORD /d "10000" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t Reg_DWORD /d "18" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t Reg_DWORD /d "6" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t Reg_SZ /d "High" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t Reg_SZ /d "High" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t Reg_SZ /d "True" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo MMCCSS

::Priority
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t Reg_SZ /d "True" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t Reg_DWORD /d "24" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t Reg_DWORD /d "10000" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t Reg_DWORD /d "18" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t Reg_DWORD /d "8" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t Reg_SZ /d "High" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t Reg_SZ /d "High" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t Reg_SZ /d "True" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Echo Priority

if "%Res%" equ "0x1" (
::Timer Resolution
bcdedit /set disabledynamictick yes >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set useplatformtick yes >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
(%SystemDrive%\EchoRes.exe -install) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
sc start STR >nul 2>&1
echo Timer Resolution
) else (
::Disable HPET
if exist "%temp%\EchoView" ("%temp%\EchoView" /disable "High Precision Event Timer" >nul 2>&1)
bcdedit /deletevalue useplatformclock >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set useplatformclock false >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set disabledynamictick true >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable HPET
)

::Device Cleanup
%temp%\EchoDevice * -s >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Clean Devices

::Disable Display Scaling Credits to Zusier
if "%DisplayScaling%" equ "0x1" for /f %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /s /f Scaling') do set "str=%%i" & if "!str!" neq "!str:Configuration\=!" (
	Reg add "%%i" /v "Scaling" /t REG_DWORD /d "1" /f
) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

::GPU AMD + Nvidia Settings
set GPU_NAME=%GPU_NAME: =%
if "%GPU_NAME%" neq "%GPU_NAME:AMD=%" goto :AMD
if "%GPU_NAME%" neq "%GPU_NAME:Ryzen=%" goto :AMD
if "%GPU_NAME%" neq "%GPU_NAME:GeForce=%" goto :NVIDIA
if "%GPU_NAME%" neq "%GPU_NAME:NVIDIA=%" goto :NVIDIA
if "%GPU_NAME%" neq "%GPU_NAME:RTX=%" goto :NVIDIA
if "%GPU_NAME%" neq "%GPU_NAME:GTX=%" goto :NVIDIA
goto :gpuUndefined

:AMD
::Disable Gamemode
Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t Reg_DWORD /d "0" /f >nul
Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t Reg_DWORD /d "0" /f >nul
echo Disable Gamemode

::AMD Reg Keys
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; related to record
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableeRecord" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_SDIEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmSWL1" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ForcePcieLinkSpeed" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_GameManagerSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_10BitMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1SS" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuBypassMode" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; Load Balancing Per Watt
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableLBPWSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePllOffInL1" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; Related to Intel SpeedStep Technology
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePPSMSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableSpreadSpectrum" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; c.f https://docs.nvidia.com/gameworks/content/developertools/desktop/timeout_detection_recovery.htm
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_AllowTDRAfterECC" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; related to record
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DVRSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; related to vm
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableDceVmSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; HDMI Feature
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEDIDManagementSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEventLog" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableHWSHighPriorityQueue" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSDMAPaging" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; c.f https://steemit.com/virtualbox/@benjamin-u4/fr-guide-qu-est-ce-que-amd-v-amd-svm-pourquoi-et-comment-l-activer
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSVMSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FramePacingSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_UseBestGPUPowerOption" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerRemotePlayEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; related to hdmi
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableHDCP" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableStutter" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; related to hdmi
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalEnableHDMI20" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; c.f https://en.wikipedia.org/wiki/Bit_manipulation_instruction_set
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceAbmEnable" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceMaxDisplayClock" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; related to display port
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; c.f https://01.org/linuxgraphics/gfx-docs/drm/ch04s02.html#:~:text=PSR%20feature%20allows%20the%20display,)%20and%20Panel%20(sink).
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; c.f https://www.amd.com/fr/technologies/blockchain
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; c.f https://docs.microsoft.com/en-us/windows-hardware/drivers/display/gdi-hardware-acceleration
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; related to vm
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IoMmuGpuIsolation" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; c.f https://www.phoronix.com/scan.php?page=news_item&px=AMDGPU-DC-Seamless-Boot
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSeamlessBoot" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IsGamingDriver" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t Reg_DWORD /d "1" /f >nul 2>&1
REM ; amd Software
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_CCCNextEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
REM ; c.f https://www.amd.com/fr/technologies/radeon-wattman
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f >nul 2>&1

::Unixcorn AMD Reg Keys
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t Reg_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t Reg_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t Reg_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

::
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t Reg_SZ /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_OPTION" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t Reg_BINARY /d "3000" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t Reg_BINARY /d "0100000001000000" /f >nul 2>&1
echo AMD Reg Keys

::Melody AMD Tweaks
for %%i in (LTRSnoopL1Latency LTRSnoopL0Latency LTRNoSnoopL1Latency LTRMaxNoSnoopLatency KMD_RpmComputeLatency
        DalUrgentLatencyNs memClockSwitchLatency PP_RTPMComputeF1Latency PP_DGBMMMaxTransitionLatencyUvd
        PP_DGBPMMaxTransitionLatencyGfx DalNBLatencyForUnderFlow DalDramClockChangeLatencyNs
        BGM_LTRSnoopL1Latency BGM_LTRSnoopL0Latency BGM_LTRNoSnoopL1Latency BGM_LTRNoSnoopL0Latency
        BGM_LTRMaxSnoopLatencyValue BGM_LTRMaxNoSnoopLatencyValue) do Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "%%i" /t Reg_DWORD /d "1" /f >nul 2>&1
) >nul 2>&1

echo Optimized AMD GPU
goto :gpuUndefined

:NVIDIA
::Enable GameMode
Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Echo Enable Gamemode

::Opt out of nvidia telemtry 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f >nul 2>nul
echo Opt out of nvidia telemtry 

::Unrestricted Clocks
cd "%SystemDrive%\Program Files\NVIDIA Corporation\NVSMI\" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
nvidia-smi -acp 0 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
if %errorlevel% equ 0 (echo Unrestricted Clocks)

::OC Scanner Fix, cuz why not?
if not exist "%SystemDrive%\Program Files\NVIDIA Corporation\NVSMI" mkdir "%SystemDrive%\Program Files\NVIDIA Corporation\NVSMI" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
copy /Y "%windir%\system32\nvml.dll" "%SystemDrive%\Program Files\NVIDIA Corporation\NVSMI\nvml.dll" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo OC Scanner Fix

::Disable GpuEnergyDrv
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t Reg_DWORD /d "4" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable GpuEnergyDrv

::Enable Tiled Display
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableTiledDisplay" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
if exist "%windir%\system32\wbem\WMIC.exe" for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do (
set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%a" /v "EnableTiledDisplay" /t REG_DWORD /d "0" /f
) >nul 2>&1
echo Enable Tiled Display

::Nvidia Reg
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Nvidia Reg

::Disable Preemption
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Preemption

::PStates 0 Credits to Timecard & Zusier
::https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/RESEARCH/WINDRIVERS#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0
if "%pstates%" equ "0x1" for /F "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "NVIDIA"') do set "str=%%i" & if "!str:HK=!" neq "!str!" (
Reg add "%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo PStates 0

::kboost
if "%KBoost%"=="0x1" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo KBoost
)

::NVCP
if not "%NVCP%"=="0x1" (
if "%NvidiaDriverVersion%" == "457.30" (
"%temp%\EchoNvidia.exe" "%temp%\EchoProfile.nip" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo NVCP Settings
)) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
:gpuUndefined

::Disable Hibernation
powercfg -h off >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Hibernation

::RAM
::Disable Memory Compression
::powershell -Command "Disable-MMAgent -mc"

::Disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::Disable Paging Combining
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Paging Combining

::Set SvcSplitThreshold (revision)
set /a ram=%mem% + 1024000
Reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t Reg_DWORD /d "%ram%" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo SvcSplitThreshold

::Set Win32PrioritySeparation 26 hex/38 dec
Reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t Reg_DWORD /d "38" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Win32PrioritySeparation

::100% Scaling and Mouse Acc
if not "%Mouse%"=="0x1" (goto :noMouse)
Reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t Reg_SZ /d "10" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t Reg_SZ /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t Reg_SZ /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t Reg_SZ /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Mouse Acc
::Missing
echo Windows Scaling
:noMouse

::DataQueueSize
FOR /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize`) DO (set KeyboardSize=%%A)
if %KeyboardSize:~2,10% gtr 75 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t Reg_DWORD /d "75" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt")
For /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize`) DO (set MouseSize=%%A)
if %KeyboardSize:~2,10% gtr 75 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t Reg_DWORD /d "75" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt")
echo DataQueueSize

::CSRSS priority
::csrss is responsible for mouse input, setting to high may yield an improvement in input latency.
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationAuditOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t Reg_DWORD /d "4" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t Reg_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo CSRSS priority

if not exist "%windir%\system32\wbem\WMIC.exe" (goto :skipMSIandAffinites)

::DEL GPU + USB + Sata controllers Device Priority + NET (Use Normal Priority on vmware)
for /f "delims=" %%# in ('"wmic computersystem get manufacturer /format:value"') do set "%%#" >nul & if "!Manufacturer:VMWare=!" neq "!Manufacturer!" (set VMWare=/t Reg_DWORD /d "2") else (set "VMWare=")
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" %VMWare% /f >nul 2>nul
(for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f) >nul 2>nul
echo Delete Device Priority

::Enable MSI Mode on GPU if supported
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" (
Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" >nul 2>&1
if !ERRORLEVEL! EQU 0 (Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1)
)
echo GPU MSI Mode

::Enable MSI Mode on USB, NET, Sata controllers
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1
(for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f) >nul 2>&1
echo CPU + NET MSI Mode

::GPU + NET Affinites
if %THREADS% gtr 4 (
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f >nul 2>nul
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t Reg_DWORD /d "5" /f >nul 2>nul
)
echo GPU + NET Affinites

::Remove GPU Limits
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" Reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f >nul 2>&1
echo Remove GPU Limits

:skipMSIandAffinites

::FSO
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disabled FSO

::BCDEdit
::Better Input
bcdedit /set tscsyncpolicy legacy >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo tscsyncpolicy legacy

if "%BCD%"=="0x1" (

::Quick Boot
if "%duelboot%" neq "yes" (bcdedit /timeout 0) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set bootux disabled >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set bootmenupolicy standard >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set hypervisorlaunchtype off >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set tpmbootentropy ForceDisable >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set quietboot yes >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Quick Boot BCDEdit

::Windows 8 Boot Stuff
for /f "tokens=4-9 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM windows 8.1
if "!version!" == "6.3.9600" (
bcdedit /set {globalsettings} custom:16000067 true >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set {globalsettings} custom:16000069 true >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set {globalsettings} custom:16000068 true >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Windows 8 Boot Stuff
)

::nx
if not "%CPU_NAME:AMD=%" == "%CPU_NAME%" (
bcdedit /set nx optout >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
) else (
bcdedit /set nx alwaysoff >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
)

::Linear Address 57
bcdedit /set linearaddress57 OptOut >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set increaseuserva 268435328 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Linear Address 57

::Disable some of the kernel memory mitigations
bcdedit /set allowedinmemorysettings 0x0 >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set isolatedcontext No >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Kernel memory mitigations

::Disable DMA memory protection and cores isolation
bcdedit /set vsmlaunchtype Off >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set vm No >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo DMA memory protection and cores isolation

::Enable X2Apic and enable Memory Mapping for PCI-E devices
bcdedit /set x2apicpolicy Enable >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set configaccesspolicy Default >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set MSI Default >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set usephysicaldestination No >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set usefirmwarepcisettings No >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
bcdedit /set uselegacyapicmode yes >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enable X2Apic and Memory Mapping
)

::Discord


::OBS
if not exist "%appdata%\obs-studio" goto :skipOBS

::Run as admin
Reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%SystemDrive%\Program Files\obs-studio\bin\64bit\obs64.exe" /t Reg_SZ /d "~ RUNASADMIN" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"

set GPU_NAME=%GPU_NAME: =%
if not "%GPU_NAME:AMD=%" == "%GPU_NAME%" goto :skipOBS
if not "%GPU_NAME:Ryzen=%" == "%GPU_NAME%" goto :skipOBS

set Resolution=%CurrentHorizontalResolution%x%CurrentVerticalResolution%
if "%Resolution%" == "1920x1080" (
set cqlevel=18
goto :foundResolution
)
if "%Resolution%" == "1280x720" (
set cqlevel=17
goto :foundResolution
)
goto :skipOBS

:foundResolution
cd %appdata%\obs-studio\basic\profiles
if not exist "Couleur" (
mkdir Couleur)
cd .\Couleur

echo [General]> basic.ini
echo Name=Couleur>> basic.ini
echo. >> basic.ini
echo [Video]>> basic.ini
echo BaseCX=%CurrentHorizontalResolution%>> basic.ini
echo BaseCY=%CurrentVerticalResolution%>> basic.ini
echo OutputCX=%CurrentHorizontalResolution%>> basic.ini
echo OutputCY=%CurrentVerticalResolution%>> basic.ini
(echo FPSType=2)>> basic.ini
echo FPSNum=60>> basic.ini
echo ScaleType=bilinear>> basic.ini
echo ColorSpace=709>> basic.ini
echo.>> basic.ini
echo [Output]>> basic.ini
echo Mode=Advanced>> basic.ini
echo.>> basic.ini
echo [AdvOut]>> basic.ini
echo TrackIndex=1>> basic.ini
echo RecType=Standard>> basic.ini
echo RecFilePath=%HOMEDRIVE%/Users/%Username%/Videos>> basic.ini
echo RecFormat=mp4>> basic.ini
echo RecEncoder=jim_nvenc>> basic.ini
echo RecTracks=1>> basic.ini
echo FLVTrack=1>> basic.ini
echo FFOutputToFile=true>> basic.ini
echo FFFormat=>> basic.ini
echo FFFormatMimeType=>> basic.ini
(echo FFVEncoderId=0)>> basic.ini
(echo FFVEncoder=)>> basic.ini
(echo FFAEncoderId=0)>> basic.ini
(echo FFAEncoder=)>> basic.ini
echo FFAudioMixes=1>> basic.ini
echo.>> basic.ini
echo [Hotkeys]>> basic.ini
echo ReplayBuffer={\n    "ReplayBuffer.Save": [\n        {\n            "key": "OBS_KEY_F4"\n        }\n    ]\n}>> basic.ini
echo OBSBasic.StartRecording={\n    "bindings": [\n        {\n            "key": "OBS_KEY_F8"\n        }\n    ]\n}>> basic.ini
echo OBSBasic.StopRecording={\n    "bindings": [\n        {\n            "key": "OBS_KEY_F8"\n        }\n    ]\n}>> basic.ini
echo OBSBasic.EnablePreview={\n    "bindings": [\n        {\n            "key": "OBS_KEY_F9"\n        }\n    ]\n}>> basic.ini
echo OBSBasic.DisablePreview={\n    "bindings": [\n        {\n            "key": "OBS_KEY_F9"\n        }\n    ]\n}>> basic.ini
echo OBSBasic.ResetStats={\n    "bindings": [\n        {\n            "key": "OBS_KEY_F12"\n        }\n    ]\n}>> basic.ini
echo.>> basic.ini
echo [SimpleOutput]>> basic.ini
echo RecRBPrefix=R>> basic.ini

::recordEncoder.json
echo {> recordEncoder.json
echo     "bf": 0,>> recordEncoder.json
echo     "cqp": %cqlevel%,>> recordEncoder.json
echo     "keyint_sec": 1,>> recordEncoder.json
echo     "preset": "hp",>> recordEncoder.json
echo     "profile": "high",>> recordEncoder.json
echo     "psycho_aq": false,>> recordEncoder.json
echo     "rate_control": "CQP">> recordEncoder.json
echo }>> recordEncoder.json

::Changing Settings
goto :skipOBS
cd %appdata%\obs-studio
if exist "global.ini.old" (del "global.ini.old" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt")
ren "global.ini" "global.ini.old" >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
>"global.ini" (
  for /f "usebackq delims=" %%A in ("global.ini.old") do (
    if "%%A" equ "Profile=Untitled" (echo Profile=Couleur) else if "%%A" neq "ProfileDir=Untitled" (echo %%A)
	if "%%A" equ "ProfileDir=Untitled" (echo ProfileDir=Couleur) else if "%%A" neq "Profile=Untitled" (echo %%A)
  )
)
:skipOBS
echo OBS Settings

::Minecraft
if exist "%appdata%\.minecraft\" (

::High Priority
if "%Priority%"=="0x1" (
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v "CpuPriorityClass" /t Reg_DWORD /d "3" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Minecraft Game Priority
)

cd "%appdata%\.minecraft"
(echo renderDistance:4) >> options.txt
(echo particles:0) >> options.txt
(echo maxFps:69420) >> options.txt
(echo fboEnable:true) >> options.txt
(echo fancyGraphics:false) >> options.txt
(echo ao:1) >> options.txt
(echo renderClouds:false) >> options.txt
(echo useVbo:true) >> options.txt
(echo showInventoryAchievementHint:false) >> options.txt
(echo mipmapLevels:4) >> options.txt
(echo forceUnicodeFont:false) >> options.txt
(echo allowBlockAlternatives:false) >> options.txt
(echo entityShadows:false) >> options.txt
(echo ofFogType:3) > optionsof.txt
(echo ofFogStart:0.6) >> optionsof.txt
(echo ofMipmapType:3) >> optionsof.txt
(echo ofOcclusionFancy:false) >> optionsof.txt
(echo ofSmoothFps:false) >> optionsof.txt
(echo ofSmoothWorld:false) >> optionsof.txt
(echo ofAoLevel:1.0) >> optionsof.txt
(echo ofClouds:3) >> optionsof.txt
(echo ofCloudsHeight:0.0) >> optionsof.txt
(echo ofTrees:1) >> optionsof.txt
(echo ofDroppedItems:1) >> optionsof.txt
(echo ofRain:3) >> optionsof.txt
(echo ofAnimatedWater:2) >> optionsof.txt
(echo ofAnimatedLava:2) >> optionsof.txt
(echo ofAnimatedFire:false) >> optionsof.txt
(echo ofAnimatedPortal:false) >> optionsof.txt
(echo ofAnimatedRedstone:false) >> optionsof.txt
(echo ofAnimatedExplosion:false) >> optionsof.txt
(echo ofAnimatedFlame:false) >> optionsof.txt
(echo ofAnimatedSmoke:false) >> optionsof.txt
(echo ofVoidParticles:false) >> optionsof.txt
(echo ofWaterParticles:false) >> optionsof.txt
(echo ofPortalParticles:false) >> optionsof.txt
(echo ofPotionParticles:false) >> optionsof.txt
(echo ofFireworkParticles:false) >> optionsof.txt
(echo ofDrippingWaterLava:false) >> optionsof.txt
(echo ofAnimatedTerrain:false) >> optionsof.txt
(echo ofAnimatedTextures:false) >> optionsof.txt
(echo ofRainSplash:false) >> optionsof.txt
(echo ofLagometer:false) >> optionsof.txt
(echo ofShowFps:false) >> optionsof.txt
(echo ofAutoSaveTicks:4000) >> optionsof.txt
(echo ofBetterGrass:3) >> optionsof.txt
(echo ofConnectedTextures:1) >> optionsof.txt
(echo ofWeather:true) >> optionsof.txt
(echo ofSky:false) >> optionsof.txt
(echo ofStars:true) >> optionsof.txt
(echo ofSunMoon:false) >> optionsof.txt
(echo ofVignette:1) >> optionsof.txt
(echo ofChunkUpdates:1) >> optionsof.txt
(echo ofChunkUpdatesDynamic:false) >> optionsof.txt
(echo ofTime:1) >> optionsof.txt
(echo ofClearWater:false) >> optionsof.txt
(echo ofAaLevel:0) >> optionsof.txt
(echo ofAfLevel:1) >> optionsof.txt
(echo ofProfiler:false) >> optionsof.txt
(echo ofBetterSnow:false) >> optionsof.txt
(echo ofSwampColors:false) >> optionsof.txt
(echo ofRandomEntities:false) >> optionsof.txt
(echo ofSmoothBiomes:false) >> optionsof.txt
(echo ofCustomFonts:false) >> optionsof.txt
(echo ofCustomColors:false) >> optionsof.txt
(echo ofCustomItems:false) >> optionsof.txt
(echo ofCustomSky:true) >> optionsof.txt
(echo ofShowCapes:true) >> optionsof.txt
(echo ofNaturalTextures:false) >> optionsof.txt
(echo ofEmissiveTextures:false) >> optionsof.txt
(echo ofLazyChunkLoading:false) >> optionsof.txt
(echo ofRenderRegions:true) >> optionsof.txt
(echo ofSmartAnimations:false) >> optionsof.txt
(echo ofAlternateBlocks:false) >> optionsof.txt
(echo ofDynamicLights:3) >> optionsof.txt
(echo ofScreenshotSize:1) >> optionsof.txt
(echo ofCustomEntityModels:false) >> optionsof.txt
(echo ofCustomGuis:false) >> optionsof.txt
(echo ofShowGlErrors:false) >> optionsof.txt
(echo ofFullscreenMode:Default) >> optionsof.txt
(echo ofFastMath:true) >> optionsof.txt
(echo ofFastRender:true) >> optionsof.txt
(echo ofTranslucentBlocks:1) >> optionsof.txt
echo Minecraft Settings
)

::Advanced Debloat
if "%Debloat%"=="0x1" (goto :AdvancedDebloat)
:FinishedDebloat

::Clean Network
if "%CleanNet%" equ "Yes" (
netsh winsock reset catalog >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
netsh int ip reset c:resetlog.txt >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
netsh int ip reset c:\tcplog.txt >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
netsh winsock reset >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
arp -d * >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo ipconfig /renew >%temp%\RefreshNet.bat
echo ipconfig /registerdns >>%temp%\RefreshNet.bat
::echo ipconfig /release >>%temp%\RefreshNet.bat
echo ipconfig /flushdns >>%temp%\RefreshNet.bat
%temp%\EchoNSudo.exe -U:T -P:E -M:S -ShowWindowMode:Hide cmd /c "%temp%\RefreshNet.bat"
echo Clean Internet
)

::Use Large System Cache to improve microstuttering
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Enable Large System Cache

::https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosTimerResolution
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\System\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Qos TimerResolution

::Network Priorities
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t Reg_DWORD /d "4" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t Reg_DWORD /d "5" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t Reg_DWORD /d "6" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t Reg_DWORD /d "7" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Network Priorities

::Remove OneDrive Sync
Reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t Reg_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Remove OneDrive Sync

::Disable Delivery Optimization
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Disable Delivery Optimization

::Disable limiting bandwith
::https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosNonBestEffortLimit
Reg add "HKLM\Software\WOW6432Node\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Remove Limiting Bandwidth

::NIC
echo Windows Registry Editor Version 5.00 >"%temp%\NIC.reg"
if exist "%windir%\system32\wbem\WMIC.exe" for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID') do set "str=%%i" & if "!str:PCI\VEN_=!" neq "!str!" ( 
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do set "str=%%a" & if "!str!" neq "!str:HKEY_!" (
echo [HKEY_LOCAL_MACHIN\SYSTEM\CurrentControlSet\Control\Class\%%a] >>"%temp%\NIC.reg"
::Disable Keys w "*"
echo "*WakeOnMagicPacket"="0" >>"%temp%\NIC.reg"
echo "*WakeOnPattern"="0" >>"%temp%\NIC.reg"
echo "*FlowControl"="0" >>"%temp%\NIC.reg"
echo "*EEE"="0" >>"%temp%\NIC.reg"
::Disable Keys wo "*"
echo "EnablePME"="0" >>"%temp%\NIC.reg"
echo "WakeOnLink"="0" >>"%temp%\NIC.reg"
echo "EEELinkAdvertisement"="0" >>"%temp%\NIC.reg"
echo "ReduceSpeedOnPowerDown"="0" >>"%temp%\NIC.reg"
echo "PowerSavingMode"="0" >>"%temp%\NIC.reg"
echo "EnableGreenEthernet"="0" >>"%temp%\NIC.reg"
echo "S5WakeOnLan"="0" >>"%temp%\NIC.reg"
echo "ULPMode"="0" >>"%temp%\NIC.reg"
echo "GigaLite"="0" >>"%temp%\NIC.reg"
echo "EnableSavePowerNow"="0" >>"%temp%\NIC.reg"
echo "EnablePowerManagement"="0" >>"%temp%\NIC.reg"
echo "EnableDynamicPowerGating"="0" >>"%temp%\NIC.reg"
echo "EnableConnectedPowerGating"="0" >>"%temp%\NIC.reg"
echo "AutoPowerSaveModeEnabled"="0" >>"%temp%\NIC.reg"
echo "AutoDisableGigabit"="0" >>"%temp%\NIC.reg"
echo "AdvancedEEE"="0" >>"%temp%\NIC.reg"
echo "PowerDownPll"="0" >>"%temp%\NIC.reg"
echo "S5NicKeepOverrideMacAddrV2"="0" >>"%temp%\NIC.reg"
::Disable JumboPacket
echo "JumboPacket"="0" >>"%temp%\NIC.reg"
::Disable LargeSendOffloads
echo "LsoV2IPv4"="0" >>"%temp%\NIC.reg"
echo "LsoV2IPv6"="0" >>"%temp%\NIC.reg"
::Enable RSS
echo "RSS"="1" >>"%temp%\NIC.reg"
::Interrupt Moderation Adaptive (Default)
echo "ITR"="125" >>"%temp%\NIC.reg"
::Receive/Transmit Buffers
echo "ReceiveBuffers"="256" >>"%temp%\NIC.reg"
echo "TransmitBuffers"="256" >>"%temp%\NIC.reg"
::Disable Wake Features
echo "WolShutdownLinkSpeed"="2" >>"%temp%\NIC.reg"
::Disable NIC Offloads
echo "UDPChecksumOffloadIPv6"="0" >>"%temp%\NIC.reg"
echo "IPChecksumOffloadIPv4"="0" >>"%temp%\NIC.reg"
echo "UDPChecksumOffloadIPv4"="0" >>"%temp%\NIC.reg"
echo "PMARPOffload"="0" >>"%temp%\NIC.reg"
echo "PMNSOffload"="0" >>"%temp%\NIC.reg"
echo "TCPChecksumOffloadIPv4"="0" >>"%temp%\NIC.reg"
echo "TCPChecksumOffloadIPv6"="0" >>"%temp%\NIC.reg"
)
)
Regedit.exe /s "%temp%\NIC.reg"
del /f "%temp%\NIC.reg"
echo NIC

::Netsh
netsh int tcp set global initialRto=2000 rsc=disabled netdma=disabled rss=enabled ecncapability=enabled MaxSynRetransmissions=2 timestamps=disabled autotuninglevel=normal nonsackrttresiliency=disabled dca=enabled >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
netsh int tcp set supplemental Internet congestionprovider=dctcp >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
netsh int tcp set heuristics disabled >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
for /f "tokens=1" %%i in ('netsh int ip show interfaces') do if %%i LSS 9 (
netsh int ip set interface %%i routerdiscovery=disabled store=persistent
) >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
echo Netsh

::Internet Reg
goto :finishMTU
set MTU=1500
set output=bad
:findMTU
ping -f -n 1 -4 www.google.com >nul
if %errorlevel% equ 1 (goto :finishMTU)
ping -f -n 1 -4 -l %MTU% 8.8.8.8 >nul >nul 2>&1 >nul 2>&1
if %errorlevel% equ 0 (
set output=good
set /a MTU=%MTU%+1
goto :findMTU
)
if %errorlevel% equ 1 (
if /i "%output%"=="good" (
for /f "tokens=3*" %%s in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "MTU" /t Reg_DWORD /d "%MTU%" /f >nul
)
goto :finishMTU
)
set output=bad
set /a MTU=%MTU%-10
goto :findMTU
)
:finishMTU

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f "tokens=3*" %%s in ('Reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s') do set "str=%%i" & if "!str:ServiceName_=!" neq "!str!" (
	::Outdated Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched\Parameters\Adapters\%%s" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f
	::Outdated Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "DeadGWDetectDefault" /t Reg_DWORD /d "1" /f
	::Outdated Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "PerformRouterDiscovery" /t Reg_DWORD /d "1" /f
	::Outdated Reg add "HKLM\SYSTEM\CurrentCoEntrolSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpInitialRTT" /t Reg_DWORD /d "0" /f
 	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f
) >>"%temp%\EchoLog.txt" 2>>nul
echo Internet Settings

::Internet Priority
if not "%DSCP%"=="0x1" (goto :skipPriority)
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "Start" /t Reg_DWORD /d "1" /f >nul 2>&1
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc start Psched"
(powershell Get-NetAdapterQos -Name "*" ^| Enable-NetAdapterQos) >nul 2>&1
for %%i in (csgo VALORANT-Win64-Shipping javaw FortniteClient-Win64-Shipping ModernWarfare r5apex) do (
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Application Name" /t Reg_SZ /d "%%i.exe" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Version" /t Reg_SZ /d "1.0" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Protocol" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local Port" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Local IP Prefix Length" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote Port" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Remote IP Prefix Length" /t Reg_SZ /d "*" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "DSCP Value" /t Reg_SZ /d "46" /f
    Reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%i" /v "Throttle Rate" /t Reg_SZ /d "-1" /f
) >nul 2>nul
echo Priority
:skipPriority

::Security Tweaks 
::PATCH V-220930 (From Zeta)
Reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::PATCH V-220929 (From Zeta)
Reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >>"%temp%\EchoLog.txt" 2>>"%temp%\EchoError.txt"
::Disable NetBIOS, can be exploited and is highly vulnerable. (From Zeta)
sc stop lmhosts >>"%temp%\EchoLog.txt" 2>>nul
sc config lmhosts start=disabled >>"%temp%\EchoLog.txt" 2>>nul
::https://cyware.com/news/what-is-smb-vulnerability-and-how-it-was-exploited-to-launch-the-wannacry-ransomware-attack-c5a97c48
sc stop LanmanWorkstation >>"%temp%\EchoLog.txt" 2>>nul
sc config LanmanWorkstation start=disabled >>"%temp%\EchoLog.txt" 2>>nul
echo Security Tweaks

::Unneeded Files
del /s /f /q %SystemDrive%\windows\temp\* >nul 2>&1
del /s /f /q %SystemDrive%\windows\tmp\* >nul 2>&1
del /s /f /q %SystemDrive%\windows\history\* >nul 2>&1
del /s /f /q %SystemDrive%\windows\recent\* >nul 2>&1
del /s /f /q %SystemDrive%\windows\spool\printers\* >nul 2>&1
del /s /f /q %SystemDrive%\Windows\Prefetch\* >nul 2>&1
echo Cleaned Drive

::Prevent explorer from screaming
::taskkill /f /im explorer.exe >nul 2>&1
::start explorer.exe >nul 2>&1

rundll32 user32.dll,MessageBeep
call:EchoXLogo
for /f "delims=" %%i in (%temp%\EchoError.txt) do set "EchoError=%%i"
::if "%EchoError: =%" neq "BeginErrorLog" (
if "%ErrorWarning%" equ "Yes" (
echo %BS%         Optimizations Error
echo %BS%     There was a error while applying Echo...
echo.
echo.
echo %BS%    Press any key to restart and fully apply...
) else (
echo %BS%       Optimizations Finished
echo %BS%     Press any key to restart and fully apply...
echo.
echo.
echo.
)
pause >nul
cls
echo Restarting...
timeout 10
shutdown.exe /r /t 00

:AdvancedDebloat

::Matishzz
Reg add "HKLM\System\CurrentControlSet\Control\Class{4d36e96c-e325-11ce-bfc1-08002be10318}" /v "UpperFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class{6bdd1fc6-810f-11d0-bec7-08002be2092f}" /v "UpperFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class{ca3e7ab9-b4c3-4ae6-8251-579ef933890f}" /v "UpperFilters" /t Reg_MULTI_SZ /d "" /f >nul 2>&1

::Zusier Debloat Settings
::Services
Reg add "HKLM\System\CurrentControlSet\Services\AppIDSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppVClient" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppXSvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cbdhsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CryptSvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\defragsvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\diagnosticshub.standardcollector.service" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\diagsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DispBrokerDesktopSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DoSvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DPS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Eaphost" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\edgeupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\edgeupdatem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fdPHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FDResPub" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\icssvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IKEEXT" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\InstallService" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
::Causes issues with NVCleanstall and driver telemetry tweak
::Reg add "HKLM\System\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LanmanServer" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\lmhosts" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\QWAVE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RasMan" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SharedAccess" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SmsRouter" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Spooler" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\sppsvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SSDPSRV" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SstpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SysMain" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UsoSvc" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VaultSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WarpJITSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WdiServiceHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WdiSystemHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WSearch" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "3" /f >nul 2>&1
for /f %%I in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (Reg add "%%I" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1)
sc config CDPSvc start=disabled >nul 2>&1

::Drivers
Reg add "HKLM\System\CurrentControlSet\Services\3ware" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ADP80XX" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AmdK8" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\arcsas" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AsyncMac" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bindflt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\buttonconverter" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CAD" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cdfs" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CimFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cnghwassist" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CompositeBus" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Dfsc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ErrDev" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fdc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\flpydisk" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fvevol" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
::Reg add "HKLM\System\CurrentControlSet\Services\FileInfo" /v "Start" /t Reg_DWORD /d "4" /f < Breaks installing Store Apps to different disk. (Now disabled via store script) >nul 2>&1
::Reg add "HKLM\System\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f < Breaks installing Store Apps to different disk. (Now disabled via store script) >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\nvraid" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PEAUTH" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\sfloppy" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SiSRaid2" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SiSRaid4" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Telemetry" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\udfs" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\umbus" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VerifierExt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
::Reg add "HKLM\System\CurrentControlSet\Services\volmgrx" /v "Start" /t Reg_DWORD /d "4" /f < Breaks Dynamic Disks >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\vsmraid" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VSTXRAID" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wcifs" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wcnfs" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WindowsTrustedRTProxy" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1

::Remove dependencies
Reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t Reg_MULTI_SZ /d "NSI\0Afd" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t Reg_MULTI_SZ /d "nsi" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t Reg_MULTI_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t Reg_SZ /d "" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t Reg_SZ /d "" /f >nul 2>&1

::Disable unneeded Tasks Zusier
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Autochk\Proxy" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateBrowserReplacementTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Registry\RegIdleBackup" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Work" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdates" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\ScanForUpdatesAsUser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\PushToInstall\LoginCheck" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" >nul 2>nul
schtasks /Change /Disable /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" >nul 2>nul

::Hone Code lol
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config xbgm start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config XboxGipSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WaaSMedicSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config wuauserv start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config W32Time start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config spectrum start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config wcncsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WebClient start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config SysMain start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config NcaSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config wlidsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config SCardSvr start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config NgcCtnrSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config diagsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config UserDataSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config stisvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config AdobeFlashPlayerUpdateSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config TrkWks start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config dmwappushservice start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config PimIndexMaintenanceSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config DiagTrack start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config VaultSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config GoogleChromeElevationService start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config OneSyncSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config ibtsiva start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config SNMPTRAP start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config pla start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config ssh-agent start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config sshd start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config DoSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config tzautoupdate start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config CertPropSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config RemoteRegistry start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config RemoteAccess start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WbioSrvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config PcaSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config NetTcpPortSharing start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WerSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config gupdate start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config gupdatem start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config MSiSCSI start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WMPNetworkSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config CDPUserSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config WpnUserService_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config shpamsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config LanmanWorkstation start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config UnistoreSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config MapsBroker start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "sc config debugRegsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /d "00000002" /t Reg_DWORD /f >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /d "00000003" /t Reg_DWORD /f >nul 2>&1"

Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Visibility" /v "DiagnosticErrorText" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticErrorText" /t Reg_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticLinkText" /t Reg_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Biometrics" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "DoNotTrack" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "OptimizeWindowsSearchResultsForScreenReaders" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead" /v "FPEnabled" /t Reg_DWORD /d "0" /f  >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes" /v "ShowSearchSuggestionsGlobal" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy" /v "EnableEncryptedMediaExtensions" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1

::https://www.gaijin.at/en/infos/windows-version-numbers
for /f "tokens=4-10 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM Windows 1809, 1803, 1709 (in that order)
if "%version%" == "10.0.17763" (goto :18093)
if "%version%" == "10.0.17134" (goto :18093)
if "%version%" == "10.0.16299" (goto :18093)
goto :not18093
:18093
Reg add "HKLM\System\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f	 >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UsoSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TokenBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netlogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LxpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AUEPLauncher" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\swenum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpnService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpnUserService_f9bd" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tzautoupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LicenseManager" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ssh-agent" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\svsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wcncsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WebClient" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WlanSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CaptureService_f9bd" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppXSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ClipSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsmSv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FrameServer" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WManSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wlidsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EntAppSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpnUserService_177c6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SamSs" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RpcLocator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\QWAVE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netprofm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
:not18093
REM Windows 20H2
if "%version%" == "10.0.19042" (
Reg add "HKLM\System\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msssmbios" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WSearch" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\InstallService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\StorSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ALG" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\COMSysApp" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Everything" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppIDSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NcbService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NgcSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NgcCtnrSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fdpHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FDResPub" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Eaphost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DoSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\dot3svc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WiaRpc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\upnphostc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TabletImputService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SharedAccess" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PolicyAgent" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SensorSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\slisvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SENS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RasMan" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\XblAuthManager" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\XblGameSave" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Upnphost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VaultSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cbdhsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DiagTrack" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DPS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DusmSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wscsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TrikWks" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LanmanServer" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MapsBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Spooler" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SysMain" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AJRouter" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Autotimesvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\aXiNSTsv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bdesv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BTAGService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BTHSERV" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CertPropSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CscService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\defragsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DevicePickerUser" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceFlowUser" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\diagsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Fax" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fhsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\HvHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\icssvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IKEEXT" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IFSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LLTDSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\lmhost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msIscsi" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NcaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\p2pimsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\perceptionsimulation" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PhoneSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PNRPAutoReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PrintNotify" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PushToInstall" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RasAuto" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RetailDemo" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RmSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SCardSvr" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ScDeviceEnum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ScPolicySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SDRSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SecutityHealthService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\semGRsVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Sense" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SensorDataService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SensorService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SessionEnv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SharedRealitySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\smphost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SmsRouter" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\spectrum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SSDPSRV" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SstpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\stisvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tabletinputService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TapiSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TermService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UmRdpService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VacSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WalletService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WarpJITSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wbengine" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WbioSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wercplsupport" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WerSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinRM" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wisvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wlpasvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WMPNetworkSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\workfolderssvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpcMonSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WwanSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpnService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UsoSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TrkWks" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\sppsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SgrmBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\fontCache" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DispBrokerDektop" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CDPSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppXSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BDESVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WpnUserService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UserDataSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WManSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wlidsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WlanSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ErrDev" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\svsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SensrSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\netprofm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LxpSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\LicenseManager" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FrameServer" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TokenBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ClipSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CDPUserSvcc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
)
for /f "tokens=4-9 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM windows 8.1
if "%version%" == "6.3.9600" (
Reg add "HKLM\System\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f	 >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AelookupSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppHostSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AppSVc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\aspnet_state" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IEEtwCollectorService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MpsSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Msiserver" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MsKeyboardFilter" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netlogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\netprofm" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wudfsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W3SVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WebClient" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WcsPlugInService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wbengine" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WAS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\w3logsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\UI0Detect" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TimeBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\THREADORDER" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\svsc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\smphost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\RpcLocator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\QWAVE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\perfHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\sppsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t Reg_DWORD /d "0" /f >nul 2>&1
)
REM windows 7 7601
if "%version%" == "6.1.7601" (
Reg add "HKLM\System\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\eventlog" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\clr_optimization_v4.0.30319_32" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\clr_optimization_v4.0.30319_64" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Sppsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\aspnet_state" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\clr_optimization_v2.0.50727_32" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\clr_optimization_v2.0.50727_64" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AeLookupSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bthserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\defragsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\IPBusEnum" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NETPROFM" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\ProtectedStorage" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\sppuinotify" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\THREADORDER" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VaultSvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WcsPluginService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxysVC" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Wlansvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\wudfsvc" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t Reg_DWORD /d "0" /f >nul 2>&1
)

:: Restrict Windows' access to internet resources
:: Enables various other GPOs that limit access on specific windows services
Reg add "HKLM\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t Reg_DWORD /d "1" /f >nul
echo Restrict Windows' access to internet resources

:: Disable Text/Ink/Handwriting Telemetry
Reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t Reg_DWORD /d "1" /f >nul
echo Disable Text/Ink/Handwriting Telemetry

:: Disable Windows Error Reporting
Reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t Reg_DWORD /d "0" /f >nul
echo Disable Windows Error Reporting

:: Disable Data Collection
Reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t Reg_DWORD /d "0" /f >nul
echo Disable Data Collection + Telemetry

::Disable Smartscreen
Reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t Reg_DWORD /d "0" /f >nul 2>&1
%temp%\EchoNSudo.exe -U:C -P:E -Wait Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /t Reg_SZ /d ".avi;.bat;.cmd;.exe;.htm;.html;.lnk;.mpg;.mpeg;.mov;.mp3;.mp4;.mkv;.msi;.m3u;.rar;.Reg;.txt;.vbs;.wav;.zip;.7z" /f >nul 2>&1
echo Disable Smartscreen

echo Advanced Services
goto :FinishedDebloat

:EchoXLogo
cls
echo.
echo.
echo %BS%     ______ _____ ___ ___ _______    ___   ___
echo %BS%    ^|\   __\   ___\  \\  \\   _  \  ^|\  \ /  /^|
echo %BS%    \ \  \__\  \__^|\  \\  \\  \\  \ \ \  \  / /
echo %BS%     \ \   __\  \   \   _  \\  \\  \ \ \   / /
echo %BS%      \ \  \__\  \___\  \\  \\  \\  \ \/   \/
echo %BS%       \ \_____\______\  \\__\\______\/  \  \
echo %BS%        \^|_____^|______^|__^|^|__^|^|______/__/ \__\
echo %BS%                                     [__^|\^|__] v5.5
goto:eof

:GrabSettings
::Setup Settings
::PowerShell
set DualBoot=Unknown
set storageType=Unknown
set CPU_NAME=%PROCESSOR_IDENTIFIER%
set THREADS=%NUMBER_OF_PROCESSORS%
if exist "%SystemRoot%\System32\wbem\WMIC.exe" (
for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v CORES') do set CORES=%%a
for /f "tokens=*" %%a in ('Reg query "HKCU\Software\Echo" /v GPU_NAME') do set GPU_NAME=%%a
for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v mem') do set mem=%%a
for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v ChassisTypes') do set ChassisTypes=%%a
for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Degrees') do set Degrees=%%a
) >nul 2>&1
::Power
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v MaxPow') do set MaxPow=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Idle') do set Idle=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Throttling') do set Throttling=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v pstates') do set pstates=%%a) >nul 2>&1
::Advanced
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Debloat') do set Debloat=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v BCD') do set BCD=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Restore') do set Restore=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v KBoost') do set KBoost=%%a) >nul 2>&1
::Optional
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Res') do set Res=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v DSCP') do set DSCP=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v DisplayScaling') do set DisplayScaling=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Mouse') do set Mouse=%%a) >nul 2>&1
::Optional PG 2
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v staticip') do set staticip=%%a) >nul 2>&1
(for /f "tokens=3 skip=2" %%a in ('Reg query "HKCU\Software\Echo" /v Animations') do set Animations=%%a) >nul 2>&1
goto:eof
