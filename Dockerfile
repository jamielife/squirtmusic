FROM php:8.3.8-apache
COPY src/ /var/www/html/
CMD docker build -t my-php-app . && docker run -d --name my-running-app my-php-app