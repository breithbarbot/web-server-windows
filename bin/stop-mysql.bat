@ECHO OFF
ECHO Stoping MySQL...
cd "C:\server\mysql\bin"
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
:: Future mistake? https://dev.mysql.com/doc/refman/5.7/en/replication-howto-additionalslaves.html
mysqladmin.exe -u root shutdown
