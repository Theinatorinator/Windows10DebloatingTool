::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 4
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto getPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 3 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::


echo " .----------------. .----------------. .----------------. .----------------. .----------------. .----------------. .----------------. "  
echo "| .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. |"  
echo "| |  ________    | | |  _________   | | |   ______     | | |   _____      | | |     ____     | | |      __      | | |  _________   | |"  
echo "| | |_   ___ `.  | | | |_   ___  |  | | |  |_   _ \    | | |  |_   _|     | | |   .'    `.   | | |     /  \     | | | |  _   _  |  | |"  
echo "| |   | |   `. \ | | |   | |_  \_|  | | |    | |_) |   | | |    | |       | | |  /  .--.  \  | | |    / /\ \    | | | |_/ | | \_|  | |"  
echo "| |   | |    | | | | |   |  _|  _   | | |    |  __'.   | | |    | |   _   | | |  | |    | |  | | |   / ____ \   | | |     | |      | |"  
echo "| |  _| |___.' / | | |  _| |___/ |  | | |   _| |__) |  | | |   _| |__/ |  | | |  \  `--'  /  | | | _/ /    \ \_ | | |    _| |_     | |"  
echo "| | |________.'  | | | |_________|  | | |  |_______/   | | |  |________|  | | |   `.____.'   | | ||____|  |____|| | |   |_____|    | |"  
echo "| |              | | |              | | |              | | |              | | |              | | |              | | |              | |"  
echo "| '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' |"  
echo " '----------------' '----------------' '----------------' '----------------' '----------------' '----------------' '----------------' "  
echo Welcome to the windows 10 debloating utility
echo Debloating provided by https://github.com/Sycnex/Windows10Debloater
echo This quick runner was made by https://github.com/Theinatorinator 

echo Are you sure you want to continue?

CHOICE /C YN 

IF %ERRORLEVEL% EQU 1 goto CONTINUE
IF %ERRORLEVEL% EQU 2 goto END

:CONTINUE

if exist Windows10Debloater (
   RMDIR "Windows10Debloater" /S /Q
)

PowerShell.exe -command "Invoke-WebRequest https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip -OutFile "%cd%"temp.zip"
PowerShell.exe -command "Expand-Archive -Force %cd%temp.zip %cd% "
ren Windows10Debloater-master Windows10Debloater
Attrib +h %cd%\Windows10Debloater
cd Windows10Debloater


rem set varibles for the execution
set "script=.\Windows10SysPrepDebloater.ps1 -Debloat -Privacy"
rem execute
PowerShell.exe -ExecutionPolicy Unrestricted -command ""%cd%""/""%script%" -verb RunAs


rem cleanup
cd ..
echo Cleaning up
Attrib -h %cd%\Windows10Debloater
RMDIR "Windows10Debloater" /S /Q

echo Opertaion Complete!
pause

:END
exit