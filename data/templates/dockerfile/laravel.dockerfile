FROM php:8.1.3-fpm-alpine as base
WORKDIR /var/www/app
RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies git tzdata && \
  apk add --update --no-cache \
  icu-dev \
  libzip-dev \
  libxml2-dev \
  oniguruma-dev
ARG TZ=Asia/Tokyo
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo ${TZ} > /etc/timezone

RUN docker-php-source extract && \
  git clone -b 5.3.4 --depth 1 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis && \
  docker-php-ext-install /usr/src/php/ext/redis

RUN docker-php-ext-install soap pdo_mysql && \
  apk del .build-dependencies
COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

FROM base as dev
RUN apk add bash

FROM base as prod
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install \
  --prefer-dist \
  --no-scripts \
  --no-dev \
  --no-autoloader && \
  rm -rf /root/.composer
COPY . .
RUN chown -R www-data:www-data ./storage/logs ./storage/framework
RUN composer dump-autoload --no-dev --optimize
CMD php artisan migrate --force && \
  php artisan db:seed --force && \
  php artisan config:cache && \
  php artisan route:cache && \
  php-fpm
