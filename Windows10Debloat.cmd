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



rem set up working directory in temp

cd %Temp%

if exist Debloater (
   RMDIR "Debloater" /S /Q
)

mkdir Debloater

cd Debloater


:DEBLOAT

rem debloat using https://github.com/Sycnex/Windows10Debloater
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
echo Debloating provided by https://github.com/Sycnex/Windows10Debloater

PowerShell.exe -command "Invoke-WebRequest https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip -OutFile "%cd%"temp.zip"
PowerShell.exe -command "Expand-Archive -Force %cd%temp.zip %cd% "
ren Windows10Debloater-master Windows10Debloater
cd Windows10Debloater

rem set varibles for the execution
set "script=.\Windows10SysPrepDebloater.ps1 -Debloat -Privacy"
rem execute
PowerShell.exe -ExecutionPolicy Unrestricted -command ""%cd%""/""%script%" -verb RunAs

rem transfer to neteowrk cleaning
:DEBLOATNEXT

:NETWORK

echo " .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. "
echo "| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |"
echo "| | ____  _____  | || |  _________   | || |  _________   | || | _____  _____ | || |     ____     | || |  _______     | || |  ___  ____   | |"
echo "| ||_   \|_   _| | || | |_   ___  |  | || | |  _   _  |  | || ||_   _||_   _|| || |   .'    `.   | || | |_   __ \    | || | |_  ||_  _|  | |"
echo "| |  |   \ | |   | || |   | |_  \_|  | || | |_/ | | \_|  | || |  | | /\ | |  | || |  /  .--.  \  | || |   | |__) |   | || |   | |_/ /    | |"
echo "| |  | |\ \| |   | || |   |  _|  _   | || |     | |      | || |  | |/  \| |  | || |  | |    | |  | || |   |  __ /    | || |   |  __'.    | |"
echo "| | _| |_\   |_  | || |  _| |___/ |  | || |    _| |_     | || |  |   /\   |  | || |  \  `--'  /  | || |  _| |  \ \_  | || |  _| |  \ \_  | |"
echo "| ||_____|\____| | || | |_________|  | || |   |_____|    | || |  |__/  \__|  | || |   `.____.'   | || | |____| |___| | || | |____||____| | |"
echo "| |              | || |              | || |              | || |              | || |              | || |              | || |              | |"
echo "| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |"
echo " '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' "

echo  ######## Releasing IP Addresses
ipconfig /release
ipconfig /release6

echo  Renewing IP Addresses 
ipconfig /renew
ipconfig /renew6

echo  Deleting Address Translation tables 
arp -d *

echo  NetBIOS / WINS - Deleting and Refreshing Cache 

nbtstat -R
nbtstat -RR

echo  Deleting DNS resolver cache 
ipconfig /flushdns

echo  Refresh DHCP leases and re-registering DNS names 
ipconfig /registerdns

rem set dns

echo setting dns

netsh interface ipv4 add dnsserver "Local Area Connection" 8.8.8.8
netsh interface ipv6 add dnsserver "Local Area Connection" 2002:0:0:0:0:0:808:808

netsh interface ipv4 add dnsserver "Wireless Network Connection" 8.8.4.4
netsh interface ipv6 add dnsserver "Wireless Network Connection" 2002:0:0:0:0:0:808:404

rem wait for connection reestablishment

set target=www.google.com
echo Waiting for connection..
:ping
<nul set /p strTemp=.
timeout 2 > NUL
ping %target% -n 1 | find "TTL="
if errorlevel==1 goto ping

echo network-ops complete

goto NETWORKNEXT


rem network next
:NETWORKNEXT
rem network next



