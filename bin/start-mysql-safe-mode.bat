@ECHO OFF
ECHO Starting MySQL (Safe mode)...
cd "C:\server\mysql\bin"
set prg=mysqld.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	%prg% --safe-mode --skip-grant-tables --log-basename=C:/server/var/log/mysql/
) else (
	echo "Process (%prg%) already starting..."
)
