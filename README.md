# Web Server for Windows

> A simple web server for windows with Nginx, PHP, MariaDB and phpMyAdmin.

<br>

- Nginx
- PHP (Recommanded PHP >= 7.3.X)
	- cURL
	- OPCache
	- APCu
	- Sendmail
	- Composer
- MariaDB
- phpMyAdmin (Recommanded phpMyAdmin >= 4.8.X)
	- With config for *phpMyAdmin configuration storage*

<br>

## Getting

```bash
cmd
cd C:\
git clone https://gitlab.com/breithbarbot/web-server-windows.git server
```

<br>

## Download
- Download the source files and extract to the each respective folder
	- **C:\server\nginx**: [Nginx](http://nginx.org/en/download.html)
	- **C:\server\php**: [[Recommanded PHP 7.3.X] PHP (x64 Thread Safe)](http://windows.php.net/download)
		- The VC15 builds require to have the Visual C++ Redistributable for [Visual Studio 2017 x64](https://aka.ms/vs/15/release/VC_redist.x64.exe)
	- **C:\server\mariadb**: [MariaDB (ZIP file - Windows x86_64)](https://downloads.mariadb.org)
	- **C:\server\phpmyadmin**: [phpMyAdmin](https://www.phpmyadmin.net/downloads)

<br>

## Configuration

### General

- Update your PATH system variable
    - `C:\server\mariadb\bin`
	- `C:\server\nginx`
	- `C:\server\php`

Restart your system.

<br>

### Nginx

> **nginx-1.X.X.zip** in: `C:\server\nginx`.

Execute: `cp C:\server\nginx\conf\nginx.conf C:\server\nginx\conf\nginx.conf.bak`

#### Configuration

- Edit nginx files:
    - [nginx documentation](http://nginx.org/en/docs/)
	- Edit:
        ```nginx
        # C:\server\nginx\conf\nginx.conf
        
        #user  nobody;
        # Calcul: grep processor /proc/cpuinfo | wc -l
        worker_processes  auto;
        
        error_log  C:/server/var/log/nginx/error.log warn;
        pid        C:/server/var/log/nginx/nginx.pid;
        
        events {
            # Definition of the maximum number of simultaneous connections (Use the command to know the maximum value of your server: `ulimit -n`)
            worker_connections  1024;
            multi_accept        on;
        }
        
        http {
            ##
            # ngx_http_charset_module
            ##
            charset  utf-8;
            
            
            ##
            # ngx_http_core_module
            ##
            client_max_body_size  500M;
            include               mime.types;
            default_type          application/octet-stream;
            keepalive_timeout     65s;
            sendfile              on;
            #tcp_nopush           on;
            
            
            ##
            # ngx_http_gzip_module
            ##
            gzip             on;
            gzip_proxied     any;
            gzip_comp_level  6;
            gzip_types       text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
            
            
            ##
            # ngx_http_log_module
            ##
            #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
            #                  '$status $body_bytes_sent "$http_referer" '
            #                  '"$http_user_agent" "$http_x_forwarded_for"';
            #access_log        C:/server/var/log/nginx/http_access.log  main;
            error_log          C:/server/var/log/nginx/http_error.log  warn;
            
            
            ##
            # Virtual Host Configs
            ##
            include  C:/server/nginx/conf/conf.d/*.conf;
        }
        ```

##### Virtual Host

> Place your configuration files in the `conf.d` directory.

- Create:
    ```nginx
    # C:\server\nginx\conf\conf.d\default.conf

    # HTTP Server
    server {
        listen       80;
        server_name  localhost;
        
        
        root   c:/server/www;
        
        
        location / {
            index  index.html index.htm index.php;
        }
        
        
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
        
        
        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
            include        fastcgi_params;
        }
        
        
        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
            deny  all;
        }
        
        
        #access_log  C:/server/var/log//nginx/localhost.access.log;
        error_log   C:/server/var/log//nginx/localhost.error.log warn;
    }
    ```

- Create (**DEPRECATED !** Use [PHP's built-in Web Server](https://symfony.com/doc/current/setup/built_in_web_server.html)):
    ```nginx
    # C:\server\nginx\conf\conf.d\symfony.conf

    # For Symfony 2/3/4 apps
    #
    server {
        listen       81;
        server_name  localhost;
        
        
        root  C:/server/www;
        
        
        location ~ /(app|app_dev|config|public/index)\.php(/|$) {
            fastcgi_pass             127.0.0.1:9000;
            fastcgi_index            index.php;
            fastcgi_param            SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
            fastcgi_param            DOCUMENT_ROOT $realpath_root;
            fastcgi_split_path_info  ^(.+\.php)(/.*)$;
            include                  fastcgi_params;
        }
        
        
        location ~ \.php$ {
            return 404;
        }
        
        
        location ~ /\.ht {
            deny  all;
        }
        
        
        #error_log   C:/server/var/log//nginx/localhost.symfony.error.log;
        access_log  C:/server/var/log//nginx/localhost.symfony.access.log;
    }
    ```

<br>

### PHP

> **php-7.X.X-Win32-VC15-x64.zip** in: `C:\server\php`.

Execute: `cp C:\server\php\php.ini-development C:\server\php\php.ini`

#### Configuration

- [List of Supported Timezones](https://secure.php.net/manual/en/timezones.php)
- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [PHP]
    realpath_cache_size = 10M
    realpath_cache_ttl = 300
    error_log = "C:\server\var\log\php_errors.log"
    post_max_size = 500M
    include_path = ".;C:\server\php\pear"
    extension_dir = "ext"
    sys_temp_dir = "C:\server\var\tmp"
    upload_tmp_dir = "C:\server\var\tmp"
    upload_max_filesize = 500M
    extension=bz2
    extension=curl
    extension=fileinfo
    extension=intl
    extension=mbstring
    extension=exif
    
    [Date]
    date.timezone = Europe/Paris
    
    [Session]
    session.save_path = "C:\server\var\tmp"
    session.gc_maxlifetime = 86400
    
    [soap]
    soap.wsdl_cache_dir="C:\server\var\tmp"
    ```

#### PEAR

- Create folder: `mkdir C:\server\php\pear`
- [PEAR Packages](https://pear.php.net/packages.php)

#### cURL / SSL

- Download: https://curl.haxx.se/docs/caextract.html
- Save file in: **C:\server\php\extras\ssl\cacert.pem**
- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [PHP]
    extension=openssl
    
    [curl]
    curl.cainfo = "C:\server\php\extras\ssl\cacert.pem"
    
    [openssl]
    openssl.cafile="C:\server\php\extras\ssl\cacert.pem"
    ```

#### OPCache

- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [opcache]
    zend_extension=opcache
    opcache.enable=1
    opcache.enable_cli=1
    opcache.memory_consumption=256
    opcache.interned_strings_buffer=16
    opcache.max_accelerated_files=30000
    opcache.error_log="C:\server\var\log\php_opcache_errors.log"
    ```

#### APCu

- Download [7.3 Thread Safe (TS) x64](https://pecl.php.net/package/APCu)
- Save file in: `C:\server\php\ext\php_apcu.dll`
- Edit at the end:
    ```ini
    ; C:\server\php\php.ini
    
    [apcu]
    extension=apcu
    apc.enabled=1
    apc.enable_cli=1
    apc.shm_size=64M
    apc.ttl=3600  
    ```

#### Sendmail

- Download: https://www.glob.com.au/sendmail/
    - Copy all files in: **C:\server\sendmail**
- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [mail function]
    sendmail_path = "\"C:\server\sendmail\sendmail.exe\" -t"
    ```
- Edit file: `C:\server\sendmail\sendmail.ini`

#### Composer

- Download and install: https://getcomposer.org/download/
	- The default installation folder/file is: **C:\ProgramData\ComposerSetup\bin\composer.phar**
	- If you have this error during install: **Signature mismatch, could not verify the phar file integrity**
		- Comment temporarily: `zend_extension=opcache` in *C:\server\php\php.ini*, run Composer install and after, uncomment.

#### Xdebug

- Download [PHP 7.3 VC15 TS (64 bit)](https://xdebug.org/download.php)
- Save file in: `C:\server\php\ext\php_xdebug.dll`
- Add at the end:
    ```ini
    ; C:\server\php\php.ini
    
    [Xdebug]
    zend_extension=xdebug
    xdebug.profiler_enable_trigger = 1
    xdebug.profiler_output_dir = "C:/server/var/tmp/profiler"
    xdebug.remote_host=127.0.0.1
    xdebug.remote_port=9001
    
    ; Display all the tree
    xdebug.var_display_max_depth = -1
    xdebug.var_display_max_children = -1
    xdebug.var_display_max_data = -1
    ```

<br>

### MariaDB

> **mariadb-10.X.X-winx64.zip** in: `C:\server\mariadb`.

- [Documentation](https://mariadb.com/kb/en/library/documentation/)

#### Installation
```bash
# Execute in admin!

C:/server/mariadb/bin/mysql_install_db.exe --datadir=C:/server/mariadb/data --service=MariaDB
```

- MariaDB service is create!
    - Start (admin): `net start MariaDB`
    - Stop (admin): `net stop MariaDB`

- For remove MariaDB a service (In admin)
    - `C:/server/mariadb/bin/mysqld.exe --remove`

#### Configuration
- Edit:
    ```ini
    ; C:\server\mariadb\data\my.ini
    
    [mysqld]
    datadir=C:/server/mariadb/data
    
    socket=C:/server/var/tmp/mariadb.sock
    
    tmpdir=C:/server/var/tmp
    
    long_query_time=10
    
    key_buffer_size=256M
    sort_buffer_size=4M
    read_buffer_size=2M
    table_open_cache=400
    
    query_cache_limit=16M
    query_cache_size=64M
    
    collation-server=utf8mb4_general_ci
    character-set-server=utf8mb4
    
    [client]
    socket=C:/server/var/tmp/mariadb.sock
    plugin-dir=C:/server/mariadb/lib/plugin
    ```

- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [PHP]
    extension=mysqli
    extension=pdo_mysql
    ```

<br>

- Default login: **root**/<no_password>
- For set password or unset password ?
	1. Start *mariadb* server **in admin** in safe mode.
		- `C:/server/bin/start-mariadb-safe-mode.bat`
	2. Run commands
		- For set password:

			```bash
			mysql -u root -p

			USE mysql;
			UPDATE user SET `password` = PASSWORD('YOUR_PASSWORD') WHERE `User` = 'root';
			FLUSH PRIVILEGES;
			quit;
			```
		- For unset password:
			- `UPDATE user SET password = '' WHERE User = 'root';`
	3. Stop ant restart *mariadb*.

#### Debug?

```bash
C:/server/mariadb/bin/mysqld.exe --defaults-file=C:/server/mariadb/data/my.ini --log-error=C:/server/var/log/mariadb/ --console
```

<br>

### phpMyAdmin

> **phpMyAdmin-4.X.X-all-languages.zip** in: `C:\server\phpmyadmin`.

- Creation of a symbolic link
	- Execute (In **cmd** in **Administrator**): `mklink /D C:\server\www\phpmyadmin C:\server\phpmyadmin`

#### Configuration (Automatique)

- [Using Setup script](https://docs.phpmyadmin.net/en/latest/setup.html#using-setup-script)

#### Configuration (Manual)

- Execute:
	- `cp C:/server/phpmyadmin/config.sample.inc.php C:/server/phpmyadmin/config.inc.php`

- [phpMyAdmin Blowfish Secret Generator](https://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator)
- Edit/create:
    ```php
    // C:\server\phpmyadmin\config.inc.php
    
    /**
    * This is needed for cookie based authentication to encrypt password in
    * cookie. Needs to be 32 chars long.
    */
    $cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
    
    /**
    * Servers configuration
    */
    $i = 0;
    
    /**
    * Server: localhost
    */
    $i++;
    /* Authentication type */
    $cfg['Servers'][$i]['auth_type'] = 'config';
    /* Server parameters */
    $cfg['Servers'][$i]['hide_db'] = 'information_schema|mysql|performance_schema|phpmyadmin';
    $cfg['Servers'][$i]['host'] = 'localhost';
    $cfg['Servers'][$i]['compress'] = false;
    $cfg['Servers'][$i]['user'] = 'root';
    // $cfg['Servers'][$i]['password'] = '';
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
    
    /**
    * phpMyAdmin configuration storage settings.
    */
    
    /* User used to manipulate with storage */
    // $cfg['Servers'][$i]['controlhost'] = '';
    // $cfg['Servers'][$i]['controlport'] = '';
    $cfg['Servers'][$i]['controluser'] = 'pma';
    $cfg['Servers'][$i]['controlpass'] = 'pmapass';
    
    /* Storage database and tables */
    $cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
    $cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
    $cfg['Servers'][$i]['relation'] = 'pma__relation';
    $cfg['Servers'][$i]['table_info'] = 'pma__table_info';
    $cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
    $cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
    $cfg['Servers'][$i]['column_info'] = 'pma__column_info';
    $cfg['Servers'][$i]['history'] = 'pma__history';
    $cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
    $cfg['Servers'][$i]['tracking'] = 'pma__tracking';
    $cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
    $cfg['Servers'][$i]['recent'] = 'pma__recent';
    $cfg['Servers'][$i]['favorite'] = 'pma__favorite';
    $cfg['Servers'][$i]['users'] = 'pma__users';
    $cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
    $cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
    $cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
    $cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
    $cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
    $cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
    
    /**
    * End of servers configuration
    */
    
    /**
    * Directories for saving/loading files from server
    */
    $cfg['UploadDir'] = 'import';
    $cfg['SaveDir'] = 'save';
    
    $cfg['MaxRows'] = 50;
    
    $cfg['DefaultLang'] = 'fr';
    
    $cfg['ShowPhpInfo'] = true;
    $cfg['ForceSSL'] = false;
    $cfg['Import']['charset'] = 'utf-8';
    $cfg['Export']['compression'] = 'gzip';
    $cfg['Export']['charset'] = 'utf-8';
    $cfg['NavigationTreeEnableGrouping'] = false;
    ```

    <br>

    - Run:

        ```bash
        mkdir C:\server\phpmyadmin\import
        mkdir C:\server\phpmyadmin\save
        ```

    <br>

    - Run: `C:/server/mariadb/bin/mysql.exe -u root < C:/server/phpmyadmin/sql/create_tables.sql`

	- Create a new **user/password** in phpMyAdmin for **phpMyAdmin configuration storage** with full privileges (without **GRANT** access) for the **phpmyadmin** database.
		- Update `$cfg['Servers'][$i]['controluser']` and `$cfg['Servers'][$i]['controlpass']` variables in `config.inc.php`

	- Delete DB (optional): **test**
	
	<br>
	
	- Optimisation
	    - http://localhost/phpmyadmin/server_status_advisor.php

<br>

## Start & Stop all servers

- Start (In admin): `C:/server/_start.bat`
- Stop (In admin): `C:/server/_stop.bat`

<br>

## In production environment

#### Nginx

- Edit:
    ```nginx
    # C:\server\nginx\conf\nginx.conf
    
    http {
        server_tokens off;
    }
    ```
    
    - Disabled `access_log` in your vhosts

#### PHP

- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [PHP]
    expose_php = Off
    error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
    display_errors = Off
    display_startup_errors = Off
    
    [mysqlnd]
    mysqlnd.collect_statistics = Off
    mysqlnd.collect_memory_statistics = Off
    
    [Assertion]
    zend.assertions = -1  
	```

<br>

## Active HTTPS (optional)

1. Create `ssl` folder in nginx folder and generate keys:
2. Execute:
    ```bash
    mkdir C:\server\nginx\ssl

    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
  
    openssl dhparam 2048 > dhparam.pem
    ```
3. Add new virtual host config in `C:\server\nginx\conf\conf.d\app.localhost.conf` file:
    ```
    # HTTPS Server
    server {
        listen               443 ssl http2 default_server;
        listen               [::]:443 ssl http2 default_server;
        server_name          app.localhost;
        ssl                  on;
        ssl_certificate      c:/server/nginx/ssl/localhost.crt;
        ssl_certificate_key  c:/server/nginx/ssl/localhost.key;
    
        # Diffie-Hellman parameter for DHE ciphersuites, recommended 2048 bits
    	ssl_dhparam c:/server/nginx/ssl/dhparam.pem;
    
    	# secure settings (A+ at SSL Labs ssltest at time of writing)
    	# see https://wiki.mozilla.org/Security/Server_Side_TLS#Nginx
    	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    	ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-CAMELLIA256-SHA:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-SEED-SHA:DHE-RSA-CAMELLIA128-SHA:HIGH:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS';
    	ssl_prefer_server_ciphers on;
    
        # ...
    }
    ```
4. Add new redirect in `C:\Windows\System32\drivers\etc\hosts` file:
    ```
    127.0.0.1       app.localhost
    ::1             app.localhost
    ```
5. Open: https://app.localhost/

<br>

## For future update ?

1. Execute:

    ```bash
    cd C:\server
    git pull
    ```

2. Comparison between your config and the README.md doc

<br>

## Uninstall

1. Backup your DB(s) and project(s)
2. Kill all services
3. Remove entry your PATH system variable:
    - C:\server\mariadb\bin
    - C:\server\nginx
    - C:\server\php
4. Remove MariaDB service (in admin): `C:/server/mariadb/bin/mysqld.exe --remove`
5. Restart your system.
