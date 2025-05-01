FROM ubuntu:24.04
ARG PHP_VERSION="8.3"

COPY ondrej-ubuntu-php.gpg /etc/apt/trusted.gpg.d/
COPY ondrej-ubuntu-php.list /etc/apt/sources.list.d/
RUN apt-get update
##RUN apt install -y software-properties-common --no-install-recommends  --no-install-suggests 
##RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install -y php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-curl php${PHP_VERSION}-mysql php${PHP_VERSION}-bcmath php${PHP_VERSION}-gd php${PHP_VERSION}-imagick php${PHP_VERSION}-mbstring php${PHP_VERSION}-opcache php${PHP_VERSION}-readline php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-redis php${PHP_VERSION}-soap php${PHP_VERSION}-intl php${PHP_VERSION}-bz2 libfcgi-bin
RUN apt-get clean
RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm
RUN ln -s /etc/php/${PHP_VERSION} /etc/php/current
COPY php-fpm.conf /etc/php/current/fpm/php-fpm.conf
COPY www.conf /etc/php/current/fpm/pool.d/www.conf
RUN mkdir -p /opt/php/log
RUN mkdir -p /opt/php/tmp
RUN mkdir -p /opt/php/run
RUN chmod 777 /opt/php/log /opt/php/tmp /opt/php/run

#COPY ping.php /ping.php
HEALTHCHECK --interval=5s --timeout=1s CMD SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect localhost:9000 | grep 'pong' || exit 1

EXPOSE 9000

WORKDIR /app

CMD [ "/usr/sbin/php-fpm", "-F", "--pid", "/opt/php/run/php-fpm.pid", "-y", "/etc/php/current/fpm/php-fpm.conf" ]
