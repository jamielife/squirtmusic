
# Patched PHP 8.3 runtime with Alpine Linux
FROM php:8.3.36-fpm-alpine3.24

# ----------------------------------------------------------
# Install Nginx, Supervisor, and PHP dependencies
# ----------------------------------------------------------
RUN set -eux; \
    apk add --no-cache \
        nginx \
        supervisor \
        fcgi \
        libzip-dev \
        icu-dev \
        oniguruma-dev; \
    docker-php-ext-install \
        pdo_mysql \
        mysqli \
        zip \
        intl; \
    mkdir -p \
        /run/nginx \
        /var/www/html \
        /var/log/supervisor \
        /etc/nginx/conf.d; \
    rm -f /etc/nginx/http.d/default.conf

# ----------------------------------------------------------
# PHP configuration
# ----------------------------------------------------------
RUN set -eux; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    { \
        echo "memory_limit=1028M"; \
        echo "max_execution_time=900"; \
        echo "post_max_size=2M"; \
        echo "upload_max_filesize=2M"; \
        echo "date.timezone=UTC"; \
        echo "display_errors=stderr"; \
        echo "cgi.fix_pathinfo=0"; \
        echo "expose_php=0"; \
        echo "session.upload_progress.enabled=0"; \
    } > "$PHP_INI_DIR/conf.d/squirtmusic.ini"

# ----------------------------------------------------------
# Nginx configuration
# ----------------------------------------------------------
COPY ./nginx/conf.d/default.conf /etc/nginx/http.d/default.conf

# Use a TCP upstream to match PHP-FPM's default listener.
# Your existing nginx config should use:
# fastcgi_pass 127.0.0.1:9000;

# ----------------------------------------------------------
# Load application
# ----------------------------------------------------------
WORKDIR /var/www/html

COPY --chown=www-data:www-data src/ /var/www/html/

RUN set -eux; \
    touch /var/log/cron.log; \
    chown -R www-data:www-data /var/www/html; \
    chmod -R u=rwX,g=rX,o=rX /var/www/html

# ----------------------------------------------------------
# Supervisor: run PHP-FPM and Nginx together
# ----------------------------------------------------------
RUN mkdir -p /etc/supervisor.d && \
    printf '%s\n' \
        '[supervisord]' \
        'nodaemon=true' \
        'logfile=/dev/null' \
        'logfile_maxbytes=0' \
        '' \
        '[program:php-fpm]' \
        'command=/usr/local/sbin/php-fpm -F' \
        'autostart=true' \
        'autorestart=true' \
        'priority=10' \
        'stdout_logfile=/dev/fd/1' \
        'stdout_logfile_maxbytes=0' \
        'stderr_logfile=/dev/fd/2' \
        'stderr_logfile_maxbytes=0' \
        '' \
        '[program:nginx]' \
        'command=/usr/sbin/nginx -g "daemon off;"' \
        'autostart=true' \
        'autorestart=true' \
        'priority=20' \
        'stdout_logfile=/dev/fd/1' \
        'stdout_logfile_maxbytes=0' \
        'stderr_logfile=/dev/fd/2' \
        'stderr_logfile_maxbytes=0' \
        > /etc/supervisord.conf

# ----------------------------------------------------------
# Startup
# ----------------------------------------------------------
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
