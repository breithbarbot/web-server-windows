@ECHO OFF
echo Stoping NGINX...
:: http://nginx.org/en/docs/windows.html
set prg=nginx.exe
QPROCESS "%prg%">NUL
IF %errorlevel% EQU 0 (
	echo "Process (%prg%) stoping..."
	cd "C:\server\nginx"
	nginx.exe -s quit
)
