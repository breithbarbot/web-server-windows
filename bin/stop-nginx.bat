@ECHO OFF
ECHO Stoping NGINX...
cd "C:\server\nginx"
:: start nginx.exe -s quit
taskkill /f /IM nginx.exe
