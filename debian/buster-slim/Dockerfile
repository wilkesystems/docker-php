FROM debian:buster-slim

MAINTAINER wilkesystems <maintainer@wilke.systems>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
echo "exim4-config exim4/mailname string $(hostname --fqdn)" | debconf-set-selections; \
echo "exim4-config exim4/dc_postmaster string postmaster@$(hostname --fqdn)" | debconf-set-selections; \
apt-get install -y ca-certificates cron composer curl exim4-daemon-light graphicsmagick \
imagemagick locales locales-all default-mysql-client openssl php-gnupg php-imagick php-redis php-yaml \
php-bcmath php-bz2 php-cgi php-cli php-curl php-dba php-enchant php-fpm php-gd php-gmp php-imap \
php-interbase php-intl php-json php-ldap php-mbstring php-mysql php-odbc php-opcache php-pgsql \
php-phpdbg php-pspell php-readline php-recode php-snmp php-soap php-sqlite3 php-sybase php-tidy \
php-xml php-xmlrpc php-xsl php-zip rrdtool rsyslog snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
