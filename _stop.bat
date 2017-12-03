@ECHO OFF
ECHO Soping all services...

call "C:\server\bin\stop-php-cgi.bat"
call "C:\server\bin\stop-nginx.bat"
call "C:\server\bin\stop-mysql.bat"

PAUSE
