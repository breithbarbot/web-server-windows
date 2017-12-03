@ECHO OFF
ECHO Starting MySQL...
cd "C:\server\mysql\bin"
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
set prg=mysqld.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	%prg% --standalone --log-basename=C:/server/var/log/mysql/
) else (
	echo "Process (%prg%) already starting..."
)
