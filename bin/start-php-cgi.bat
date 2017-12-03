@ECHO OFF
ECHO Starting PHP FastCGI...
cd "C:\server\php"
set prg=php-cgi.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	echo "Process (%prg%) starting..."
	C:\server\bin\RunHiddenConsole.exe %prg% -b 127.0.0.1:9000
) else (
	echo "Process (%prg%) already starting..."
)
