@ECHO OFF
ECHO Starting all services...

call "C:\server\bin\start-php-cgi.bat"
call "C:\server\bin\start-nginx.bat"
call "C:\server\bin\start-mysql.bat"

PAUSE
