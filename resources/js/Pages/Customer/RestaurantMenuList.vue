<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import RestaurantCard from '@/Pages/Customer/Components/RestaurantCard.vue'
import MenuCard from '@/Pages/Customer/Components/MenuCard.vue'
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import axios from 'axios'

const props = defineProps({
  auth: Object,
})

// -------------------- Data from database --------------------
const restaurants = ref([])
const menus = ref([])
const loading = ref(true)
const error = ref(null)

// -------------------- Restaurants controls --------------------
const searchQueryRestaurants = ref('')
const selectedCategory = ref('All')
const minRating = ref(0)

// -------------------- Menus controls --------------------
const queryMenus = ref('')
const selectedSort = ref('name_asc')

// Fetch data from database
onMounted(async () => {
  try {
    const [restaurantsResponse, menusResponse] = await Promise.all([
      axios.get('/api/restaurants'),
      axios.get('/api/menus')
    ])
    
    restaurants.value = restaurantsResponse.data.restaurants
    menus.value = menusResponse.data.menus
  } catch (err) {
    error.value = 'Failed to load data'
    console.error('Error loading data:', err)
  } finally {
    loading.value = false
  }
})

// Order functionality
const orderModalOpen = ref(false)
const selectedMenu = ref(null)
const orderQuantity = ref(1)
const orderNotes = ref('')

const openOrderModal = (menu) => {
  selectedMenu.value = menu
  orderQuantity.value = 1
  orderNotes.value = ''
  orderModalOpen.value = true
}

const closeOrderModal = () => {
  orderModalOpen.value = false
  selectedMenu.value = null
  orderQuantity.value = 1
  orderNotes.value = ''
}

const placeOrder = () => {
  if (!selectedMenu.value) return
  
  // Create order object
  const order = {
    menuId: selectedMenu.value.id,
    menuName: selectedMenu.value.name,
    quantity: orderQuantity.value,
    price: Number(selectedMenu.value.price) || 0,
    total: (Number(selectedMenu.value.price) || 0) * orderQuantity.value,
    notes: orderNotes.value,
    timestamp: new Date().toISOString()
  }
  
  // Store order in localStorage (for demo purposes)
  const existingOrders = JSON.parse(localStorage.getItem('customerOrders') || '[]')
  existingOrders.push(order)
  localStorage.setItem('customerOrders', JSON.stringify(existingOrders))
  
  // Show success message
  alert(`Order placed successfully!\n\n${order.quantity}x ${order.menuName}\nTotal: ${new Intl.NumberFormat('en-ET', {
    style: 'currency',
    currency: 'ETB',
    minimumFractionDigits: 2,
  }).format(order.total)}`)
  
  closeOrderModal()
}

const totalOrderPrice = computed(() => {
  if (!selectedMenu.value) return 0
  return (Number(selectedMenu.value.price) || 0) * orderQuantity.value
})

// Restaurant categories
const categories = computed(() => {
  const cats = (restaurants.value || []).map(r => r.category).filter(Boolean)
  return ['All', ...Array.from(new Set(cats))]
})

// Filtered restaurants
const filteredRestaurants = computed(() => {
  const list = restaurants.value || []
  return list.filter(r => {
    const name = (r.name || '').toLowerCase()
    const matchesSearch = name.includes(searchQueryRestaurants.value.toLowerCase())
    const matchesCategory = selectedCategory.value === 'All' || r.category === selectedCategory.value
    const rating = parseFloat(r.rating || 0)
    const matchesRating = rating >= minRating.value
    return matchesSearch && matchesCategory && matchesRating
  })
})

// Filtered menus
const filteredMenus = computed(() => {
  const q = queryMenus.value.trim().toLowerCase().replace(/\s+/g, ' ')
  let list = (menus.value || []).filter((m) => {
    const name = (m?.name ?? '').toLowerCase()
    const desc = (m?.description ?? '').toLowerCase()
    return q === '' || name.includes(q) || desc.includes(q)
  })

  switch (selectedSort.value) {
    case 'price_asc':
      list.sort((a, b) => (Number(a.price) || 0) - (Number(b.price) || 0))
      break
    case 'price_desc':
      list.sort((a, b) => (Number(b.price) || 0) - (Number(a.price) || 0))
      break
    case 'name_desc':
      list.sort((a, b) => (b.name || '').localeCompare(a.name || '', undefined, { sensitivity: 'base' }))
      break
    case 'name_asc':
    default:
      list.sort((a, b) => (a.name || '').localeCompare(b.name || '', undefined, { sensitivity: 'base' }))
      break
  }

  return list
})

function viewRestaurant(restaurant) {
  if (restaurant?.slug) {
    window.location.href = `/restaurants/${encodeURIComponent(restaurant.slug)}`
  } else if (restaurant?.id) {
    window.location.href = `/restaurants/${restaurant.id}`
  }
}

