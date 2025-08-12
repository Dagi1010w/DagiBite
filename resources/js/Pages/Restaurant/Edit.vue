<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SideBar from '@/Pages/Restaurant/SideBar.vue'
import { useForm, Link } from '@inertiajs/vue3'
import { ref } from 'vue'

const { menu } = defineProps({
  menu: { type: Object, required: true },
})

// Prefer Ziggy's route() if available; fall back to plain paths
const indexUrl = typeof route === 'function' ? route('menus.index') : '/menus'
const updateUrl = typeof route === 'function' ? route('menus.update', menu.id) : `/menus/${menu.id}`

const form = useForm({
  name: menu?.name ?? '',
  price: String(menu?.price ?? ''),
  description: menu?.description ?? '',
  picture: null,
})

const fileError = ref('')
const maxFileSize = 2 * 1024 * 1024 // 2MB

function handleFileChange(e) {
  const file = e.target.files?.[0]
  if (!file) return
  if (file.size > maxFileSize) {
    fileError.value = `File size (${(file.size / 1024 / 1024).toFixed(2)}MB) exceeds 2MB limit`
    form.picture = null
    e.target.value = ''
  } else {
    fileError.value = ''
    form.picture = file
  }
}

function submit() {
  fileError.value = ''
  form.transform((data) => {
    const payload = {
      _method: 'put',
      name: (data.name ?? '').trim(),
      description: data.description ?? '',
      price: data.price === '' ? null : Number(data.price),
    }
    if (data.picture) payload.picture = data.picture
    return payload
  })

  form.post(updateUrl, {
    forceFormData: true,
    preserveScroll: true,
  })
}
</script>

<template>
  <AuthenticatedLayout>
    <div class="min-h-screen flex">
      <SideBar />

      <div class="flex-1 ml-20 md:ml-64 p-6 bg-white bg-opacity-90 min-h-screen">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-800">Edit Menu Item</h1>
          <p class="text-gray-600">Update your menu item details</p>
        </div>

        <div class="max-w-2xl mx-auto">
          <form @submit.prevent="submit" class="bg-white rounded-xl shadow-lg border border-gray-100 p-8 space-y-6">
            <div>
              <label for="name" class="block text-sm font-semibold text-gray-700 mb-2">Menu Item Name</label>
              <input
                v-model="form.name"
                id="name"
                type="text"
                placeholder="Enter menu item name"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition"
                :class="{ 'border-red-500': form.errors.name }"
              />
              <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</p>
            </div>

            <div>
              <label for="description" class="block text-sm font-semibold text-gray-700 mb-2">Description</label>
              <textarea
                v-model="form.description"
                id="description"
                rows="4"
                placeholder="Describe your menu item"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition resize-none"
                :class="{ 'border-red-500': form.errors.description }"
              ></textarea>
              <p v-if="form.errors.description" class="mt-1 text-sm text-red-600">{{ form.errors.description }}</p>
            </div>

            <div>
              <label for="price" class="block text-sm font-semibold text-gray-700 mb-2">Price (ETB)</label>
              <input
                v-model="form.price"
                id="price"
                type="number"
                step="0.01"
                min="0"
                placeholder="0.00"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-orange-500 transition"
                :class="{ 'border-red-500': form.errors.price }"
              />
              <p v-if="form.errors.price" class="mt-1 text-sm text-red-600">{{ form.errors.price }}</p>
            </div>

            <div>
              <label for="picture" class="block text-sm font-semibold text-gray-700 mb-2">Menu Item Picture</label>
              <div class="mt-1 flex items-center space-x-4">
                <div v-if="menu.picture" class="relative">
                  <img
                    :src="`/storage/${menu.picture}`"
                    alt="Current menu item image"
                    class="h-24 w-24 rounded-lg object-cover border border-gray-200"
                  />
                </div>

                <div class="flex-1">
                  <input
                    @change="handleFileChange"
                    id="picture"
                    type="file"
                    accept="image/*"
                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-orange-50 file:text-orange-700 hover:file:bg-orange-100 transition"
                  />
                  <p class="mt-1 text-xs text-gray-500">PNG, JPG, JPEG up to 2MB</p>
                  <p v-if="fileError" class="mt-1 text-xs text-red-600">{{ fileError }}</p>
                </div>
              </div>
              <p v-if="form.errors.picture" class="mt-1 text-sm text-red-600">{{ form.errors.picture }}</p>
            </div>

            <div class="flex items-center justify-end space-x-4 pt-6 border-t border-gray-100">
              <Link :href="indexUrl" class="px-6 py-3 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition">
                Cancel
              </Link>
              <button
                :disabled="form.processing || !!fileError"
                class="px-6 py-3 text-sm font-medium text-white bg-orange-600 hover:bg-orange-700 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span v-if="form.processing" class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Updating...
                </span>
                <span v-else>Update Menu Item</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>
