# Server web for windows

A simple server web for windows with PHP, Nginx, MariaDB and phpMyAdmin.

- PHP
	- cURL
	- OPCache
	- APCu
	- Sendmail
- Nginx
- MariaDB
- phpMyAdmin
	- With config for user control

<br>

## Getting

```bash
cd \
git clone https://gitlab.com/breithbarbot/server-web-windows.git server\
```

<br>

## Download
- Download the source files and extract to the each respective folder
	- **C:\server\php** : [PHP (x64 Thread Safe)](http://windows.php.net/download)
		- The VC15 builds require to have the Visual C++ Redistributable for Visual Studio 2017 [x64](https://go.microsoft.com/fwlink/?LinkId=746572)
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

[List of Supported Timezones](https://secure.php.net/manual/en/timezones.php)

- Edit **php.ini** (C:\server\php\php.ini) :
	- `error_log = "C:\server\var\log\php_errors.log"`
	- `include_path = ".;C:\server\php\pear"`
	- `extension_dir = "C:\server\php\ext"`
	- `sys_temp_dir = "C:\server\var\tmp"`
	- `upload_tmp_dir = "C:\server\var\tmp"`
	- `extension=curl`
	- `extension=fileinfo`
	- `extension=intl`
	- `extension=mbstring`
	- `extension=openssl`
	- `date.timezone = Europe/Paris`
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
	zend_extension = "C:\server\php\ext\php_opcache.dll"
	opcache.enable=1
	opcache.enable_cli=1
	opcache.error_log = "C:\server\var\log\php_opcache_errors.log"
	```

#### APCu

- Download [7.2 Thread Safe (TS) x64](https://pecl.php.net/package/APCu)
- Save file in : `C:\server\php\ext\php_apcu.dll`
- Edit end **php.ini** (C:\server\php\php.ini) :

	```ini
	[apcu]
	extension = "C:\server\php\ext\php_apcu.dll"
	apc.enabled=1
	apc.enable_cli=1
	apc.shm_size=64M
	```

#### Sendmail

- Download : https://www.glob.com.au/sendmail/
- Edit **php.ini** (C:\server\php\php.ini) :
	- `sendmail_path = "\"C:\server\sendmail\sendmail.exe\" -t"`
- Edit file : `C:\server\sendmail\sendmail.ini`

<br>

### Nginx

Execute : `cp C:\server\nginx\conf\nginx.conf C:\server\nginx\conf\nginx.conf.original`

- Edit nginx files in : "C:\server\nginx"
	- Edit **nginx.conf** (C:\server\nginx\conf\nginx.conf) :
		- `gzip  on;`
		- `error_log  C:\server\var\log\/nginx\error.log;`
		- `pid        C:\server\var\log\/nginx/\\nginx.pid;`
		- `access_log  C:\server\var\log\/nginx\access.log  main;`
		- `access_log  C:\server\var\log\/nginx\localhost.access.log  main;`

		```ini
        location / {
            root   c:/server/www;
            index  index.html index.htm index.php;
        }
		```

		```ini
        location ~ \.php$ {
            root           c:/server/www;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $realpath_root$fastcgi_script_name;
            include        fastcgi_params;
        }
		  ```

		```ini
		location ~ /\.ht {
	        deny  all;
	    }
		```

	- Edit **nginx.conf** for *symfony* (C:\server\nginx\conf\nginx.conf) :
		
		```ini
		# SYMFONY
		location ~ /(app|app_dev|config)\.php(/|$) {
            root           c:/server/www;
            fastcgi_pass   127.0.0.1:9000;
			fastcgi_split_path_info ^(.+\.php)(/.*)$;
			include fastcgi_params;
 
			fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
			fastcgi_param DOCUMENT_ROOT $realpath_root;
		}
		```

<br>

### MariaDB

Execute : `cp C:\server\mysql\my-huge.ini C:\server\mysql\bin\my.ini`

- Edit **my.ini** (C:\server\mysql\bin\my.ini) :
	- `socket		= C:\server\var\log\mysql\mysql.sock`
	- `socket		= C:\server\var\log\mysql\mysql.sock`
	- `tmpdir		= C:\server\var\tmp\`

- Edit **php.ini** (C:\server\php\php.ini) :
	- `extension=mysqli`
	- `extension=pdo_mysql`

- Default login / password
	- login : **root**
	- password : *null*

<br>

### phpMyAdmin

- Execute (only with **cmd** in **Administrator**) : `mklink /D C:\server\www\phpmyadmin C:\server\phpmyadmin`

#### Configuration (Automatique)

- [Using Setup script](https://docs.phpmyadmin.net/en/latest/setup.html#using-setup-script)

#### Configuration (Manual)

- Edit **config.inc.php** (C:\server\phpmyadmin\config.inc.php) :
	- Change your **blowfish_secret** : [phpMyAdmin Blowfish Secret Generator](https://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator)
	- `mkdir C:\server\phpmyadmin\import`
	- `mkdir C:\server\phpmyadmin\save`
	- Example *config.inc.php* (Change password to *controlpass*) :

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
	$cfg['Servers'][$i]['auth_type'] = 'cookie';
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
	$cfg['Servers'][$i]['controlpass'] = '5_5v0lo73EAT2Wx';

	/* End of servers configuration */

	$cfg['blowfish_secret'] = '`CCYKmuMJiLNDD>C1sVMzt3x^c^(3WD^';
	$cfg['DefaultLang'] = 'fr';
	$cfg['ServerDefault'] = 1;
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
	- Create user/pssw for user control
	- Delete DB (optional) : test

<br>

## Start & Stop all servers

- Start : `C:\server\_start.bat`
- Stop : `C:\server\_stop.bat`
