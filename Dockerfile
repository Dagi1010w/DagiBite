# =========================
# Stage 1: PHP dependencies
# =========================
FROM composer:2 AS vendor
WORKDIR /app

# Copy only composer files first (better layer caching)
COPY composer.json composer.lock ./

# Install production deps (no cache mounts)
RUN composer install --no-dev --prefer-dist --no-ansi --no-interaction --no-progress

# Copy the rest of the app (so we can optimize autoload)
COPY . .
RUN composer dump-autoload -o --no-ansi

# =====================================
# Stage 2: Frontend (Vite) build output
# =====================================
FROM node:20 AS frontend
WORKDIR /app

# Copy package files first for caching
COPY package.json ./
COPY package-lock.json* ./
COPY yarn.lock* ./
COPY pnpm-lock.yaml* ./

# Install deps (auto-pick npm/yarn/pnpm)
RUN if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; \
    elif [ -f yarn.lock ]; then corepack enable && yarn install --frozen-lockfile; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable && pnpm install --frozen-lockfile; \
    else npm install --no-audit --no-fund; fi

# Build
COPY . .
RUN npm run build

# ==========================================
# Stage 3: Production (Nginx + PHP 8.3 FPM)
# ==========================================
FROM php:8.3-fpm

# System packages & PHP extensions commonly needed by Laravel
RUN apt-get update && apt-get install -y --no-install-recommends \
      nginx git unzip libzip-dev libicu-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) pdo_mysql zip bcmath intl gd opcache \
  && rm -rf /var/lib/apt/lists/*

# PHP production tuning
RUN printf "%s" "\
memory_limit=256M
upload_max_filesize=32M
post_max_size=32M
expose_php=0
opcache.enable=1
opcache.enable_cli=1
opcache.jit=off
opcache.validate_timestamps=0
opcache.max_accelerated_files=20000
opcache.revalidate_freq=0
" > $PHP_INI_DIR/conf.d/zz-prod.ini

WORKDIR /var/www

# Copy application code (everything) first
COPY . .

# Overwrite with production vendor + built assets from previous stages
COPY --from=vendor   /app/vendor            ./vendor
COPY --from=vendor   /app/composer.json     ./composer.json
COPY --from=vendor   /app/composer.lock     ./composer.lock
COPY --from=frontend /app/public/build      ./public/build

# Nginx config & startup script
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Laravel writable dirs
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R ug+rwx storage bootstrap/cache

# Cloud Run best practice: listen on 8080
ENV PORT=8080
EXPOSE 8080

# Run small caches on container boot (won't fail the container if not ready)
ENV APP_ENV=production \
    LOG_CHANNEL=stderr

CMD ["/start.sh"]
