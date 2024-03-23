FROM php:8.3-fpm-alpine

RUN apk update --no-cache \
&& apk add \
icu-dev \
oniguruma-dev \
tzdata \
postgresql-dev \
php-pgsql


RUN apk add --no-cache zip libzip-dev

RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

RUN docker-php-ext-install intl

RUN docker-php-ext-install pcntl

RUN docker-php-ext-install pdo pdo_pgsql pgsql

RUN docker-php-ext-install mbstring

RUN docker-php-ext-enable pdo_pgsql pgsql

RUN apk add --no-cache \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    && docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN composer global require "laravel/installer"

CMD ["php-fpm"]