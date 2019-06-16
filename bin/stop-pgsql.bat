@echo off
echo Stoping PostgreSQL...

net stop PostgreSQL

set prg=pg_ctl.exe
if "%errorlevel%" GTR "2" (
	echo "Process (%prg%) could not stop service."
) else if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) already stopping!"
) else (
	echo "Process (%prg%) service successfully stopped."
)
