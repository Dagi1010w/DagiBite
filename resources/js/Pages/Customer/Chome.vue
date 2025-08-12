<script setup>
import { Link } from '@inertiajs/vue3';
</script>

<template>
  <section class="relative bg-gradient-to-br from-orange-500 via-yellow-400 to-yellow-300 text-white min-h-screen flex items-center">
    <!-- Background Image -->
    <div
      class="absolute inset-0 bg-cover bg-center filter brightness-75"
      style="background-image: url('https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=1470&q=80');"
      aria-hidden="true"
    ></div>

    <!-- Overlay -->
    <div class="absolute inset-0 bg-gradient-to-r from-orange-700/90 via-orange-600/80 to-yellow-400/60"></div>

    <!-- Content -->
    <div class="relative max-w-7xl mx-auto px-6 py-20 md:py-32 flex flex-col md:flex-row items-center w-full">

      <!-- Text Content -->
      <div class="md:w-1/2 mb-12 md:mb-0 text-center md:text-left z-10">
        <h1 class="text-4xl md:text-6xl font-extrabold drop-shadow-lg mb-6 leading-tight tracking-wide">
          Delicious Food <br /> Delivered To Your Doorstep
        </h1>
        <p class="text-lg md:text-2xl mb-8 drop-shadow-md max-w-lg mx-auto md:mx-0">
          Experience fast and fresh delivery from your favorite restaurants with DagiBites.
          Hot, tasty meals just a click away!
        </p>
        <div class="flex justify-center md:justify-start space-x-6">
          <Link href="/restaurantmenulist"
            class="bg-white text-orange-600 font-semibold px-8 py-4 rounded-lg shadow-lg hover:bg-yellow-200 transition transform hover:-translate-y-1 hover:scale-105 duration-300"
          >
            Order Now
          </Link>
          <Link href="/menu"
            class="bg-transparent border-2 border-white text-white font-semibold px-8 py-4 rounded-lg hover:bg-white hover:text-orange-600 transition transform hover:-translate-y-1 hover:scale-105 duration-300"
          >
          See Menu
          </Link>
        </div>
      </div>
      <!-- Image -->
      <div class="md:w-1/2 flex justify-center z-10">
        <img
          src="https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=600&q=80"
          alt="Delicious food"
          class="rounded-3xl shadow-xl max-w-full h-auto transform transition-transform duration-700 hover:scale-105"
        />
      </div>
    
    </div>
  </section>
</template>