// -------- Cart state --------
const cartItems = ref([])
const loadCart = () => {
  try {
    cartItems.value = JSON.parse(localStorage.getItem('cart') || '[]')
  } catch (e) {
    cartItems.value = []
  }
}
const cartCount = computed(() => cartItems.value.reduce((sum, i) => sum + Number(i.quantity || 0), 0))
const getCartQuantity = (id) => {
  const item = cartItems.value.find(i => i.menuId === id)
  return item ? Number(item.quantity || 0) : 0
}
const saveCart = () => {
  localStorage.setItem('cart', JSON.stringify(cartItems.value))
  window.dispatchEvent(new CustomEvent('cart:updated', { detail: { count: cartCount.value } }))
}
const addToCart = (menu) => {
  if (!menu) return
  const id = menu.id
  const price = Number(menu.price) || 0
  const name = menu.name || ''
  const idx = cartItems.value.findIndex(i => i.menuId === id)
  if (idx >= 0) {
    cartItems.value[idx].quantity = Number(cartItems.value[idx].quantity || 0) + 1
  } else {
    cartItems.value.push({ menuId: id, name, price, quantity: 1 })
  }
  saveCart()
}
const onStorage = (e) => { if (!e || e.key === 'cart') loadCart() }
const onCartUpdated = () => loadCart()

onMounted(() => {
  loadCart()
  window.addEventListener('storage', onStorage)
  window.addEventListener('cart:updated', onCartUpdated)
})
onBeforeUnmount(() => {
  window.removeEventListener('storage', onStorage)
  window.removeEventListener('cart:updated', onCartUpdated)
})
</script>

