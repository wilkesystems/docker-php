# Supported tags and respective `Dockerfile` links

-	[`7.4`, `7.4-fpm` (*/php/7.4/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/7.4/buster/fpm/Dockerfile)
-	[`7`, `7.3`, `7.3-fpm` (*/php/7.3/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/7.3/buster/fpm/Dockerfile)
-	[`7.2`, `7.2-fpm` (*/php/7.2/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/7.2/buster/fpm/Dockerfile)
-	[`7.1`, `7.1-fpm` (*/php/7.1/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/7.1/buster/fpm/Dockerfile)
-	[`7.0`, `7.0-fpm` (*/php/7.0/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/7.0/buster/fpm/Dockerfile)
-	[`5`, `5.6`, `5.6-fpm` (*/php/5.6/buster/fpm/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/php/5.6/buster/fpm/Dockerfile)
-	[`buster` (*/debian/buster/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/buster/Dockerfile)
-	[`buster-slim`, `latest` (*/debian/buster-slim/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/buster-slim/Dockerfile)
-	[`stretch` (*/debian/stretch/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/stretch/Dockerfile)
-	[`stretch-slim` (*/debian/stretch-slim/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/stretch-slim/Dockerfile)
-	[`jessie` (*/debian/jessie/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/jessie/Dockerfile)
-	[`jessie-slim` (*/debian/jessie-slim/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/jessie-slim/Dockerfile)
-	[`wheezy` (*/debian/wheezy/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/wheezy/Dockerfile)
-	[`wheezy-slim` (*/debian/wheezy-slim/Dockerfile*)](https://github.com/wilkesystems/docker-php/blob/master/debian/wheezy-slim/Dockerfile)

----------------

![PHP](https://github.com/wilkesystems/docker-php/raw/master/docs/logo.png)

# PHP Hypertext Preprocessor
PHP is a server-side scripting language designed for web development, but which can also be used as a general-purpose programming language. PHP can be added to straight HTML or it can be used with a variety of templating engines and web frameworks. PHP code is usually processed by an interpreter, which is either implemented as a native module on the web-server or as a common gateway interface (CGI).

----------------

# Get Image
[Docker hub](https://hub.docker.com/r/wilkesystems/php)

```bash
docker pull wilkesystems/php
```

----------------

# How to use this image

```bash
docker run -d -p 9000 wilkesystems/php
```

----------------

# Environment

| Variable                       | Function                                  |
|--------------------------------|-------------------------------------------|
| PHP_UID                        | Sets the User ID of the worker processes  |
| PHP_GID                        | Sets the Group ID of the worker processes |
| PHP_PID                        | Sets the Socket of the worker processes   |
| PHP_INI_DATE_TIMEZONE          | Set date timezone                         |
| PHP_INI_EXPOSE_PHP             | Set expose php                            |
| PHP_INI_FILE_UPLOADS           | Set file uploads                          |
| PHP_INI_MAIL_ADD_X_HEADER      | Set mail add x header                     |
| PHP_INI_MAIL_LOG               | Set mail log                              |
| PHP_INI_MAX_EXECUTION_TIME     | Set max execution time                    |
| PHP_INI_MAX_INPUT_TIME         | Set max input time                        |
| PHP_INI_MAX_INPUT_VARS         | Set max input vars                        |
| PHP_INI_MEMORY_LIMIT           | Set memory limit                          |
| PHP_INI_OPEN_BASEDIR           | Set open basedir                          |
| PHP_INI_POST_MAX_SIZE          | Set post max size                         |
| PHP_INI_SHORT_OPEN_TAG         | Set short open tag                        |
| PHP_INI_SESSION_GC_MAXLIFETIME | Set session gc maxlifetime                |
| PHP_INI_SESSION_NAME           | Set session name                          |
| PHP_INI_UPLOAD_MAX_FILESIZE    | Set upload max filesize                   |

----------------

# Auto Builds
New images are automatically built by each new library push.

----------------

# Package: php
Package: [php](https://packages.debian.org/buster/php)

PHP (recursive acronym for PHP: Hypertext Preprocessor) is a widely-used open source general-purpose scripting language that is especially suited for web development and can be embedded into HTML. 
This package is a dependency package, which depends on Debian's default PHP version (currently 7.3). 
