<script setup>
import { Link, usePage } from '@inertiajs/vue3';

const currentRoute = usePage().url;
</script>

<template>
  <div class="w-20 md:w-64 h-screen bg-orange-800 shadow-lg fixed">
    <div class="flex flex-col items-center md:items-start p-4">
      <nav class="w-full space-y-1">
        <Link
          href="/rhome"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute === '/' ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z"/>
          </svg>
          <span class="hidden md:block ml-3">Dashboard</span>
        </Link>

        <Link
          href="/customers"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute.startsWith('/customers') ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
          </svg>
          <span class="hidden md:block ml-3">Customers</span>
        </Link>

        <Link
          href="/staff"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute.startsWith('/staff') ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z"/>
          </svg>
          <span class="hidden md:block ml-3">Staff</span>
        </Link>

        <Link
          href="/restaurantmenus"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute.startsWith('/restaurantmenus') ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
          </svg>
          <span class="hidden md:block ml-3">Manage Menus</span>
        </Link>

        <Link
          href="/report"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute.startsWith('/reports') ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
            <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd"/>
          </svg>
          <span class="hidden md:block ml-3">Reports</span>
        </Link>

        <Link
          href="/setting"
          :class="[
            'flex items-center p-3 text-white rounded-lg',
            currentRoute.startsWith('/settings') ? 'bg-orange-700' : 'hover:bg-orange-700'
          ]"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd"/>
          </svg>
          <span class="hidden md:block ml-3">Settings</span>
        </Link>
      </nav>
    </div>
  </div>
</template>
