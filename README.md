# Web Server for Windows
> A simple web server for windows with PHP, Nginx, MariaDB and phpMyAdmin.

<br>

- PHP (Recommanded PHP 7.2)
	- cURL
	- OPCache
	- APCu
	- Sendmail
	- Composer
- Nginx
- MariaDB
- phpMyAdmin
	- With config for *phpMyAdmin configuration storage*

<br>

## Getting

```bash
cmd
cd C:\
git clone https://gitlab.com/breithbarbot/server-web-windows.git server\
```

<br>

## Download
- Download the source files and extract to the each respective folder
	- **C:\server\php** : [[Recommanded PHP 7.2] PHP (x64 Thread Safe)](http://windows.php.net/download)
		- The VC15 builds require to have the Visual C++ Redistributable for [Visual Studio 2017 x64](https://go.microsoft.com/fwlink/?LinkId=746572)
	- **C:\server\nginx** : [Nginx](http://nginx.org/en/download.html)
	- **C:\server\mysql** : [MariaDB (ZIP file - Windows x86_64)](https://downloads.mariadb.org)
	- **C:\server\phpmyadmin** : [phpMyAdmin](https://www.phpmyadmin.net/downloads)

<br>

## Configuration

### General

- Update your PATH system variable
	- `C:\server\mysql\bin`
	- `C:\server\nginx`
	- `C:\server\php`

Restart your system.

<br>

### PHP

Execute : `cp C:\server\php\php.ini-development C:\server\php\php.ini`

- Edit **php.ini** (C:\server\php\php.ini) :
	- `error_log = "C:\server\var\log\php_errors.log"`
	- `include_path = ".;C:\server\php\pear"`
	- `extension_dir = "C:\server\php\ext"`
	- `sys_temp_dir = "C:\server\var\tmp"`
	- `upload_tmp_dir = "C:\server\var\tmp"`
	- `extension=bz2`
	- `extension=curl`
	- `extension=fileinfo`
	- `extension=intl`
	- `extension=mbstring`
	- `extension=exif`
	- `extension=openssl`
	- `date.timezone = Europe/Paris` ([List of Supported Timezones](https://secure.php.net/manual/en/timezones.php))
	- `session.save_path = "C:\server\var\tmp"`
	- `soap.wsdl_cache_dir = "C:\server\var\tmp"`

#### cURL

- Download : https://curl.haxx.se/docs/caextract.html
- Save file in : **C:\server\php\extras\ssl\cacert.pem**
- Edit **php.ini** (C:\server\php\php.ini) :
	- `curl.cainfo = "C:\server\php\extras\ssl\cacert.pem"`

#### OPCache

- Edit **php.ini** (C:\server\php\php.ini) :

	```ini
	[opcache]
	zend_extension=opcache
	opcache.enable=1
	opcache.enable_cli=1
	opcache.error_log = "C:\server\var\log\php_opcache_errors.log"
	```

#### APCu

- Download [7.2 Thread Safe (TS) x64](https://pecl.php.net/package/APCu)
- Save file in : `C:\server\php\ext\php_apcu.dll`
- Edit at the end **php.ini** (C:\server\php\php.ini) :

	```ini
	[apcu]
	extension=apcu
	apc.enabled=1
	apc.enable_cli=1
	apc.shm_size=64M
	```

#### Sendmail

- Download : https://www.glob.com.au/sendmail/
    - Copy all files in : **C:\server\sendmail**
- Edit **php.ini** (C:\server\php\php.ini) :
	- `sendmail_path = "\"C:\server\sendmail\sendmail.exe\" -t"`
- Edit file : `C:\server\sendmail\sendmail.ini`

#### Composer

- Download and install : https://getcomposer.org/download/
	- The default installation folder/file is : **C:\ProgramData\ComposerSetup\bin\composer.phar**
	- If you have this error during install : **Signature mismatch, could not verify the phar file integrity**
		- Comment temporarily : `zend_extension=opcache` in *C:\server\php\php.ini*, run Composer install and after, uncomment.

#### Xdebug

- Download [PHP 7.2 VC15 TS (64 bit)](https://xdebug.org/download.php)
- Save file in : `C:\server\php\ext\php_xdebug.dll`
- Add at the end **php.ini** (C:\server\php\php.ini) :

	```ini
    [Xdebug]
    zend_extension=xdebug
	```

<br>

### Nginx

Execute : `cp C:\server\nginx\conf\nginx.conf C:\server\nginx\conf\nginx.conf.original`

- Edit nginx files in : "C:\server\nginx"
    - [Core functionality](http://nginx.org/en/docs/ngx_core_module.html)
	- Edit **nginx.conf** (C:\server\nginx\conf\nginx.conf) :

	    ```ini
        #user  nobody;
        worker_processes  auto;
        
        error_log  C:\server\var\log\/nginx\error.log;
        #error_log  logs/error.log  notice;
        #error_log  logs/error.log  info;
        
        pid        C:\server\var\log\/nginx/\\nginx.pid;
        
        events {
        	worker_connections  2048;
        	multi_accept  on;
        }
        
        http {
            include       mime.types;
            default_type  application/octet-stream;
        
            #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
            #                  '$status $body_bytes_sent "$http_referer" '
            #                  '"$http_user_agent" "$http_x_forwarded_for"';
        
        	error_log  C:\server\var\log\/nginx\http.error.log;
            access_log  C:\server\var\log\/nginx\http.access.log;
        
            sendfile        on;
            #tcp_nopush     on;
        
            #keepalive_timeout  0;
            keepalive_timeout  65;
        
            gzip  on;
        	gzip_comp_level  2;
        	gzip_min_length  1000;
        
        	##
        	# Virtual Host Configs
        	##
        	include C:\server\/nginx\conf\conf.d/*.conf;
        }
	    ```

    - Create **default.conf** (C:\server\nginx\conf\conf.d\default.conf) :

	    ```ini
        # HTTP Server
        server {
            listen       80;
            server_name  localhost;
        
            root   c:/server/www;
        
            charset utf-8;
        
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
        
            error_log  C:\server\var\log\/nginx\localhost.error.log;
            access_log  C:\server\var\log\/nginx\localhost.access.log;
        }
	    ```

    - Create **symfony.conf** (C:\server\nginx\conf\conf.d\symfony.conf) :

	    ```ini
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
        
            error_log  C:\server\var\log\/nginx\localhost.symfony.error.log;
            access_log  C:\server\var\log\/nginx\localhost.symfony.access.log;
        }
	    ```

<br>

### MariaDB

- Execute :
	- `cp C:\server\mysql\my-huge.ini C:\server\mysql\bin\my.ini`
	- `rm C:\server\mysql\data\ib_buffer_pool`
	- `rm C:\server\mysql\data\ib_logfile0`
	- `rm C:\server\mysql\data\ib_logfile1`
	- `rm C:\server\mysql\data\ibdata1`

- Edit **my.ini** (C:\server\mysql\bin\my.ini) :

	```ini
	[client]
	socket		= C:/server/var/tmp/mysql.sock

	[mysqld]

	socket		= C:/server/var/tmp/mysql.sock

	# Point the following paths to a dedicated disk
	tmpdir		= C:/server/var/tmp/

	# Uncomment the following if you are using InnoDB tables
	innodb_data_home_dir = C:/server/mysql/data/
	innodb_data_file_path = ibdata1:250M;ibdata2:10M:autoextend
	innodb_log_group_home_dir = C:/server/mysql/data/
	# You can set .._buffer_pool_size up to 50 - 80 %
	# of RAM but beware of setting memory usage too high
	innodb_buffer_pool_size = 384M
	#innodb_additional_mem_pool_size = 20M
	# Set .._log_file_size to 25 % of buffer pool size
	innodb_log_file_size = 50M
	innodb_log_buffer_size = 8M
	innodb_flush_log_at_trx_commit = 1
	innodb_lock_wait_timeout = 50

    collation-server     = utf8mb4_general_ci
    character-set-server = utf8mb4
	```

- Edit **php.ini** (C:\server\php\php.ini) :
	- `extension=mysqli`
	- `extension=pdo_mysql`

- Default login / password
	- login : **root**
	- password : *null*

- Set password or null/empty password ?
	1. Start *mysql* server in safe mode.
		- *C:\server\bin\start-mysql-safe-mode.bat*
	2. Run commands
		- For set **null / empty** password : `UPDATE user SET password = '' WHERE User = 'root';`
		
		```bash
		mysql -u root -p

		MariaDB [(none)]> USE mysql;
		MariaDB [(none)]> UPDATE user SET `password` = PASSWORD('YOUR_PASSWORD') WHERE `User` = 'root';
		MariaDB [(none)]> FLUSH PRIVILEGES;
		MariaDB [(none)]> quit;
		```
	3. Stop ant restart *mysql*.

<br>

### phpMyAdmin

- Creation of a symbolic link
	- Execute (only with **cmd** in **Administrator**) : `mklink /D C:\server\www\phpmyadmin C:\server\phpmyadmin`

#### Configuration (Automatique)

- [Using Setup script](https://docs.phpmyadmin.net/en/latest/setup.html#using-setup-script)

#### Configuration (Manual)

- Edit **config.inc.php** (C:\server\phpmyadmin\config.inc.php) :
	- Change your **blowfish_secret** : [phpMyAdmin Blowfish Secret Generator](https://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator)
	- `mkdir C:\server\phpmyadmin\import`
	- `mkdir C:\server\phpmyadmin\save`
	- Example *config.inc.php* :

		```php
		<?php

		/* Servers configuration */
		$i = 0;

		/* Server: localhost */
		$i++;
		$cfg['Servers'][$i]['hide_db'] = 'information_schema|mysql|performance_schema|phpmyadmin';
		$cfg['Servers'][$i]['verbose'] = '';
		$cfg['Servers'][$i]['host'] = 'localhost';
		$cfg['Servers'][$i]['port'] = '';
		$cfg['Servers'][$i]['socket'] = '';
		$cfg['Servers'][$i]['auth_type'] = 'config';
		$cfg['Servers'][$i]['user'] = 'root';
		$cfg['Servers'][$i]['password'] = '';
		$cfg['Servers'][$i]['AllowNoPassword'] = true;
		$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
		$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
		$cfg['Servers'][$i]['relation'] = 'pma__relation';
		$cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
		$cfg['Servers'][$i]['users'] = 'pma__users';
		$cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
		$cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
		$cfg['Servers'][$i]['table_info'] = 'pma__table_info';
		$cfg['Servers'][$i]['column_info'] = 'pma__column_info';
		$cfg['Servers'][$i]['history'] = 'pma__history';
		$cfg['Servers'][$i]['recent'] = 'pma__recent';
		$cfg['Servers'][$i]['favorite'] = 'pma__favorite';
		$cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
		$cfg['Servers'][$i]['tracking'] = 'pma__tracking';
		$cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
		$cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
		$cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
		$cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
		$cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
		$cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
		$cfg['Servers'][$i]['controluser'] = 'phpmyadmin';
		$cfg['Servers'][$i]['controlpass'] = 'YOUR_PASSWORD';

		/* End of servers configuration */

		$cfg['blowfish_secret'] = '`CCYKmuMJiLNDD>C1sVMzt3x^c^(3WD^';
		$cfg['DefaultLang'] = 'en';
		$cfg['ShowPhpInfo'] = true;
		$cfg['ShowDbStructureCharset'] = true;
		$cfg['MaxRows'] = 50;
		$cfg['Import']['charset'] = 'utf-8';
		$cfg['Export']['compression'] = 'zip';
		$cfg['Export']['charset'] = 'utf-8';
		$cfg['UploadDir'] = 'import';
		$cfg['SaveDir'] = 'save';
		?>
		```
	
	- Create user/password for **phpMyAdmin configuration storage**
		- Change user to *controluser* variable
		- Change password to *controlpass* variable
	- Delete DB (optional) : test

<br>

## En environement de production

#### PHP

- Edit **php.ini** (C:\server\php\php.ini) :

	```ini
    expose_php = Off

    error_reporting = Off

    mysqlnd.collect_statistics = Off
    mysqlnd.collect_memory_statistics = Off
	```

#### Nginx

- Edit **conf.conf** (C:\server\nginx\conf\nginx.conf) :

	```ini
	server_tokens off;
	```


## Start & Stop all servers

- Start : `C:\server\_start.bat`
- Stop : `C:\server\_stop.bat`

<br>

## For future update ?

1. Execute :
    
    ```bash
    cd C:\server
    git pull
    ```

2. Comparison between your config and the README.md doc

<br>

## Uninstall

1. Backup your DB(s) and project(s)
2. Kill all services
3. Remove entry your PATH system variable :
    - C:\server\mysql\bin
    - C:\server\nginx
    - C:\server\php
4. Restart your system.
