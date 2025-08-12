<script>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import SideBar from '@/Pages/Restaurant/SideBar.vue';

export default {
  name: 'StaffPage',
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
      staff: [
        {
          id: 1,
          name: 'Alice Johnson',
          email: 'alice.johnson@email.com',
          avatar: 'https://placehold.co/60x60?text=AJ',
          role: 'Chef',
          joined: '2021-03-15',
          tenure: 3,
          activeToday: true
        },
        {
          id: 2,
          name: 'Brian Lee',
          email: 'brian.lee@email.com',
          avatar: 'https://placehold.co/60x60?text=BL',
          role: 'Waiter',
          joined: '2022-07-10',
          tenure: 2,
          activeToday: false
        },
        {
          id: 3,
          name: 'Cynthia Smith',
          email: 'cynthia.smith@email.com',
          avatar: 'https://placehold.co/60x60?text=CS',
          role: 'Manager',
          joined: '2020-01-05',
          tenure: 4,
          activeToday: true
        },
        {
          id: 4,
          name: 'David Kim',
          email: 'david.kim@email.com',
          avatar: 'https://placehold.co/60x60?text=DK',
          role: 'Sous Chef',
          joined: '2023-02-20',
          tenure: 1,
          activeToday: true
        }
      ]
    }
  },
  computed: {
    uniqueRoles() {
      return [...new Set(this.staff.map(s => s.role))];
    },
    avgTenure() {
      if (!this.staff.length) return 0;
      const total = this.staff.reduce((sum, s) => sum + s.tenure, 0);
      return (total / this.staff.length).toFixed(1);
    }
  }
}
</script>

<template>
  <AuthenticatedLayout :auth="auth">
    <div class="min-h-screen flex">
      <!-- Sidebar -->
      <SideBar />
      <!-- Main Content: always leaves room for sidebar -->
      <div class="flex-1 ml-20 md:ml-64 p-4 sm:p-6 bg-white bg-opacity-90 min-h-screen transition-all duration-300">
        <!-- Header -->
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
          <div>
            <h1 class="text-2xl sm:text-3xl font-bold text-gray-800">Staff</h1>
            <p class="text-gray-600 text-sm sm:text-base">Manage your restaurant's staff members</p>
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
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6 mb-8">
          <div class="bg-white p-4 sm:p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500 text-sm">Total Staff</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ staff.length }}</p>
              </div>
              <div class="p-2 sm:p-3 rounded-lg bg-orange-50 text-orange-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 sm:h-6 sm:w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87M17 8a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
            </div>
            <p class="text-xs sm:text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +2 this month
            </p>
          </div>
          <div class="bg-white p-4 sm:p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500 text-sm">Active Today</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ staff.filter(s => s.activeToday).length }}</p>
              </div>
              <div class="p-2 sm:p-3 rounded-lg bg-blue-50 text-blue-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 sm:h-6 sm:w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11c0-1.104-.896-2-2-2s-2 .896-2 2 .896 2 2 2 2-.896 2-2zm6 2a2 2 0 100-4 2 2 0 000 4zm-6 6a6 6 0 100-12 6 6 0 000 12z" />
                </svg>
              </div>
            </div>
            <p class="text-xs sm:text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +1 from yesterday
            </p>
          </div>
          <div class="bg-white p-4 sm:p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500 text-sm">Roles</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ uniqueRoles.length }}</p>
              </div>
              <div class="p-2 sm:p-3 rounded-lg bg-green-50 text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 sm:h-6 sm:w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
            <p class="text-xs sm:text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              {{ uniqueRoles.join(', ') }}
            </p>
          </div>
          <div class="bg-white p-4 sm:p-6 rounded-xl shadow-sm border border-gray-100">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-500 text-sm">Avg. Tenure</p>
                <p class="text-2xl sm:text-3xl font-bold mt-1">{{ avgTenure }} yrs</p>
              </div>
              <div class="p-2 sm:p-3 rounded-lg bg-purple-50 text-purple-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 sm:h-6 sm:w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
            </div>
            <p class="text-xs sm:text-sm text-green-500 mt-2 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18" />
              </svg>
              +0.1 this year
            </p>
          </div>
        </div>

        <!-- Staff List -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <div class="p-4 sm:p-6 border-b border-gray-100 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <h2 class="text-lg sm:text-xl font-semibold text-gray-800">Staff List</h2>
            <button class="text-orange-600 hover:text-orange-700 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-1" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
              </svg>
              Add Staff
            </button>
          </div>
          <div class="divide-y divide-gray-100 scrollbar-hide" style="max-height: 600px; overflow-y: auto;">
            <div v-for="member in staff" :key="member.id" class="p-4 sm:p-6 hover:bg-gray-50 transition-colors duration-150 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
              <div class="flex items-center w-full sm:w-auto">
                <img :src="member.avatar" :alt="member.name" class="h-12 w-12 rounded-full object-cover">
                <div class="ml-4">
                  <h3 class="font-medium text-gray-800">{{ member.name }}</h3>
                  <p class="text-sm text-gray-500">{{ member.email }}</p>
                  <p class="text-xs text-gray-400 mt-1">Role: {{ member.role }}</p>
                  <p class="text-xs text-gray-400">Joined: {{ member.joined }}</p>
                </div>
              </div>
              <div class="flex flex-wrap items-center space-x-0 sm:space-x-8 gap-2 sm:gap-0 w-full sm:w-auto">
                <div class="text-center w-1/2 sm:w-auto">
                  <p class="text-lg font-bold text-gray-800">{{ member.tenure }} yrs</p>
                  <p class="text-xs text-gray-500">Tenure</p>
                </div>
                <div class="text-center w-1/2 sm:w-auto">
                  <span
                    :class="member.activeToday ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'"
                    class="px-3 py-1 rounded-full text-xs font-semibold"
                  >
                    {{ member.activeToday ? 'Active Today' : 'Inactive' }}
                  </span>
                </div>
                <button class="p-2 rounded-lg bg-orange-100 text-orange-700 hover:bg-orange-200 w-full sm:w-auto">
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
