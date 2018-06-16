@echo off

echo ------------------------
echo Starting all services...
echo ------------------------

echo.
echo.

call "C:\server\bin\start-nginx.bat"

echo.
echo.

call "C:\server\bin\start-php-fcgi.bat"

echo.
echo.

call "C:\server\bin\start-mysql.bat"

echo.
echo.

pause
