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
    ca-certificates \
    gnupg \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Install Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Node.js v18 directly from Debian repos
RUN apt-get update && apt-get install -y nodejs npm \
    && npm install -g npm@latest

# Set working directory
WORKDIR /app

# Copy composer files first
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --ignore-platform-reqs

# Copy package files and install Node.js dependencies
COPY package*.json ./
RUN npm ci

# Copy rest of the application
COPY . .

# Create required directories for nginx (if using it)
RUN mkdir -p /var/log/nginx && mkdir -p /var/cache/nginx

EXPOSE 9000

CMD ["php-fpm"]
