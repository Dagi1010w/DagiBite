# Stage 1: PHP + Composer
FROM composer:2 AS composer-deps
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader
COPY . .

# Stage 2: Node + Build
FROM node:18 AS node-deps
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 3: Production
FROM php:8.2-fpm
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /var/www
COPY --from=composer-deps /app /var/www
COPY --from=node-deps /app/public /var/www/public
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
EXPOSE 80
CMD ["php-fpm"]
