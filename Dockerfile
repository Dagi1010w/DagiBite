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


# --- STAGE 3: Final runtime with PHP 8.2 + Apache + PostgreSQL support ---
FROM php:8.2-apache

# Install system dependencies including PostgreSQL client and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP PostgreSQL extension
RUN docker-php-ext-install pdo pdo_pgsql pgsql

# Enable Apache mods
RUN a2enmod rewrite

# Configure Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
 && sed -ri -e 's!/var/www!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy full app from assets stage
COPY --from=assets /app /var/www/html

# Copy vendor directory from vendor stage
COPY --from=vendor /app/vendor /var/www/html/vendor

# Ensure storage and cache dirs exist and are writable
# ✅ CORRECT: user is 'www-www-data', NOT 'www-www-data'
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
 && chown -R www-www-data /var/www/html/storage /var/www/html/bootstrap/cache \
 && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Run migrations and start Apache
CMD php /var/www/html/artisan migrate --force && \
    apache2-foreground