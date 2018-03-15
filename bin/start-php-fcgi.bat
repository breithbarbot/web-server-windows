@echo off
echo Starting PHP FastCGI...
set prg=php-cgi.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) starting..."

	cd "C:/server/php"
	C:/server/bin/RunHiddenConsole.exe %prg% -b 127.0.0.1:9000
) else (
	echo "Process (%prg%) already starting..."
)
