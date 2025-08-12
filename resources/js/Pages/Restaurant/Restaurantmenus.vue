<script setup>
import { ref, onMounted } from 'vue';
import { usePage, Link } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SideBar from '@/Pages/Restaurant/SideBar.vue'

const { props } = usePage();
const menus = ref([]);
const loading = ref(true);
const restaurant = ref(null);

// Fetch restaurant menus
const fetchMenus = async () => {
    try {
        const response = await fetch('/api/restaurant/menus');
        const data = await response.json();
        menus.value = data.menus || [];
        restaurant.value = data.restaurant || null;
    } catch (error) {
        console.error('Error fetching menus:', error);
    } finally {
        loading.value = false;
    }
};

// Delete menu item
const deleteMenu = async (id) => {
    if (confirm('Are you sure you want to delete this menu item?')) {
        try {
            const response = await fetch(`/api/restaurantmenus/${id}`, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
                    'Content-Type': 'application/json'
                }
            });
            if (response.ok) {
                menus.value = menus.value.filter(menu => menu.id !== id);
            }
        } catch (error) {
            console.error('Error deleting menu:', error);
        }
    }
};

onMounted(() => {
    fetchMenus();
});
</script>

<template>
    <AuthenticatedLayout :auth="$page.props.auth">
        <div class="min-h-screen flex bg-orange-50">
        <SideBar />
        <div class="flex-1 ml-20 md:ml-64 p-4 sm:p-6 bg-white bg-opacity-90 min-h-screen transition-all duration-300">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-10 py-8">

                <!-- Header -->
                <div class="bg-white shadow rounded-2xl p-6 mb-8 border border-orange-100">
                    <div class="flex flex-col sm:flex-row justify-between items-center gap-6">
                        <div>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-orange-600">🍽 Manage Menus</h1>
                            <p class="mt-1 text-gray-600 max-w-md">Easily manage your restaurant's menu items</p>
                        </div>
                        <Link 
                            href="/menuform" 
                            class="bg-orange-600 text-white px-5 py-2 rounded-lg shadow-md hover:bg-orange-700 transition transform hover:scale-105 whitespace-nowrap"
                        >
                            ➕ Add New Menu
                        </Link>
                    </div>
                </div>

                <!-- Loading State -->
                <div v-if="loading" class="text-center py-12">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-600 mx-auto"></div>
                    <p class="mt-4 text-gray-600">Loading menus...</p>
                </div>

                <!-- Empty State -->
                <div v-if="!loading && menus.length === 0" class="bg-white shadow rounded-2xl p-10 text-center border border-dashed border-orange-300">
                    <svg class="mx-auto h-12 w-12 text-orange-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
                    <h3 class="mt-4 text-lg font-semibold text-gray-900">No menus yet</h3>
                    <p class="mt-1 text-gray-500 max-w-xs mx-auto">Start by creating your first menu item.</p>
                    <Link 
                        href="/menuform" 
                        class="mt-5 inline-flex items-center px-5 py-2 rounded-lg shadow-md text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 transition transform hover:scale-105 whitespace-nowrap"
                    >
                        Create Menu
                    </Link>
                </div>

                <!-- Menu Grid -->
                <div v-if="!loading && menus.length > 0" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div 
                        v-for="menu in menus" 
                        :key="menu.id" 
                        class="bg-white shadow-lg rounded-2xl overflow-hidden hover:shadow-xl transition transform hover:scale-[1.02] border border-gray-100 flex flex-col"
                    >
                        <div v-if="menu.picture" class="relative flex-shrink-0">
                            <img 
                                :src="`/storage/${menu.picture}`" 
                                :alt="menu.name"
                                class="w-full h-48 object-cover"
                            />
                            <span class="absolute top-2 right-2 bg-orange-600 text-white px-3 py-1 text-xs rounded-full shadow">
                                ${{ parseFloat(menu.price).toFixed(2) }}
                            </span>
                        </div>
                        <div class="p-5 flex flex-col flex-grow">
                            <h3 class="text-lg sm:text-xl font-bold text-gray-900">{{ menu.name }}</h3>
                            <p class="text-gray-600 text-sm sm:text-base mt-1 line-clamp-2">{{ menu.description }}</p>
                            <p class="text-sm sm:text-base text-gray-500 mt-2">
                                Category: <span class="font-medium">{{ menu.category || 'Uncategorized' }}</span>
                            </p>

                            <div class="flex justify-end items-center gap-3 mt-auto pt-4 border-t border-gray-100">
                                <Link 
                                    :href="`/menus/${menu.id}/edit`" 
                                    class="px-3 py-1 rounded-md bg-blue-50 text-blue-600 hover:bg-blue-100 transition whitespace-nowrap"
                                >
                                    ✏ Edit
                                </Link>
                                <button 
                                    @click="deleteMenu(menu.id)" 
                                    class="px-3 py-1 rounded-md bg-red-50 text-red-600 hover:bg-red-100 transition whitespace-nowrap"
                                >
                                    🗑 Delete
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        </div>
    </AuthenticatedLayout>
</template>
