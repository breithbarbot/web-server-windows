@ECHO OFF
ECHO Stoping NGINX...
cd "C:\server\nginx"
:: http://nginx.org/en/docs/windows.html
nginx.exe -s quit
