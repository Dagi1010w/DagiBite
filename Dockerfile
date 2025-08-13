# ---------- Stage 1: PHP dependencies ----------
FROM composer:2 AS composer-deps
WORKDIR /app

# Cache-friendly: copy only composer files first
COPY composer.json composer.lock ./

# IMPORTANT: install WITHOUT running scripts (artisan isn't copied yet)
RUN --mount=type=cache,target=/tmp/cache \
    COMPOSER_CACHE_DIR=/tmp/cache \
    composer install --prefer-dist --no-interaction --no-dev --optimize-autoloader --no-scripts

# Now copy the full app and THEN run scripts (artisan exists now)
COPY . .
RUN composer run-script post-autoload-dump

# ---------- Stage 2: Node/Vite build ----------
FROM node:18 AS node-deps
WORKDIR /app

# Cache-friendly: copy only lockfiles first
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

# Now copy the rest and build
COPY . .
RUN npm run build

# ---------- Stage 3: Production image (PHP-FPM + Nginx) ----------
FROM php:8.2-fpm

# PHP extensions + Nginx
RUN apt-get update && apt-get install -y \
    nginx libpng-dev libjpeg-dev libfreetype6-dev zip git unzip \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install pdo pdo_mysql gd \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

# Backend code from composer stage
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=composer-deps /app/composer.json ./composer.json
COPY --from=composer-deps /app/composer.lock ./composer.lock
COPY --from=composer-deps /app/artisan ./artisan
COPY --from=composer-deps /app/config ./config
COPY --from=composer-deps /app/routes ./routes
COPY --from=composer-deps /app/app ./app
COPY --from=composer-deps /app/database ./database
COPY --from=composer-deps /app/resources ./resources
COPY --from=composer-deps /app/bootstrap ./bootstrap
COPY --from=composer-deps /app/storage ./storage

# Built frontend assets
COPY --from=node-deps /app/public ./public

# Ensure dirs + permissions
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache \
 && chown -R www-data:www-data /var/www \
 && chmod -R ug+rwx /var/www
