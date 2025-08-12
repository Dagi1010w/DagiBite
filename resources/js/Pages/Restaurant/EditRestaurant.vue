<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head, useForm } from '@inertiajs/vue3'
import { ref, watch, onMounted } from 'vue'

const props = defineProps({
  auth: Object,
  restaurant: Object,
})

// Suggested categories (editable by user)
const categorySuggestions = [
  'Ethiopian',
  'Italian',
  'Indian',
  'Chinese',
  'Japanese',
  'American',
  'Vegan',
  'Vegetarian',
  'Desserts',
  'Bakery',
  'Cafe',
  'Fast Food',
  'Seafood',
  'BBQ',
  'Grill',
]

// Form state (aligned with restaurants schema)
const form = useForm({
  name: '',
  description: '',
  category: '',
  phone: '',
  address: '',
  logo: null, // file
  rating: 0,
  slug: '',
  _method: 'PUT', // For PUT request
})

// Slug helpers
const userEditedSlug = ref(false)
function slugify(str) {
  return (str || '')
    .toString()
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '') // strip diacritics
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/[\s_-]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 80)
}

watch(
  () => form.name,
  (val) => {
    if (!userEditedSlug.value) {
      form.slug = slugify(val)
    }
  }
)

function onSlugInput() {
  userEditedSlug.value = true
}

// File handling
const logoPreview = ref(null)
const existingLogo = ref(null)

function onLogoChange(e) {
  const file = e.target.files?.[0]
  form.logo = file || null
  if (file) {
    const reader = new FileReader()
    reader.onload = (ev) => {
      logoPreview.value = ev.target?.result
    }
    reader.readAsDataURL(file)
  } else {
    logoPreview.value = null
  }
}

function regenerateSlugFromName() {
  form.slug = slugify(form.name)
  userEditedSlug.value = false
}

// Initialize form with restaurant data
onMounted(() => {
  if (props.restaurant) {
    form.name = props.restaurant.name || ''
    form.description = props.restaurant.description || ''
    form.category = props.restaurant.category || ''
    form.phone = props.restaurant.phone || ''
    form.address = props.restaurant.address || ''
    form.rating = props.restaurant.rating || 0
    form.slug = props.restaurant.slug || ''
    
    if (props.restaurant.logo_path) {
      existingLogo.value = `/storage/${props.restaurant.logo_path}`
    }
  }
})

// Submit
function submit() {
  form.post(`/restaurants/${props.restaurant.id}`, {
    forceFormData: true, // ensure multipart for file upload
    onSuccess: () => {
      // Redirect to restaurant home after successful update
      window.location.href = '/setting'
    },
  })
}
</script>

