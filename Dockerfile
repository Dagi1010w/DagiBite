# --- STAGE 1: Install PHP dependencies (with artisan present) ---
FROM composer:2 AS vendor
WORKDIR /app

# Copy composer files first
COPY composer.json composer.lock ./

# Copy artisan early so `package:discover` works
COPY artisan ./

# Install production dependencies
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# Optional: Optimize autoloader
RUN composer dump-autoload --optimize


# --- STAGE 2: Build frontend assets with Node.js ---
FROM node:20-alpine AS assets
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Node.js dependencies
RUN npm ci

# Copy full app (including PHP files, resources, etc.)
COPY . .

# Build frontend assets using Vite
RUN npm run build


# --- STAGE 3: Final runtime image with NGINX + PHP-FPM ---
FROM richarvey/nginx-php-fpm:latest

# Set working directory
ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

# Copy entire app from vendor stage (includes vendor/, artisan, etc.)
COPY --from=vendor /app /var/www/html

# Copy built assets from Node stage
COPY --from=assets /app/public/build ./public/build

# Ensure writable directories for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# Optional: Set proper permissions on logs
RUN mkdir -p storage/logs \
 && chown -R www-data:www-data storage/logs \
 && chmod -R 775 storage/logs