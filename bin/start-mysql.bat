@ECHO OFF
ECHO Starting MySQL...
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
:: Future mistake? https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html
:: https://mariadb.com/kb/en/library/running-mariadb-from-the-build-directory/
set prg=mysqld.exe
QPROCESS "%prg%">NUL
IF %errorlevel% GTR 0 (
	echo "Process (%prg%) starting..."
	cd "C:\server\mysql\bin"
	%prg% --defaults-file=C:\server\mysql\bin\my.ini --log-error=C:\server\var\log\mysql\ 
) else (
	echo "Process (%prg%) already starting..."
)
