@ECHO OFF
ECHO Starting NGINX...
cd "C:\server\nginx"
:: http://nginx.org/en/docs/windows.html
set prg=nginx.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	start %prg%
) else (
	echo "Process (%prg%) already starting..."
)
