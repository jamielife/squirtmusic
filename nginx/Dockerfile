FROM php:8.3.8-fpm

RUN apt-get update && apt-get install -y zlib1g-dev g++ git libicu-dev zip curl libzip-dev zip \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

WORKDIR /var/www/html