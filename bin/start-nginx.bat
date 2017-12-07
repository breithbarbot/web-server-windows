@ECHO OFF
ECHO Starting NGINX...
:: http://nginx.org/en/docs/windows.html
set prg=nginx.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	echo "Process (%prg%) starting..."
	cd "C:\server\nginx"
	start %prg%
) else (
	echo "Process (%prg%) already starting..."
)
