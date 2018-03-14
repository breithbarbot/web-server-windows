@ECHO OFF
echo Stoping PHP FastCGI...
set prg=php-cgi.exe
QPROCESS "%prg%">NUL
IF %errorlevel% EQU 0 (
	echo "Process (%prg%) stoping..."
	cd "C:\server\php"
	taskkill /f /IM %prg%
)
