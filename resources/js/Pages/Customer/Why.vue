<template>
  <section class="bg-orange-50 py-16 px-6">
    <div class="max-w-7xl mx-auto text-center">
      <h2 class="text-4xl sm:text-5xl font-bold text-orange-600 mb-6">Why We're Better</h2>
      <p class="text-lg text-gray-700 mb-12 max-w-2xl mx-auto">
        At <strong>Dagi Delivery</strong>, we believe food delivery should be fast, reliable, and delicious. Here's why our customers love us!
      </p>

      <div ref="counterSection" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-8">
        <div v-for="item in counters" :key="item.label" class="bg-white rounded-xl shadow-md py-8 px-4 hover:scale-105 transform transition">
          <h3 class="text-4xl font-extrabold text-orange-600">{{ item.current }}</h3>
          <p class="text-sm text-gray-700 mt-2">{{ item.label }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'

const counterSection = ref(null)

const counters = reactive([
  { label: 'Happy Customers', target: 5000, current: 0 },
  { label: 'Partnered Restaurants', target: 250, current: 0 },
  { label: 'Orders Delivered', target: 10000, current: 0 },
  { label: 'Delivery Areas', target: 50, current: 0 }
])

let hasCounted = false

function animateCount(index, target) {
  const duration = 1500
  const start = 0
  const steps = 30
  let step = 0

  const interval = setInterval(() => {
    step++
    counters[index].current = Math.floor((step / steps) * target)
    if (step >= steps) {
      counters[index].current = target
      clearInterval(interval)
    }
  }, duration / steps)
}

onMounted(() => {
  const observer = new IntersectionObserver(
    (entries) => {
      if (entries[0].isIntersecting && !hasCounted) {
        hasCounted = true
        counters.forEach((item, index) => {
          animateCount(index, item.target)
        })
      }
    },
    {
      threshold: 0.3
    }
  )
  if (counterSection.value) {
    observer.observe(counterSection.value)
  }
})
</script>
