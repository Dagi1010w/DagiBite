# ---------- Base PHP image ----------
FROM php:8.2-fpm

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

# Install Node.js (v18 LTS) & npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# Set working directory
WORKDIR /app

# Copy only composer files first for caching
COPY composer.json composer.lock ./

# Install PHP dependencies without platform checks
RUN composer install --no-dev --prefer-dist --no-interaction --ignore-platform-reqs

# Copy package files and install Node.js dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the application
COPY . .

# Create required directories for nginx (if using it inside container)
RUN mkdir -p /var/log/nginx && mkdir -p /var/cache/nginx

# Expose port (default PHP-FPM is 9000, change if needed)
EXPOSE 9000

# Default command (for PHP-FPM)
CMD ["php-fpm"]
