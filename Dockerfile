# --- 1) PHP deps with Composer (no dev) ---
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction
COPY . .
# Optional: discover providers, optimize autoload
RUN php artisan package:discover --ansi || true \
 && composer dump-autoload --optimize

# --- 2) Build front-end assets with Vite ---
FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- 3) Final runtime: NGINX + PHP-FPM ---
FROM richarvey/nginx-php-fpm:latest
ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

# App code + vendor
COPY --from=vendor /app /var/www/html
# Prebuilt Vite assets
COPY --from=assets /app/public/build /var/www/html/public/build

# Laravel writable dirs
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache
