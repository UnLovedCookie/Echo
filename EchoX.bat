::v4
::https://github.com/Xt5gamerxX/Echo/blob/main/LICENSE
@echo off
Mode 52,16
title Echo X
color fc

::Get Admin Rights
if exist "C:\Windows\system32\adminrightstest" (rmdir C:\Windows\system32\adminrightstest >nul 2>&1)
mkdir C:\Windows\system32\adminrightstest >nul 2>&1
if %errorlevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "%SystemDrive%\Windows\system32\cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

::Run CMD in 32-Bit
set "SystemPath=%SystemRoot%\System32"
if not "%ProgramFiles(x86)%"=="" (if exist %SystemRoot%\Sysnative\* set "SystemPath=%SystemRoot%\Sysnative")
if not %processor_architecture%==AMD64 (%SystemPath%\cmd.exe /c "%~s0" && exit /b)

::Choice Prompt Setup
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
set Inputln=/m "%BS%                        >:"%1

::Enable Delayed Expansion
setlocal EnableDelayedExpansion >nul 2>&1

::Check For Internet
Ping www.google.nl -n 1 -w 1000 >nul
if %errorlevel% neq 0 (
cls
echo.
echo.
echo %BS%               No Internet Connection
echo %BS%          connect or press any key to skip
echo.
call :logo
echo.
pause >nul
)

::Check For Requirements
if not exist "%windir%\system32\WindowsPowerShell\v1.0\powershell.exe" (
cls
echo.
echo.
echo %BS%               Missing PowerShell 1.0
echo %BS%          press any key to continue anyway
echo.
call :logo
echo.
pause >nul
)

