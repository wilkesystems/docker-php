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
php7.1-bcmath php7.1-bz2 php7.1-cgi php7.1-cli php7.1-curl php7.1-dba php7.1-enchant php7.1-fpm \
php7.1-gd php7.1-gmp php7.1-imap php7.1-interbase php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring \
php7.1-mysql php7.1-odbc php7.1-opcache php7.1-pgsql php7.1-phpdbg php7.1-pspell php7.1-readline \
php7.1-recode php7.1-snmp php7.1-soap php7.1-sqlite3 php7.1-sybase php7.1-tidy php7.1-xml \
php7.1-xmlrpc php7.1-xsl php7.1-zip rrdtool rsyslog snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
