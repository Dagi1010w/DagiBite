
<script setup>
import { ref, onMounted } from 'vue';
import Chart from 'chart.js/auto';
import { Link } from '@inertiajs/vue3'; // ✅ No need to register manually
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'; 
import SideBar from '@/Pages/Restaurant/SideBar.vue';

defineProps({
  auth: Object
});

const salesChart = ref(null);

onMounted(() => {
  if (salesChart.value) {
    const ctx = salesChart.value.getContext('2d');
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: ['6AM', '8AM', '10AM', '12PM', '2PM', '4PM', '6PM', '8PM'],
        datasets: [{
          label: 'Orders',
          data: [5, 12, 8, 15, 18, 22, 24, 18],
          borderColor: '#ea580c',
          backgroundColor: 'rgba(234, 88, 12, 0.1)',
          borderWidth: 2,
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: { stepSize: 5 }
          }
        }
      }
    });
  }

  // Notification
  function showNotification() {
    const notification = document.getElementById('newOrderNotification');
    if (notification) {
      notification.classList.remove('translate-y-20', 'opacity-0');
      notification.classList.add('translate-y-0', 'opacity-100');
      setTimeout(() => {
        notification.classList.remove('translate-y-0', 'opacity-100');
        notification.classList.add('translate-y-20', 'opacity-0');
      }, 5000);
    }
  }

  setInterval(showNotification, 15000);
  setTimeout(showNotification, 2000);
});
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
                    <h1 class="text-3xl font-bold text-gray-800">Restaurant Dashboard</h1>
                    <p class="text-gray-600">Manage your orders and restaurant operations</p>
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
                        <img src="https://placehold.co/40x40?text=RS" alt="Restaurant manager profile picture - professional headshot with neutral background" class="h-8 w-8 rounded-full">
                        <span class="hidden md:block ml-2 font-medium">Restaurant Manager</span>
                    </div>
                </div>
            </div>

            <!-- Stats Overview -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Today's Orders</p>
                            <p class="text-3xl font-bold mt-1">24</p>
                        </div>
                        <div class="p-3 rounded-lg bg-orange-50 text-orange-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                            </svg>
                        </div>
                    </div>
                    <p class="text-sm text-green-500 mt-2 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
                        </svg>
                        +12% from yesterday
                    </p>
                </div>

                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Pending Orders</p>
                            <p class="text-3xl font-bold mt-1">5</p>
                        </div>
                        <div class="p-3 rounded-lg bg-blue-50 text-blue-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
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
                            <p class="text-gray-500">Today's Revenue</p>
                            <p class="text-3xl font-bold mt-1">$842</p>
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
                        +15% from yesterday
                    </p>
                </div>

                <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500">Avg. Order Value</p>
                            <p class="text-3xl font-bold mt-1">$35.08</p>
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
                        +5% from yesterday
                    </p>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
                <!-- Orders Section -->
                <div class="lg:col-span-2 bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="p-6 border-b border-gray-100">
                        <div class="flex items-center justify-between">
                            <h2 class="text-xl font-semibold text-gray-800">Recent Orders</h2>
                            <button class="text-orange-600 hover:text-orange-700">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
                                </svg>
                            </button>
                        </div>
                    </div>
                    
                    <div class="divide-y divide-gray-100 scrollbar-hide" style="max-height: 500px; overflow-y: auto;">
                        <!-- Order 1 -->
                        <!-- ... (orders markup unchanged) ... -->
                    </div>
                </div>

                <!-- Activity and Popular Items -->
                <!-- ... (rest of the template unchanged) ... -->
            </div>
        </div>
    </div>

    <!-- New Order Notification -->
    <div id="newOrderNotification" class="fixed bottom-5 right-5 bg-orange-600 text-white p-4 rounded-lg shadow-lg transform transition-transform duration-300 translate-y-20 opacity-0 floating-notification">
        <div class="flex items-center justify-between">
            <div>
                <h3 class="font-bold">New Order Received!</h3>
                <p>Order #3243 - 2 items • $24.50</p>
            </div>
            <button class="ml-4 bg-white text-orange-600 px-3 py-1 rounded hover:bg-gray-100 transition">
                View
            </button>
        </div>
    </div>


    <div>
    <!-- ✅ Canvas for Chart -->
    <canvas ref="salesChart" class="w-full h-64"></canvas>

    <!-- Optional: New Order Notification -->
    <div
      id="newOrderNotification"
      class="fixed top-4 right-4 bg-orange-500 text-white px-4 py-2 rounded transition duration-500 transform translate-y-20 opacity-0"
    >
      🔔 New order received!
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