::Nvidia Drivers
goto GraphicsFound
nvidia-smi >nul 2>&1
if %errorlevel% neq 0 goto GraphicsFound
nvidia-smi --query-gpu=driver_version --format=csv | findstr /c:"457.30" && cls && goto GraphicsFound
echo Recommended graphics driver not found:
echo.
echo [1] Install
echo [2] Skip
echo.
choice /c 12 /n /m ^>:
set choice=%errorlevel%
if not %choice%==1 (goto GraphicsFound)
cls & echo Downloading Nvidia Driver [...]
if exist "%temp%\457.30x64Desktop.exe" del "%temp%\457.30x64Desktop.exe"
Reg query "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DCHUVen" >nul 2>&1
if %ERRORLEVEL% EQU 0 (powershell "wget 'https://onedrive.live.com/download?cid=91FD8D99AB112B7E&resid=91FD8D99AB112B7E%%21108&authkey=AHcg0GQ-iB6_-AM' -OutFile '%temp%\457.30x64Desktop.exe'") else (powershell "wget 'https://onedrive.live.com/download?cid=91FD8D99AB112B7E&resid=91FD8D99AB112B7E%%21106&authkey=AOw9OffeXfkCw8w' -OutFile '%temp%\457.30x64Desktop.exe'")
cls & echo Installing Nvidia Driver [...]
"%temp%\457.30x64Desktop.exe"
if %errorlevel% neq 0 (cls & echo Failed to install Nvidia Drivers [...] & echo You'll have to manually install Nvidia Driver 457.30) else (cls & echo Installed Nvidia Drivers [...])
timeout 5 & cls
:GraphicsFound

:Home
::vcredist.exe /ai /passive

::start "Viox" /I cmd /c "@echo off & Mode 52,16 & color fc & echo hi & pause && call ^"%~s0^" && exit /b 0"
::exit /b 0

::PS Script Here to be quicker
::for /f "delims=" %%# in  ('"wmic path Win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution /format:value"') do (set "%%#">nul)
Reg add "HKCU\Software\Echo" /f >nul 2>&1
echo import-module Microsoft.PowerShell.Management > "%temp%\EchoSettings.ps1"
echo import-module Microsoft.PowerShell.Utility >> "%temp%\EchoSettings.ps1"
echo $GPU = (Get-WmiObject win32_VideoController ^| Select-Object -ExpandProperty Name ^| out-string) >> "%temp%\EchoSettings.ps1"
echo Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "GPU_NAME" -Type String -Value "$GPU" >> "%temp%\EchoSettings.ps1"
::echo $CORES = (Get-WmiObject win32_processor ^| Select-Object -ExpandProperty NumberOfCores ^| out-string) >> "%temp%\EchoSettings.ps1"
::echo Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "CORES" -Type String -Value "$CORES" >> "%temp%\EchoSettings.ps1"
echo $mem = (Get-WmiObject win32_operatingsystem ^| Select-Object -ExpandProperty TotalVisibleMemorySize ^| out-string) >> "%temp%\EchoSettings.ps1"
echo Set-ItemProperty -Path "HKCU:\Software\Echo" -Name "mem" -Type String -Value "$mem" >> "%temp%\EchoSettings.ps1"
start /b powershell -ExecutionPolicy Unrestricted -NoProfile -File "%temp%\EchoSettings.ps1"

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
echo %BS%                                     [__^|\^|__] v4
echo          [91m[[94m1[91m] Optimize  [[94m2[91m] Undo
echo                 [[94m3[91m] Settings  [[94m4[91m] Credits
echo.
choice /c:3421 /n /m "%BS%                                   >:"
set MenuItem=%errorlevel%

if "%MenuItem%"=="5" (
taskkill /im "cmd.exe" 
)

if "%MenuItem%"=="3" (
cls
echo Reverting Changes
echo.
echo Close the program to cancel
timeout 10
Regedit.exe /s "%SystemDrive%\Regbackup.Reg"
bcdedit.exe /import "%SystemDrive%\bcdedit.bcd"
if not exist "%temp%\Default.nip" (
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/881683546891235398/Default.nip -OutFile "%temp%\Default.nip") else (
bitsadmin /transfer "DefaultNIP" https://cdn.discordapp.com/attachments/798190447117074473/881683546891235398/Default.nip "%temp%\Default.nip"))
taskkill /IM "EchoNvidia.exe"
start /b %temp%\EchoNvidia.exe "%temp%\Default.nip"
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
echo Credits              Vuk - Tweak
pause
cls
goto :Home
)

if not "%MenuItem%"=="1" (goto :notSettings)
set SettingsPage=1
set onoff=undefined

:Settings
cls
set SettingsItem=

::Get Setting Keys
::Power
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle ^|findstr /ri "Reg_DWORD"') do set Idle=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling ^|findstr /ri "Reg_DWORD"') do set Throttling=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v PromoteDemote ^|findstr /ri "Reg_DWORD"') do set PromoteDemote=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v IncreaseDecrease ^|findstr /ri "Reg_DWORD"') do set IncreaseDecrease=%%a) >nul 2>&1

::Advanced
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat ^|findstr /ri "Reg_DWORD"') do set Debloat=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD ^|findstr /ri "Reg_DWORD"') do set BCD=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost ^|findstr /ri "Reg_DWORD"') do set KBoost=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore ^|findstr /ri "Reg_DWORD"') do set Restore=%%a) >nul 2>&1

::Optional
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res ^|findstr /ri "Reg_DWORD"') do set Res=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP ^|findstr /ri "Reg_DWORD"') do set DSCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v NVCP ^|findstr /ri "Reg_DWORD"') do set NVCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse ^|findstr /ri "Reg_DWORD"') do set Mouse=%%a) >nul 2>&1

::Warning
::(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Warning ^|findstr /ri "Reg_DWORD"') do set Warning=%%a) >nul 2>&1
::if not "%Warning%"=="0x1" (
::echo THESE SETTINGS ARE VERY DANGEROUS
::echo It's recommened to leave them all OFF
::pause & cls
::Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Warning /t Reg_DWORD /d "1" /f >nul
::)

if "%SettingsPage%"=="1" (
echo                     POWER PLAN
echo.
if "%PromoteDemote%"=="0x1" (set onoff=60/30) else (set onoff=100/100)
echo [[94m1[91m] Promote/Demote Threshold [32m!onoff![91m
echo 100/100 for performance, 60/30 for cooling
echo.
if "%Throttling%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m2[91m] Power-Throttling [32m!onoff![91m
echo Turn this on if your on a laptop
echo.
if "%Idle%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m3[91m] Disable Idle [32m!onoff![91m
echo Can generate more heat but has more stable FPS
echo.
if "%IncreaseDecrease%"=="0x1" (set onoff=60/30) else (set onoff=0/0)
echo [[94m4[91m] Increase/Decrease Threshold [32m!onoff![91m
echo 0/0 for performance, 60/30 for cooling
echo.
choice /c:1234NB /n /m "%BS%                [N] Next   [B] Back"
set SettingsItem=!errorlevel!
if "!SettingsItem!"=="5" (set SettingsPage=2)
cls
)

if "%SettingsItem%"=="1" if "%PromoteDemote%"=="0x1" (%Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v PromoteDemote /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v PromoteDemote /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="2" if "%Throttling%"=="0x1" (%Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="3" if "%Idle%"=="0x1" (%Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="4" if "%IncreaseDecrease%"=="0x1" (%Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v IncreaseDecrease /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v IncreaseDecrease /t Reg_DWORD /d "1" /f >nul)
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

if "%SettingsItem%"=="1" if "%Debloat%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="2" if "%BCD%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="3" if "%KBoost%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="4" if "%Restore%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

if %SettingsPage%==3 (
echo                       OPTIONAL
echo.
if "%NVCP%"=="0x1" (set onoff=on) else (set onoff=off)
echo [[94m1[91m] Disable NVCP [32m!onoff![91m
echo Turn this on to enable vsync
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
if "!SettingsItem!"=="5" (set SettingsPage=1)
cls
)

if "%SettingsItem%"=="1" if "%NVCP%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v NVCP /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v NVCP /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="2" if "%Res%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="3" if "%Mouse%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="4" if "%DSCP%"=="0x1" (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP /t Reg_DWORD /d "0" /f >nul) else (Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP /t Reg_DWORD /d "1" /f >nul)
if "%SettingsItem%"=="5" (goto Settings)
if "%SettingsItem%"=="6" (goto Home)
set SettingsItem=

goto :Settings
:notSettings

if not exist "%temp%\EchoProfile.nip" (if not "%NVCP%"=="0x1" (
echo Downloading Nvidia Nip [...]
if exist "%appdata%\.minecraft\options.txt" (set DL=https://cdn.discordapp.com/attachments/798190447117074473/880931795632271390/Minecraft.nip) else (set DL=https://cdn.discordapp.com/attachments/798190447117074473/891526556692938774/EchoProfile.nip)
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoProfile.nip") else (bitsadmin /transfer "" !DL! "%temp%\EchoProfile.nip")
))

if not exist "%temp%\EchoNvidia.exe" (if not "%NVCP%"=="0x1" (
echo Downloading Nvidia Inspector [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143545083461672/EchoProfile.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoNvidia.exe") else (bitsadmin /transfer "" !DL! "%temp%\EchoNvidia.exe")
))

if not exist "%SystemDrive%\EchoRes.exe" (if "%Res%"=="0x1" (
echo Downloading Timer Resolution [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143531414749195/EchoRes.exe
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%SystemDrive%\EchoRes.exe") else (bitsadmin /transfer "" !DL! "%SystemDrive%\EchoRes.exe")
))

if not exist "%temp%\EchoPow.pow" (
echo Downloading Power Plan [...]
set DL=https://cdn.discordapp.com/attachments/798190447117074473/912233308258189332/EchoPow.pow
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (powershell wget !DL! -OutFile "%temp%\EchoPow.pow") else (bitsadmin /transfer "" !DL! "%temp%\EchoPow.pow")
)

set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143551979028480/EchoDevice.exe
if not exist "%temp%\EchoDevice.exe" (
echo Downloading Device Cleanup [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" ( powershell wget %DL% -OutFile "%temp%\EchoDevice.exe" ) else (bitsadmin /transfer "" %DL% "%temp%\EchoDevice.exe") >nul 2>&1
)

set DL=https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe
if not exist "%temp%\EchoNSudo.exe" (
echo Downloading NSudo [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" ( powershell wget %DL% -OutFile "%temp%\EchoNSudo.exe" ) else (bitsadmin /transfer "" %DL% "%temp%\EchoNSudo.exe") >nul 2>&1
)

set DL=https://cdn.discordapp.com/attachments/798190447117074473/910780105842884638/EchoView.exe
if not exist "%temp%\EchoView.exe" (
echo Downloading DevManView [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" ( powershell wget %DL% -OutFile "%temp%\EchoView.exe" ) else (bitsadmin /transfer "" %DL% "%temp%\EchoView.exe") >nul 2>&1
)

if not exist "%windir%\System32\gpedit.msc" (echo Installing gpedit.msc [...]
cd %temp%
if exist "List.txt" (del "List.txt" >nul 2>&1)
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt 
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt 
>nul 2>&1 (for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i")
if exist "List.txt" (del "List.txt" >nul 2>&1)
)

::Setup Nsudo
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "3" /f"
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "sc start "TrustedInstaller""

::Setup Settings
::PowerShell
set CPU_NAME=%PROCESSOR_IDENTIFIER%
set THREADS=%NUMBER_OF_PROCESSORS%
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v CORES ^|findstr /ri "REG_SZ"') do set CORES=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v GPU_NAME ^|findstr /ri "REG_SZ"') do set GPU_NAME=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v mem ^|findstr /ri "REG_SZ"') do set mem=%%a) >nul 2>&1

::Power
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle ^|findstr /ri "Reg_DWORD"') do set Idle=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Throttling ^|findstr /ri "Reg_DWORD"') do set Throttling=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v PromoteDemote ^|findstr /ri "Reg_DWORD"') do set PromoteDemote=%%a) >nul 2>&1

::Advanced
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat ^|findstr /ri "Reg_DWORD"') do set Debloat=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD ^|findstr /ri "Reg_DWORD"') do set BCD=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost ^|findstr /ri "Reg_DWORD"') do set KBoost=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore ^|findstr /ri "Reg_DWORD"') do set Restore=%%a) >nul 2>&1

::Optional
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res ^|findstr /ri "Reg_DWORD"') do set Res=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP ^|findstr /ri "Reg_DWORD"') do set DSCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v NVCP ^|findstr /ri "Reg_DWORD"') do set NVCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse ^|findstr /ri "Reg_DWORD"') do set Mouse=%%a) >nul 2>&1

::Registry Backup
if not exist "%SystemDrive%\Regbackup.Reg" (cls
echo Creating Registry Backup [...]
Regedit /e "%SystemDrive%\Regbackup.Reg" >nul 2>&1
)

::BCD Backup
if not exist "%SystemDrive%\bcdbackup.bcd" (cls
echo Creating BCD Backup [...]
bcdedit /export "%SystemDrive%\bcdbackup.bcd" >nul 2>&1
)

::Restore Point
if not "%Restore%"=="0x1" (cls
echo Creating System Restore Point [...] & echo.
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t Reg_DWORD /d 0 /f >nul
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Echo Optimization' -RestorePointType 'MODIFY_SETTINGS'"
)

::Fix System Files
::sfc /scannow
::Dism /Online /Cleanup-Image /RestoreHealth

::Optimize Drives
::defrag /C /O

::Microcode Mitigation
goto skipMicrocodeMitigation
if not exist "%SystemDrive%\Windows\System32\mcupdate_AuthenticAMD.dll.old" (
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "ren %SystemDrive%\Windows\System32\mcupdate_AuthenticAMD.dll mcupdate_AuthenticAMD.dll.old"
)
if not exist "%SystemDrive%\Windows\System32\mcupdate_GenuineIntel.dll.old" (
%temp%\EchoNSudo.exe -U:T -P:E -ShowWindowMode:Hide cmd /c "ren %SystemDrive%\Windows\System32\mcupdate_GenuineIntel.dll mcupdate_GenuineIntel.dll.old"
)
echo Microcode Mitigation
:skipMicrocodeMitigation

::Disable Process Mitigations
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
>nul (echo powershell Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess) > "%temp%\ProcessMitigation.ps1"
(start /b powershell.exe -ExecutionPolicy Unrestricted -File "%temp%\ProcessMitigation.ps1") >nul 2>&1
::powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue") >nul 2>&1
echo Disabled Process Mitigations
)

::https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
Reg add "HKLM\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t Reg_DWORD /d "1" /f >nul 2>nul

::Disable SEHOP
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable SEHOP

::Disable ASLR
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable ASLR

::Disable Spectre And Meltdown
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t Reg_DWORD /d "3" /f >nul 2>&1
echo Disabled Spectre And Meltdown

::Disable CFG Lock
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable CFG Lock

:: Disable NTFS/ReFS and FS Mitigations
Reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable NTFS/ReFS and FS Mitigations

::Disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t Reg_DWORD /d "1" /f >nul 2>&1

::Use Large System Cache to improve microstuttering
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t Reg_DWORD /d "1" /f >nul 2>&1

::Reliable Timestamp
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t Reg_DWORD /d "3" /f >nul 2>&1
echo Timestamp Interval

::Enable Hardware Accelerated Scheduling
Reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t Reg_DWORD /d "2" /f >nul 2>&1
echo Enable Hardware Accelerated Scheduling

::Xbox GameBar/FSE
Reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t Reg_DWORD /d "3" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg delete "HKCU\System\GameConfigStore\Children" /f >nul 2>&1
Reg delete "HKCU\System\GameConfigStore\Parents" /f >nul 2>&1
echo Disable FSO

::Monitor Latency
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Monitor Latency

::System responsiveness + Network throttling
::https:nit//cdn.discordapp.com/attachments/890128142075850803/890135598566895666/unknown.png
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t Reg_DWORD /d "10" /f >nul
::PanTeR Said to use 14
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t Reg_DWORD /d "14" /f >nul
echo System Responsivness

::Wallpaper quality 100%
Reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t Reg_DWORD /d "100" /f >nul
echo Wallpaper Quality

::Speedup Startup
Reg add "HKEY_CURRENT_USER\AppEvents\Schemes" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Fastboot

::Background Apps
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t Reg_DWORD /d "2" /f >nul
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f"
%temp%\EchoNSudo.exe -U:S -ShowWindowMode:Hide cmd /c "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t Reg_DWORD /d "0" /f"
echo Disable Background Apps

::Storage Optimizations
if not exist "%windir%\System32\fsutil.exe" (goto skipfsutil)

::Raise the limit of paged pool memory
fstuil set memory query usage 2 >nul 2>&1
::https://www.serverbrain.org/solutions-2003/the-mft-zone-can-be-optimized.html
fsutil behavior set mftzone 2 >nul 2>&1
echo Memory Optimizations

::HDD + SSD
fsutil behavior set disabledeletenotify 0 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
::https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security/
fsutil behavior set disable8dot3 1 >nul 2>&1
::Disable NTFS compression
fsutil behavior set disablecompression 1 >nul 2>&1
::Disable Last Access information on directories, performance/privacy
::Old CMD, for /f "tokens=* skip=1" %%n in ('powershell get-physicaldisk ^| findstr "."') do set storageType=%%n
set storageType=%storageType: =%
if not "%storageType:SSD=%"=="%storageType%" (fsutil behavior set disableLastAccess 0 >nul 2>&1)
if not "%storageType:HDD=%"=="%storageType%" (fsutil behavior set disableLastAccess 1 >nul 2>&1)
echo HDD + SSD Optimizations

:skipfsutil

::Optimize NTFS
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t Reg_DWORD /d "1" /f >nul 2>&1
echo NTFS Optimizations

::Disk Optimizations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "StartedComponents" /t Reg_DWORD /d "513347" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminDisable" /t Reg_DWORD /d "8704" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disk Optimizations

::Disable Prefetch
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable Prefetch

::Disable Startup Apps
del /f /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\*.*" >nul 2>&1
echo Disable Start Up Programs

::Disable FTH
Reg delete "HKLM\SOFTWARE\Microsoft\FTH\State" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable FTH

::Power Plan
powercfg -delete 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg -import "%temp%\EchoPow.pow" 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg /setactive 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg /changename scheme_current "Echo" "For EchoX Optimizer (dsc.gg/EchoX) By UnLovedCookie & yungkkj"
echo Power Plan

::Device Idle Policy Power Savings
powercfg -setacvalueindex scheme_current sub_none 4faab71a-92e5-4726-b531-224559672d19 1 >nul 2>&1

::Device Idle Policy Performance
powercfg -setacvalueindex scheme_current sub_none 4faab71a-92e5-4726-b531-224559672d19 0 >nul 2>&1

if "%Idle%"=="0x1" (
::Disable Idle
powercfg /setacvalueindex scheme_current 5d76a2ca-e8c0-402f-a133-2158492d58ad 1 >nul 2>&1
echo Disable Idle
) else (
::Enable Idle
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0 >nul 2>&1
echo Enable Idle
)

if "%Throttling%"=="0x1" (
::Enable Power Throttling
Reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f >nul 2>&1
Reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /f >nul 2>&1
echo Enable Power Throttling
) else (
::Disable Power Throttling
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t Reg_DWORD /d "1" /f >nul 2>&1
echo Disable Power Throttling
)

if "%PromoteDemote%"=="0x1" (
::60/30 Promote Demote
powercfg -setacvalueindex scheme_current sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 60 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor 4b92d758-5a24-4851-a470-815d78aee119 30 >nul 2>&1
echo 60/30 Promote Demote
) else (
::100/100 Promote Demote
powercfg -setacvalueindex scheme_current sub_processor 7b224883-b3cc-4d79-819f-8374152cbe7c 100 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor 4b92d758-5a24-4851-a470-815d78aee119 100 >nul 2>&1
echo 100/100 Promote Demote
)

if "%IncreaseDecrease%"=="0x1" (
::60/30 Increase Decrease
powercfg -setacvalueindex scheme_current sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 60 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 30 >nul 2>&1
echo 60/30 Increase Decrease
) else (
::0/0 Increase Decrease
powercfg -setacvalueindex scheme_current sub_processor 06cadf0e-64ed-448a-8927-ce7bf90eb35d 0 >nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 0 >nul 2>&1
echo 0/0 Increase Decrease
)

::Apply
powercfg -setactive scheme_current >nul 2>&1

::MMCSS
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t Reg_DWORD /d "1" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t Reg_DWORD /d "10000" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t Reg_DWORD /d "0" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t Reg_SZ /d "False" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t Reg_DWORD /d "10000" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t Reg_DWORD /d "18" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t Reg_DWORD /d "6" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t Reg_SZ /d "High" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t Reg_SZ /d "High" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t Reg_SZ /d "True" /fe >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t Reg_DWORD /d "1" /fe >nul 2>&1
echo MMCCSS

::Latency
if not "%Priority%"=="0x1" goto :skipGPUPriority
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t Reg_SZ /d "True" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t Reg_DWORD /d "24" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t Reg_DWORD /d "10000" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t Reg_DWORD /d "18" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t Reg_DWORD /d "8" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t Reg_SZ /d "High" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t Reg_SZ /d "High" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t Reg_SZ /d "True" /f >nul 2>&1
:skipGPUPriority

::https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosTimerResolution
Reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Qos TimerResolution

::Timer Resolution
if "%Res%"=="0x1" (
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
(%SystemDrive%\EchoRes.exe -install) >nul 2>&1
sc start STR >nul 2>&1
echo Timer Resolution
) else (
::Disable HPET
::pnputil /disable-device "ACPI\VEN_PNP&DEV_0103" >nul 2>&1
("%temp%\EchoView.exe" /disable "High Precision Event Timer") >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformclock false >nul 2>&1
bcdedit /set disabledynamictick true >nul 2>&1
echo Disable HPET
)

::Disable Devices
goto :skipDisableDevices
(%temp%\devmanview.exe /disable "System Speaker") >nul 2>&1
(%temp%\devmanview.exe /disable "System Timer") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (IKEv2)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (IP)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (IPv6)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (L2TP)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (Network Monitor)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (PPPOE)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (PPTP)") >nul 2>&1
(%temp%\devmanview.exe /disable "WAN Miniport (SSTP)") >nul 2>&1
(%temp%\devmanview.exe /disable "UMBus Root Bus Enumerator") >nul 2>&1
(%temp%\devmanview.exe /disable "Microsoft System Management BIOS Driver") >nul 2>&1
(%temp%\devmanview.exe /disable "Programmable Interrupt Controller") >nul 2>&1
(%temp%\devmanview.exe /disable "PCI Encryption/Decryption Controller") >nul 2>&1
(%temp%\devmanview.exe /disable "AMD PSP") >nul 2>&1
(%temp%\devmanview.exe /disable "Intel SMBus") >nul 2>&1
(%temp%\devmanview.exe /disable "Intel Management Engine") >nul 2>&1
(%temp%\devmanview.exe /disable "PCI Memory Controller") >nul 2>&1
(%temp%\devmanview.exe /disable "PCI standard RAM Controller") >nul 2>&1
(%temp%\devmanview.exe /disable "Composite Bus Enumerator") >nul 2>&1
(%temp%\devmanview.exe /disable "Microsoft Kernel Debug Network Adapter") >nul 2>&1
(%temp%\devmanview.exe /disable "SM Bus Controller") >nul 2>&1
(%temp%\devmanview.exe /disable "NDIS Virtual Network Adapter Enumerator") >nul 2>&1
::(%temp%\devmanview.exe /disable "Microsoft Virtual Drive Enumerator") >nul 2>&1 < Breaks ISO mounts
(%temp%\devmanview.exe /disable "Numeric Data Processor") >nul 2>&1
(%temp%\devmanview.exe /disable "Microsoft RRAS Root Enumerator") >nul 2>&1
echo Disable Devices
:skipDisableDevices

::Device Cleanup
%temp%\EchoDevice * -s >nul 2>&1
echo Clean Devices

::GPU AMD + Nvidia Settings
set GPU_NAME=%GPU_NAME: =%
if not "%GPU_NAME:GeForce=%" == "%GPU_NAME%" goto :NVIDIA
if not "%GPU_NAME:NVIDIA=%" == "%GPU_NAME%" goto :NVIDIA
if not "%GPU_NAME:RTX=%" == "%GPU_NAME%" goto :NVIDIA
if not "%GPU_NAME:GTX=%" == "%GPU_NAME%" goto :NVIDIA
if not "%GPU_NAME:AMD=%" == "%GPU_NAME%" goto :AMD
if not "%GPU_NAME:Ryzen=%" == "%GPU_NAME%" goto :AMD
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
REM ; amd software
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
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t Reg_SZ /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_OPTION" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t Reg_BINARY /d "3100" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t Reg_BINARY /d "3000" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t Reg_BINARY /d "3200" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t Reg_BINARY /d "0100000001000000" /f >nul 2>&1
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
Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t Reg_DWORD /d "1" /f >nul
Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t Reg_DWORD /d "1" /f >nul
Echo Enable Gamemode

::Unrestricted Clocks
nvidia-smi -acp 0 >nul 2>&1
if %errorlevel% neq 0 ("C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe" -acp 0 >nul 2>&1)
if %errorlevel% equ 0 (echo Unrestricted Clocks)

::OC Scanner Fix, cuz why not?
if not exist "C:\Program Files\NVIDIA Corporation\NVSMI" mkdir "C:\Program Files\NVIDIA Corporation\NVSMI" >nul 2>&1
copy /Y "%windir%\system32\nvml.dll" "C:\Program Files\NVIDIA Corporation\NVSMI\nvml.dll" >nul 2>&1
echo OC Scanner Fix

::Nvidia Reg
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableTiledDisplay" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t Reg_DWORD /d "1" /f >nul 2>&1
echo Nvidia Reg

::Disable Preemption
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable Preemption

::kboost
if "%KBoost%"=="0x1" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f >nul
echo KBoost
)

::NVCP
if not "%NVCP%"=="0x1" (
taskkill /IM "EchoNvidia.exe" /F >nul 2>&1
start /b %temp%\EchoNvidia.exe "%temp%\EchoProfile.nip" >nul 2>&1
echo NVCP Settings
)

:gpuUndefined

::Disable Hibernation
powercfg -h off >nul 2>&1
echo Disable Hibernation

::RAM
:: Disable Memory Compression
::powershell -Command "Disable-MMAgent -mc"
::Disable Paging Combining
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t Reg_DWORD /d "1" /f >nul
echo Disable Paging Combining
:: Set SvcSplitThreshold
:: Credits: revision
set /a ram=%mem% + 1024000
Reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t Reg_DWORD /d "%ram%" /f >nul 2>&1
echo SvcSplitThreshold

::Disable DmaRemapping
::https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%i in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	Reg add "%%i" /v "DmaRemappingCompatible" /t Reg_DWORD /d "0" /f >nul 2>&1
)
echo Disable DmaRemapping

::Set Win32PrioritySeparation 26 hex/38 dec
Reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t Reg_DWORD /d "38" /f >nul 2>&1
echo Win32PrioritySeparation

::100% Scaling and Mouse Acc
if not "%Mouse%"=="0x1" (goto :noMouse)
Reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t Reg_SZ /d "10" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t Reg_SZ /d "0" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t Reg_SZ /d "0" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t Reg_SZ /d "0" /f >nul
echo Mouse Acc
::Missing
echo Windows Scaling
:noMouse

::DataQueueSize
FOR /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize`) DO (set KeyboardSize=%%A)
if %KeyboardSize:~2,10% gtr 50 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t Reg_DWORD /d "50" /f >nul 2>&1)
For /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize`) DO (set MouseSize=%%A)
if %KeyboardSize:~2,10% gtr 50 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t Reg_DWORD /d "50" /f >nul 2>&1)
echo DataQueueSize

::CSRSS priority
::csrss is responsible for mouse input, setting to high may yield an improvement in input latency.
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationAuditOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t Reg_DWORD /d "4" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t Reg_DWORD /d "3" /f >nul
echo CSRSS priority

if not exist "%windir%\system32\wbem\WMIC.exe" (goto :skipMSIandAffinites)
::DEL GPU + USB + NET + Sata controllers Device Priority
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg delete "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
(for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f) >nul 2>nul
echo Delete Device Priority

::Enable MSI Mode on GPU if supported
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
Reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" >nul 2>&1
if %ERRORLEVEL% EQU 0 (Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1)
)
echo GPU MSI Mode

::Enable MSI Mode on USB, NET, Sata controllers
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul 2>&1
(for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f) >nul 2>&1
echo CPU + NET MSI Mode

::GPU + NET Affinites
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f >nul 2>nul
for /f %%i in ('wmic path win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t Reg_DWORD /d "5" /f >nul 2>nul
echo GPU + NET Affinites

::Remove GPU Limits
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f >nul 2>&1
echo Remove GPU Limits

:: If e.g. vmware is used, skip setting to undefined.
wmic computersystem get manufacturer /format:value| findstr /i /C:VMWare&&goto vmGO
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
goto noVM
:vmGO
:: Set to Normal Priority
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do Reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t Reg_DWORD /d "2"  /f
:noVM
:skipMSIandAffinites

::BCDEdit
::Better Input
bcdedit /set tscsyncpolicy legacy >nul 2>&1
if not "%BCD%"=="0x1" (goto :NoBCD)
::SHOKE Tweaker Settings
::bcdedit /timeout 0 >nul 2>&1
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1
bcdedit /set uselegacyapicmode yes >nul 2>&1

::Matishzz bcdedit
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set tpmbootentropy ForceDisable >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1

::Windows 8 Boot Stuff
for /f "tokens=4-9 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM windows 8.1
if "%version%" == "6.3.9600" (
bcdedit /set {globalsettings} custom:16000067 true >nul 2>&1
bcdedit /set {globalsettings} custom:16000069 true >nul 2>&1
bcdedit /set {globalsettings} custom:16000068 true >nul 2>&1
)

::Linear Address 57
bcdedit /set linearaddress57 OptOut >nul 2>&1
bcdedit /set increaseuserva 268435328 >nul 2>&1

::Disable some of the kernel memory mitigations
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1

::Disable DMA memory protection and cores isolation
bcdedit /set vsmlaunchtype Off >nul 2>&1
bcdedit /set vm No >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t Reg_DWORD /d "0" /f >nul 2>&1

::Enable X2Apic and enable Memory Mapping for PCI-E devices
bcdedit /set x2apicpolicy Enable >nul 2>&1
bcdedit /set configaccesspolicy Default >nul 2>&1
bcdedit /set MSI Default >nul 2>&1
bcdedit /set usephysicaldestination No >nul 2>&1
bcdedit /set usefirmwarepcisettings No >nul 2>&1

>nul 2>&1 find "AMD" %CPU_NAME% && (
bcdedit /set nx optout >nul 2>&1
echo Optimized AMD CPU
) else (
bcdedit /set nx alwaysoff >nul 2>&1
echo Optimized Intel CPU
)

echo BCDEdit
:NoBCD

::Discord


::OBS
if not exist "%appdata%\obs-studio" goto :skipOBS

::Run as admin
Reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\obs-studio\bin\64bit\obs64.exe" /t Reg_SZ /d "~ RUNASADMIN" /f >nul

set GPU_NAME=%GPU_NAME: =%
if not "%GPU_NAME:AMD=%" == "%GPU_NAME%" goto :skipOBS
if not "%GPU_NAME:Ryzen=%" == "%GPU_NAME%" goto :skipOBS
for /f "delims=" %%# in  ('"wmic path Win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution /format:value"') do (set "%%#">nul)
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
goto :skipOBSApply
cd %appdata%\obs-studio
ren "global.ini" "global.ini.old" >nul 2>&1
>"global.ini" (
  for /f "usebackq delims=" %%A in ("global.ini.old") do (
    if "%%A" equ "Profile=Untitled" (echo Profile=Couleur) else if "%%A" neq "ProfileDir=Untitled" (echo %%A)
	if "%%A" equ "ProfileDir=Untitled" (echo ProfileDir=Couleur) else if "%%A" neq "Profile=Untitled" (echo %%A)
  )
)
:skipOBSApply
echo OBS Settings
:skipOBS

::Minecraft
if exist "%appdata%\.minecraft\" (

::High Priority
if "%Priority%"=="0x1" (
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v "CpuPriorityClass" /t Reg_DWORD /d "3" /f >nul 2>&1
echo Minecraft Game Priority
)

cd %appdata%\.minecraft\
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

::Small Network Priorities
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t Reg_DWORD /d "4" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t Reg_DWORD /d "5" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t Reg_DWORD /d "6" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t Reg_DWORD /d "7" /f >nul
echo Network Priorities

::Remove OneDrive Sync
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t Reg_DWORD /d "1" /f >nul
echo Remove OneDrive Sync

::Disable Delivery Optimization
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t Reg_DWORD /d "0" /f >nul
echo Disable Delivery Optimization

::Disable limiting bandwith
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosNonBestEffortLimit
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >nul
echo Remove Limiting Bandwidth

::Configure NIT
goto skipNIT
for /f %%a in ('Reg query HKLM /v "*WakeOnMagicPacket" /s ^| findstr  "HKEY"') do (
for /f %%i in ('Reg query "%%a" /v "GigaLite" ^| findstr "HKEY"') do (Reg add "%%i" /v "GigaLite" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (Reg add "%%i" /v "*EEE" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "*FlowControl" ^| findstr "HKEY"') do (Reg add "%%i" /v "*FlowControl" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "PowerSavingMode" ^| findstr "HKEY"') do (Reg add "%%i" /v "PowerSavingMode" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableSavePowerNow" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableSavePowerNow" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnablePowerManagement" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnablePowerManagement" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableGreenEthernet" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableGreenEthernet" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableDynamicPowerGating" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableDynamicPowerGating" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnableConnectedPowerGating" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnableConnectedPowerGating" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AutoPowerSaveModeEnabled" ^| findstr "HKEY"') do (Reg add "%%i" /v "AutoPowerSaveModeEnabled" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AutoDisableGigabit" ^| findstr "HKEY"') do (Reg add "%%i" /v "AutoDisableGigabit" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "AdvancedEEE" ^| findstr "HKEY"') do (Reg add "%%i" /v "AdvancedEEE" /t Reg_DWORD /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "ULPMode" ^| findstr "HKEY"') do (Reg add "%%i" /v "ULPMode" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "ReduceSpeedOnPowerDown" ^| findstr "HKEY"') do (Reg add "%%i" /v "ReduceSpeedOnPowerDown" /t Reg_SZ /d "0" /f)
for /f %%i in ('Reg query "%%a" /v "EnablePME" ^| findstr "HKEY"') do (Reg add "%%i" /v "EnablePME" /t Reg_SZ /d "0" /f)
) >nul 2>nul
echo Configured NIT
:skipNIT

::Disable Network Power Saving
for /f %%r in ('Reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /f "PCI\VEN_" /d /s^|Findstr HKEY_') do (
Reg add %%r /v "AutoDisableGigabit" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "EnableGreenEthernet" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "GigaLite" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "PowerSavingMode" /t Reg_SZ /d "0" /f >nul
)
echo Disable Network Power Saving

::Reset
::netsh winsock reset >nul 2>&1
::ipconfig /renew >nul 2>&1
::ipconfig /release >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo Reset Internet

::Netsh
netsh int tcp set global initialRto=2000 >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=disabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global MaxSynRetransmissions=2 >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
for /f "tokens=1" %%i in ('netsh int ip show interfaces ^| findstr [0-9]') do (
	netsh int ip set interface %%i routerdiscovery=disabled store=persistent
) >nul 2>&1
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
for /f "tokens=3*" %%s in ('Reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s^|findstr /i /l "ServiceName"') do (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "MTU" /t Reg_DWORD /d "%MTU%" /f >nul)
goto :finishMTU
)
set output=bad
set /a MTU=%MTU%-10
goto :findMTU
)
:finishMTU

:: Disable Nagle's Algorithm
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f "tokens=3*" %%s in ('Reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s^|findstr /i /l "ServiceName"') do (
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched\Parameters\Adapters\%%s" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "DeadGWDetectDefault" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "PerformRouterDiscovery" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpInitialRTT" /t Reg_DWORD /d "0" /f >nul
 	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f  >nul
	)
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

::Taskbar Fix
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t Reg_DWORD /d "2" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t Reg_DWORD /d "2" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ctfmon" /t Reg_SZ /d "%SystemDrive%\Windows\System32\ctfmon.exe" /f >nul
echo Taskbar Fix

::Security Tweaks 
::PATCH V-220930 (From Zeta)
Reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f >nul 2>&1
::PATCH V-220929 (From Zeta)
Reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f >nul 2>&1
::Disable NetBIOS, can be exploited and is highly vulnerable. (From Zeta)
sc stop lmhosts >nul
sc config lmhosts start=disabled >nul .
:: Disable LanmanWorkstation, needed for SMB. Just trying to patch vulnerable services & Kill Security Holes. (From Zeta)
:: https://cyware.com/news/what-is-smb-vulnerability-and-how-it-was-exploited-to-launch-the-wannacry-ransomware-attack-c5a97c48
sc stop LanmanWorkstation >nul
sc config LanmanWorkstation start=disabled >nul
echo Security Tweaks

::Unneeded Files
del /s /f /q %SystemDrive%\windows\temp\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\tmp\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\history\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\recent\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\spool\printers\*.* >nul 2>&1
del /s /f /q %SystemDrive%\Windows\Prefetch\*.* >nul 2>&1
echo Cleaned Drive

::Prevent explorer from screaming
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe >nul 2>&1

rundll32 user32.dll,MessageBeep
echo.
echo.
call :Logo
echo %BS%       Optimizations Finished
echo %BS%     Press any key to restart and fully apply...
echo.
echo.
echo.
pause >nul
cls
echo Restarting...
timeout 10
shutdown.exe /r /t 00
taskkill /im "cmd.exe"

:AdvancedDebloat

::MS Account Checker by Zeta
if exist "%windir%\system32\wbem\WMIC.exe" (
call wmic /locale:ms_409 service where (name="wlidsvc") get state /value | findstr State=Running
if %ErrorLevel% neq 0 (
echo Echo has detected you may be on a MS Account
echo If you are, debloat might brick your PC
echo.
echo Would you still like to continue? [Y/N]

set /P c=Would you still like to continue? [Y/N]
if /I "%c%" EQU "N" (goto :FinishedDebloat)
if /I "%c%" equ "n" (goto :FinishedDebloat)
)
)

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
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\nvraid" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\PEAUTH" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\QWAVEdrv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
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
Reg add "HKLM\System\CurrentControlSet\Services\fvevol" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1

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
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "DiagnosticErrorText" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticErrorText" /t Reg_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticLinkText" /t Reg_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
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
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v "Value" /t Reg_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "DoNotTrack" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "OptimizeWindowsSearchResultsForScreenReaders" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead" /v "FPEnabled" /t Reg_DWORD /d "0" /f  >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes" /v "ShowSearchSuggestionsGlobal" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy" /v "EnableEncryptedMediaExtensions" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t Reg_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t Reg_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t Reg_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t Reg_DWORD /d "1" /f >nul 2>&1
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
if not "%version%" == "" (goto :not18093)
:18093
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f	
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AUEPLauncher" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\swenum" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService_f9bd" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService_f9bd" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EntAppSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService_177c6" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SamSs" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcLocator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netprofm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f
not18093
REM Windows 20H2
if "%version%" == "10.0.19042" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msssmbios" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\StorSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ALG" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\COMSysApp" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Everything" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppIDSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NgcCtnrSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\fdpHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FDResPub" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\dot3svc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WiaRpc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\upnphostc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TabletImputService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensorSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\slisvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SENS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Upnphost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DusmSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrikWks" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AJRouter" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Autotimesvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\aXiNSTsv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bdesv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTAGService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BTHSERV" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUser" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceFlowUser" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Fax" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\fhsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\HvHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\icssvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IFSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LLTDSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\lmhost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msIscsi" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\p2pimsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\perceptionsimulation" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PhoneSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PNRPAutoReg" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PushToInstall" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RasAuto" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RetailDemo" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RmSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SCardSvr" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ScDeviceEnum" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ScPolicySvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SDRSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecutityHealthService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\semGRsVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensorDataService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensorService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SessionEnv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedRealitySvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SmsRouter" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\spectrum" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tabletinputService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TapiSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TermService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UmRdpService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VacSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WalletService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WarpJITSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wbengine" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WbioSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinRM" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wisvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlpasvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\workfolderssvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpcMonSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WwanSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\sppsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SgrmBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\fontCache" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DispBrokerDektop" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BDESVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ErrDev" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SensrSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvcc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f
)
for /f "tokens=4-9 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM windows 8.1
if "%version%" == "6.3.9600" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f	
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AelookupSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppHostSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppSVc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\aspnet_state" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IEEtwCollectorService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MpsSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Msiserver" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MsKeyboardFilter" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wudfsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WcsPlugInService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wbengine" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WAS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\w3logsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\UI0Detect" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\THREADORDER" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\svsc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\RpcLocator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\perfHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\sppsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AppHostSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t Reg_DWORD /d "0" /f
)
REM windows 7 7601
if "%version%" == "6.1.7601" (
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tcpipReg" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\eventlog" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\clr_optimization_v4.0.30319_32" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\clr_optimization_v4.0.30319_64" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sppsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\aspnet_state" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\clr_optimization_v2.0.50727_32" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\clr_optimization_v2.0.50727_64" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\AeLookupSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bthserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\IPBusEnum" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\NETPROFM" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\ProtectedStorage" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\sppuinotify" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\THREADORDER" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WcsPluginService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxysVC" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Wlansvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\wudfsvc" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t Reg_DWORD /d "4" /f
Reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t Reg_DWORD /d "0" /f
)

:: Disable Connection Checking (pings Microsoft Servers)
:: May cause internet icon to show it is disconnected
Reg add "HKLM\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t Reg_DWORD /d "0" /f >nul
echo Disable Connection Checking

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
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul
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


:logo
echo %BS%     ______ _____ ___ ___ _______    ___   ___
echo %BS%    ^|\   __\   ___\  \\  \\   _  \  ^|\  \ /  /^|
echo %BS%    \ \  \__\  \__^|\  \\  \\  \\  \ \ \  /  / /
echo %BS%     \ \   __\  \   \   _  \\  \\  \ \ \   / /
echo %BS%      \ \  \__\  \___\  \\  \\  \\  \ \/   \/
echo %BS%       \ \_____\______\  \\__\\______\/  /  \
echo %BS%        \^|_____^|______^|__^|^|__^|^|______/__/ \__\
echo %BS%                                     [__^|\^|__] v3
goto:eof
