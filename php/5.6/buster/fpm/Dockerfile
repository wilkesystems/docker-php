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
php5.6-bcmath php5.6-bz2 php5.6-cgi php5.6-cli php5.6-curl php5.6-dba php5.6-enchant php5.6-fpm \
php5.6-gd php5.6-gmp php5.6-imap php5.6-interbase php5.6-intl php5.6-json php5.6-ldap php5.6-mbstring \
php5.6-mysql php5.6-odbc php5.6-opcache php5.6-pgsql php5.6-phpdbg php5.6-pspell php5.6-readline \
php5.6-recode php5.6-snmp php5.6-soap php5.6-sqlite3 php5.6-sybase php5.6-tidy php5.6-xml \
php5.6-xmlrpc php5.6-xsl php5.6-zip rrdtool rsyslog snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
