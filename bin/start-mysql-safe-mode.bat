@echo off
echo Starting MySQL (Safe mode)...
set prg=mysqld.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) starting..."

	net stop mysql
	cd "C:/server/mysql/bin"
	%prg% --safe-mode --skip-grant-tables --log-basename=C:/server/var/log/mysql --console
) else (
	echo "Process (%prg%) already starting..."
)
