FROM php:8.2-apache
RUN apt-get update && apt-get install -y \
unzip \
curl \
libpng-dev \
zip \
git \
curl \
libsqlite3-dev \
&& docker-php-ext-install pdo pdo_sqlite pdo_mysql gd
RUN a2enmod rewrite
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer 
WORKDIR /var/www/html/
COPY . .
RUN composer install --no-interaction --no-dev --optimize-autoloader
RUN chown -R www-data:www-data storage bootstrap/cache database \
&& chmod -R 775 storage storage bootstrap/cache database
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
EXPOSE 80
CMD [ "apache2-foreground" ]