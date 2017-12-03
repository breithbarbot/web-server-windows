@ECHO OFF
ECHO Stoping PHP FastCGI...
cd "C:\server\php"
taskkill /f /IM php-cgi.exe
