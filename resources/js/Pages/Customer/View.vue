<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head, Link } from '@inertiajs/vue3'

const props = defineProps({
  auth: Object,
  restaurant: Object,
})

function imageSrc(r) {
  if (!r) return ''
  if (r.logo_path) return `/storage/${r.logo_path}`
  return 'https://images.unsplash.com/photo-1498654200943-1088dd4438ae?auto=format&fit=crop&w=900&q=60'
}
</script>

<template>
  <AuthenticatedLayout :auth="auth">
    <Head :title="restaurant?.name ? restaurant.name + ' – Restaurant' : 'Restaurant'" />

    <section class="bg-orange-50 min-h-screen py-10">
      <div class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
        <div class="mb-6">
          <Link href="/restaurantlist" class="text-orange-600 hover:text-orange-700 font-medium">← Back to Restaurants</Link>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-orange-100 overflow-hidden">
          <div class="relative h-56 sm:h-72 md:h-80 bg-orange-100">
            <img :src="imageSrc(restaurant)" :alt="restaurant?.name" class="absolute inset-0 h-full w-full object-cover" />
          </div>

          <div class="p-6 sm:p-8">
            <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4">
              <div>
                <h1 class="text-3xl font-extrabold text-gray-900">{{ restaurant?.name }}</h1>
                <p class="mt-1 text-sm text-gray-500">Category: <span class="font-medium text-orange-600">{{ restaurant?.category || '—' }}</span></p>
              </div>
              <div class="flex items-center gap-2 bg-yellow-50 text-yellow-700 px-3 py-1 rounded-full border border-yellow-200 self-start">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.802 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.803-2.034a1 1 0 00-1.175 0L6.711 16.3c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L3.076 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                </svg>
                <span class="font-semibold">{{ restaurant?.rating ?? 0 }}</span>
              </div>
            </div>

            <div class="mt-6 grid grid-cols-1 sm:grid-cols-2 gap-6">
              <div>
                <h2 class="text-lg font-semibold text-gray-900">About</h2>
                <p class="mt-2 text-gray-700 whitespace-pre-line">{{ restaurant?.description || 'No description provided.' }}</p>
              </div>
              <div>
                <h2 class="text-lg font-semibold text-gray-900">Contact</h2>
                <dl class="mt-2 text-gray-700 space-y-2">
                  <div class="flex gap-2">
                    <dt class="font-medium w-24">Phone</dt>
                    <dd>{{ restaurant?.phone || '—' }}</dd>
                  </div>
                  <div class="flex gap-2">
                    <dt class="font-medium w-24">Address</dt>
                    <dd>{{ restaurant?.address || '—' }}</dd>
                  </div>
                  <div class="flex gap-2">
                    <dt class="font-medium w-24">Slug</dt>
                    <dd>/restaurants/{{ restaurant?.slug }}</dd>
                  </div>
                </dl>
              </div>
            </div>

            <div class="mt-8">
              <Link :href="`/restaurants/${encodeURIComponent(restaurant?.slug || restaurant?.id)}/menu`" class="inline-flex items-center rounded-lg bg-gradient-to-r from-orange-500 to-amber-500 px-5 py-2.5 text-sm font-semibold text-white shadow hover:from-orange-600 hover:to-amber-600">
                View Menu
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  </AuthenticatedLayout>
</template>
