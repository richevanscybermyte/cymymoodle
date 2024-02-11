FROM bitnami/moodle:4.3.2
ARG PHP_INI_DIR='/opt/bitnami/php/etc'
ADD ./docker-php-ext-enable /usr/local/bin/
RUN chmod -R 777 /usr/local/bin/docker-php-ext-enable; \
    sed -i 's/upload_max_filesize\ \=\ 40M/upload_max_filesize\ \=\ 5G/g' /opt/bitnami/php/etc/php.ini; \
    sed -i 's/max_execution_time\ \=\ 30/max_execution_time\ \=\ 600/g' /opt/bitnami/php/etc/php.ini; \
    sed -i 's/post_max_size\ \=\ 40M/post_max_size\ \=\ 6G/g' /opt/bitnami/php/etc/php.ini; \
    sed -i 's/memory_limit\ \=\ 256M/memory_limit\ \=\ 2G/g' /opt/bitnami/php/etc/php.ini;
RUN apt update && apt install -y autoconf make gcc; \
    pecl install apcu igbinary;
RUN docker-php-ext-enable apcu igbinary
RUN printf "\n" | pecl install --configureoptions 'enable-redis-igbinary="yes"' redis
RUN docker-php-ext-enable redis
# Clean up unnessasary stuff
RUN apt remove -y autoconf make gcc && apt-get -y autoremove && apt-get -y autoclean && rm -f /usr/local/bin/docker-php-ext-enable
