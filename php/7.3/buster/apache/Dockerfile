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
php-redis php-yaml php7.3-bcmath php7.3-bz2 php7.3 php7.3-cli php7.3-curl php7.3-dba php7.3-enchant \
php7.3-fpm php7.3-gd php7.3-gmp php7.3-imap php7.3-interbase php7.3-intl php7.3-json php7.3-ldap \
php7.3-mbstring php7.3-mysql php7.3-odbc php7.3-opcache php7.3-pgsql php7.3-phpdbg php7.3-pspell \
php7.3-readline php7.3-recode php7.3-snmp php7.3-soap php7.3-sqlite3 php7.3-sybase php7.3-tidy php7.3-xml \
php7.3-xmlrpc php7.3-xsl php7.3-zip libapache2-mod-php7.3 libapache2-mod-gnutls rrdtool rsyslog snmp  \
ssl-cert supervisor; a2ensite default-tls; a2enmod alias setenvif socache_dbm socache_shmcb userdir; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443

STOPSIGNAL WINCH

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

WORKDIR /var/www

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
