@ECHO OFF
ECHO Stoping NGINX...
cd "C:\server\nginx"
taskkill /f /IM php-cgi.exe
