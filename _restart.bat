@echo off

echo --------------------------
echo Restarting all services...
echo --------------------------

echo.
echo.

call "C:\server\bin\stop-nginx.bat"
call "C:\server\bin\stop-php-fcgi.bat"
call "C:\server\bin\stop-mysql.bat"

echo.
echo.

pause

echo.
echo.

call "C:\server\bin\start-nginx.bat"
call "C:\server\bin\start-php-fcgi.bat"
call "C:\server\bin\start-mysql.bat"

echo.
echo.

pause
