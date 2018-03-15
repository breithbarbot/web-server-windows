@echo off
echo Stoping PHP FastCGI...
set prg=php-cgi.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" EQU "0" (
	echo "Process (%prg%) stoping..."

	cd "C:/server/php"
	taskkill /f /IM %prg%
) else (
    echo "Process (%prg%) is not currently running."
)
