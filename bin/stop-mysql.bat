@ECHO OFF
ECHO Stoping MySQL...
cd "C:\server\mysql\bin"
:: start mysqld.exe -q
taskkill /f /IM mysqld.exe
