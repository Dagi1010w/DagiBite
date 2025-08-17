# --- STAGE 1: Install PHP dependencies ---
FROM composer:2 AS vendor
WORKDIR /app

COPY composer.json composer.lock ./
COPY artisan ./
COPY bootstrap/ ./bootstrap/
COPY app/ ./app/
COPY routes/ ./routes/

RUN composer install --no-dev --prefer-dist --no-progress --no-interaction
RUN composer dump-autoload --optimize

# --- STAGE 2: Build frontend assets ---
FROM node:20-alpine AS assets
WORKDIR /app

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- STAGE 3: Final runtime image ---
FROM richarvey/nginx-php-fpm:latest

ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

COPY --from=assets /app /var/www/html
COPY --from=assets /app/public/build ./public/build

# ✅ Fix permissions with CORRECT user
RUN mkdir -p \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs \
    bootstrap/cache \
 && chown -R www-www-data storage \
 && chmod -R 775 storage \
 && chown -R www-www-data bootstrap/cache \
 && chmod -R 775 bootstrap/cache

# Ensure logs are writable
RUN chown -R www-www-data storage/logs \
 && chmod -R 775 storage/logs

# ✅ Start app: migrate, start services
CMD sh -c "php artisan migrate --force && \
           service nginx start && \
           service php-fpm start && \
           tail -f storage/logs/laravel.log"