@ECHO OFF
ECHO Starting all services...

call "C:\server\bin\start-php-fcgi.bat"
call "C:\server\bin\start-nginx.bat"
call "C:\server\bin\start-mysql.bat"

PAUSE
