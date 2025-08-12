<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SideBar from '@/Pages/Restaurant/SideBar.vue'

defineProps({
  auth: Object
})

// Example stats and data (replace with real backend data)
const totalSales = 12450
const totalOrders = 320
const avgOrderValue = totalSales / totalOrders

const topMenuItem = {
  name: 'Margherita Pizza',
  orders: 87
}

const recentOrders = [
  { id: 3243, customer: 'John Smith', menuItem: 'Margherita Pizza', total: 24.50, date: '2024-06-01' },
  { id: 3242, customer: 'Sarah Johnson', menuItem: 'Caesar Salad', total: 12.00, date: '2024-05-31' },
  { id: 3241, customer: 'Michael Brown', menuItem: 'Spaghetti Carbonara', total: 18.75, date: '2024-05-30' },
  { id: 3240, customer: 'Emily Wilson', menuItem: 'Margherita Pizza', total: 24.50, date: '2024-05-29' }
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
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-2">
          <div>
            <h1 class="text-2xl sm:text-3xl font-bold text-gray-800">Reports</h1>
            <p class="text-gray-600 text-sm sm:text-base">View analytics and performance of your restaurant</p>
          </div>
          <div class="flex items-center space-x-4 mt-4 sm:mt-0">
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

        <!-- Stats Overview -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Total Sales</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">${{ totalSales.toLocaleString() }}</p>
              </div>
              <div class="p-3 rounded-lg bg-orange-50 text-orange-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
            <p class="text-xs text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +5% this month
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Orders</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ totalOrders }}</p>
              </div>
              <div class="p-3 rounded-lg bg-blue-50 text-blue-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h2l1 2h8l1-2h2" />
                </svg>
              </div>
            </div>
            <p class="text-xs text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +12 new orders
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Top Menu Item</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ topMenuItem.name }}</p>
              </div>
              <div class="p-3 rounded-lg bg-green-50 text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
              </div>
            </div>
            <p class="text-xs text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              {{ topMenuItem.orders }} orders
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Avg. Order Value</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">${{ avgOrderValue.toFixed(2) }}</p>
              </div>
              <div class="p-3 rounded-lg bg-purple-50 text-purple-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
            </div>
            <p class="text-xs text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +$2.10 this month
            </p>
          </div>
        </div>

        <!-- Recent Orders Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-x-auto">
          <div class="p-6 border-b border-gray-100 flex items-center justify-between">
            <h2 class="text-xl font-semibold text-gray-800">Recent Orders</h2>
          </div>
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-100 text-sm">
              <thead>
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Order #</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Menu Item</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-100">
                <tr v-for="order in recentOrders" :key="order.id" class="hover:bg-orange-50 transition">
                  <td class="px-4 py-4 whitespace-nowrap font-semibold text-orange-700">#{{ order.id }}</td>
                  <td class="px-4 py-4 whitespace-nowrap">{{ order.customer }}</td>
                  <td class="px-4 py-4 whitespace-nowrap">{{ order.menuItem }}</td>
                  <td class="px-4 py-4 whitespace-nowrap">${{ order.total.toFixed(2) }}</td>
                  <td class="px-4 py-4 whitespace-nowrap">{{ order.date }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-if="recentOrders.length === 0" class="text-center text-gray-500 py-8">
            No recent orders found.
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
.bg-orange-transparent {
  background-color: rgba(234, 88, 12, 0.9);
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
}
.chart-container {
  height: 200px;
}
.floating-notification {
  animation: float 3s ease-in-out infinite;
}
@keyframes float {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0px); }
}
</style>