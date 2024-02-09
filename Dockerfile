FROM bitnami/moodle:4.3.2
ARG PHP_INI_DIR='/opt/bitnami/php/etc'
ADD ./docker-php-ext-enable /usr/local/bin/
RUN chmod -R 777 /usr/local/bin/docker-php-ext-enable
RUN apt update && apt install -y autoconf make gcc; \
    pecl install apcu igbinary;
RUN docker-php-ext-enable apcu igbinary
RUN printf "\n" | pecl install --configureoptions 'enable-redis-igbinary="yes"' redis
RUN docker-php-ext-enable redis
