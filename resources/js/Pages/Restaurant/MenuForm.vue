<template>
  <AuthenticatedLayout :auth="auth">
    <template #default>
      <div class="relative min-h-screen">
        <!-- Background image with overlay -->
        <div 
          class="absolute inset-0 bg-cover bg-center bg-no-repeat"
          style="background-image: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80')"
        >
          <div class="absolute inset-0 bg-gradient-to-br from-black/60 via-black/40 to-orange-900/30"></div>
        </div>
        
        <div class="relative z-10 py-10 px-4 sm:px-6 lg:px-8">
          <div class="max-w-2xl mx-auto">
            <div class="bg-white/30 backdrop-blur-md border border-white/20 rounded-2xl shadow-lg p-6 text-white">
          <h2 class="text-3xl font-bold text-orange-700 mb-6 text-center">Add Menu Item</h2>
          <form @submit.prevent="submitForm" class="space-y-6" enctype="multipart/form-data" ref="menuForm" >
            <div v-if="successMessage" class="bg-green-100 text-green-800 px-4 py-2 rounded mb-4 border border-green-300 transition">
              {{ successMessage }}
            </div>
            <div v-if="formError" class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">
              {{ formError }}
            </div>
            <div v-if="fileError" class="bg-yellow-100 text-yellow-700 px-4 py-2 rounded mb-4">
              {{ fileError }}
            </div>
            <div>
              <label for="name" class="block text-sm font-semibold text-orange-900 mb-1">Name</label>
              <input id="name" type="text" v-model="menuItem.name" required class="w-full px-4 py-2 border border-orange-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 text-black" />
              <div v-if="errors.name" class="text-red-600 text-sm mt-1">{{ errors.name[0] }}</div>
            </div>
            <div>
              <label for="price" class="block text-sm font-semibold text-orange-900 mb-1">Price (ETB)</label>
              <input id="price" type="number" v-model="menuItem.price" required class="w-full px-4 py-2 border border-orange-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 text-black" />
              <div v-if="errors.price" class="text-red-600 text-sm mt-1">{{ errors.price[0] }}</div>
            </div>
            <div>
              <label for="picture" class="block text-sm font-semibold text-orange-900 mb-1">Picture</label>
              <input id="picture" type="file" @change="handleFileUpload" accept="image/*" required class="w-full px-4 py-2 border border-orange-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500" ref="pictureInput" />
              <div v-if="errors.picture" class="text-red-600 text-sm mt-1">{{ errors.picture[0] }}</div>
            </div>
            <div>
              <label for="description" class="block text-sm font-semibold text-orange-900 mb-1">Description</label>
              <textarea id="description" v-model="menuItem.description" rows="4" class="w-full px-4 py-2 border border-orange-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 text-black"></textarea>
              <div v-if="errors.description" class="text-red-600 text-sm mt-1">{{ errors.description[0] }}</div>
            </div>
            <button type="submit" :disabled="loading" class="w-full bg-orange-600 hover:bg-orange-700 text-white font-bold py-3 rounded-md transition">
              <span v-if="loading">Adding...</span>
              <span v-else>Add Menu Item</span>
            </button>
          </form>
        </div>
      </div>

    </div>
        </div>
      <Contact />
    </template>
  </AuthenticatedLayout>
</template>

<script setup>
import { reactive, ref } from 'vue'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import Contact from '@/Pages/Comp/Contact.vue'

defineProps({
  auth: Object
})

const menuItem = reactive({
  name: '',
  price: null,
  description: ''
})

let pictureFile = null
const errors = reactive({})
const formError = ref('')
const successMessage = ref('')
const fileError = ref('')
const loading = ref(false)
const menuForm = ref(null)
const pictureInput = ref(null)
let successTimeout = null

function handleFileUpload(event) {
  pictureFile = event.target.files[0]
  
  // File size validation
  if (pictureFile && pictureFile.size > 2 * 1024 * 1024) { // 2MB limit
    fileError.value = 'File is too large. Please select an image under 2MB.'
    pictureFile = null
    if (pictureInput.value) pictureInput.value.value = ''
    return
  }
  
  fileError.value = ''
}

function getCsrfToken() {
  const tag = document.querySelector('meta[name="csrf-token"]')
  return tag ? tag.getAttribute('content') : null
}

async function submitForm() {
  formError.value = ''
  successMessage.value = ''
  fileError.value = ''
  Object.keys(errors).forEach(k => delete errors[k])
  loading.value = true

  if (!pictureFile) {
    errors.picture = ['Picture is required']
    loading.value = false
    return
  }

  const formData = new FormData();
  formData.append('name', menuItem.name);
  formData.append('price', menuItem.price);
  formData.append('description', menuItem.description);
  formData.append('picture', pictureFile);

  const csrfToken = getCsrfToken()
  if (!csrfToken) {
    formError.value = 'CSRF token not found. Please refresh the page.'
    loading.value = false
    return
  }

  try {
    const response = await fetch('/menus', {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': csrfToken
      },
      body: formData
    });

    if (response.status === 422) {
      const data = await response.json()
      if (data.errors) {
        Object.assign(errors, data.errors)
        formError.value = 'Please fix the errors below.'
      } else {
        formError.value = 'Validation failed.'
      }
      loading.value = false
      return
    }

    if (!response.ok) {
      formError.value = 'Failed to add menu item. Please try again.'
      loading.value = false
      return
    }

    // Redirect to restaurant menus page after successful creation
    window.location.href = '/restaurantmenus';
  } catch (error) {
    console.error('Error adding menu item:', error);
    formError.value = 'Failed to add menu item. Please try again.'
  } finally {
    loading.value = false
  }
}

function resetForm() {
  menuItem.name = ''
  menuItem.price = null
  menuItem.description = ''
  pictureFile = null
  fileError.value = ''
  Object.keys(errors).forEach(k => delete errors[k])
  formError.value = ''
  if (pictureInput.value) pictureInput.value.value = ''
}
</script>