goto END
:END
echo all ops complete!
echo "eeeeeeeeee_____eeeeeeeeeeeeeeeeeeee_____eeeeeeeeeeeeeeeeeeee_____eeeeeeeeee"
echo "eeeeeeeee/\eeee\eeeeeeeeeeeeeeeeee/\eeee\eeeeeeeeeeeeeeeeee/\eeee\eeeeeeeee"
echo "eeeeeeee/::\eeee\eeeeeeeeeeeeeeee/::\____\eeeeeeeeeeeeeeee/::\eeee\eeeeeeee"
echo "eeeeeee/::::\eeee\eeeeeeeeeeeeee/::::|eee|eeeeeeeeeeeeeee/::::\eeee\eeeeeee"
echo "eeeeee/::::::\eeee\eeeeeeeeeeee/:::::|eee|eeeeeeeeeeeeee/::::::\eeee\eeeeee"
echo "eeeee/:::/\:::\eeee\eeeeeeeeee/::::::|eee|eeeeeeeeeeeee/:::/\:::\eeee\eeeee"
echo "eeee/:::/__\:::\eeee\eeeeeeee/:::/|::|eee|eeeeeeeeeeee/:::/ee\:::\eeee\eeee"
echo "eee/::::\eee\:::\eeee\eeeeee/:::/e|::|eee|eeeeeeeeeee/:::/eeee\:::\eeee\eee"
echo "ee/::::::\eee\:::\eeee\eeee/:::/ee|::|eee|e_____eeee/:::/eeee/e\:::\eeee\ee"
echo "e/:::/\:::\eee\:::\eeee\ee/:::/eee|::|eee|/\eeee\ee/:::/eeee/eee\:::\e___\e"
echo "/:::/__\:::\eee\:::\____\/::e/eeee|::|eee/::\____\/:::/____/eeeee\:::|eeee|"
echo "\:::\eee\:::\eee\::/eeee/\::/eeee/|::|ee/:::/eeee/\:::\eeee\eeeee/:::|____|"
echo "e\:::\eee\:::\eee\/____/ee\/____/e|::|e/:::/eeee/ee\:::\eeee\eee/:::/eeee/e"
echo "ee\:::\eee\:::\eeee\eeeeeeeeeeeeee|::|/:::/eeee/eeee\:::\eeee\e/:::/eeee/ee"
echo "eee\:::\eee\:::\____\eeeeeeeeeeeee|::::::/eeee/eeeeee\:::\eeee/:::/eeee/eee"
echo "eeee\:::\eee\::/eeee/eeeeeeeeeeeee|:::::/eeee/eeeeeeee\:::\ee/:::/eeee/eeee"
echo "eeeee\:::\eee\/____/eeeeeeeeeeeeee|::::/eeee/eeeeeeeeee\:::\/:::/eeee/eeeee"
echo "eeeeee\:::\eeee\eeeeeeeeeeeeeeeeee/:::/eeee/eeeeeeeeeeee\::::::/eeee/eeeeee"
echo "eeeeeee\:::\____\eeeeeeeeeeeeeeee/:::/eeee/eeeeeeeeeeeeee\::::/eeee/eeeeeee"
echo "eeeeeeee\::/eeee/eeeeeeeeeeeeeeee\::/eeee/eeeeeeeeeeeeeeee\::/____/eeeeeeee"
echo "eeeeeeeee\/____/eeeeeeeeeeeeeeeeee\/____/eeeeeeeeeeeeeeeeee~~eeeeeeeeeeeeee"
echo "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
goto CLEANUP

:CLEANUP 
rem delete temp files
cd %temp%
if exist Debloater (
   RMDIR "Debloater" /S /Q
)
goto EOF

:EOF
echo "eeeeeeeeee_____eeeeeeeeee"
echo "eeeeeeeee/\eeee\eeeeeeeee"
echo "eeeeeeee/::\eeee\eeeeeeee"
echo "eeeeeee/::::\eeee\eeeeeee"
echo "eeeeee/::::::\eeee\eeeeee"
echo "eeeee/:::/\:::\eeee\eeeee"
echo "eeee/:::/__\:::\eeee\eeee"
echo "eee/::::\eee\:::\eeee\eee"
echo "ee/::::::\eee\:::\eeee\ee"
echo "e/:::/\:::\eee\:::\eeee\e"
echo "/:::/__\:::\eee\:::\____\"
echo "\:::\eee\:::\eee\::/eeee/"
echo "e\:::\eee\:::\eee\/____/e"
echo "ee\:::\eee\:::\eeee\eeeee"
echo "eee\:::\eee\:::\____\eeee"
echo "eeee\:::\eee\::/eeee/eeee"
echo "eeeee\:::\eee\/____/eeeee"
echo "eeeeee\:::\eeee\eeeeeeeee"
echo "eeeeeee\:::\____\eeeeeeee"
echo "eeeeeeee\::/eeee/eeeeeeee"
echo "eeeeeeeee\/____/eeeeeeeee"
echo "eeeeeeeeeeeeeeeeeeeeeeeee"
exit