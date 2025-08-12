<template>
  <section class="bg-orange-50 py-16 px-4 sm:px-8">
    <div class="max-w-6xl mx-auto text-center">
      <h2 class="text-4xl font-bold text-orange-600 mb-4">What Our Customers Say</h2>
      <p class="text-gray-700 mb-12 max-w-2xl mx-auto">We deliver not just food, but happiness. Here's what people love about Dagi Delivery.</p>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div
          v-for="(testimonial, index) in testimonials"
          :key="index"
          class="bg-white shadow-md rounded-xl p-6 hover:shadow-lg transition duration-300"
        >
          <div class="flex items-center mb-4">
            <img
              :src="testimonial.avatar"
              alt="User avatar"
              class="w-12 h-12 rounded-full mr-4"
            />
            <div class="text-left">
              <h4 class="text-lg font-semibold text-orange-600">{{ testimonial.name }}</h4>
              <p class="text-sm text-gray-500">{{ testimonial.role }}</p>
            </div>
          </div>
          <p class="text-gray-700 text-sm">“{{ testimonial.message }}”</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
const testimonials = [
  {
    name: "Selam Tesfaye",
    role: "Customer from Addis Ababa",
    message: "Dagi Delivery always brings my favorite meals hot and fresh. I love the speed and service!",
    avatar: "https://randomuser.me/api/portraits/women/44.jpg",
  },
  {
    name: "Kaleab Bekele",
    role: "Restaurant Partner",
    message: "Thanks to Dagi, our restaurant sales have doubled. Their system is simple and effective.",
    avatar: "https://randomuser.me/api/portraits/men/32.jpg",
  },
  {
    name: "Hanna Kidane",
    role: "Frequent User",
    message: "I can track my orders easily, and support is always responsive. Highly recommend!",
    avatar: "https://randomuser.me/api/portraits/women/65.jpg",
  },
  {
    name: "Dawit Girma",
    role: "New Customer",
    message: "First time using Dagi Delivery and I’m impressed! Food arrived earlier than expected.",
    avatar: "https://randomuser.me/api/portraits/men/76.jpg",
  },
  {
    name: "Liya Tadesse",
    role: "Busy Professional",
    message: "Ordering lunch between meetings has never been this easy. I love the app’s simplicity.",
    avatar: "https://randomuser.me/api/portraits/women/18.jpg",
  },
  {
    name: "Samuel Assefa",
    role: "Delivery Agent",
    message: "The delivery system is well-structured and I enjoy working with Dagi Delivery daily.",
    avatar: "https://randomuser.me/api/portraits/men/47.jpg",
  },
];
</script>