<template>
  <AuthenticatedLayout :auth="auth">
    <Head title="Edit Restaurant" />

    <section class="min-h-screen bg-gradient-to-b from-orange-50/40 via-white to-white py-8">
      <div class="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="mb-8 text-center">
          <h1 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-transparent bg-clip-text bg-gradient-to-r from-orange-600 to-amber-500">
            Edit Restaurant
          </h1>
          <p class="mt-2 text-sm sm:text-base text-gray-600">Update your restaurant details below.</p>
        </div>

        <!-- Form Card -->
        <div class="rounded-2xl border border-orange-100 bg-white p-5 shadow-sm sm:p-6 lg:p-8">
          <!-- Accent bar -->
          <div class="-mx-5 -mt-5 mb-6 h-1 bg-gradient-to-r from-orange-500 via-amber-400 to-orange-500 sm:-mx-6 lg:-mx-8" />

          <form @submit.prevent="submit" enctype="multipart/form-data" class="space-y-8">
            <!-- Basic Info -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900">Basic Information</h2>
              <p class="text-sm text-gray-500">Name and public slug for your restaurant.</p>
              <div class="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2">
                <div>
                  <label for="name" class="block text-sm font-medium text-gray-700">Name <span class="text-orange-600">*</span></label>
                  <input
                    id="name"
                    v-model.trim="form.name"
                    type="text"
                    required
                    placeholder="e.g., Spice Garden"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</p>
                </div>

                <div>
                  <div class="flex items-center justify-between">
                    <label for="slug" class="block text-sm font-medium text-gray-700">Slug <span class="text-orange-600">*</span></label>
                    <button
                      type="button"
                      class="text-xs font-medium text-orange-600 hover:text-orange-700"
                      @click="regenerateSlugFromName"
                    >
                      Regenerate from name
                    </button>
                  </div>
                  <input
                    id="slug"
                    v-model.trim="form.slug"
                    @input="onSlugInput"
                    type="text"
                    required
                    placeholder="e.g., spice-garden"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <p v-if="form.errors.slug" class="mt-1 text-sm text-red-600">{{ form.errors.slug }}</p>
                </div>
              </div>
            </div>

            <!-- Classification -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900">Classification</h2>
              <p class="text-sm text-gray-500">Category helps customers discover your cuisine.</p>
              <div class="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2">
                <div>
                  <label for="category" class="block text-sm font-medium text-gray-700">Category</label>
                  <input
                    id="category"
                    v-model.trim="form.category"
                    type="text"
                    list="category-suggestions"
                    placeholder="e.g., Indian"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <datalist id="category-suggestions">
                    <option v-for="c in categorySuggestions" :key="c" :value="c">{{ c }}</option>
                  </datalist>
                  <p v-if="form.errors.category" class="mt-1 text-sm text-red-600">{{ form.errors.category }}</p>
                </div>

                <div>
                  <label for="rating" class="block text-sm font-medium text-gray-700">Rating</label>
                  <input
                    id="rating"
                    v-model.number="form.rating"
                    type="number"
                    step="0.01"
                    min="0"
                    max="9.99"
                    placeholder="0 - 9.99"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <p v-if="form.errors.rating" class="mt-1 text-sm text-red-600">{{ form.errors.rating }}</p>
                </div>
              </div>
            </div>

            <!-- Contact & Address -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900">Contact</h2>
              <p class="text-sm text-gray-500">Make it easy for customers to reach you.</p>
              <div class="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2">
                <div>
                  <label for="phone" class="block text-sm font-medium text-gray-700">Phone</label>
                  <input
                    id="phone"
                    v-model.trim="form.phone"
                    type="tel"
                    inputmode="tel"
                    placeholder="e.g., +251 900 000000"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <p v-if="form.errors.phone" class="mt-1 text-sm text-red-600">{{ form.errors.phone }}</p>
                </div>

                <div>
                  <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
                  <input
                    id="address"
                    v-model.trim="form.address"
                    type="text"
                    placeholder="Street, City, Country"
                    class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-2.5 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                  />
                  <p v-if="form.errors.address" class="mt-1 text-sm text-red-600">{{ form.errors.address }}</p>
                </div>
              </div>
            </div>

            <!-- Description -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900">Description</h2>
              <p class="text-sm text-gray-500">Tell customers what makes your restaurant special.</p>
              <div class="mt-4">
                <label for="description" class="sr-only">Description</label>
                <textarea
                  id="description"
                  v-model.trim="form.description"
                  rows="5"
                  placeholder="Write a short description..."
                  class="mt-1 w-full rounded-xl border border-orange-200/70 bg-white px-3 py-3 text-sm shadow-sm placeholder:text-gray-400 focus:border-orange-500 focus:ring-2 focus:ring-orange-200"
                ></textarea>
                <p v-if="form.errors.description" class="mt-1 text-sm text-red-600">{{ form.errors.description }}</p>
              </div>
            </div>

            <!-- Logo Upload -->
            <div>
              <h2 class="text-lg font-semibold text-gray-900">Logo</h2>
              <p class="text-sm text-gray-500">Upload an optional logo (PNG/JPG/SVG). Max ~2MB.</p>
              <div class="mt-4 grid grid-cols-1 gap-5 sm:grid-cols-2">
                <div>
                  <label for="logo" class="block text-sm font-medium text-gray-700">Logo file</label>
                  <input
                    id="logo"
                    type="file"
                    accept="image/*"
                    @change="onLogoChange"
                    class="mt-1 block w-full text-sm text-gray-700 file:mr-4 file:rounded-lg file:border-0 file:bg-orange-50 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-orange-700 hover:file:bg-orange-100"
                  />
                  <p v-if="form.errors.logo" class="mt-1 text-sm text-red-600">{{ form.errors.logo }}</p>
                </div>

                <div v-if="logoPreview" class="sm:justify-self-end">
                  <div class="text-sm text-gray-500 mb-2">Preview</div>
                  <img :src="logoPreview" alt="Logo preview" class="h-24 w-24 rounded-xl object-cover ring-1 ring-orange-200/70" />
                </div>

                <div v-else-if="existingLogo" class="sm:justify-self-end">
                  <div class="text-sm text-gray-500 mb-2">Current Logo</div>
                  <img :src="existingLogo" alt="Current logo" class="h-24 w-24 rounded-xl object-cover ring-1 ring-orange-200/70" />
                </div>
              </div>
            </div>

            <!-- Actions -->
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-end">
              <button
                type="button"
                class="inline-flex items-center justify-center rounded-lg border border-orange-200 bg-white px-4 py-2 text-sm font-medium text-orange-700 shadow-sm hover:bg-orange-50 focus:outline-none focus:ring-2 focus:ring-orange-200"
                @click="form.reset(); logoPreview = null; existingLogo = null; userEditedSlug = false;"
              >
                Reset
              </button>

              <button
                type="submit"
                :disabled="form.processing"
                class="inline-flex items-center justify-center rounded-lg bg-gradient-to-r from-orange-500 to-amber-500 px-5 py-2.5 text-sm font-semibold text-white shadow transition-colors hover:from-orange-600 hover:to-amber-600 focus:outline-none focus:ring-2 focus:ring-orange-300 disabled:cursor-not-allowed disabled:opacity-60"
              >
                <svg
                  v-if="form.processing"
                  class="-ml-0.5 mr-2 h-4 w-4 animate-spin text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
                </svg>
                Save Restaurant
              </button>
            </div>
          </form>
        </div>
      </div>
    </section>
  </AuthenticatedLayout>
</template>

<style scoped>
/* Hide-only utility for accessible labels */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
</style>
