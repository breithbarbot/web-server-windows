@echo off
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
:: Future mistake? https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html
echo Stoping MariaDB...

net stop mariadb

set prg=mysqld.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not stop service."
) else if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) already stopping!"
) else (
	echo "Process (%prg%) service successfully stopped."
)
