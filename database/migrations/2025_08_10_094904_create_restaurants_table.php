<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
         Schema::create('restaurants', function (Blueprint $table) {
    $table->id();

    // Foreign key to users table
    $table->foreignId('user_id')
          ->constrained()
          ->cascadeOnDelete();

    $table->string('name');
    $table->text('description')->nullable();
    $table->string('category')->nullable();
    $table->string('phone')->unique()->nullable();
    $table->text('address')->nullable();

    // Optional logo path
    $table->string('logo_path')->nullable();

    // Rating (max 9.99)
    $table->decimal('rating', 3, 2)->default(0);

    // Unique slug for SEO-friendly URLs
    $table->string('slug')->unique();

    $table->timestamps();
});

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('restaurants');
    }
};
