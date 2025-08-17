# --- STAGE 1: Install PHP dependencies ---
FROM composer:2 AS vendor
WORKDIR /app

# Copy essential files for composer install to succeed
COPY composer.json composer.lock ./
COPY artisan ./
COPY bootstrap/ ./bootstrap/
COPY app/ ./app/
COPY routes/ ./routes/

# Install production dependencies
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# Optimize autoloader
RUN composer dump-autoload --optimize


# --- STAGE 2: Build frontend assets with Node.js ---
FROM node:20-alpine AS assets
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install Node.js dependencies
RUN npm ci

# Copy full app (including resources, config, etc.)
COPY . .

# Build frontend assets using Vite
RUN npm run build


# --- STAGE 3: Final runtime image with NGINX + PHP-FPM ---
FROM richarvey/nginx-php-fpm:latest

# Set document root
ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

# Copy the entire app from the vendor stage
COPY --from=vendor /app /var/www/html

# Copy only the built assets from the assets stage
COPY --from=assets /app/public/build ./public/build

# Fix permissions: Use correct user 'www-data', not 'www-www-data'
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# Ensure logs directory is writable
RUN mkdir -p storage/logs \
 && chown -R www-data:www-data storage/logs \
 && chmod -R 775 storage/logs