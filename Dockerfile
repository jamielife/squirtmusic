FROM php:8.3.8-apache
COPY src/ /var/www/html/
WORKDIR /var/www/html/
CMD [ "php", "./index.php" ]