@echo off
echo Starting PostgreSQL...
set prg=pg_ctl.exe
QPROCESS "%prg%">NUL
if "%errorlevel%" GTR "0" (
	echo "Process (%prg%) starting..."

	cd "C:/server/pgsql/bin"
	%prg% -D ../data -l fichier_de_trace start
) else (
	echo "Process (%prg%) already starting..."
)
