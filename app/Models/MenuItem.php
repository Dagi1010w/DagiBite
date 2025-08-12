<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MenuItem extends Model
{
     protected $table = 'menu_items';
     protected $fillable = ['name', 'price', 'picture', 'description', 'restaurant_id'];

     public function restaurant()
     {
         return $this->belongsTo(\App\Models\Restaurant::class);
     }
}
