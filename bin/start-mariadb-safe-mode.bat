@echo off
echo Starting MariaDB (Safe mode)...

net stop mariadb

set prg=mysqld.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not stop service."
) else (
	cd "C:/server/mariadb/bin"
	%prg% --safe-mode --skip-grant-tables --log-basename=C:/server/var/log/mariadb --console
)
