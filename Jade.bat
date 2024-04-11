@echo off
setlocal

rem Set variables for downloading MSCOMCTL.OCX
set "url=https://github.com/lht99/jade/raw/main/MSCOMCTL.OCX"
set "filename=MSCOMCTL.OCX"
set "tempfile=%TEMP%\%filename%"

rem Download MSCOMCTL.OCX using curl
curl -L -o "%tempfile%" "%url%"

rem Check if download was successful
if %errorlevel% neq 0 (
    echo Failed to download MSCOMCTL.OCX.
    exit /b 1
)

rem Check if downloaded file size is correct
for %%I in ("%tempfile%") do set "download_size=%%~zI"
if %download_size% lss 1 (
    echo Downloaded file is empty.
    exit /b 1
)

rem Copy MSCOMCTL.OCX to C:\Windows\SysWOW64
copy "%tempfile%" C:\Windows\SysWOW64

rem Check if copy was successful
if %errorlevel% neq 0 (
    echo Failed to copy MSCOMCTL.OCX.
    exit /b 1
)

rem Set variables for additional files
set "source_folder=C:\Program Files (x86)\MDI Jade 6"
set "destination_folder=C:\Windows\SysWOW64"

rem Copy additional files from source to destination
copy "%source_folder%\COMDLG32.OCX" "%destination_folder%"
copy "%source_folder%\MSCOMCT2.OCX" "%destination_folder%"
copy "%source_folder%\THREED32.OCX" "%destination_folder%"

rem Check if additional copies were successful
if %errorlevel% neq 0 (
    echo Failed to copy additional files.
    exit /b 1
)

rem Register OCX files without displaying alerts
regsvr32.exe /s "%destination_folder%\MSCOMCTL.OCX"
regsvr32.exe /s "%destination_folder%\COMDLG32.OCX"
regsvr32.exe /s "%destination_folder%\MSCOMCT2.OCX"
regsvr32.exe /s "%destination_folder%\THREED32.OCX"

rem Check if registration was successful
if %errorlevel% neq 0 (
    echo Failed to register OCX files.
    exit /b 1
)

echo Files downloaded, copied, and registered successfully.
exit /b 0
