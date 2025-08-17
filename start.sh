#!/bin/sh

# Run migrations
echo "Running migrations..."
php artisan migrate --force

# Start Nginx
echo "Starting Nginx..."
service nginx start

# Start PHP-FPM
echo "Starting PHP-FPM..."
service php-fpm start

# Keep container alive and show logs
echo "Tailing logs..."
tail -f storage/logs/laravel.log