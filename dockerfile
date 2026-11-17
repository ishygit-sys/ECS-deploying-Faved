# Frontend stage 1
FROM node:22-slim AS frontend

WORKDIR /app

COPY app/frontend/package*.json ./

RUN npm ci 

COPY  app/frontend ./

RUN npm run build

# build/backend

FROM php:8.5-cli AS composer

COPY  --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY  app/composer.json app/composer.lock ./

RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*

RUN composer install --no-dev --optimize-autoloader


 # stage 3 runtime


 FROM php:8.5-apache AS production

 RUN a2enmod rewrite 

 WORKDIR /var/www/html

 COPY app/ /var/www/html

 COPY app/apache-conf/faved.conf /etc/apache2/sites-available/

 RUN a2dissite 000-default && a2ensite faved 

 COPY --from=frontend /app/dist/ /var/www/html/public/dist

 COPY --from=composer /app/vendor /var/www/html/vendor/

 COPY health.php /var/www/html/public/

 RUN chown -R www-data:www-data /var/www/html 

 RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/:80>/:8080>/' /etc/apache2/sites-available/faved.conf

 USER www-data

 EXPOSE 8080





























