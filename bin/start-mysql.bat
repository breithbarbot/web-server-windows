@echo off
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
:: Future mistake? https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html
:: https://mariadb.com/kb/en/library/running-mariadb-from-the-build-directory/
echo Starting MySQL...

net start mysql

set prg=mysqld.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not start service."
) else if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) already starting!"
) else (
	echo "Process (%prg%) service started successfully."
)

:: For debug
::cd "C:/server/mysql/bin"
::mysqld.exe --defaults-file=C:/server/mysql/bin/my.ini --log-error=C:/server/var/log/mysql/ --console
