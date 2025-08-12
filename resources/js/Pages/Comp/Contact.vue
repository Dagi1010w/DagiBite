
<template>
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
          
              <template v-if="user && user.role === 'restaurant'">
                <li><Link href="/restaurant" class="hover:underline">Home</Link></li>
                <li><Link href="/menuform" class="hover:underline">Add Menu</Link></li>
                <li><Link href="/rhome" class="hover:underline">Dashboard</Link></li>
                <li><Link href="/about" class="hover:underline">About</Link></li>
                <li><Link href="/contactus" class="hover:underline">Contact Us</Link></li>
              </template>

              <template v-if="user && user.role === 'customer'">
                <li><Link href="/dashboard" class="hover:underline">Home</Link></li>
                <li><Link href="/restaurantlist" class="hover:underline">Restaurants</Link></li>
                <li><Link href="/menu" class="hover:underline">Menu</Link></li>
                <li><Link href="/about" class="hover:underline">About</Link></li>
                <li><Link href="/contactus" class="hover:underline">Contact Us</Link></li>
              </template>
           
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
          <a href="#" class="hover:text-gray-200 transition duration-300"><i class="fab fa-facebook-f"></i></a>
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

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';
import ResponsiveNavLink from '@/Components/ResponsiveNavLink.vue';
import { Link, usePage } from '@inertiajs/vue3';

const showingNavigationDropdown = ref(false);
const page = usePage();
const user = computed(() => {
  const auth = page.props.auth;
  return auth && (auth.user || auth) ? (auth.user || auth) : null;
});

// Cart indicator state
const cartCount = ref(0);
const loadCartCount = () => {
  try {
    const items = JSON.parse(localStorage.getItem('cart') || '[]');
    cartCount.value = items.reduce((sum, i) => sum + Number(i.quantity || 0), 0);
  } catch (e) {
    cartCount.value = 0;
  }
};
const onStorage = (e) => { if (!e || e.key === 'cart') loadCartCount(); };
const onCartUpdated = () => loadCartCount();

onMounted(() => {
  loadCartCount();
  window.addEventListener('storage', onStorage);
  window.addEventListener('cart:updated', onCartUpdated);
});

onBeforeUnmount(() => {
  window.removeEventListener('storage', onStorage);
  window.removeEventListener('cart:updated', onCartUpdated);
});
</script>

<style scoped>
/* Include Font Awesome if not already */
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css');
</style>
