# Stage 1: PHP dependencies
FROM composer:2 AS composer-deps
WORKDIR /app

# Copy composer files first (for caching)
COPY composer.json composer.lock ./

# Use cache mount with Railway-compatible ID
RUN --mount=type=cache,id=cache-composer,target=/tmp/cache \
    COMPOSER_CACHE_DIR=/tmp/cache \
    composer install --prefer-dist --no-interaction --no-dev --optimize-autoloader

# Copy rest of the application
COPY . .

# Stage 2: Node dependencies
FROM node:18 AS node-deps
WORKDIR /app

# Copy package files first (for caching)
COPY package.json package-lock.json ./

# Use cache mount with Railway-compatible ID
RUN --mount=type=cache,id=cache-npm,target=/root/.npm \
    npm install

# Copy rest of the application
COPY . .
RUN npm run build

# Stage 3: Production container
FROM php:8.2-fpm

# Install PHP extensions & Nginx
RUN apt-get update && apt-get install -y \
    nginx libpng-dev libjpeg-dev libfreetype6-dev zip git unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

# Copy backend code & vendor
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

# Copy built frontend assets
COPY --from=node-deps /app/public ./public

# Set permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Configure Nginx
COPY docker/nginx.conf /etc/nginx/sites-available/default

# Start script for Nginx + PHP-FPM
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
