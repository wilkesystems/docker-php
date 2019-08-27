FROM debian:buster-slim

MAINTAINER wilkesystems <maintainer@wilke.systems>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
echo "exim4-config exim4/mailname string $(hostname --fqdn)" | debconf-set-selections; \
echo "exim4-config exim4/dc_postmaster string postmaster@$(hostname --fqdn)" | debconf-set-selections; \
apt-get update; apt-get install -y gnupg wget; wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key \
add -; echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list; \
apt-get update; apt-get install -y apache2 ca-certificates cron composer curl exim4-daemon-light  \
graphicsmagick imagemagick locales locales-all default-mysql-client openssl php-gnupg php-imagick \
php-redis php-yaml php7.4-bcmath php7.4-bz2 php7.4 php7.4-cli php7.4-curl php7.4-dba php7.4-enchant \
php7.4-fpm php7.4-gd php7.4-gmp php7.4-imap php7.4-interbase php7.4-intl php7.4-json php7.4-ldap \
php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-phpdbg php7.4-pspell \
php7.4-readline php7.4-recode php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xml \
php7.4-xmlrpc php7.4-xsl php7.4-zip libapache2-mod-php7.4 libapache2-mod-gnutls rrdtool rsyslog snmp  \
ssl-cert supervisor; a2ensite default-tls; a2enmod alias setenvif socache_dbm socache_shmcb userdir; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443

STOPSIGNAL WINCH

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

WORKDIR /var/www

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
