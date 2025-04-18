@echo off
chcp 65001 >nul
powershell echo. >nul
setlocal enabledelayedexpansion

:warning
Title WARNING: Safety Warning
color 4
echo WARNING: This will show your public IP address. Do not use while screensharing or video calling for safety!
echo Would you like to continue?
set /p input=[Y/N]: 

if /I "%input%" EQU "Y" (
    echo.
    timeout 1 >nul
    echo Proceeding.
    cls
    goto :start
) else (
    cls
	exit /b
)

:start
:: Define the folder path on the desktop
set folder_path=%USERPROFILE%\Desktop\SystemInfo
if not exist "%folder_path%" mkdir "%folder_path%"

:: Get Public IPv4 and IPv6
for /f "delims=" %%A in ('powershell -Command "(Invoke-WebRequest -UseBasicParsing -Uri 'https://api64.ipify.org?format=text').Content"') do set ipv4=%%A
set "ipv6=Not available"
for /f "delims=" %%A in ('powershell -Command "try { (Invoke-WebRequest -UseBasicParsing -Uri 'https://api64.ipify.org?format=text').Content } catch { '' }"') do (
    echo %%A | find ":" >nul
    if !errorlevel! == 0 (
        set "ipv6=%%A"
    )
)
:: Gather system info
for /f "delims=" %%A in ('powershell -Command "Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version | Format-List | Out-String -Width 300"') do echo %%A >> "%folder_path%\osinfo.txt"

for /f "delims=" %%A in ('powershell -Command "$sys = Get-CimInstance Win32_ComputerSystem; if ($sys.Manufacturer -eq 'System manufacturer' -or $sys.Model -eq 'System Product Name') { Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer,Product | Format-List | Out-String -Width 300 } else { $sys | Select-Object Manufacturer,Model | Format-List | Out-String -Width 300 }"') do echo %%A >> "%folder_path%\systeminfo.txt"

for /f "delims=" %%A in ('powershell -Command "Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors | Format-List | Out-String -Width 300"') do echo %%A >> "%folder_path%\cpuinfo.txt"

for /f "delims=" %%A in ('powershell -Command "$mem = Get-CimInstance Win32_ComputerSystem; [math]::Round($mem.TotalPhysicalMemory / 1GB, 2)"') do echo Total Physical Memory: %%A GB >> "%folder_path%\raminfo.txt"

for /f "delims=" %%A in ('powershell -Command "Get-CimInstance Win32_BIOS | Select-Object Manufacturer,SMBIOSBIOSVersion,ReleaseDate | Format-List | Out-String -Width 300"') do echo %%A >> "%folder_path%\biosinfo.txt"

for /f "delims=" %%A in ('powershell -Command "Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion | Format-List | Out-String -Width 300"') do echo %%A >> "%folder_path%\gpuinfo.txt"

for /f "delims=" %%A in ('powershell -Command "[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds | Out-String -Width 300"') do echo %%A >> "%folder_path%\displayinfo.txt"

:: Display results
cls
echo [31m[^+] [4;38;5;48m[System Information][0m
echo Public IPv4 Address: %ipv4%
echo Public IPv6 Address: %ipv6%
echo.

echo [31m[^+] [4;38;5;48m[Operating System Information][0m
type "%folder_path%\osinfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[System Manufacturer / Model][0m
type "%folder_path%\systeminfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[CPU Information][0m
type "%folder_path%\cpuinfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[RAM Information][0m
type "%folder_path%\raminfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[BIOS Information][0m
type "%folder_path%\biosinfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[GPU Information][0m
type "%folder_path%\gpuinfo.txt"
echo.

echo [31m[^+] [4;38;5;48m[Display Resolution][0m
type "%folder_path%\displayinfo.txt"
echo.

:: Clean up
rd /s /q "%folder_path%" >nul 2>&1

echo Created by @soowu.
pause
exit /b

:warningno
echo.
timeout 1 >nul
echo Closing..
exit /b

:error
cls
color 4
call :skull
echo.
echo ERROR:
echo A problem occurred at step %erl%.
echo Please report this to @soowu. on discord.
pause >nul
exit /b

:skull
echo                        ______
echo                    .-"      "-.
echo                   /            \
echo       _          '|              ''|          _
echo      ( \         '|,  .-.  .-.  ,''|         / )
echo       '> "=._     | )(__/  \__)( |     _.=" ''<
echo      (_/"=._"=._ '|/     /\     \''| _.="_.="\_)
echo             "=._ (_     ^^     _)"_.="
echo                 "=\__|IIIIII|__/="
echo                _.="| \IIIIII/ |"=._ 
echo      _     _.="_.="\          /"=._"=._     _
echo     ( \_.="_.="     `--------`     "=._"=._/ )
echo      '> _.="                            "=._ ''<
echo     (_/                                    \_)
