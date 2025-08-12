<script setup>
import { ref, computed } from 'vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Contact from '@/Pages/Comp/Contact.vue';

const props = defineProps({
  auth: Object,
  restaurants: Array,
});

const searchQuery = ref('');
const selectedCategory = ref('All');
const minRating = ref(0);

const categories = computed(() => {
  const cats = (props.restaurants || []).map(r => r.category).filter(Boolean);
  return ['All', ...Array.from(new Set(cats))];
});

const filteredRestaurants = computed(() => {
  const list = props.restaurants || [];
  return list.filter(r => {
    const name = (r.name || '').toLowerCase();
    const matchesSearch = name.includes(searchQuery.value.toLowerCase());
    const matchesCategory = selectedCategory.value === 'All' || r.category === selectedCategory.value;
    const rating = parseFloat(r.rating || 0);
    const matchesRating = rating >= minRating.value;
    return matchesSearch && matchesCategory && matchesRating;
  });
});

function restaurantImage(r) {
  if (r.logo_path) return `/storage/${r.logo_path}`;
  return 'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?auto=format&fit=crop&w=900&q=60';
}

function viewRestaurant(restaurant) {
  // Navigate to the public restaurant page by slug
  if (restaurant.slug) {
    window.location.href = `/restaurants/${encodeURIComponent(restaurant.slug)}`;
  } else {
    window.location.href = `/restaurants/${restaurant.id}`; // fallback
  }
}

defineOptions({
  layout: AuthenticatedLayout,
});
</script>

<template>
  <section class="bg-orange-50 min-h-screen py-16 px-6">
    <div class="max-w-7xl mx-auto">
      <h1 class="text-4xl font-extrabold text-orange-600 mb-10 text-center">Restaurants</h1>

      <div class="mb-8 max-w-4xl mx-auto flex flex-col sm:flex-row sm:items-center sm:space-x-6 space-y-4 sm:space-y-0">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search restaurants..."
          class="flex-grow px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition"
        />
        <select
          v-model="selectedCategory"
          class="px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition"
        >
          <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
        </select>
        <select
          v-model.number="minRating"
          class="px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition"
        >
          <option :value="0">All Ratings</option>
          <option :value="4">4 stars & up</option>
          <option :value="4.5">4.5 stars & up</option>
          <option :value="5">5 stars</option>
        </select>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
        <div
          v-for="restaurant in filteredRestaurants"
          :key="restaurant.id"
          class="bg-white rounded-2xl shadow-lg overflow-hidden transform hover:scale-105 transition-transform duration-300 cursor-pointer"
          @click="viewRestaurant(restaurant)"
        >
          <img
            :src="restaurantImage(restaurant)"
            :alt="restaurant.name"
            class="w-full h-48 object-cover"
          />
          <div class="p-6">
            <h3 class="text-xl font-semibold text-orange-600 mb-2">{{ restaurant.name }}</h3>
            <p class="text-gray-700 text-sm mb-2 min-h-[60px]">{{ restaurant.description }}</p>
            <p class="text-sm text-orange-500 font-semibold mb-4">Category: {{ restaurant.category }}</p>
            <p class="text-sm text-yellow-500 font-semibold">Rating: {{ restaurant.rating }} ⭐</p>
            <button
              class="mt-4 bg-orange-600 text-white px-4 py-2 rounded-xl hover:bg-orange-700 transition"
              @click.stop="viewRestaurant(restaurant)"
            >
              View
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
  <Contact />
</template>
