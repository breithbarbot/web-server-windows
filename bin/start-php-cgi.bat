@ECHO OFF
ECHO Starting PHP FastCGI...
cd "C:\server\php"
C:\server\bin\RunHiddenConsole.exe php-cgi.exe -b 127.0.0.1:9000
