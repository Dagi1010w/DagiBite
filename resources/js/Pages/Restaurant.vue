<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head } from '@inertiajs/vue3'
import RestaurantHome from './Restaurant/RestaurantHome.vue'

defineProps({
  auth: Object,
})
</script>

<template>
  <Head title="Restaurant Dashboard" />

  <AuthenticatedLayout :auth="auth">
   <RestaurantHome />

    
  </AuthenticatedLayout>
</template>
