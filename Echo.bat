@echo off
title Echo
Mode 53,16
color fc

::Get Admin Rights
if exist "C:\Windows\system32\adminrightstest" (rmdir C:\Windows\system32\adminrightstest >nul 2>&1)
mkdir C:\Windows\system32\adminrightstest >nul 2>&1
if %errorlevel% neq 0 (
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
) else (echo Right click Echo and click "Run as administrator" & pause)
)

::Speed up Batch
setlocal EnableExtensions >nul 2>&1
setlocal EnableDelayedExpansion >nul 2>&1
wmic process where name="cmd.exe" call setpriority 128 >nul 2>&1

::Check For Connection
Ping www.google.nl -n 1 -w 1000 >nul
if errorlevel 1 (
echo No Internet Connection, Connect And Try Again
pause ^& exit 0)

if not exist "%windir%\system32\wbem\WMIC.exe" (
echo Missing WMIC, Your PC Is To Stripped
pause ^& exit 0)

if not exist "%windir%\system32\Reg.exe" (
echo Missing Windows Regisrty, Your PC Is To Stripped
pause ^& exit 0)

if not exist "%windir%\system32\bcdedit.exe" (
echo Missing BCDEdit, Your PC Is To Stripped
pause ^& exit 0)

if not exist "%windir%\system32\netsh.exe" (
echo Missing NETSH, Your PC Is To Stripped
pause ^& exit 0)

:Home

