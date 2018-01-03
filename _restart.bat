@ECHO OFF
ECHO Restarting all services...

call "C:\server\bin\stop-php-fcgi.bat"
call "C:\server\bin\stop-mysql.bat"

PAUSE

ECHO Restarting NGINX...
cd "C:\server\nginx"
start nginx.exe -s reload

PAUSE

call "C:\server\bin\start-php-fcgi.bat"
call "C:\server\bin\start-mysql.bat"

PAUSE
