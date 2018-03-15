@echo off
echo Stoping NGINX...
:: http://nginx.org/en/docs/windows.html
set prg=nginx.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" EQU "0" (
	echo "Process (%prg%) stoping..."

	cd "C:/server/nginx"
	nginx.exe -s quit
) else (
    echo "Process (%prg%) is not currently running."
)
