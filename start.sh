#!/usr/bin/env bash

echo "Running Composer"
composer install --no-dev --working-dir=/var/www/html

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Publishing cloudinary provider..."
php artisan vendor:publish --provider="Cloudinary\CloudinaryLaravel\CloudinaryServiceProvider" --tag="cloudinary.config"

echo "Running migrations..."
php artisan migrate --force