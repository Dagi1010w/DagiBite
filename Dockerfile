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

# Install Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy composer files and install PHP deps
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --ignore-platform-reqs --no-scripts

# =========================
# Stage 2 - Node dependencies
# =========================
FROM node:18 AS node-deps

WORKDIR /app

# Copy package files and install Node deps
COPY package*.json ./
RUN npm ci

# =========================
# Stage 3 - Final image
# =========================
FROM php:8.2-fpm

# Install system deps & PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libzip-dev zip curl ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql bcmath exif pcntl \
    && rm -rf /var/lib/apt/lists/*

# Copy Composer from php-deps stage
COPY --from=php-deps /usr/bin/composer /usr/bin/composer
COPY --from=php-deps /app/vendor /app/vendor

# Copy Node modules from node-deps stage
COPY --from=node-deps /app/node_modules /app/node_modules

WORKDIR /app

# Copy the rest of the app source
COPY . .

# Ignore Laravel's storage symlink in builds (handled at runtime)
RUN rm -rf public/storage

# Create required dirs for nginx (optional)
RUN mkdir -p /var/log/nginx && mkdir -p /var/cache/nginx

# Run storage link at container startup
CMD php artisan storage:link && php-fpm

EXPOSE 9000
