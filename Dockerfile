FROM php:8.3.8-apache
COPY src/ /var/www/html/

RUN docker build -t my-php-app .
RUN docker run -d --name my-running-app my-php-app