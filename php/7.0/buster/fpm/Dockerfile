FROM debian:buster-slim

MAINTAINER wilkesystems <maintainer@wilke.systems>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
echo "exim4-config exim4/mailname string $(hostname --fqdn)" | debconf-set-selections; \
echo "exim4-config exim4/dc_postmaster string postmaster@$(hostname --fqdn)" | debconf-set-selections; \
apt-get install -y gnupg wget; wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -; \
echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list; \
apt-get update; apt-get install -y ca-certificates cron composer curl exim4-daemon-light graphicsmagick \
imagemagick locales locales-all default-mysql-client openssl php-gnupg php-imagick php-redis php-yaml \
php7.0-bcmath php7.0-bz2 php7.0-cgi php7.0-cli php7.0-curl php7.0-dba php7.0-enchant php7.0-fpm \
php7.0-gd php7.0-gmp php7.0-imap php7.0-interbase php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring \
php7.0-mysql php7.0-odbc php7.0-opcache php7.0-pgsql php7.0-phpdbg php7.0-pspell php7.0-readline \
php7.0-recode php7.0-snmp php7.0-soap php7.0-sqlite3 php7.0-sybase php7.0-tidy php7.0-xml \
php7.0-xmlrpc php7.0-xsl php7.0-zip rrdtool rsyslog snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
