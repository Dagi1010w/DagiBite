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

# Copy full app
COPY . .
RUN npm run build


# --- STAGE 3: Final runtime image ---
FROM richarvey/nginx-php-fpm:latest

ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

# Copy full app from assets stage (has everything)
COPY --from=assets /app /var/www/html

# Re-copy only the built assets (optional, but ensures latest)
COPY --from=assets /app/public/build ./public/build

# Ensure directories exist and set permissions
RUN mkdir -p storage bootstrap/cache storage/logs \
 && chown -R www-data:www-data storage bootstrap/cache storage/logs \
 && chmod -R 775 storage bootstrap/cache storage/logs