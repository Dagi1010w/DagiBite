# ---------- Base PHP image ----------
FROM php:8.2-fpm

# Set the DEBIAN_FRONTEND variable to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Install Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Node.js (v20 LTS) & npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Set working directory
WORKDIR /app

# Copy the entire application first
COPY . .

# Install PHP dependencies without platform checks
RUN composer install --no-dev --prefer-dist --no-interaction --ignore-platform-reqs

# Copy package files and install Node.js dependencies
COPY package*.json ./
RUN npm ci

# Set permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Expose port (default PHP-FPM is 9000, change if needed)
EXPOSE 9000

# Default command (for PHP-FPM)
CMD ["php-fpm"]