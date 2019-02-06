FROM php:7.3.1-fpm-alpine

LABEL maintainer="Fred Gauthier <fred.gauthier.dev@gmail.com>" \
    Description="A lightweigth PHP 7.3.1 container for Symfony with Xdebug and Composer, build with Alpine"

ARG PHP_XDEBUG_VERSION=2.7.0beta1

WORKDIR /home/docker

RUN apk update \
    # Install PHP extensions with dependencies
    && echo -e '\033[0;31m' Install PHP extensions with dependencies '\033[0m'\
    #
    # INTL (require libicu-dev )
    && echo -e '\033[0;33m' INTL '\033[0m'\
    && apk add --no-cache icu-dev && docker-php-ext-install intl \
    #
    # XML ( require libxml2-dev )
    && echo -e '\033[0;33m' XML '\033[0m'\
    && apk add --no-cache --virtual php-dependencies libxml2-dev && docker-php-ext-install xml \
    #
    # ZIP ( require zlib1g-dev )
    && echo -e '\033[0;33m' ZIP '\033[0m'\
    && apk add --no-cache libzip-dev && docker-php-ext-install zip \
    #
    # Install PHP extensions without dependencies
    && echo -e '\033[0;31m' Install PHP extensions with dependencies '\033[0m' \
    && echo -e '\033[0;33m' mbstring bcmath opcache '\033[0m'\
    && docker-php-ext-install \
        mbstring \
        bcmath \
        opcache \
    #
    # Install the PHP database driver
    && echo -e '\033[0;31m' Install the PHP database driver '\033[0m' \
    && echo -e '\033[0;33m' pdo_mysql '\033[0m'\
    && docker-php-ext-install \
        pdo_mysql \ 
    #
    # Install Xdebug
    && echo -e '\033[0;31m' Install Xdebug '\033[0m' \
    && apk add --no-cache --virtual xdebug-dependencies \
        g++ \
        autoconf \
        make \
    && pecl install xdebug-$PHP_XDEBUG_VERSION \
    && docker-php-ext-enable xdebug \
    && docker-php-source delete \
    #
    # Install Composer
    && echo -e '\033[0;31m' Install Composer '\033[0m' \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    #
    # Change the user 1000 to www-data to avoid permissions issues
    && echo -e '\033[0;31m' Change user permissions '\033[0m' \
    && cd /home/docker \
    && apk --no-cache add shadow && usermod -u 1000 www-data && groupmod -g 987 www-data \
    && echo -e '\033[0;31m' Check Permissions for '\033[0m' $PWD \
    && ls -la \
    && apk del shadow \
    # Clean up apk cache folder and the virtuals folders
    && echo -e '\033[0;31m' Clean up apk cache folder and the virtuals folders '\033[0m' \
    && apk del --purge xdebug-dependencies \
    && apk del --purge php-dependencies \
    && rm -rf /var/cache/apk/*

USER www-data
