@echo off
echo Starting PostgreSQL...

net start PostgreSQL

set prg=pg_ctl.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not start service."
) else if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) already starting!"
) else (
	echo "Process (%prg%) service started successfully."
)

:: For debug
:: cd C:\server\pgsql\bin
:: pg_ctl -D ../data -l trace_file start
