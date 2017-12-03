@ECHO OFF
ECHO Starting MySQL (Safe mode)...
cd "C:\server\mysql\bin"
start mysqld.exe --safe-mode --skip-grant-tables
