FROM debian:stretch

MAINTAINER wilkesystems <maintainer@wilke.systems>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
echo "exim4-config exim4/mailname string $(hostname --fqdn)" | debconf-set-selections; \
echo "exim4-config exim4/dc_postmaster string postmaster@$(hostname --fqdn)" | debconf-set-selections; \
apt-get install -y cron ca-certificates composer curl exim4-daemon-light graphicsmagick \
imagemagick locales locales-all mysql-client openssl php-apcu php-bcmath \
php-bz2 php-cgi php-cli php-curl php-dba php-enchant php-fpm php-gd php-gmp \
php-imagick php-imap php-interbase php-intl php-json php-ldap php-mbstring \
php-mcrypt php-mysql php-opcache php-pear php-pgsql php-pspell php-readline \
php-recode php-snmp php-soap php-sqlite3 php-sybase php-tidy php-xml \
php-xmlrpc php-xsl php-zip rrdtool snmp ssl-cert supervisor; \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www

EXPOSE 9000

COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
