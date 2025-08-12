<script>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SideBar from '@/Pages/Restaurant/SideBar.vue';


export default {
  name: 'CustomersPage',
  components: {
    AuthenticatedLayout,
    SideBar
  },
  props: {
    auth: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      customers: [
        {
          id: 1,
          name: 'John Smith',
          email: 'john.smith@email.com',
          avatar: 'https://placehold.co/60x60?text=JS',
          joined: '2023-08-12',
          orders: 12,
          spent: 420.50
        },
        {
          id: 2,
          name: 'Sarah Johnson',
          email: 'sarah.j@email.com',
          avatar: 'https://placehold.co/60x60?text=SJ',
          joined: '2023-09-05',
          orders: 7,
          spent: 210.99
        },
        {
          id: 3,
          name: 'Michael Brown',
          email: 'michael.b@email.com',
          avatar: 'https://placehold.co/60x60?text=MB',
          joined: '2022-12-22',
          orders: 18,
          spent: 680.75
        },
        {
          id: 4,
          name: 'Emily Wilson',
          email: 'emily.w@email.com',
          avatar: 'https://placehold.co/60x60?text=EW',
          joined: '2023-01-15',
          orders: 5,
          spent: 120.99
        }
      ]
    }
  }

  
}
</script>

<template>
  <AuthenticatedLayout :auth="auth">
    <div class="min-h-screen flex">
      <!-- Sidebar -->
      <SideBar />

      <!-- Main Content -->
      <div class="flex-1 ml-20 md:ml-64 p-6 bg-white bg-opacity-90 min-h-screen">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
          <div>
            <h1 class="text-3xl font-bold text-gray-800">Customers</h1>
            <p class="text-gray-600">View and manage your restaurant's customers</p>
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

        <!-- Stats Overview -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Total Customers</p>
                <p class="text-3xl font-bold mt-1">1,245</p>
              </div>
              <div class="p-3 rounded-lg bg-orange-50 text-orange-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87M17 8a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
            </div>
            <p class="text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +30 this week
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">New Today</p>
                <p class="text-3xl font-bold mt-1">7</p>
              </div>
              <div class="p-3 rounded-lg bg-blue-50 text-blue-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.104-.896-2-2-2s-2 .896-2 2 .896 2 2 2 2-.896 2-2zm6 2a2 2 0 100-4 2 2 0 000 4zm-6 6a6 6 0 100-12 6 6 0 000 12z" />
                </svg>
              </div>
            </div>
            <p class="text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +2 from yesterday
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Returning</p>
                <p class="text-3xl font-bold mt-1">1,050</p>
              </div>
              <div class="p-3 rounded-lg bg-green-50 text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
            <p class="text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              84% retention
            </p>
          </div>
          <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500">Avg. Orders</p>
                <p class="text-3xl font-bold mt-1">4.2</p>
              </div>
              <div class="p-3 rounded-lg bg-purple-50 text-purple-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
            </div>
            <p class="text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +0.2 this month
            </p>
          </div>
        </div>

        <!-- Main Content Area: Customers List -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <div class="p-6 border-b border-gray-100 flex items-center justify-between">
            <h2 class="text-xl font-semibold text-gray-800">Customer List</h2>
            <button class="text-orange-600 hover:text-orange-700 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
              </svg>
              Add Customer
            </button>
          </div>
          <div class="divide-y divide-gray-100 scrollbar-hide" style="max-height: 600px; overflow-y: auto;">
            <div v-for="customer in customers" :key="customer.id" class="p-6 hover:bg-gray-50 transition-colors duration-150 flex items-center justify-between">
              <div class="flex items-center">
                <img :src="customer.avatar" :alt="customer.name" class="h-12 w-12 rounded-full object-cover">
                <div class="ml-4">
                  <h3 class="font-medium text-gray-800">{{ customer.name }}</h3>
                  <p class="text-sm text-gray-500">{{ customer.email }}</p>
                  <p class="text-xs text-gray-400 mt-1">Joined: {{ customer.joined }}</p>
                </div>
              </div>
              <div class="flex items-center space-x-8">
                <div class="text-center">
                  <p class="text-lg font-bold text-gray-800">{{ customer.orders }}</p>
                  <p class="text-xs text-gray-500">Orders</p>
                </div>
                <div class="text-center">
                  <p class="text-lg font-bold text-gray-800">${{ customer.spent }}</p>
                  <p class="text-xs text-gray-500">Spent</p>
                </div>
                <button class="p-2 rounded-lg bg-orange-100 text-orange-700 hover:bg-orange-200">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M15 8a3 3 0 11-6 0 3 3 0 016 0zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
            </div>
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