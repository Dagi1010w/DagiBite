<script setup>
import { ref, onMounted } from 'vue';
import { gsap } from 'gsap';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Contact from '@/Pages/Comp/Contact.vue';

const form = ref({
  name: '',
  email: '',
  message: '',
});

const successMessage = ref('');
const errorMessage = ref('');

function submitForm() {
  if (!form.value.name || !form.value.email || !form.value.message) {
    errorMessage.value = 'Please fill in all fields.';
    successMessage.value = '';
    return;
  }
  // Simulate form submission
  successMessage.value = 'Thank you for contacting us! We will get back to you soon.';
  errorMessage.value = '';
  form.value.name = '';
  form.value.email = '';
  form.value.message = '';
}

const heading = ref(null);
const formSection = ref(null);
const infoSection = ref(null);

onMounted(() => {
  const tl = gsap.timeline({ defaults: { duration: 1, ease: 'power3.out' } });
  tl.from(heading.value, { y: -50, opacity: 0 })
    .from(formSection.value, { x: -100, opacity: 0 }, '-=0.5')
    .from(infoSection.value, { x: 100, opacity: 0 }, '-=0.5');
});

defineOptions({
  layout: AuthenticatedLayout,
});
</script>

<template>
  <section class="bg-gradient-to-r from-yellow-400 via-orange-400 to-red-400 min-h-screen flex items-center justify-center px-6 py-16">
    <div class="max-w-6xl mx-auto bg-white rounded-3xl shadow-xl p-12 flex flex-col md:flex-row items-center space-y-10 md:space-y-0 md:space-x-12">
      <div class="md:w-1/2" ref="formSection">
        <h1 ref="heading" class="text-5xl font-extrabold text-orange-600 mb-6">Contact Us</h1>
        <p class="text-gray-700 mb-8 leading-relaxed">
          At Dagi Delivery, our vision is to connect people with the best food experiences effortlessly. We are here to listen to your feedback, answer your questions, and help you enjoy our service to the fullest.
        </p>
        <form @submit.prevent="submitForm" class="space-y-6">
          <div>
            <label for="name" class="block text-sm font-semibold text-gray-700 mb-1">Name</label>
            <input
              id="name"
              v-model="form.name"
              type="text"
              placeholder="Your name"
              class="w-full px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition"
            />
          </div>
          <div>
            <label for="email" class="block text-sm font-semibold text-gray-700 mb-1">Email</label>
            <input
              id="email"
              v-model="form.email"
              type="email"
              placeholder="Your email"
              class="w-full px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition"
            />
          </div>
          <div>
            <label for="message" class="block text-sm font-semibold text-gray-700 mb-1">Message</label>
            <textarea
              id="message"
              v-model="form.message"
              rows="5"
              placeholder="Your message"
              class="w-full px-4 py-3 rounded-xl border border-orange-300 focus:outline-none focus:ring-2 focus:ring-orange-500 transition resize-none"
            ></textarea>
          </div>
          <button
            type="submit"
            class="bg-orange-600 text-white px-6 py-3 rounded-xl hover:bg-orange-700 transition font-semibold"
          >
            Send Message
          </button>
          <p v-if="successMessage" class="text-green-600 font-semibold mt-4">{{ successMessage }}</p>
          <p v-if="errorMessage" class="text-red-600 font-semibold mt-4">{{ errorMessage }}</p>
        </form>
      </div>
      <div class="md:w-1/2" ref="infoSection">
        <img
          src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=600&q=80"
          alt="Contact us"
          class="rounded-2xl shadow-lg object-cover w-full h-80"
        />
      </div>
    </div>
  </section>
  <Contact />
</template>

<style scoped>
section {
  background-size: 200% 200%;
  animation: gradientShift 15s ease infinite;
}

@keyframes gradientShift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}
</style>
