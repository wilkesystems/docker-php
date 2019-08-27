#!/bin/bash

function main {
    if [ "$1" != "supervisord" ]; then
        args=$(getopt -n "$(basename $0)" -o h --long help,debug,version -- "$@")
        eval set --"$args"
        while true; do
            case "$1" in
                -h | --help ) print_usage; shift ;;
                --debug ) DEBUG=true; shift ;;
                --version ) print_version; shift ;;
                --) shift ; break ;;
                * ) break ;;
            esac
        done
        shift $((OPTIND-1))
        apache_config
    else
        apache_config
    fi

    if [ -d /etc/supervisor/conf.d ]; then
        sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

        echo -e "[program:apache2]" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "command=apache2ctl -D FOREGROUND" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "autostart=true" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "autorestart=true" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "startsecs=0" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "stdout_logfile=/var/log/supervisor/apache2-stdout.log" >> /etc/supervisor/conf.d/apache2.conf
        echo -e "stderr_logfile=/var/log/supervisor/apache2-stderr.log" >> /etc/supervisor/conf.d/apache2.conf

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

function print_usage {
cat << EOF
Usage: "$(basename $0)" [Options]... [Vhosts]...
  -h  --help     display this help and exit
      --debug    output debug information
      --version  output version information and exit
E-mail bug reports to: <developer@wilke.systems>.
EOF
exit
}

function print_version {
cat << EOF
MIT License
Copyright (c) 2017 Wilke.Systems
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
exit
}

function apache_config {
    [ "$DEBUG" = "true" ] && set -x

    if [ ! -z "$APACHE2_GID" -a -z "${APACHE2_GID//[0-9]/}" -a "$APACHE2_GID" != "$(id --group www-data)" ]; then
        groupmod -g $APACHE2_GID www-data
    fi

    if [ ! -z "$APACHE2_UID" -a -z "${APACHE2_UID//[0-9]/}" -a "$APACHE2_UID" != "$(id --user www-data)" ]; then
        usermod -u $APACHE2_UID www-data
    fi

    if [ -d /etc/docker-entrypoint.d ]; then
        for APACHE2_PACKAGE in /etc/docker-entrypoint.d/*.tar.gz; do
            tar xfz $APACHE2_PACKAGE -C /
        done
    fi

    php_config
    exim_config
}

function php_config {
    if [ ! -z "$PHP_GID" -a -z "${PHP_GID//[0-9]/}" ]; then
        groupmod -g $PHP_GID www-data
    fi

    if [ ! -z "$PHP_UID" -a -z "${PHP_UID//[0-9]/}" ]; then
        usermod -u $PHP_UID www-data
    fi

    if [ -f /etc/php/7.4/php.ini ]; then
        if [ ! -z "$PHP_INI_DATE_TIMEZONE" ]; then
            sed -i -e "s/;date.timezone =/date.timezone = \"${PHP_INI_DATE_TIMEZONE////\\/}\"/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_EXPOSE_PHP" ]; then
            sed -i -e "s/expose_php = On/expose_php = $PHP_INI_EXPOSE_PHP/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_FILE_UPLOADS" ]; then
            sed -i -e "s/file_uploads = On/file_uploads = $PHP_INI_FILE_UPLOADS/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MAIL_ADD_X_HEADER" ]; then
            sed -i -e "s/;mail.add_x_header = On/mail.add_x_header = $PHP_INI_MAIL_ADD_X_HEADER/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MAIL_LOG" ]; then
            sed -i -e "s/;mail.log = syslog/mail.log = $PHP_INI_MAIL_LOG/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_EXECUTION_TIME" ]; then
            sed -i -e "s/max_execution_time = 30/max_execution_time = $PHP_INI_MAX_EXECUTION_TIME/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_INPUT_TIME" ]; then
            sed -i -e "s/max_input_time = 60/max_input_time = $PHP_INI_MAX_INPUT_TIME/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MAX_INPUT_VARS" ]; then
            sed -i -e "s/; max_input_vars = 1000/max_input_vars = $PHP_INI_MAX_INPUT_VARS/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_MEMORY_LIMIT" ]; then
            sed -i -e "s/memory_limit = 128M/memory_limit = $PHP_INI_MEMORY_LIMIT/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_OPEN_BASEDIR" ]; then
            sed -i -e "s/;open_basedir =/open_basedir = ${PHP_INI_OPEN_BASEDIR////\\/}/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_POST_MAX_SIZE" ]; then
            sed -i -e "s/post_max_size = 8M/post_max_size = $PHP_INI_POST_MAX_SIZE/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_SHORT_OPEN_TAG" ]; then
            sed -i -e "s/short_open_tag = Off/short_open_tag = $PHP_INI_SHORT_OPEN_TAG/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_SESSION_GC_MAXLIFETIME" ]; then
            sed -i -e "s/session.gc_maxlifetime = 1440/session.gc_maxlifetime = $PHP_INI_SESSION_GC_MAXLIFETIME/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_SESSION_NAME" ]; then
            sed -i -e "s/session.name = PHPSESSID/session.name = $PHP_INI_SESSION_NAME/" /etc/php/7.4/php.ini
        fi

        if [ ! -z "$PHP_INI_UPLOAD_MAX_FILESIZE" ]; then
            sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = $PHP_INI_UPLOAD_MAX_FILESIZE/" /etc/php/7.4/php.ini
        fi
    fi

    mkdir -p -m 755 /run/php

    chown www-data:www-data /run/php
}

function exim_config {
    if [ -f /etc/exim4/update-exim4.conf.conf ]; then
        sed -i -e "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
        sed -i -e "s/dc_other_hostnames=.*/dc_other_hostnames='$(hostname --fqdn)'/" /etc/exim4/update-exim4.conf.conf
        sed -i -e "s/dc_local_interfaces=.*/dc_local_interfaces='127.0.0.1'/" /etc/exim4/update-exim4.conf.conf
    fi

    echo $(hostname) > /etc/mailname

    update-exim4.conf
}

main "$@"

exit
