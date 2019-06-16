@echo off

echo -----------------------
echo Stoping all services...
echo -----------------------

echo.
echo.

call "C:\server\bin\stop-nginx.bat"

echo.
echo.

call "C:\server\bin\stop-php-fcgi.bat"

echo.
echo.

call "C:\server\bin\stop-mariadb.bat"

echo.
echo.

call "C:\server\bin\stop-pgsql.bat"

echo.
echo.

pause
