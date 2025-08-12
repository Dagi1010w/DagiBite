<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head } from '@inertiajs/vue3'
import Chome from '@/Pages/Customer/Chome.vue'
import RestaurantMenuList from '@/Pages/Customer/RestaurantMenuList.vue'
import Contact from '@/Pages/Comp/Contact.vue'
import Why from '@/Pages/Customer/Why.vue'
import Testimonial from '@/Pages/Customer/Testimonial.vue'

defineProps({
  auth: Object,
})
</script>

<template>
  <Head title="Customer Dashboard" />

  <AuthenticatedLayout :auth="auth">
    <Chome />
    <RestaurantMenuList />
    <Testimonial />
    <Why />
    <Contact />
  </AuthenticatedLayout>
</template>
