<script setup>
import { ref, onMounted } from 'vue';
import { gsap } from 'gsap';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Contact from '@/Pages/Comp/Contact.vue';

const heading = ref(null);
const paragraph = ref(null);
const image = ref(null);
const featuresSection = ref(null);
const testimonialsSection = ref(null);

onMounted(() => {
  const tl = gsap.timeline({ defaults: { duration: 1, ease: 'power3.out' } });
  tl.from(heading.value, { y: -50, opacity: 0 })
    .from(paragraph.value, { y: 50, opacity: 0 }, '-=0.5')
    .from(image.value, { scale: 0.8, opacity: 0 }, '-=0.5')
    .from(featuresSection.value, { y: 50, opacity: 0, stagger: 0.3 }, '-=0.5')
    .from(testimonialsSection.value, { y: 50, opacity: 0, stagger: 0.3 }, '-=0.5');
});

defineOptions({
  layout: AuthenticatedLayout,
});
</script>

<template>
  <section class="bg-gradient-to-r from-orange-400 via-yellow-300 to-orange-400 min-h-screen flex flex-col items-center justify-center px-6 py-16">
    <div class="max-w-5xl mx-auto bg-white rounded-3xl shadow-xl p-12 flex flex-col md:flex-row items-center space-y-10 md:space-y-0 md:space-x-12 w-full">
      <div class="md:w-1/2">
        <h1 ref="heading" class="text-5xl font-extrabold text-orange-600 mb-6">
          About Dagi Delivery
        </h1>
        <p ref="paragraph" class="text-lg text-gray-700 leading-relaxed mb-6">
          Welcome to Dagi Delivery, your premier food delivery service dedicated to bringing delicious meals from your favorite restaurants right to your doorstep. Our mission is to connect food lovers with the best culinary experiences in town, all with just a few clicks.
          <br /><br />
          We pride ourselves on fast, reliable delivery and a user-friendly platform that makes ordering food easy and enjoyable. Whether you're craving local favorites or international cuisine, Dagi Delivery has you covered.
          <br /><br />
          Join us on this flavorful journey and discover new tastes every day!
        </p>
      </div>
      <div class="md:w-1/2">
        <img
          ref="image"
          src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80"
          alt="Delicious food"
          class="rounded-2xl shadow-lg object-cover w-full h-80 hover:scale-105 transition-transform duration-500"
        />
      </div>
    </div>

    <!-- Features Section -->
    <div ref="featuresSection" class="max-w-5xl mx-auto bg-white rounded-3xl shadow-xl p-12 mt-16 w-full">
      <h2 class="text-4xl font-bold text-orange-600 mb-8 text-center">Our Features</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-8">
        <div class="flex flex-col items-center text-center p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <svg class="w-12 h-12 mb-4 text-orange-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12l2-2 4 4 8-8 2 2-10 10z"/></svg>
          <h3 class="text-xl font-semibold mb-2">Fast Delivery</h3>
          <p class="text-gray-600">Get your food delivered quickly and reliably, right to your doorstep.</p>
        </div>
        <div class="flex flex-col items-center text-center p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <svg class="w-12 h-12 mb-4 text-orange-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
          <h3 class="text-xl font-semibold mb-2">24/7 Service</h3>
          <p class="text-gray-600">Order anytime, anywhere with our round-the-clock service availability.</p>
        </div>
        <div class="flex flex-col items-center text-center p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <svg class="w-12 h-12 mb-4 text-orange-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
          <h3 class="text-xl font-semibold mb-2">Wide Variety</h3>
          <p class="text-gray-600">Choose from a wide range of cuisines and restaurants to satisfy your cravings.</p>
        </div>
      </div>
    </div>

    <!-- Testimonials Section -->
    <div ref="testimonialsSection" class="max-w-5xl mx-auto bg-white rounded-3xl shadow-xl p-12 mt-16 w-full">
      <h2 class="text-4xl font-bold text-orange-600 mb-8 text-center">What Our Customers Say</h2>
      <div class="space-y-8">
        <div class="p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <p class="text-gray-700 italic mb-4">"Dagi Delivery has transformed the way I order food. Fast, reliable, and always delicious!"</p>
          <p class="font-semibold text-orange-600">- Sarah K.</p>
        </div>
        <div class="p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <p class="text-gray-700 italic mb-4">"Excellent service and a great variety of restaurants. Highly recommend!"</p>
          <p class="font-semibold text-orange-600">- James L.</p>
        </div>
        <div class="p-6 border rounded-lg shadow hover:shadow-lg transition-shadow duration-300">
          <p class="text-gray-700 italic mb-4">"The app is so easy to use and the delivery is always on time. Love it!"</p>
          <p class="font-semibold text-orange-600">- Emily R.</p>
        </div>
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

/* Responsive adjustments */
@media (max-width: 768px) {
  h1 {
    font-size: 3rem;
  }
  h2 {
    font-size: 2rem;
  }
  p {
    font-size: 1rem;
  }
  img {
    height: 60vh;
  }
}
</style>
