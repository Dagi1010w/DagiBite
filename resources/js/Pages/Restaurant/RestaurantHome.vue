<script setup>
import About from '@/Pages/Comp/About.vue'

</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-cover bg-center relative" style="background-image: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1500&q=80');">
    <div class="absolute inset-0 bg-orange-900 bg-opacity-60"></div>
    <div class="relative z-10 text-center p-10 rounded-xl shadow-xl bg-white bg-opacity-80 max-w-xl mx-auto">
      <h1 class="text-5xl font-extrabold text-orange-800 mb-4 drop-shadow-lg">Welcome to Your Restaurant Dashboard</h1>
      <p class="text-xl text-orange-700 mb-6">Manage your menu, orders, and staff with ease.</p>
      <div class="flex justify-center gap-4">
        <button class="bg-orange-600 hover:bg-orange-700 text-white font-semibold py-2 px-6 rounded-lg shadow transition">View Menu</button>
        <button class="bg-white hover:bg-orange-100 text-orange-700 font-semibold py-2 px-6 rounded-lg shadow border border-orange-300 transition">Add New Item</button>
      </div>
    </div>
  </div>
  <About />
</template>
