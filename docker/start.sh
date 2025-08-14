#!/usr/bin/env sh
set -e

cd /var/www

# Optional: prep caches (don't crash if env/DB not ready yet)
php artisan config:cache --no-ansi || true
php artisan route:cache  --no-ansi || true
php artisan view:cache   --no-ansi || true
php artisan storage:link || true

# Start PHP-FPM in background, then keep Nginx in foreground
php-fpm -D
exec nginx -g 'daemon off;'
