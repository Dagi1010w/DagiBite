<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SideBar from '@/Pages/Restaurant/SideBar.vue'
import { Link, usePage } from '@inertiajs/vue3';

defineProps({
  auth: Object
})

// Example settings data (replace with real backend data)
const settings = [
  {
    id: 1,
    label: 'Restaurant Name',
    value: 'Pizza Palace',
    icon: '🏪'
  },
  {
    id: 2,
    label: 'Email',
    value: 'manager@pizzapalace.com',
    icon: '📧'
  },
  {
    id: 3,
    label: 'Phone',
    value: '+1 555-123-4567',
    icon: '📞'
  },
  {
    id: 4,
    label: 'Address',
    value: '123 Main St, Springfield',
    icon: '📍'
  },
  {
    id: 5,
    label: 'Opening Hours',
    value: '10:00 AM - 10:00 PM',
    icon: '⏰'
  }
]
</script>

<template>
  <AuthenticatedLayout :auth="auth">
    <div class="min-h-screen flex bg-orange-50">
      <!-- Sidebar -->
      <SideBar />

      <!-- Main Content -->
      <div class="flex-1 ml-20 md:ml-64 p-4 sm:p-6 bg-white bg-opacity-90 min-h-screen transition-all duration-300">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-3xl font-bold text-gray-800">Settings</h1>
            <p class="text-gray-600">Manage your restaurant's profile and preferences</p>
          </div>
          <div class="flex items-center space-x-4">
            <div class="relative">
              <button class="p-2 rounded-full bg-orange-100 text-orange-600 hover:bg-orange-200">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z" />
                </svg>
              </button>
              <span class="absolute top-0 right-0 h-2 w-2 rounded-full bg-red-500"></span>
            </div>
            <div class="flex items-center">
              <img src="https://placehold.co/40x40?text=RS" alt="Restaurant manager profile picture" class="h-8 w-8 rounded-full">
              <span class="hidden md:block ml-2 font-medium">Restaurant Manager</span>
            </div>
          </div>
        </div>

        <!-- Settings Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="setting in settings"
            :key="setting.id"
            class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex items-center space-x-4 hover:shadow-lg transition"
          >
            <div class="text-3xl">{{ setting.icon }}</div>
            <div>
              <div class="text-gray-500 text-sm">{{ setting.label }}</div>
              <div class="text-lg font-semibold text-gray-800 break-all">{{ setting.value }}</div>
            </div>
            <!-- You can add edit buttons here if needed -->
          </div>
        </div>

        <!-- Example: Account Actions -->
        <div class="mt-12">
          <h2 class="text-xl font-semibold text-gray-800 mb-4">Account Actions</h2>
          <div class="flex flex-col sm:flex-row gap-4">
            <template v-if="$page.props.restaurant">
              <Link :href="`/restaurants/${$page.props.restaurant.id}/edit`" class="bg-red-100 hover:bg-red-200 text-red-700 font-semibold py-2 px-6 rounded-lg transition">Edit Restaurant</Link>
            </template>
            <template v-else>
              <Link :href="route('restaurants.create')" class="bg-green-100 hover:bg-green-200 text-green-700 font-semibold py-2 px-6 rounded-lg transition">Add Restaurant</Link>
            </template>
          </div>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
body {
  font-family: 'Poppins', sans-serif;
  background-image: url('https://placehold.co/1920x1080?text=');
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  background-color: #f8f8f8;
}
</style>