if not exist "%temp%\EchoProfile.nip" (cls
echo Downloading Nvidia Inspector [...]
if exist "%appdata%\.minecraft\options.txt" (
::if exist "%appdata%\.minecraft\UseHonePlan.txt" (
	if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
	powershell wget https://cdn.discordapp.com/attachments/798190447117074473/880931795632271390/Minecraft.nip -OutFile "%%temp%\EchoProfile.nip" >nul 2>&1) else (
	bitsadmin /transfer "Nvidia" https://cdn.discordapp.com/attachments/798190447117074473/880931795632271390/Minecraft.nip "%temp%\EchoProfile.nip" >nul 2>&1)
) else (
	if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
	powershell wget https://cdn.discordapp.com/attachments/798190447117074473/891526556692938774/EchoProfile.nip -OutFile "%temp%\EchoProfile.nip" >nul 2>&1) else (
	bitsadmin /transfer "Nvidia" https://cdn.discordapp.com/attachments/798190447117074473/891526556692938774/EchoProfile.nip "%temp%\EchoProfile.nip" >nul 2>&1)
))

if not exist "%SystemDrive%\EchoRes.exe" (cls
echo Downloading Timer Resolution [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/829143531414749195/EchoRes.exe -OutFile "%SystemDrive%\EchoRes.exe" >nul 2>&1) else (
bitsadmin /transfer "Res" https://cdn.discordapp.com/attachments/798190447117074473/829143531414749195/EchoRes.exe "%SystemDrive%\EchoRes.exe" >nul 2>&1)
)

if not exist "%temp%\EchoPow.pow" (cls
echo Downloading Power Plan [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/869778490843627550/EchoPow.pow -OutFile "%temp%\EchoPow.pow" >nul 2>&1) else (
bitsadmin /transfer "Pow" https://cdn.discordapp.com/attachments/798190447117074473/869778490843627550/EchoPow.pow "%temp%\EchoPow.pow" >nul 2>&1)
)

if not exist "%temp%\EchoNvidia.exe" (cls
echo Downloading Nvidia Profile [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/829143545083461672/EchoProfile.exe -OutFile "%temp%\EchoNvidia.exe" >nul 2>&1) else (
bitsadmin /transfer "Profile" https://cdn.discordapp.com/attachments/798190447117074473/829143545083461672/EchoProfile.exe "%temp%\EchoNvidia.exe" >nul 2>&1)
)

if not exist "%temp%\EchoDevice.exe" (cls
echo Downloading Device Cleanup [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/829143551979028480/EchoDevice.exe -OutFile "%temp%\EchoDevice.exe" >nul 2>&1) else (
bitsadmin /transfer "Device" https://cdn.discordapp.com/attachments/798190447117074473/829143551979028480/EchoDevice.exe "%temp%\EchoDevice.exe" >nul 2>&1)
)

if not exist "%temp%\EchoNSudo.exe" (cls
echo Downloading NSudo [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe -OutFile "%temp%\EchoNSudo.exe" >nul 2>&1) else (
bitsadmin /transfer "NSudo" https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe "%temp%\EchoNSudo.exe" >nul 2>&1)
)

if not exist "%temp%\EchoNSudo.exe" (cls
echo Downloading NSudo [...]
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe -OutFile "%temp%\EchoNSudo.exe" >nul 2>&1) else (
bitsadmin /transfer "NSudo" https://cdn.discordapp.com/attachments/798190447117074473/829143552088473620/EchoNSudo.exe "%temp%\EchoNSudo.exe" >nul 2>&1)
)

if not exist "%windir%\System32\gpedit.msc" (cls
pushd "%~dp0"
echo Installing gpedit.msc [...]
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt 
dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt 
for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
)

set MenuWarning=[97mI[91m
cls
echo        ___         ___         ___         ___     
echo       /\__\       /\__\       /\  \       /\  \    
echo      /:/ _/_     /:/  /       \:\  \     /::\  \   
echo     /:/ /\__\   /:/  /         \:\  \   /:/\:\  \  
echo    /:/ /:/ _/_ /:/  /  ___ ___ /::\  \ /:/  \:\  \ 
echo   /:/_/:/ /\__/:/__/  /\__/\  /:/\:\__/:/__/ \:\__\
echo   \:\/:/ /:/  \:\  \ /:/  \:\/:/  \/__\:\  \ /:/  /
echo    \::/_/:/  / \:\  /:/  / \::/__/     \:\  /:/  / 
echo     \:\/:/  /   \:\/:/  /   \:\  \      \:\/:/  /  
echo      \::/  /     \::/  /     \:\__\      \::/  /   
echo       \/__/       \/__/       \/__/       \/__/    
echo %MenuWarning%
echo          [[94m1[91m] Settings  [[94m2[91m] Credits  [[94m3[91m] Undo
echo                    Enter - Optimize
set MenuItem=
set /p MenuItem=[97mI[91m                        ^>:
set MenuWarning=[97mI[91m

if not "%MenuItem%"=="3" (goto :notRevert)
cls
echo Reverting Changes
echo.
echo Close the program to cancel
timeout 10
regedit.exe /s "%SystemDrive%\regbackup.reg"
bcdedit.exe /import "%SystemDrive%\bcdedit.bcd"
if not exist "%temp%\Default.nip" (
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
powershell wget https://cdn.discordapp.com/attachments/798190447117074473/881683546891235398/Default.nip -OutFile "%temp%\Default.nip") else (
bitsadmin /transfer "DefaultNIP" https://cdn.discordapp.com/attachments/798190447117074473/881683546891235398/Default.nip "%temp%\Default.nip"))
taskkill /IM "EchoNvidia.exe"
start /b %temp%\EchoNvidia.exe "%temp%\Default.nip"
goto :Home
:notRevert

if "%MenuItem%"=="2" (
echo [======================Credits======================]
echo             UnLovedCookie#6871 - Creator
echo            Couleur - App and Game Settings
echo              Uwe Sieber - Device Cleaner
echo               Melody - Pagefile and AMD
echo               Matishzz - AMD and Device
echo                EverythingTech - Helped
echo                AuraSide Inc. - Debloat
echo                 Orbmu2k - NVInspector
echo                 Mark Cranness - Mouse
echo                  mbk1969 - Timer Res
echo                  Phlegm - Power Plan
echo                   Nani - Nvidia Nip
echo                    M2Teams - NSudo
echo                    Waffle - Helped
echo                    Zusier - Helped
pause
goto :Home
)

if "%MenuItem%"=="1" (goto :Settings)

if not "%MenuItem%"=="" ((set MenuWarning=       Just press enter or use a single number) & goto :Home)

goto Confirm

:Settings
set MenuItem=
::Get Setting Keys
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat ^|findstr /ri "Reg_DWORD"') do set Debloat=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD ^|findstr /ri "Reg_DWORD"') do set BCD=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse ^|findstr /ri "Reg_DWORD"') do set Mouse=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle ^|findstr /ri "Reg_DWORD"') do set Idle=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost ^|findstr /ri "Reg_DWORD"') do set KBoost=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res ^|findstr /ri "Reg_DWORD"') do set Res=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP ^|findstr /ri "Reg_DWORD"') do set DSCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore ^|findstr /ri "Reg_DWORD"') do set Restore=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Warning ^|findstr /ri "Reg_DWORD"') do set Warning=%%a) >nul 2>&1
set DebloatReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat /t Reg_DWORD /d
set BCDReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD /t Reg_DWORD /d
set MouseReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse /t Reg_DWORD /d
set IdleReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle /t Reg_DWORD /d
set KBoostReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost /t Reg_DWORD /d
set ResReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res /t Reg_DWORD /d
set DSCPReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP /t Reg_DWORD /d
set RestoreReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore /t Reg_DWORD /d
set WarningReg=Reg add "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Warning /t Reg_DWORD /d

if not "%Warning%"=="0x1" (
cls
echo THESE SETTINGS ARE VERY DANGEROUS
echo It's recommened to leave them all OFF
pause
%WarningReg% "1" /f >nul
)

if "%MenuNumber%"=="MenuNumber2" (goto :MenuNumber2)

:MenuNumber1
cls
echo.
if "%Debloat%"=="0x1" (echo [[94m1[91m] ADVANCED Debloat [32mon[91m
			   ) else (echo [[94m1[91m] ADVANCED Debloat [32moff[91m)
echo CAN CAUSE BSOD OR REMOVE WINDOWS FEATURES & echo.
if "%BCD%"=="0x1" (echo [[94m2[91m] BCDEdit [32mon[91m
		   ) else (echo [[94m2[91m] BCDEdit [32moff[91m)
echo Turn this off if you're on a laptop & echo.
if "%Mouse%"=="0x1" (echo [[94m3[91m] Mouse Optimization [32mon[91m
		     ) else (echo [[94m3[91m] Mouse Optimization [32moff[91m)
echo Turn this off if you use a trackpad or older mouse & echo.
if "%Idle%"=="0x1" (echo [[94m4[91m] Disable Idle [32mon[91m
		    ) else (echo [[94m4[91m] Disable Idle [32moff[91m)
echo Turn this off if your computer gets hot & echo.

echo [97mI[91m                  [[94m0[91m] Next Page
set /p MenuItem=[97mI[91m                        ^>:
set MenuNumber=MenuNumber1

if "%MenuItem%"=="0" (
:MenuNumber2
cls
echo.
if "%KBoost%"=="0x1" (echo [[94m5[91m] KBoost [32mon[91m
              ) else (echo [[94m5[91m] KBoost [32moff[91m)
echo Turn this off if your computer gets hot & echo.
if "%Res%"=="0x1" (echo [[94m6[91m] Timer Resolution [32mon[91m
           ) else (echo [[94m6[91m] Timer Resolution [32moff[91m)
echo Turn this on for older games & echo.
if "%DSCP%"=="0x1" (echo [[94m7[91m] DSCP Value [32mon[91m
            ) else (echo [[94m7[91m] DSCP Value [32moff[91m)
echo Turn this on to prioritize your packets & echo.
if "%Restore%"=="0x1" (echo [[94m8[91m] Don't Create A Restore Point [32mon[91m
			   ) else (echo [[94m8[91m] Don't Create A Restore Point [32moff[91m)
echo Not recommended to turn this off & echo.

echo [97mI[91m                  [[94m0[91m] Next Page
set /p MenuItem=[97mI[91m                        ^>:
set MenuNumber=MenuNumber2
)

if "%MenuItem%"=="0" (set MenuNumber=MenuNumber1 & goto :Settings)
if "%MenuItem%"=="1" ((if "%Debloat%"=="0x1" (%DebloatReg% "0" /f >nul) else (%DebloatReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="2" ((if "%BCD%"=="0x1" (%BCDReg% "0" /f >nul) else (%BCDReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="3" ((if "%Mouse%"=="0x1" (%MouseReg% "0" /f >nul) else (%MouseReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="4" ((if "%Idle%"=="0x1" (%IdleReg% "0" /f >nul) else (%IdleReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="5" ((if "%KBoost%"=="0x1" (%KBoostReg% "0" /f >nul) else (%KBoostReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="6" ((if "%Res%"=="0x1" (%ResReg% "0" /f >nul) else (%ResReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="7" ((if "%DSCP%"=="0x1" (%DSCPReg% "0" /f >nul) else (%DSCPReg% "1" /f >nul)) & goto :Settings)
if "%MenuItem%"=="8" ((if "%Restore%"=="0x1" (%RestoreReg% "0" /f >nul) else (%RestoreReg% "1" /f >nul)) & goto :Settings)
goto :Home

:Confirm
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Debloat ^|findstr /ri "Reg_DWORD"') do set Debloat=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v BCD ^|findstr /ri "Reg_DWORD"') do set BCD=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Mouse ^|findstr /ri "Reg_DWORD"') do set Mouse=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Idle ^|findstr /ri "Reg_DWORD"') do set Idle=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v KBoost ^|findstr /ri "Reg_DWORD"') do set KBoost=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Res ^|findstr /ri "Reg_DWORD"') do set Res=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v DSCP ^|findstr /ri "Reg_DWORD"') do set DSCP=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Restore ^|findstr /ri "Reg_DWORD"') do set Restore=%%a) >nul 2>&1
(for /f "tokens=3" %%a in ('Reg query "HKEY_CURRENT_USER\SOFTWARE\Echo" /v Priority ^|findstr /ri "Reg_DWORD"') do set Priority=%%a) >nul 2>&1
cls

if not exist "%SystemDrive%\regbackup.reg" (
echo Creating Registry Backup [...]
regedit /e %SystemDrive%\regbackup.reg
cls)

if not exist "%SystemDrive%\bcdbackup.bcd" (
echo Creating BCD Backup [...]
bcdedit /export "%SystemDrive%\bcdbackup.bcd"
cls)

if not "%Restore%"=="0x1" (
echo Creating System Restore Point [...] ^& echo.
(powershell Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\') >nul 2>&1
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v SystemRestorePointCreationFrequency /t REG_DWORD /d 0 /f >nul
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Echo Optimization' -RestorePointType 'MODIFY_SETTINGS'"
cls)

taskkill /f /im explorer.exe >nul 2>&1

goto :skipLong
echo Fixing System Files... (May Take Some Time)
sfc /scannow
Dism /Online /Cleanup-Image /RestoreHealth
echo Fixed System Files
echo Optimizing Drives... (May Take Some Time)
defrag /C /O
echo Optimized Drives
:skipLong

::Disable Hibernation
powercfg -h off >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul
echo Disable Hibernation

::Text Improvements Avalon
for %%i in (HKLM\SOFTWARE HKLM\SOFTWARE\WOW6432Node HKEY_CURRENT_USER\SOFTWARE) do (
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "ClearTypeLevel" /t Reg_DWORD /d "100" /f >nul 2>&1
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "EnhancedContrastLevel" /t Reg_DWORD /d "0" /f >nul 2>&1
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "GammaLevel" /t Reg_DWORD /d "1600" /f >nul 2>&1
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "GrayscaleEnhancedContrastLevel" /t Reg_DWORD /d "0" /f >nul 2>&1
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "PixelStructure" /t Reg_DWORD /d "1" /f >nul 2>&1
    Reg add "%%i\Microsoft\Avalon.Graphics" /v "TextContrastLevel" /t Reg_DWORD /d "6" /f >nul 2>&1
)
echo Text Improvments

::Microcode Mitigation
if not exist "%SystemDrive%\Windows\System32\mcupdate_AuthenticAMD.dll.old" (
start /b %temp%\EchoNSudo.exe -U:T -P:E cmd /c "ren %SystemDrive%\Windows\System32\mcupdate_AuthenticAMD.dll mcupdate_AuthenticAMD.dll.old" >nul 2>&1
)
if not exist "%SystemDrive%\Windows\System32\mcupdate_GenuineIntel.dll.old" (
start /b %temp%\EchoNSudo.exe -U:T -P:E cmd /c "ren %SystemDrive%\Windows\System32\mcupdate_GenuineIntel.dll mcupdate_GenuineIntel.dll.old" >nul 2>&1
)
echo Microcode Mitigation

::Disable Process Mitigations
if exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (
::(powershell Set-ProcessMitigation -System -Disable DEP, EmulateAtlThunks, SEHOP, ForceRelocateImages, RequireInfo, BottomUp, HighEntropy, StrictHandle, DisableWin32kSystemCalls, AuditSystemCall, DisableExtensionPoints, BlockDynamicCode, AllowThreadsToOptOut, AuditDynamicCode, CFG, SuppressExports, StrictCFG, MicrosoftSignedOnly, AllowStoreSignedBinaries, AuditMicrosoftSigned, AuditStoreSigned, EnforceModuleDependencySigning, DisableNonSystemFonts, AuditFont, BlockRemoteImageLoads, BlockLowLabelImageLoads, PreferSystem32, AuditRemoteImageLoads, AuditLowLabelImageLoads, AuditPreferSystem32, EnableExportAddressFilter, AuditEnableExportAddressFilter, EnableExportAddressFilterPlus, AuditEnableExportAddressFilterPlus, EnableImportAddressFilter, AuditEnableImportAddressFilter, EnableRopStackPivot, AuditEnableRopStackPivot, EnableRopCallerCheck, AuditEnableRopCallerCheck, EnableRopSimExec, AuditEnableRopSimExec, SEHOP, AuditSEHOP, SEHOPTelemetry, TerminateOnError, DisallowChildProcessCreation, AuditChildProcess) >nul 2>&1
::(powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue") >nul 2>&1
echo Disabled Process Mitigations
)

::Disable Kernel Mitigations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>&1
echo Disabled Kernel Mitigations

::Disable additional NTFS/ReFS mitigations
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul

::Priority for csrss.exe
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>&1

::Disallow drivers to get paged into virtual memory
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul

::Use big system memory caching to improve microstuttering
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f >nul

::Reliable Timestamp
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f >nul
echo Timestamp Interval

::Xbox
Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f >nul 2>&1
Reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f >nul 2>&1
Reg delete "HKCU\System\GameConfigStore\Children" /f >nul 2>&1
Reg delete "HKCU\System\GameConfigStore\Parents" /f >nul 2>&1
echo Disable FSO

::Monitor Latency
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "0" /f >nul 2>&1
echo Monitor Latency

::Disable Spectre And Meltdown
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t REG_DWORD /d 0 /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul
echo Disabled Spectre And Meltdown

::System responsiveness + Network throttling
::https://cdn.discordapp.com/attachments/890128142075850803/890135598566895666/unknown.png
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

::Power Throttling
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "DisableRealtimeMonitoring" /t Reg_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t Reg_DWORD /d "0" /f >nul
echo Disable Power Throttling

::Background Apps
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f >nul
echo Disable Background Apps

::Storage Optimizations
goto :skipSetting
if not exist "%windir%\system32\windowspowershell\v1.0\powershell.exe" (goto :skipSetting)
for /f "tokens=* skip=1" %%n in ('powershell get-physicaldisk ^| findstr "."') do set storageType=%%n
set storageType=%storageType: =%
if not "%storageType:HDD=%"=="%storageType%" (
fsutil behavior set disableLastAccess 1 >nul 2>&1
)
if not "%storageType:SSD=%"=="%storageType%" (
fsutil behavior set disableLastAccess 0 >nul 2>&1
)
:skipSetting
fstuil set memory query usage  >nul 2>&1
fstuil set memory query usage 2  >nul 2>&1
fsutil behavior set disable8dot3 1   >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "1" /f  >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "StartedComponents" /t REG_DWORD /d "513347" /f  >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminDisable" /t REG_DWORD /d "8704" /f  >nul 2>&1
Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "AdminEnable" /t REG_DWORD /d "0" /f  >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisable8dot3NameCreation" /t REG_DWORD /d "1" /f  >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NTFSDisableLastAccessUpdate" /t REG_DWORD /d "1" /f  >nul 2>&1
echo Storage Optimizations

::Disable Startup Apps
del /f /q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\*.*" >nul 2>&1
echo Disable Start Up Programs

::Disable FTH
Reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FTH\State" /f >nul 2>&1
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FTH" /v "Enabled" /t Reg_DWORD /d "0" /f >nul 2>&1
echo Disable FTH

::Power Plan + Disable Core Parking
powercfg -delete 99999999-9999-9999-9999-999999999999 >nul 2>&1
powercfg -import "%temp%\EchoPow.pow" 99999999-9999-9999-9999-999999999999 >nul 2>&1
if not "%Idle%"=="0x1" goto :skipIdle
Reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d "0" /f >nul 2>&1
for /f "tokens=* skip=1" %%n in ('wmic cpu get numberOfLogicalProcessors ^| findstr "."') do set THREADS=%%n
for /f "tokens=* skip=1" %%n in ('wmic cpu get numberOfCores ^| findstr "."') do set CORES=%%n
if "%CORES: =%" EQU "%THREADS: =%" (
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
)
:skipIdle
powercfg /setactive 99999999-9999-9999-9999-999999999999 >nul 2>&1
echo Power Plan

::Latency
if not "%Priority%"=="0x1" goto :skipGPUPriority
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d "24" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d "10000" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d "18" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d "8" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
:skipGPUPriority

::Timer Resolution
if "%Res%"=="0x1" (
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformtick yes >nul 2>&1
(start /b %SystemDrive%\EchoRes.exe -install) >nul 2>&1
sc start STR >nul 2>&1
echo Timer Resolution
)

::Device Cleanup
%temp%\EchoDevice * -s >nul 2>&1
echo Clean Devices

::GPU AMD + Nvidia Settings
for /f "tokens=* skip=1" %%n in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set GPU_NAME=%%n
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
Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f >nul
Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f >nul
echo Disable Gamemode

::AMD Reg Keys
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f
REM ; related to record
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableeRecord" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_SDIEnable" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmSWL1" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ForcePcieLinkSpeed" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_GameManagerSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_10BitMode" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1SS" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuBypassMode" /t REG_DWORD /d "1" /f
REM ; Load Balancing Per Watt
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableLBPWSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePllOffInL1" /t REG_DWORD /d "0" /f
REM ; Related to Intel SpeedStep Technology
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePPSMSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableSpreadSpectrum" /t REG_DWORD /d "0" /f
REM ; c.f https://docs.nvidia.com/gameworks/content/developertools/desktop/timeout_detection_recovery.htm
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_AllowTDRAfterECC" /t REG_DWORD /d "1" /f
REM ; related to record
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DVRSupport" /t REG_DWORD /d "0" /f
REM ; related to vm
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableDceVmSupport" /t REG_DWORD /d "0" /f
REM ; HDMI Feature
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEDIDManagementSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEventLog" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableHWSHighPriorityQueue" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSDMAPaging" /t REG_DWORD /d "1" /f
REM ; c.f https://steemit.com/virtualbox/@benjamin-u4/fr-guide-qu-est-ce-que-amd-v-amd-svm-pourquoi-et-comment-l-activer
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSVMSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FramePacingSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_UseBestGPUPowerOption" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerEnabled" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerRemotePlayEnabled" /t REG_DWORD /d "0" /f
REM ; related to hdmi
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableHDCP" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableStutter" /t REG_DWORD /d "1" /f
REM ; related to hdmi
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalEnableHDMI20" /t REG_DWORD /d "0" /f
REM ; c.f https://en.wikipedia.org/wiki/Bit_manipulation_instruction_set
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceAbmEnable" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceMaxDisplayClock" /t REG_DWORD /d "1" /f
REM ; related to display port
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t REG_DWORD /d "1" /f
REM ; c.f https://01.org/linuxgraphics/gfx-docs/drm/ch04s02.html#:~:text=PSR%20feature%20allows%20the%20display,)%20and%20Panel%20(sink).
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t REG_DWORD /d "0" /f
REM ; c.f https://www.amd.com/fr/technologies/blockchain
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t REG_DWORD /d "1" /f
REM ; c.f https://docs.microsoft.com/en-us/windows-hardware/drivers/display/gdi-hardware-acceleration
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t REG_DWORD /d "1" /f
REM ; related to vm
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IoMmuGpuIsolation" /t REG_DWORD /d "0" /f
REM ; c.f https://www.phoronix.com/scan.php?page=news_item&px=AMDGPU-DC-Seamless-Boot
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSeamlessBoot" /t REG_DWORD /d "0" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IsGamingDriver" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t REG_DWORD /d "1" /f
REM ; amd software
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_CCCNextEnabled" /t REG_DWORD /d "0" /f
REM ; c.f https://www.amd.com/fr/technologies/radeon-wattman
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f

::Unixcorn AMD Reg Keys
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t REG_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t REG_SZ /d "false" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t REG_SZ /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
echo AMD Reg Keys

::Melody AMD Tweaks
for %%i in (LTRSnoopL1Latency LTRSnoopL0Latency LTRNoSnoopL1Latency LTRMaxNoSnoopLatency KMD_RpmComputeLatency
        DalUrgentLatencyNs memClockSwitchLatency PP_RTPMComputeF1Latency PP_DGBMMMaxTransitionLatencyUvd
        PP_DGBPMMaxTransitionLatencyGfx DalNBLatencyForUnderFlow DalDramClockChangeLatencyNs
        BGM_LTRSnoopL1Latency BGM_LTRSnoopL0Latency BGM_LTRNoSnoopL1Latency BGM_LTRNoSnoopL0Latency
        BGM_LTRMaxSnoopLatencyValue BGM_LTRMaxNoSnoopLatencyValue) do Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "%%i" /t Reg_DWORD /d "1" /f >nul 2>&1
)

echo Optimized AMD GPU
goto :gpuUndefined

:NVIDIA
::Enable GameMode
Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f >nul
Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f >nul
Echo Enable Gamemode

::Unrestricted Clocks
("C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe" -acp 0) >nul 2>&1

::Nvidia Settings
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableTiledDisplay" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t REG_DWORD /d "0" /f >nul 2>&1
REM ; Nvidia Matishzz Optimization
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>&1
echo Nvidia Reg

::kboost
if "%KBoost%"=="0x1" (
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t REG_DWORD /d "1" /f >nul
echo KBoost
)

::NVCP
taskkill /IM "EchoNvidia.exe" /F >nul 2>&1
start /b %temp%\EchoNvidia.exe "%temp%\EchoProfile.nip" >nul 2>&1
echo NVCP Settings
:gpuUndefined

::RAM
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableBoottrace" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "DisablePagingCombining" /t Reg_DWORD /d "1" /f >nul
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /format:value') do set /a ram=%%i
Reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d %ram% /f >nul 2>&1
echo Ram

::100% Scaling and Mouse Acc
if not "%Mouse%"=="0x1" (goto :noMouse)
Reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t Reg_SZ /d "10" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseSpeed" /t Reg_SZ /d "0" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold1" /t Reg_SZ /d "0" /f >nul
Reg add "HKU\.DEFAULT\Control Panel\Mouse" /v "MouseThreshold2" /t Reg_SZ /d "0" /f >nul
::DataQueueSize
FOR /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize`) DO (set KeyboardSize=%%A)
if %KeyboardSize:~2,10% gtr 32 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "32" /f >nul 2>&1)
For /f "usebackq tokens=3*" %%A in (`Reg query "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize`) DO (set MouseSize=%%A)
if %KeyboardSize:~2,10% gtr 16 (Reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "16" /f >nul 2>&1)

Reg add "HKCU\Control Panel\Accessibility\Keyboard Preference" /v "On" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "BounceTime" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last BounceKey Setting" /t REG_DWORD /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Delay" /t REG_DWORD /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Repeat" /t REG_DWORD /d "0" /f >nul
Reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Last Valid Wait" /t REG_DWORD /d "0" /f >nul
Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul
Reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul
echo Keyboard Input Delay

echo DataQueueSize
echo Windows Scaling
echo Mouse Acc
:noMouse

::Affinities + MSI Mode
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "PCI\VEN_"') do set GPU=%%g
for /f %%g in ('wmic path win32_NetworkAdapter get PNPDeviceID ^| findstr /L "PCI\VEN_"') do set NET=%%g
for /f %%n in ('wmic path win32_USBController get PNPDeviceID ^| findstr /L "10DE"') do set USB=%%n
for /f "tokens=* skip=1" %%n in ('wmic cpu get numberOfLogicalProcessors ^| findstr "."') do set THREADS=%%n
for /f "tokens=* skip=1" %%n in ('wmic cpu get numberOfCores ^| findstr "."') do set CORES=%%n
if "%CORES%" GTR "4" (
Reg add "HKLM\SYSTEM\ControlSet001\Enum\%GPU%\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t Reg_DWORD /d "3" /f >nul
Reg add "HKLM\SYSTEM\ControlSet001\Enum\%NET%\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t Reg_DWORD /d "5" /f >nul
)
Echo Affinities

::Enable MSI Mode if supported
Reg query "HKLM\SYSTEM\ControlSet001\Enum\%GPU%\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" >nul 2>&1
if %ERRORLEVEL% EQU 0 (Reg add "HKLM\SYSTEM\ControlSet001\Enum\%GPU%\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t Reg_DWORD /d "1" /f >nul)

::Remove Limits
Reg delete "HKLM\SYSTEM\ControlSet001\Enum\%GPU%\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f >nul 2>&1

echo Remove Limits
echo Contact Between CPU and GPU
echo Device Priority

::BCDEdit
::Better Input
bcdedit /set tscsyncpolicy legacy >nul 2>&1

if not "%BCD%"=="0x1" (goto :NoBCD)
for /f "tokens=* skip=1" %%n in ('wmic cpu get caption ^| findstr "."') do set CPU_NAME=%%n
>nul 2>&1 find "AMD" %CPU_NAME% && (
bcdedit /set nx optout >nul 2>&1
echo Optimized AMD CPU
)
bcdedit /set bootux disabled >nul 2>&1
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set hypervisorlaunchtype off >nul 2>&1
bcdedit /set tpmbootentropy ForceDisable >nul 2>&1
bcdedit /set quietboot yes >nul 2>&1
bcdedit /set {globalsettings} custom:16000067 true >nul 2>&1
bcdedit /set {globalsettings} custom:16000069 true >nul 2>&1
bcdedit /set {globalsettings} custom:16000068 true >nul 2>&1

::Linear Address 57
bcdedit /set linearaddress57 OptOut >nul 2>&1
bcdedit /set increaseuserva 268435328 >nul 2>&1

::Avoid the use of uncontiguous portions of low-memory from the OS
bcdedit /set firstmegabytepolicy UseAll >nul 2>&1
bcdedit /set avoidlowmemory 0x8000000 >nul 2>&1
bcdedit /set nolowmem Yes >nul 2>&1

::Disable some of the kernel memory mitigations
bcdedit /set allowedinmemorysettings 0x0 >nul 2>&1
bcdedit /set isolatedcontext No >nul 2>&1

::Disable DMA memory protection and cores isolation
bcdedit /set vsmlaunchtype Off >nul 2>&1
bcdedit /set vm No >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >nul 2>&1

::Enable X2Apic and enable Memory Mapping for PCI-E devices
bcdedit /set x2apicpolicy Enable
bcdedit /set configaccesspolicy Default
bcdedit /set MSI Default
bcdedit /set usephysicaldestination No
bcdedit /set usefirmwarepcisettings No

echo BCDEdit
:NoBCD

::Pagefile
wmic pagefileset where name="D:\\pagefile.sys" delete >nul
wmic pagefileset create name="C:\pagefile.sys" >nul 2>&1
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=32768,MaximumSize=32768 >nul
if %errorlevel% neq 0 (wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=16384,MaximumSize=16384 >nul)
if %errorlevel% neq 0 (wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=8192,MaximumSize=8192 >nul)
if %errorlevel% neq 0 (wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul)
if %errorlevel% neq 0 (wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=2048,MaximumSize=2048 >nul)
if %errorlevel% neq 0 (wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=1024,MaximumSize=1024 >nul)
echo Page File

::Discord


::OBS
if not exist "%appdata%\obs-studio" goto :skipOBS

::Run as admin
Reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Program Files\obs-studio\bin\64bit\obs64.exe" /t REG_SZ /d "~ RUNASADMIN" /f >nul

for /f "tokens=* skip=1" %%n in ('WMIC path Win32_VideoController get Name ^| findstr "."') do set GPU_NAME=%%n
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
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f >nul 2>&1
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
(echo ofFogType:3) >> optionsof.txt
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
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f >nul

::Remove OneDrive Sync
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f >nul

::Disable Delivery Optimization
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f >nul
echo Disable Delivery Optimization

::Disable limiting bandwith
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >nul
echo Remove Limiting Bandwidth

::Disable Network Power Saving
for /f %%r in ('Reg query "HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /f "PCI\VEN_" /d /s^|Findstr HKEY_') do (
Reg add %%r /v "AutoDisableGigabit" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "EnableGreenEthernet" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "GigaLite" /t Reg_SZ /d "0" /f >nul
Reg add %%r /v "PowerSavingMode" /t Reg_SZ /d "0" /f >nul
)
echo Disable Network Power Saving

::Netsh
netsh winsock reset catalog >nul 2>&1
netsh int ip reset %SystemDrive%\resetlog.txt >nul 2>&1
netsh int ip reset %SystemDrive%\tcplog.txt >nul 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global initialRto=2000 >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rsc=disabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=disabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1
netsh interface tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global MaxSynRetransmissions=2 >nul 2>&1
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

for /f "tokens=3*" %%s in ('Reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /f "ServiceName" /s^|findstr /i /l "ServiceName"') do (
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched\Parameters\Adapters\%%s" /v "NonBestEffortLimit" /t Reg_DWORD /d "0" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "DeadGWDetectDefault" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "PerformRouterDiscovery" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpAckFrequency" /t Reg_DWORD /d "1" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpDelAckTicks" /t Reg_DWORD /d "0" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpInitialRTT" /t Reg_DWORD /d "0" /f >nul
 	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TCPNoDelay" /t Reg_DWORD /d "1" /f  >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "TcpWindowSize" /t Reg_DWORD /d "32767" /f >nul
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%s" /v "UseZeroBroadcast" /t Reg_DWORD /d "1" /f >nul
)

Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BITS" /v "Start" /t REG_DWORD /d "2" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDCA" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IGMPLevel" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableTCPA" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableLargeMtu" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d "65535" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65535" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxHalfOpen" /t REG_DWORD /d "500" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpFinWait1Delay" /t REG_DWORD /d "30" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDeadGWDetect" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxSendFree" /t REG_DWORD /d "65535" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableAddrMaskReply" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableBcastArpReply" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableTaskOffload" /t REG_DWORD /d "0" /f  >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumForwardPackets" /t REG_DWORD /d "586" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "KeepAliveInterval" /t REG_DWORD /d "1000" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d "65536" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPCongestionControl" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NoNameReleaseOnDemand" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NumTcbTablePartitions" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNumConnections" /t REG_DWORD /d "65534" /f >nul
Reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableDHCPMediaSense" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableFragmentChecking" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxNumForwardPackets" /t REG_DWORD /d "586" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "StrictTimeWaitSeqCheck" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxHalfOpenRetried" /t REG_DWORD /d "400" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxPortsExhausted" /t REG_DWORD /d "2000" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "UseDomainNameDevolution" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "ForwardBufferMemory" /t REG_DWORD /d "150016" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableMulticastForwarding" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d "3" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableMediaSenseEventLog" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "32767" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxForwardBufferMemory" /t REG_DWORD /d "150016" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DontAddDefaultGatewayDefault" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableConnectionRateLimiting" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxConnectRetransmissions" /t REG_DWORD /d "2" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "PPTPTcpMaxDataRetransmissions" /t REG_DWORD /d "5" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "UseSystemMaximum" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "QualifyingDestinationThreshold" /t REG_DWORD /d "3" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "SBM2" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "Size" /t REG_DWORD /d "3" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "MaxBandwidthValidTo" /t REG_DWORD /d "14" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableIPAutoConfigurationLimits" /t REG_DWORD /d "1" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "MaxBandwidthValidFrom" /t REG_DWORD /d "8" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCmds" /t REG_DWORD /d "40" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "EnableBITSMaxBandwidth" /t REG_DWORD /d "1" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpCreateAndConnectTcbRateLimitDepth" /t REG_DWORD /d "0" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxConnectResponseRetransmissions" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableDos" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxMpxCt" /t REG_DWORD /d "800" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxThreads" /t REG_DWORD /d "40" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "KeepConn" /t REG_DWORD /d "15180" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "SizReqBuf" /t REG_DWORD /d "4410" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "MaxTransferRateOnSchedule" /t REG_DWORD /d "10" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "EnableOplocks" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "IRPStackSize" /t REG_DWORD /d "20" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\SOFTWARE\Policies\Microsoft\Windows\BITS" /v "MaxTransferRateOffSchedule" /t REG_DWORD /d "11" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableLargeMtu" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxWorkItems" /t REG_DWORD /d "2000" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxRawWorkItems" /t REG_DWORD /d "200" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxCollectionCount" /t REG_DWORD /d "20" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MaxFreeConnections" /t REG_DWORD /d "64" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "MinFreeConnections" /t REG_DWORD /d "20" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "SharingViolationDelay" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "autodisconnect" /t REG_DWORD /d "4294967295" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "SharingViolationRetries" /t REG_DWORD /d "0" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableStrictNameChecking" /t REG_DWORD /d "1" /f >nul
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d "1" /f >nul
echo Internet Settings

::Internet Priority
goto :skipPriority
if not "%DSCP%"=="0x1" (goto :skipPriority)
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v "Start" /t REG_DWORD /d "1" /f >nul 2>&1
start /b %temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc start Psched"
(powershell Get-NetAdapterQos -Name "*" ^| Enable-NetAdapterQos) >nul 2>&1
::fortniteclient-win64-shipping.exe
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Version" /t REG_SZ /d "1.0" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Application Name" /t REG_SZ /d "javaw.exe" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Protocol" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Local Port" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Local IP" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Remote Port" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Remote IP" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "DSCP Value" /t REG_SZ /d "46" /f >nul 2>&1
Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{F08CC7E3-524B-4C06-B1B7-C51552D97910}Machine\Software\Policies\Microsoft\Windows\QoS\Minecraft" /v "Throttle Rate" /t REG_SZ /d "-1" /f >nul 2>&1
echo Priority
:skipPriority

::Taskbar Fix
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /t REG_DWORD /d "2" /f >nul
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "2" /f >nul
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ctfmon" /t REG_SZ /d "%SystemDrive%\Windows\System32\ctfmon.exe" /f >nul
echo Taskbar Fix

::Unneeded Files
del /s /f /q %SystemDrive%\windows\temp\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\tmp\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\history\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\recent\*.* >nul 2>&1
del /s /f /q %SystemDrive%\windows\spool\printers\*.* >nul 2>&1
del /s /f /q %SystemDrive%\Windows\Prefetch\*.* >nul 2>&1
echo Cleaned Drive

start explorer.exe >nul
cls
echo Optimizations Finished, Restart to fully apply.
echo. & echo Press any key to restart...
pause >nul
echo Restarting... 
timeout 10
shutdown.exe /r /t 00
exit 0

:AdvancedDebloat
::Hone Code lol
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config xbgm start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config XboxGipSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WaaSMedicSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config wuauserv start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config W32Time start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config spectrum start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config wcncsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WebClient start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config SysMain start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config NcaSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config wlidsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config SCardSvr start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config NgcCtnrSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config diagsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config UserDataSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config stisvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config AdobeFlashPlayerUpdateSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config TrkWks start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config dmwappushservice start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config PimIndexMaintenanceSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config DiagTrack start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config VaultSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config GoogleChromeElevationService start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config OneSyncSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config ibtsiva start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config SNMPTRAP start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config pla start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config ssh-agent start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config sshd start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config DoSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config tzautoupdate start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config CertPropSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config RemoteRegistry start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config RemoteAccess start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WbioSrvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config PcaSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config NetTcpPortSharing start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WerSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config gupdate start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config gupdatem start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config MSiSCSI start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WMPNetworkSvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config CDPUserSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config WpnUserService_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config shpamsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config LanmanWorkstation start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config UnistoreSvc_3228d start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config MapsBroker start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "sc config debugregsvc start=disabled >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Ndu" /v "Start" /d "00000002" /t REG_DWORD /f >nul 2>&1"
%temp%\EchoNSudo.exe -U:T -P:E cmd /c "reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /d "00000003" /t REG_DWORD /f >nul 2>&1"

Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "DiagnosticErrorText" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticErrorText" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings" /v "DiagnosticLinkText" /t REG_SZ /d "" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1 
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "DoNotTrack" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "OptimizeWindowsSearchResultsForScreenReaders" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead" /v "FPEnabled" /t REG_DWORD /d "0" /f  >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\User\Default\SearchScopes" /v "ShowSearchSuggestionsGlobal" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy" /v "EnableEncryptedMediaExtensions" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgradePeriod" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpdatePeriod" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d" /v "RegisteredWithAU" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>&1

::Matishzz (with a few services removed)
reg add "HKLM\System\CurrentControlSet\Control\Class{4d36e96c-e325-11ce-bfc1-08002be10318}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class{6bdd1fc6-810f-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Class{ca3e7ab9-b4c3-4ae6-8251-579ef933890f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f >nul 2>&1

::https://www.gaijin.at/en/infos/windows-version-numbers
for /f "tokens=4-10 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM Windows 1809, 1803, 1709 (in that order)
if "%version%" == "10.0.17763" (goto :18093)
if "%version%" == "10.0.17134" (goto :18093)
if "%version%" == "10.0.16299" (goto :18093)
if not "%version%" == "" (goto :not18093)
:18093
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f	
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AUEPLauncher" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\swenum" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnUserService_f9bd" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wcncsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CaptureService_f9bd" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsmSv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EntAppSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnUserService_177c6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SamSs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RpcLocator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netprofm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ssh-agent" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t REG_DWORD /d "4" /f
not18093
REM Windows 20H2
if "%version%" == "10.0.19042" (
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msssmbios" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\InstallService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\StorSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ALG" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\COMSysApp" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Everything" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppIDSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcbService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NgcSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NgcCtnrSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\fdpHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FDResPub" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\dot3svc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WiaRpc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\upnphostc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TabletImputService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PolicyAgent" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SensorSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\slisvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SENS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Upnphost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxNetApiSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DusmSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrikWks" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MapsBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AJRouter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Autotimesvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\aXiNSTsv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bdesv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BTAGService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BthAvctpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BTHSERV" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cbdhsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CertPropSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CscService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicePickerUser" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceFlowUser" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Fax" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\fhsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HvHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\icssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IFSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LLTDSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lmhost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msIscsi" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\p2pimsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\perceptionsimulation" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PhoneSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PNRPAutoReg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PrintNotify" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PushToInstall" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RasAuto" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RetailDemo" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RmSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SCardSvr" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ScDeviceEnum" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ScPolicySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SDRSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecutityHealthService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\semGRsVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SensorDataService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SensorService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SessionEnv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedRealitySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SmsRouter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\spectrum" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SSDPSRV" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tabletinputService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TapiSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TermService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UmRdpService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VacSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WalletService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WarpJITSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wbengine" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinRM" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wisvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wlpasvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WMPNetworkSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\workfolderssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpcMonSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WPDBusEnum" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WwanSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrkWks" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\sppsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\fontCache" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DispBrokerDektop" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppXSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BDESVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XboxGipSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WManSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wlidsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WFDSConMgrSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ErrDev" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SensrSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LxpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IpxlatCfgSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GraphicsPerfSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DmEnrollmentSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DisplayEnhancementService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevQueryBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WpnUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UserDataSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ClipSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UdkUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UnistoreSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DevicePickerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceAssociationBrokerSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ConsentUxUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvcc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CaptureService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CredentialEnrollmentManagerUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CDPUserSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t REG_DWORD /d "4" /f
)
for /f "tokens=4-9 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
REM windows 8.1
if "%version%" == "6.3.9600" (
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f	
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AelookupSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppHostSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppMgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppReadiness" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppSVc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\aspnet_state" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IEEtwCollectorService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KtmRm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MpsSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MSDTC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Msiserver" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MsKeyboardFilter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NcdAutoSetup" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\netprofm" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wudfsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WEPHOSTSVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WcsPlugInService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wbengine" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WAS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\w3logsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\UI0Detect" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TimeBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\THREADORDER" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\svsc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMPTRAP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ShellHWDetection" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RpcLocator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\QWAVE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pla" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\perfHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DeviceInstall" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\smphost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\sppsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventSystem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AppHostSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t REG_DWORD /d "0" /f
)
REM windows 7 7601
if "%version%" == "6.1.7601" (
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\acpiex" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FileCrypt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\afunix" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\circlass" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\b06bdrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HTTP" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tcpipreg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CLFS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Beep" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\pcw" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\cdrom" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tunnel" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msisadrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\eventlog" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PcaSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\clr_optimization_v4.0.30319_32" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\clr_optimization_v4.0.30319_64" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Schedule" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sppsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Themes" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\aspnet_state" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\clr_optimization_v2.0.50727_32" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\clr_optimization_v2.0.50727_64" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetMsmqActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetPipeActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpActivator" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetTcpPortSharing" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AeLookupSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bthserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hidserv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IPBusEnum" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\KeyIso" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\msiserver" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netman" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NETPROFM" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PeerDistSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfHost" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ProtectedStorage" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\seclogon" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\sppuinotify" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\swprv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\THREADORDER" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TrustedInstaller" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VaultSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vds" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSS" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WcsPluginService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wecsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxysVC" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Wlansvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wmiApSrv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wudfsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bravem" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\brave" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\GoogleChromeElevationService" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MozillaMaintenance" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCANetwork" /t REG_DWORD /d "0" /f
)

::Disable Telemetry
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t Reg_DWORD /d "0" /f >nul
echo Disable Telementry

echo Advanced Services
goto :FinishedDebloat
