@echo off
echo Starting MySQL (Safe mode)...

net stop mysql

set prg=mysqld.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not stop service."
) else (
	cd "C:/server/mysql/bin"
	%prg% --safe-mode --skip-grant-tables --log-basename=C:/server/var/log/mysql --console
)
