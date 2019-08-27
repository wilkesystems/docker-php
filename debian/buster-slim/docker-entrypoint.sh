#!/bin/bash

function main {
    [ "$DEBUG" = "true" ] && set -x

    if [ ! -z "$PHP_GID" -a -z "${PHP_GID//[0-9]/}" ]; then
        groupmod -g $PHP_GID www-data
    fi

    if [ ! -z "$PHP_UID" -a -z "${PHP_UID//[0-9]/}" ]; then
        usermod -u $PHP_UID www-data
    fi

    if [ -f /etc/php/7.3/fpm/php-fpm.conf ]; then
        if [ ! -z "$PHP_PID" ]; then
            sed -i -e "s/pid = \/run\/php\/php7.3-fpm.pid/pid = ${PHP_PID////\\/}/" /etc/php/7.3/fpm/php-fpm.conf
        fi
    fi

    if [ -f /etc/php/7.3/fpm/php.ini ]; then
        if [ ! -z "$PHP_INI_DATE_TIMEZONE" ]; then
            sed -i -e "s/;date.timezone =/date.timezone = \"${PHP_INI_DATE_TIMEZONE////\\/}\"/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_EXPOSE_PHP" ]; then
            sed -i -e "s/expose_php = On/expose_php = $PHP_INI_EXPOSE_PHP/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_FILE_UPLOADS" ]; then
            sed -i -e "s/file_uploads = On/file_uploads = $PHP_INI_FILE_UPLOADS/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MAIL_ADD_X_HEADER" ]; then
            sed -i -e "s/;mail.add_x_header = On/mail.add_x_header = $PHP_INI_MAIL_ADD_X_HEADER/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MAIL_LOG" ]; then
            sed -i -e "s/;mail.log = syslog/mail.log = $PHP_INI_MAIL_LOG/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_EXECUTION_TIME" ]; then
            sed -i -e "s/max_execution_time = 30/max_execution_time = $PHP_INI_MAX_EXECUTION_TIME/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_INPUT_TIME" ]; then
            sed -i -e "s/max_input_time = 60/max_input_time = $PHP_INI_MAX_INPUT_TIME/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_INPUT_VARS" ]; then
            sed -i -e "s/; max_input_vars = 1000/max_input_vars = $PHP_INI_MAX_INPUT_VARS/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_MEMORY_LIMIT" ]; then
            sed -i -e "s/memory_limit = 128M/memory_limit = $PHP_INI_MEMORY_LIMIT/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_OPEN_BASEDIR" ]; then
            sed -i -e "s/;open_basedir =/open_basedir = ${PHP_INI_OPEN_BASEDIR////\\/}/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_POST_MAX_SIZE" ]; then
            sed -i -e "s/post_max_size = 8M/post_max_size = $PHP_INI_POST_MAX_SIZE/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_SHORT_OPEN_TAG" ]; then
            sed -i -e "s/short_open_tag = Off/short_open_tag = $PHP_INI_SHORT_OPEN_TAG/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_SESSION_GC_MAXLIFETIME" ]; then
            sed -i -e "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = $PHP_INI_SESSION_GC_MAXLIFETIME/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_SESSION_NAME" ]; then
            sed -i -e "s/session.name = PHPSESSID/session.name = $PHP_INI_SESSION_NAME/" /etc/php/7.3/fpm/php.ini
        fi

        if [ ! -z "$PHP_INI_UPLOAD_MAX_FILESIZE" ]; then
            sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = $PHP_INI_UPLOAD_MAX_FILESIZE/" /etc/php/7.3/fpm/php.ini
        fi
    fi

    if [ -f /etc/php/7.3/fpm/pool.d/www.conf ]; then
        if [ ! -z "$PHP_LISTEN" ]; then
            sed -i -e "s/listen = \/run\/php\/php7.3-fpm.sock/listen = ${PHP_LISTEN////\\/}/" /etc/php/7.3/fpm/pool.d/www.conf
        fi

        if [ ! -z "$PHP_REQUEST_TERMINATE_TIMEOUT" ]; then
            sed -i -e "s/;request_terminate_timeout = 0/request_terminate_timeout = $PHP_REQUEST_TERMINATE_TIMEOUT/" /etc/php/7.3/fpm/pool.d/www.conf
        fi

        if [ ! -z "$PHP_SECURITY_LIMIT_EXTENSIONS" ]; then
            sed -i -e "s/;security.limit_extensions = .php .php3 .php4 .php5 .php7/security.limit_extensions = $PHP_SECURITY_LIMIT_EXTENSIONS/" /etc/php/7.3/fpm/pool.d/www.conf
        fi
    fi

    mkdir -p -m 755 /run/php

    chown www-data:www-data /run/php

    if [ -f /etc/exim4/update-exim4.conf.conf ]; then
        sed -i -e "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
        sed -i -e "s/dc_other_hostnames=.*/dc_other_hostnames='$(hostname --fqdn)'/" /etc/exim4/update-exim4.conf.conf
        sed -i -e "s/dc_local_interfaces=.*/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
    fi

    echo $(hostname) > /etc/mailname

    update-exim4.conf

    if [ -d /etc/supervisor/conf.d ]; then
        sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

        echo -e "[program:php]" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "command=php-fpm7.3 -F" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "autostart=true" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "startsecs=0" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "stdout_logfile=/var/log/supervisor/php-stdout.log" >> /etc/supervisor/conf.d/php-fpm7.3.conf
        echo -e "stderr_logfile=/var/log/supervisor/php-stderr.log" >> /etc/supervisor/conf.d/php-fpm7.3.conf

        echo -e "[program:cron]" > /etc/supervisor/conf.d/cron.conf
        echo -e "command=/usr/sbin/cron -f" >> /etc/supervisor/conf.d/cron.conf
        echo -e "autostart=true" >> /etc/supervisor/conf.d/cron.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/cron.conf
        echo -e "startsecs=0" >> /etc/supervisor/conf.d/cron.conf
        echo -e "stdout_logfile=/var/log/supervisor/cron-stdout.log" >> /etc/supervisor/conf.d/cron.conf
        echo -e "stderr_logfile=/var/log/supervisor/cron-stderr.log" >> /etc/supervisor/conf.d/cron.conf

        echo -e "[program:exim4]" > /etc/supervisor/conf.d/exim4.conf
        echo -e "command=/usr/sbin/exim4 -bd -v" >> /etc/supervisor/conf.d/exim4.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/exim4.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/exim4.conf
        echo -e "startsecs=0" >> /etc/supervisor/conf.d/exim4.conf
        echo -e "stdout_logfile=/var/log/supervisor/exim4-stdout.log" >> /etc/supervisor/conf.d/exim4.conf
        echo -e "stderr_logfile=/var/log/supervisor/exim4-stderr.log" >> /etc/supervisor/conf.d/exim4.conf

        echo -e "[program:rsyslogd]" > /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "porcess_name = rsyslogd" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "command=rsyslogd -n" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "autostart=true" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "startsecs=0" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "stdout_logfile=/var/log/supervisor/rsyslog-stdout.log" >> /etc/supervisor/conf.d/rsyslogd.conf
        echo -e "stderr_logfile=/var/log/supervisor/rsyslog-stderr.log" >> /etc/supervisor/conf.d/rsyslogd.conf
    fi

    exec "$@"
}

main "$@"

exit