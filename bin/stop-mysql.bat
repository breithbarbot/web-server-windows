@ECHO OFF
echo Stoping MySQL...
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
:: Future mistake? https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html
set prg=mysqld.exe
QPROCESS "%prg%">NUL
IF %errorlevel% EQU 0 (
	echo "Process (%prg%) stoping..."
	::cd "C:\server\mysql\bin"
	::mysqladmin.exe -u root shutdown
	net stop mysql
) else (
    echo "Process (%prg%) is not currently running."
)
