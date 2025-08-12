# Navigation Bar Enhancement

<script setup>
import { Head, Link } from '@inertiajs/vue3';
import Why from './Customer/Why.vue';
import Testimonial from './Customer/Testimonial.vue';
import Contact from './Comp/Contact.vue';

defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    laravelVersion: {
        type: String,
        required: true,
    },
    phpVersion: {
        type: String,
        required: true,
    },
});

function handleImageError() {
    document.getElementById('screenshot-container')?.classList.add('!hidden');
    document.getElementById('docs-card')?.classList.add('!row-span-1');
    document.getElementById('docs-card-content')?.classList.add('!flex-row');
    document.getElementById('background')?.classList.add('!hidden');
}

const bgImage = 'https://images.unsplash.com/photo-1606755962773-d324e0e9e5e6?auto=format&fit=crop&w=1400&q=80'

function scrollToFeatures() {
  alert('In a full application, this would scroll to the menu section')
}

function registerUser() {
  alert('In a full application, this would open the registration form')
}

</script>

<template>
    <Head title="Welcome" />
    
    <div class="position:sticky relative w-full max-w-2xl px-6 lg:max-w-7xl bg-white rounded-lg ">
        <header class="flex justify-between items-center py-5 bg-white">
            <div class="flex items-center space-x-4">
                <div class="bg-orange-500 rounded-full p-2">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M8 12v6m0-6a2 2 0 104 0m0 0v6m0-6a2 2 0 114 0M7 6h10" />
                    </svg>
                </div>
                <Link href='/dashboard' class="text-xl font-bold text-orange-600">DagiBites</Link>
            </div>
            

<nav v-if="canLogin" class="flex items-center space-x-4">
    <Link
        v-if="$page.props.auth.user"
        :href="route('dashboard')"
        class="rounded-md px-3 py-2 text-white bg-blue-600 ring-1 ring-transparent transition hover:bg-blue-500 focus:outline-none focus-visible:ring-[#FF2D20] dark:focus-visible:ring-white"
    >
        Dashboard
    </Link>

    <template v-else>
        <Link
            :href="route('login')"
            class="rounded-md px-3 py-2 text-white bg-orange-600 ring-1 ring-transparent transition hover:bg-orange-500 focus:outline-none focus-visible:ring-[#FF2D20] dark:focus-visible:ring-white"
        >
            Log in
        </Link>

        <Link
            v-if="canRegister"
            :href="route('register')"
            class="rounded-md px-3 py-2 text-white bg-orange-600 ring-1 ring-transparent transition hover:bg-orange-500 focus:outline-none focus-visible:ring-[#FF2D20] dark:focus-visible:ring-white"
        >
            Register
        </Link>
    </template>
</nav>

        </header>
        
        <div class="md:w-1/2 flex justify-center z-10">
        </div>
        
    </div>

    <!-- Hero Section -->
    <div id="app">
        <div class="hero-section relative flex items-center justify-center text-white">
            <div class="absolute inset-0">
                <img src="https://storage.googleapis.com/workspace-0f70711f-8b4e-4d94-86f1-2a93ccde5887/image/64bc9b00-c723-44e8-8115-2c2657d62c0d.png" 
                     alt="Delicious assortment of gourmet dishes" 
                     class="w-full h-full object-cover hidden">
            </div>
            
            <div class="container mx-auto px-6 z-10 text-center">
                <div class="max-w-2xl mx-auto space-y-6">
                    <h1 class="text-4xl md:text-6xl font-bold tracking-tight animate-fade-in">
                        Hungry? <span class="text-amber-400">Good.</span> You're in the right place.
                    </h1>
                    <p class="text-lg md:text-xl text-gray-100">
                        Delivering your favorite meals in under 30 minutes or it's free. 
                        Try FoodExpress today and discover why thousands of customers 
                        trust us for their daily meals.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <Link :href="route('login')"
                            class="bg-amber-500 hover:bg-amber-600 text-white font-bold py-3 px-8 rounded-full transition-all duration-300 transform hover:scale-105 shadow-lg">
                            Explore Menu
                        </Link>
                        <Link :href="route('register')"
                            class="bg-transparent border-2 border-white hover:bg-white hover:text-gray-900 font-bold py-3 px-8 rounded-full transition-all duration-300">
                            Sign Up - It's Free!
                        </Link>
                    </div>
                </div>
            </div>
            
            <div class="absolute bottom-10 left-0 right-0 text-center animate-bounce">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 mx-auto text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3" />
                </svg>
            </div>
        </div>
    </div>
    <Testimonial />
    <Why />
    <footer class="bg-orange-600 text-white">
    <div class="max-w-7xl mx-auto px-6 py-12 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
      <!-- Brand -->
      <div>
        <h2 class="text-2xl font-bold mb-4">🍽️ Dagi Delivery</h2>
        <p class="text-sm">
          Fast, reliable and tasty! Bringing your favorite meals to your doorsteps with love.
        </p>
      </div>

      <!-- Navigation Links -->
      <div>
        <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
        <ul class="space-y-2">
          <li><Link :href="route('login')" href="/" class="hover:underline">Home</Link></li>
          <li><Link :href="route('login')"  class="hover:underline">Menu</Link></li>
          <li><Link :href="route('login')" class="hover:underline">Restaurants</Link></li>
          <li><Link :href="route('login')" class="hover:underline">About</Link></li>
          <li><Link :href="route('login')"  class="hover:underline">Contact</Link></li>
        </ul>
      </div>

      <!-- Contact Info -->
      <div>
        <h3 class="text-lg font-semibold mb-4">Contact Us</h3>
        <p class="text-sm">📍 Bole, Addis Ababa, Ethiopia</p>
        <p class="text-sm">📞 +251 911 123 456</p>
        <p class="text-sm">✉️ support@dagi-delivery.com</p>
      </div>

      <!-- Social Icons -->
      <div>
        <h3 class="text-lg font-semibold mb-4">Follow Us</h3>
        <div class="flex space-x-4">
          <a href="" class="hover:text-gray-200 transition duration-300"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="hover:text-gray-200 transition duration-300"><i class="fab fa-twitter"></i></a>
          <a href="#" class="hover:text-gray-200 transition duration-300"><i class="fab fa-instagram"></i></a>
          <a href="#" class="hover:text-gray-200 transition duration-300"><i class="fab fa-tiktok"></i></a>
        </div>
      </div>
    </div>

    <!-- Bottom -->
    <div class="bg-orange-700 text-center py-4 text-sm">
      © {{ new Date().getFullYear() }} Dagi Delivery. All rights reserved.
    </div>
  </footer>
</template>

<style>
.hero-section {
    background-image: linear-gradient(to right, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.4)), 
                      url('https://storage.googleapis.com/workspace-0f70711f-8b4e-4d94-86f1-2a93ccde5887/image/ec3a6c9a-060d-4894-93c1-7165c242825e.png');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    height: 100vh;
}
@media (max-width: 768px) {
    .hero-section {
        background-attachment: scroll;
    }
}

@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css');
</style>
