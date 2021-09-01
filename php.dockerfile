FROM alpine:latest

WORKDIR /var/www/html/

# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl sqlite nginx supervisor

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP
RUN apk add --no-cache php8 \
    php8-common \
    php8-fpm \
    php8-pdo \
    php8-opcache \
    php8-zip \
    php8-phar \
    php8-iconv \
    php8-cli \
    php8-curl \
    php8-openssl \
    php8-mbstring \
    php8-tokenizer \
    php8-fileinfo \
    php8-json \
    php8-xml \
    php8-xmlwriter \
    php8-simplexml \
    php8-dom \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-tokenizer \
    php8-pecl-redis \
    php8-pecl-imagick

RUN ln -s /usr/bin/php8 /usr/bin/php

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY .docker/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure php-fpm
RUN mkdir -p /run/php/
RUN touch /run/php/php8.0-fpm.pid
RUN touch /run/php/php8.0-fpm.sock
COPY .docker/www.conf /etc/php8/php-fpm.d/www.conf
COPY .docker/php-fpm.conf /etc/php8/php-fpm.conf

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY .docker/default.conf /etc/nginx/conf.d/default.conf
COPY .docker/default.conf /etc/nginx/http.d/default.conf
COPY .docker/fastcgi-php.conf /etc/nginx/fastcgi-php.conf


RUN mkdir -p /run/nginx/
RUN touch /run/nginx/nginx.pid

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Building process
COPY --chown=nginx:nginx . .
RUN composer install --no-dev



# Configure Laravel logs
RUN ln -sf /dev/stdout /var/www/html/storage/laravel.log

EXPOSE 80
RUN echo "v0.0.2"
CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
