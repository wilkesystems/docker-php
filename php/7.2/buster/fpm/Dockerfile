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
php7.2-bcmath php7.2-bz2 php7.2-cgi php7.2-cli php7.2-curl php7.2-dba php7.2-enchant php7.2-fpm \
php7.2-gd php7.2-gmp php7.2-imap php7.2-interbase php7.2-intl php7.2-json php7.2-ldap php7.2-mbstring \
php7.2-mysql php7.2-odbc php7.2-opcache php7.2-pgsql php7.2-phpdbg php7.2-pspell php7.2-readline \
php7.2-recode php7.2-snmp php7.2-soap php7.2-sqlite3 php7.2-sybase php7.2-tidy php7.2-xml \
php7.2-xmlrpc php7.2-xsl php7.2-zip rrdtool rsyslog snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
