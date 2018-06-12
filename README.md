# Web Server for Windows

> A simple web server for windows with PHP, Nginx, MariaDB and phpMyAdmin.

<br>

- Nginx
- PHP (Recommanded PHP >= 7.2)
	- cURL
	- OPCache
	- APCu
	- Sendmail
	- Composer
- MariaDB
- phpMyAdmin (Recommanded phpMyAdmin >= 4.7.7)
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
	- **C:\server\php**: [[Recommanded PHP 7.2] PHP (x64 Thread Safe)](http://windows.php.net/download)
		- The VC15 builds require to have the Visual C++ Redistributable for [Visual Studio 2017 x64](https://aka.ms/vs/15/release/VC_redist.x64.exe)
	- **C:\server\mysql**: [MariaDB (ZIP file - Windows x86_64)](https://downloads.mariadb.org)
	- **C:\server\phpmyadmin**: [phpMyAdmin](https://www.phpmyadmin.net/downloads)

<br>

## Configuration

### General

- Update your PATH system variable
    - `C:\server\mysql\bin`
	- `C:\server\nginx`
	- `C:\server\php`

Restart your system.

<br>

### Nginx

> **nginx-1.X.X.zip** in: `C:\server\nginx`.

Execute: `cp C:\server\nginx\conf\nginx.conf C:\server\nginx\conf\nginx.conf.bak`

- Edit/create nginx files in: "C:\server\nginx"
    - [Core functionality](http://nginx.org/en/docs/ngx_core_module.html)
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
            multi_accept  on;
        }
        
        http {
            ##
            # Basic Settings
            ##
            sendfile on;
            #tcp_nopush on;
            #tcp_nodelay on;
            keepalive_timeout 65;
            types_hash_max_size 2048;
            server_tokens off;
            charset utf-8;
            
            ##
            # Buffers
            ##
            client_body_buffer_size 10K;
            client_header_buffer_size 1k;
            client_max_body_size 500M;
            large_client_header_buffers 2 1k;
            
            include       mime.types;
            default_type  application/octet-stream;
            
            ##
            # Logging Settings
            ##
            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                              '$status $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"';
            
            access_log C:/server/var/log/nginx/http_access.log main;
            error_log C:/server/var/log/nginx/http_error.log warn;
            
            ##
            # Gzip Settings
            ##
            gzip  on;
            gzip_proxied any;
            gzip_comp_level 6;
            gzip_min_length 1100;
            gzip_buffers 16 8k;
            gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
            
            ##
            # Virtual Host Configs
            ##
            include C:/server/nginx/conf/conf.d/*.conf;
        }
        ```

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
            
            access_log  C:/server/var/log//nginx/localhost.access.log;
            error_log  C:/server/var/log//nginx/localhost.error.log warn;
        }
        ```

	- **DEPRECATED !** Use [PHP's built-in Web Server](https://symfony.com/doc/current/setup/built_in_web_server.html)
    - Create:
	    ```nginx
	    # C:\server\nginx\conf\conf.d\symfony.conf

        # For Symfony 2/3/4 apps
        #
        server {
            listen       81;
            server_name  localhost;
            
            root   c:/server/www;
            
            charset utf-8;
            
            location ~ /(app|app_dev|config|public/index)\.php(/|$) {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_split_path_info ^(.+\.php)(/.*)$;
                include fastcgi_params;
            
                fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
                fastcgi_param DOCUMENT_ROOT $realpath_root;
            }
            
            location ~ \.php$ {
                return 404;
            }
            
            location ~ /\.ht {
                deny  all;
            }
            
            error_log  C:/server/var/log//nginx/localhost.symfony.error.log;
            access_log  C:/server/var/log//nginx/localhost.symfony.access.log;
        }
	    ```

<br>

### PHP

> **php-7.X.X-Win32-VC15-x64.zip** in: `C:\server\php`.

Execute: `cp C:\server\php\php.ini-development C:\server\php\php.ini`

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
    session.gc_maxlifetime = 18000
    
    [soap]
    soap.wsdl_cache_dir = "C:\server\var\tmp"
    ```

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
    openssl.cafile = "C:\server\php\extras\ssl\cacert.pem"
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
    opcache.error_log = "C:\server\var\log\php_opcache_errors.log"
    ```

#### APCu

- Download [7.2 Thread Safe (TS) x64](https://pecl.php.net/package/APCu)
- Save file in: `C:\server\php\ext\php_apcu.dll`
- Edit at the end:
    ```ini
    ; C:\server\php\php.ini
    
    [apcu]
    extension=apcu
    apc.enabled=1
    apc.shm_size=64M
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

- Download [PHP 7.2 VC15 TS (64 bit)](https://xdebug.org/download.php)
- Save file in: `C:\server\php\ext\php_xdebug.dll`
- Add at the end:
    ```ini
    ; C:\server\php\php.ini
    
    [Xdebug]
    zend_extension=xdebug
    
    ; Display all the tree
    xdebug.var_display_max_depth = -1
    xdebug.var_display_max_children = -1
    xdebug.var_display_max_data = -1
    ```

<br>

### MariaDB

> **mariadb-10.X.X-winx64.zip** in: `C:\server\mysql`.

- Execute:
	- `cp C:/server/mysql/my-huge.ini C:/server/mysql/bin/my.ini`
	- `rm -fr C:/server/mysql/data/*`

- Edit:
    ```ini
    ; C:\server\mysql\bin\my.ini
    
    [client]
    socket		= C:/server/var/tmp/mysql.sock
    
    # Here follows entries for some specific programs
    plugin-dir=C:/server/mysql/lib/plugin
    
    [mysqld]
    
    socket		= C:/server/var/tmp/mysql.sock
    
    # Point the following paths to a dedicated disk
    tmpdir		= C:/server/var/tmp
    
    # Uncomment the following if you are using InnoDB tables
    innodb_data_home_dir = C:/server/mysql/data
    #innodb_data_file_path = ibdata1:200M;ibdata2:10M:autoextend
    innodb_log_group_home_dir = C:/server/mysql/data
    # You can set .._buffer_pool_size up to 50 - 80 %
    # of RAM but beware of setting memory usage too high
    #innodb_buffer_pool_size = 384M
    #innodb_additional_mem_pool_size = 20M
    # Set .._log_file_size to 25 % of buffer pool size
    #innodb_log_file_size = 100M
    #innodb_log_buffer_size = 8M
    #innodb_flush_log_at_trx_commit = 1
    #innodb_lock_wait_timeout = 50
    
    collation-server     = utf8mb4_general_ci
    character-set-server = utf8mb4
    datadir = C:/server/mysql/data
    ```

- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [Xdebug]
    extension=mysqli
    extension=pdo_mysql
    ```

- For install MySQL a service (In admin)
    - `C:/server/mysql/bin/mysqld.exe --install MySQL --defaults-file=C:/server/mysql/bin/my.ini`

- For remove MySQL a service (In admin)
    - `C:/server/mysql/bin/mysqld.exe --remove`

- Install DB:
    - `C:/server/mysql/bin/mysql_install_db.exe --datadir=C:/server/mysql/data`

- Run:
    - Start: `net start mysql`
    - Stop: `net stop mysql`

Default login: **root**

<br>

- For set password or null/empty password ?
	1. Start *mysql* server in safe mode.
		- `C:/server/bin/start-mysql-safe-mode.bat`
	2. Run commands
		- For remove password:
			- `UPDATE user SET password = '' WHERE User = 'root';`
		- For set password:

			```bash
			mysql -u root -p

			USE mysql;
			UPDATE user SET `password` = PASSWORD('YOUR_PASSWORD') WHERE `User` = 'root';
			FLUSH PRIVILEGES;
			quit;
			```
	3. Stop ant restart *mysql*.

<br>

### phpMyAdmin

> **phpMyAdmin-4.X.X-all-languages.zip** in: `C:\server\phpmyadmin`.

- Creation of a symbolic link
	- Execute (only with **cmd** in **Administrator**): `mklink /D C:\server\www\phpmyadmin C:\server\phpmyadmin`

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
    $cfg['Servers'][$i]['password'] = '';
    $cfg['Servers'][$i]['AllowNoPassword'] = true;
    
    /**
    * phpMyAdmin configuration storage settings.
    */
    
    /* User used to manipulate with storage */
    // $cfg['Servers'][$i]['controlhost'] = '';
    // $cfg['Servers'][$i]['controlport'] = '';
    $cfg['Servers'][$i]['controluser'] = 'phpmyadmin';
    $cfg['Servers'][$i]['controlpass'] = 'vhYSsFuTa6qx';
    
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
    $cfg['Export']['compression'] = 'zip';
    $cfg['Export']['charset'] = 'utf-8';
    ```

    <br>

    - `mkdir C:\server\phpmyadmin\import`
    - `mkdir C:\server\phpmyadmin\save`

    <br>

    - Run: `C:/server/mysql/bin/mysql.exe -u root < C:/server/phpmyadmin/sql/create_tables.sql`

	- Create a **user** and **password** in phpMyAdmin for **phpMyAdmin configuration storage** with full privileges for the **phpmyadmin** base.
		- Change **user** and **password** to *controluser* variable in `config.inc.php`

	- Delete DB (optional): test

	- Create a symbolic link: `mklink /d C:\server\www\phpmyadmin C:\server\phpmyadmin`

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

#### PHP

- Edit:
    ```ini
    ; C:\server\php\php.ini
    
    [PHP]
    expose_php = Off
    error_reporting = Off
    
    [mysqlnd]
    mysqlnd.collect_statistics = Off
    mysqlnd.collect_memory_statistics = Off
	```

## Start & Stop all servers

- Start (In admin): `C:/server/_start.bat`
- Stop (In admin): `C:/server/_stop.bat`

<br>

## For future update ?

1. Execute:
    ```bash
    cd C:/server
    git pull
    ```

2. Comparison between your config and the README.md doc

<br>

## Uninstall

1. Backup your DB(s) and project(s)
2. Kill all services
3. Remove entry your PATH system variable:
    - C:\server\mysql\bin
    - C:\server\nginx
    - C:\server\php
4. Remove MySQL service (in admin): `C:/server/mysql/bin/mysqld.exe --remove`
5. Restart your system.