<template>
  
    <div class="min-h-screen bg-gradient-to-b from-orange-50/40 via-white to-white">
      <div class="max-w-7xl mx-auto px-6 py-12">
        <!-- Loading State -->
        <div v-if="loading" class="flex justify-center items-center h-64">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500"></div>
          <span class="ml-3 text-gray-600">Loading restaurants and menus...</span>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="text-center py-12">
          <div class="text-red-500 text-xl mb-4">⚠️ {{ error }}</div>
          <button 
            @click="window.location.reload()" 
            class="bg-orange-500 text-white px-4 py-2 rounded-lg hover:bg-orange-600 transition"
          >
            Try Again
          </button>
        </div>

        <!-- Content -->
        <div v-else>
          <!-- Restaurants Section -->
          <h2 class="text-3xl font-extrabold text-gray-900 mb-6">Featured Restaurants</h2>

          <!-- Restaurants Controls -->
          <div class="mb-8 max-w-4xl flex flex-col sm:flex-row sm:items-center sm:space-x-6 space-y-4 sm:space-y-0">
            <input
              v-model="searchQueryRestaurants"
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

          <!-- Restaurants Grid -->
          <div v-if="filteredRestaurants.length === 0" class="text-center py-8 text-gray-500">
            No restaurants found matching your criteria.
          </div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8 mb-16">
            <div
              v-for="restaurant in filteredRestaurants"
              :key="restaurant.id"
              class="cursor-pointer"
              @click="viewRestaurant(restaurant)"
            >
              <RestaurantCard :restaurant="restaurant" />
            </div>
          </div>

          <!-- Menus Section -->
          <h2 class="text-3xl font-extrabold text-gray-900 mb-6">Featured Menus</h2>

          <!-- Menus Controls -->
          <div class="mb-6 rounded-2xl border border-orange-100 bg-white/90 p-4 sm:p-5 shadow-sm">
            <div class="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
              <!-- Search -->
              <div class="w-full sm:max-w-md">
                <label for="menu-search" class="sr-only">Search dishes</label>
                <div class="relative">
                  <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                      <circle cx="11" cy="11" r="8" />
                      <path d="m21 21-4.3-4.3" />
                    </svg>
                  </span>
                  <input
                    id="menu-search"
                    v-model="queryMenus"
                    type="search"
                    placeholder="Search dishes..."
                    class="w-full rounded-xl border border-orange-200/70 bg-white pl-10 pr-10 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <button
                    v-if="queryMenus"
                    type="button"
                    class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-gray-600"
                    aria-label="Clear search"
                    @click="queryMenus = ''"
                  >
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                      <path d="M18 6 6 18M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>

              <!-- Sort -->
              <div class="w-full sm:w-60">
                <label for="menu-sort" class="sr-only">Sort menu</label>
                <div class="relative">
                  <select
                    id="menu-sort"
                    v-model="selectedSort"
                    class="block w-full appearance-none rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  >
                    <option value="name_asc">Name: A → Z</option>
                    <option value="name_desc">Name: Z → A</option>
                    <option value="price_asc">Price: Low → High</option>
                    <option value="price_desc">Price: High → Low</option>
                  </select>
                  <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="h-5 w-5" aria-hidden="true">
                      <path fill-rule="evenodd" d="M5.23 7.21a.75.75 0 0 1 1.06.02L10 10.94l3.71-3.71a.75.75 0 1 1 1.06 1.06l-4.24 4.24a.75.75 0 0 1-1.06 0L5.25 8.27a.75.75 0 0 1-.02-1.06Z" clip-rule="evenodd" />
                    </svg>
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Menus Grid -->
          <div v-if="filteredMenus.length === 0" class="text-center py-8 text-gray-500">
            No menu items found matching your criteria.
          </div>
          <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
            <article
              v-for="menu in filteredMenus"
              :key="menu.id"
              role="listitem"
              class="group relative overflow-hidden rounded-2xl border border-orange-100 bg-white shadow-sm transition-all hover:-translate-y-0.5 hover:shadow-lg focus-within:ring-2 focus-within:ring-orange-300"
            >
              <!-- Subtle top gradient bar -->
              <div class="pointer-events-none absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-orange-500 via-amber-400 to-orange-500 opacity-70"></div>

              <!-- Image with maintained aspect ratio -->
              <div class="relative overflow-hidden">
                <div class="aspect-[4/3] w-full bg-gray-100"></div>
                <img
                  :src="menu?.picture ? `/storage/${menu.picture}` : 'https://via.placeholder.com/800x600.png?text=No+Image'"
                  :alt="menu?.name ? `${menu.name} image` : 'Menu image'"
                  loading="lazy"
                  class="absolute inset-0 h-full w-full object-cover transition duration-300 group-hover:scale-[1.03]"
                />
                <div class="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/15 via-transparent to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100"></div>
              </div>

              <!-- Content -->
              <div class="p-4 sm:p-5">
                <h3 class="text-lg font-semibold text-gray-900">
                  {{ menu.name }}
                </h3>
                <p class="mt-1 text-sm text-gray-600 clamp-2">{{ menu.description }}</p>

                <div class="mt-4 flex items-center justify-between">
                  <span class="text-base sm:text-lg font-semibold text-orange-600">
                    {{ new Intl.NumberFormat('en-ET', {
                      style: 'currency',
                      currency: 'ETB',
                      minimumFractionDigits: 2,
                    }).format(Number(menu.price) || 0) }}
                  </span>
                  <div class="flex gap-2">
                    <button
                      type="button"
                      @click="editMenu(menu)"
                      class="inline-flex items-center gap-1.5 rounded-lg bg-gradient-to-r from-blue-500 to-blue-600 px-3 py-1.5 text-xs font-medium text-white shadow hover:from-blue-600 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300"
                      aria-label="Edit menu"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-4 w-4">
                        <path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-8.4 8.4a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32l8.4-8.4Z"/>
                        <path d="M5.25 5.25a3 3 0 0 0-3 3v10.5a3 3 0 0 0 3 3h10.5a3 3 0 0 0 3-3V13.5a.75.75 0 0 0-1.5 0v5.25a1.5 1.5 0 0 1-1.5 1.5H5.25a1.5 1.5 0 0 1-1.5-1.5V8.25a1.5 1.5 0 0 1 1.5-1.5h5.25a.75.75 0 0 0 0-1.5H5.25Z"/>
                      </svg>
                      Edit
                    </button>
                    <button
                      type="button"
                      @click="deleteMenu(menu)"
                      class="inline-flex items-center gap-1.5 rounded-lg bg-gradient-to-r from-red-500 to-red-600 px-3 py-1.5 text-xs font-medium text-white shadow hover:from-red-600 hover:to-red-700 focus:outline-none focus:ring-2 focus:ring-red-300"
                      aria-label="Delete menu"
                    >
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-4 w-4">
                        <path fill-rule="evenodd" d="M16.5 4.478v.227a48.816 48.816 0 0 1 3.878.512.75.75 0 1 1-.256 1.478l-.209-.035-1.005 13.07a3 3 0 0 1-2.991 2.77H8.084a3 3 0 0 1-2.991-2.77L4.087 6.66l-.209.035a.75.75 0 0 1-.256-1.478A48.567 48.567 0 0 1 7.5 4.705v-.227c0-1.564 1.213-2.9 2.816-2.951a52.662 52.662 0 0 1 3.369 0c1.603.051 2.815 1.387 2.815 2.951Zm-6.136-1.452a51.196 51.196 0 0 1 3.273 0C14.39 3.05 15 3.684 15 4.478v.113a49.488 49.488 0 0 0-6 0v-.113c0-.794.609-1.428 1.224-1.452Z"/>
                        <path d="M5.25 7.5A.75.75 0 0 1 6 6.75h12a.75.75 0 0 1 .75.75v8.25a.75.75 0 0 1-.75.75H6a.75.75 0 0 1-.75-.75V7.5Z"/>
                      </svg>
                      Delete
                    </button>
                  </div>
                </div>
              </div>
            </article>
          </div>
        </div>
      </div>
    </div>
</template>

<style scoped>
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
</style>
