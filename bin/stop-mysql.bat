@ECHO OFF
ECHO Stoping MySQL...
cd "C:\server\mysql\bin"
:: https://dev.mysql.com/doc/refman/5.7/en/windows-start-command-line.html
mysqladmin.exe -u root shutdown
