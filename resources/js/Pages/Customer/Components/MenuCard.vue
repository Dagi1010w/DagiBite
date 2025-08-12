<template>
  <div class="bg-white rounded-lg shadow-lg overflow-hidden transform transition-transform duration-300 hover:scale-105">
    <img :src="imageSrc" :alt="menu?.name || 'Menu image'" class="w-full h-48 object-cover" />
    <div class="p-4">
      <h3 class="text-xl font-semibold text-gray-800 mb-1">{{ menu?.name }}</h3>
      <p class="text-gray-600 text-sm mb-3">{{ menu?.description }}</p>
      <div class="text-orange-600 font-semibold text-lg">{{ price }}</div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  menu: { type: Object, required: true },
})

const imageSrc = computed(() => {
  if (props.menu?.picture) return `/storage/${props.menu.picture}`
  return 'https://via.placeholder.com/600x400.png?text=No+Image'
})

const price = computed(() => {
  const value = Number(props.menu?.price) || 0
  return new Intl.NumberFormat('en-ET', { style: 'currency', currency: 'ETB', minimumFractionDigits: 2 }).format(value)
})
</script>
