@echo off
echo Stoping PostgreSQL...
set prg=pg_ctl.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" EQU "0" (
	echo "Process (%prg%) stoping..."

	cd "C:/server/pgsql/bin"
	%prg% -D ../data -l fichier_de_trace stop
) else (
    echo "Process (%prg%) is not currently running."
)
