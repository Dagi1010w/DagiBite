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
        Schema::dropIfExists('menus');
    }

    public function down(): void
    {
        // Optional: recreate the table if you want to be able to rollback
        Schema::create('menus', function ($table) {
            $table->id();
            $table->string('name');
            $table->timestamps();
        });
    }
};
