# =========================
# Stage 1 - PHP dependencies
# =========================
FROM php:8.2-fpm AS php-deps

# Install system deps & PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libzip-dev zip curl ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql bcmath exif pcntl \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy composer files and install PHP deps
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --ignore-platform-reqs --no-scripts

# =========================
# Stage 2 - Node dependencies
# =========================
FROM node:18 AS node-deps

WORKDIR /app

COPY package*.json ./
RUN npm ci

# =========================
# Stage 3 - Final image with PHP-FPM + Nginx
# =========================
FROM php:8.2-fpm

# Install Nginx & PHP extensions
RUN apt-get update && apt-get install -y \
    nginx libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libzip-dev zip curl ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql bcmath exif pcntl \
    && rm -rf /var/lib/apt/lists/*

# Copy Composer & vendor files
COPY --from=php-deps /usr/bin/composer /usr/bin/composer
COPY --from=php-deps /var/www/vendor /var/www/vendor

# Copy Node modules
COPY --from=node-deps /app/node_modules /var/www/node_modules

WORKDIR /var/www

# Copy Laravel application
COPY . .

# Remove existing storage link & recreate at runtime
RUN rm -rf public/storage && mkdir -p /var/www/storage \
    && chown -R www-data:www-data /var/www

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD php artisan storage:link && php artisan serve --host=0.0.0.0 --port=80

