ARG VERSION=8.0.8-fpm-alpine3.18-nginx-1.21.1
FROM dwchiang/nginx-php-fpm:${VERSION}

LABEL maintainer="Ernest Chiang <me@ernestchiang.com>"

ARG VERSION_PHP_MINOR
ARG VERSION_OS
ENV VERSION_OS=${VERSION_OS}

### ----------------------------------------------------------
### Library and PHP Packges
### ----------------------------------------------------------

RUN set -x && \
    # php configurations
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    # Memory, Time, Size Limits
    #   You can limit these at your orchestration layer.
    echo "memory_limit=2048M" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "max_execution_time=900" >> $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "post_max_size=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini && \
    echo "upload_max_filesize=20M" >> $PHP_INI_DIR/conf.d/memory-limit.ini && \
    # Time Zone
    echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini && \
    # Display errors in stderr
    echo "display_errors=stderr" > $PHP_INI_DIR/conf.d/display-errors.ini && \
    # Disable PathInfo
    echo "cgi.fix_pathinfo=0" > $PHP_INI_DIR/conf.d/path-info.ini && \
    # Disable expose PHP
    echo "expose_php=0" > $PHP_INI_DIR/conf.d/path-info.ini && \
    # clean up
    apk del --no-network && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/nginx/html/*

### ----------------------------------------------------------
### Load our app
### ----------------------------------------------------------

COPY src /var/www/html

RUN set -x && \
    touch /var/log/cron.log && \
    chown -R www-data:www-data /usr/share/nginx/html && \
    chown -R www-data:www-data /var/www/html

CMD ["/docker-entrypoint.sh"]