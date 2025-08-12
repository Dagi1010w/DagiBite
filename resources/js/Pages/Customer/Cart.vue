<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps({
  auth: Object,
})

// Cart state
const cartItems = ref([])

const loadCart = () => {
  try {
    cartItems.value = JSON.parse(localStorage.getItem('cart') || '[]')
  } catch (e) {
    cartItems.value = []
  }
}

const saveCart = () => {
  localStorage.setItem('cart', JSON.stringify(cartItems.value))
  window.dispatchEvent(new CustomEvent('cart:updated', { detail: { count: cartCount.value } }))
}

const cartCount = computed(() => cartItems.value.reduce((sum, i) => sum + Number(i.quantity || 0), 0))
const cartTotal = computed(() => cartItems.value.reduce((sum, i) => sum + (Number(i.price) || 0) * (Number(i.quantity) || 0), 0))

const priceFormatter = new Intl.NumberFormat('en-ET', {
  style: 'currency',
  currency: 'ETB',
  minimumFractionDigits: 2,
})

const increment = (item) => {
  item.quantity = Number(item.quantity || 0) + 1
  saveCart()
}

const decrement = (item) => {
  const qty = Number(item.quantity || 0) - 1
  if (qty <= 0) {
    removeItem(item)
  } else {
    item.quantity = qty
    saveCart()
  }
}

const removeItem = (item) => {
  cartItems.value = cartItems.value.filter(i => i.menuId !== item.menuId)
  saveCart()
}

const clearCart = () => {
  cartItems.value = []
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

const checkout = () => {
  if (!cartItems.value.length) return
  alert(`Checkout not implemented. Items: ${cartCount.value}, Total: ${priceFormatter.format(cartTotal.value)}`)
}
</script>

<template>
  <AuthenticatedLayout :auth="props.auth">
    <div class="min-h-screen bg-gradient-to-b from-orange-50/40 via-white to-white">
      <div class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8 py-10">
        <h1 class="text-3xl font-extrabold text-gray-900 mb-6">Your Cart</h1>

        <div v-if="cartItems.length === 0" class="rounded-2xl border border-dashed border-orange-200 bg-orange-50/50 p-10 text-center">
          <div class="mx-auto mb-4 w-12 h-12 flex items-center justify-center rounded-full bg-white text-orange-500 shadow">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2 9m12-9l2 9m-6-9v9"/></svg>
          </div>
          <p class="text-gray-700 font-medium">Your cart is empty.</p>
          <a href="/menu" class="mt-4 inline-flex items-center rounded-lg bg-gradient-to-r from-orange-500 to-amber-500 px-4 py-2 text-sm font-medium text-white shadow hover:from-orange-600 hover:to-amber-600 focus:outline-none focus:ring-2 focus:ring-orange-300">Browse Menu</a>
        </div>

        <div v-else class="space-y-6">
          <!-- Items -->
          <div class="rounded-2xl border border-orange-100 bg-white shadow-sm divide-y">
            <div v-for="item in cartItems" :key="item.menuId" class="p-4 sm:p-5 flex items-center justify-between gap-4">
              <div class="min-w-0">
                <h3 class="text-base font-semibold text-gray-900 truncate">{{ item.name }}</h3>
                <p class="text-sm text-gray-600">Unit price: {{ priceFormatter.format(Number(item.price) || 0) }}</p>
              </div>

              <div class="flex items-center gap-4">
                <div class="inline-flex items-center rounded-lg border border-orange-200">
                  <button type="button" class="px-2 py-1.5 text-orange-600 hover:bg-orange-50" @click="decrement(item)" aria-label="Decrease">
                    -
                  </button>
                  <span class="px-3 py-1.5 text-sm font-semibold text-gray-900 min-w-[2rem] text-center">{{ item.quantity }}</span>
                  <button type="button" class="px-2 py-1.5 text-orange-600 hover:bg-orange-50" @click="increment(item)" aria-label="Increase">
                    +
                  </button>
                </div>

                <div class="text-right">
                  <div class="text-sm text-gray-500">Subtotal</div>
                  <div class="text-base font-semibold text-orange-700">{{ priceFormatter.format((Number(item.price)||0) * (Number(item.quantity)||0)) }}</div>
                </div>

                <button type="button" class="ml-2 inline-flex items-center rounded-lg border border-red-200 bg-red-50 px-3 py-1.5 text-xs font-medium text-red-700 hover:bg-red-100" @click="removeItem(item)">
                  Remove
                </button>
              </div>
            </div>
          </div>

          <!-- Summary -->
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <button type="button" class="inline-flex items-center rounded-lg border border-orange-200 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-orange-50" @click="clearCart">
              Clear Cart
            </button>
            <div class="text-right">
              <div class="text-sm text-gray-600">Items: <span class="font-medium text-gray-900">{{ cartCount }}</span></div>
              <div class="text-lg font-bold text-orange-600">Total: {{ priceFormatter.format(cartTotal) }}</div>
            </div>
          </div>

          <div class="flex justify-end">
            <button type="button" class="inline-flex items-center rounded-lg bg-gradient-to-r from-orange-500 to-amber-500 px-5 py-2.5 text-sm font-medium text-white shadow hover:from-orange-600 hover:to-amber-600 focus:outline-none focus:ring-2 focus:ring-orange-300" @click="checkout">
              Checkout
            </button>
          </div>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<style scoped>
/********** Accessibility / Utility **********/
.sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0, 0, 0, 0); white-space: nowrap; border-width: 0; }
</style>
