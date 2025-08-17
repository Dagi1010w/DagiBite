# --- STAGE 1: Install PHP dependencies ---
FROM composer:2 AS vendor
WORKDIR /app

# Copy essential files for composer install
COPY composer.json composer.lock ./
COPY artisan ./
COPY bootstrap/ ./bootstrap/
COPY app/ ./app/
COPY routes/ ./routes/

# Install production dependencies
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction

# Optimize autoloader
RUN composer dump-autoload --optimize


# --- STAGE 2: Build frontend assets ---
FROM node:20-alpine AS assets
WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Copy full app
COPY . .
RUN npm run build


# --- STAGE 3: Final runtime image ---
FROM richarvey/nginx-php-fpm:latest

# Set document root
ENV WEBROOT=/var/www/html/public
WORKDIR /var/www/html

# Copy full app from assets stage
COPY --from=assets /app /var/www/html

# Re-copy built assets
COPY --from=assets /app/public/build ./public/build

# 🔧 Create required directories and fix permissions
# ✅ Fixed: user is 'www-data', not 'www-www-data'
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

# ✅ Final command to start the service
CMD sh -c "php artisan migrate --force && \
           service nginx start && \
           service php-fpm start && \
           tail -f storage/logs/laravel.log"