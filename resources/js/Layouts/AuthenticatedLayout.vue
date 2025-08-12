<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';
import ResponsiveNavLink from '@/Components/ResponsiveNavLink.vue';
import { Link, usePage } from '@inertiajs/vue3';

const showingNavigationDropdown = ref(false);
const page = usePage();
const user = computed(() => {
  const auth = page.props.auth;
  return auth && (auth.user || auth) ? (auth.user || auth) : null;
});

// Cart indicator state
const cartCount = ref(0);
const loadCartCount = () => {
  try {
    const items = JSON.parse(localStorage.getItem('cart') || '[]');
    cartCount.value = items.reduce((sum, i) => sum + Number(i.quantity || 0), 0);
  } catch (e) {
    cartCount.value = 0;
  }
};
const onStorage = (e) => { if (!e || e.key === 'cart') loadCartCount(); };
const onCartUpdated = () => loadCartCount();

onMounted(() => {
  loadCartCount();
  window.addEventListener('storage', onStorage);
  window.addEventListener('cart:updated', onCartUpdated);
});

onBeforeUnmount(() => {
  window.removeEventListener('storage', onStorage);
  window.removeEventListener('cart:updated', onCartUpdated);
});
</script>

<template>
  <div>
    <div class="min-h-screen bg-gray-100">
      <nav class="sticky top-0 z-50 border-b border-gray-100 bg-white shadow-sm">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="flex h-16 justify-between items-center">
            <!-- Logo & Name -->
            <div class="flex items-center space-x-4">
              <div class="bg-orange-500 rounded-full p-2">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M8 12v6m0-6a2 2 0 104 0m0 0v6m0-6a2 2 0 114 0M7 6h10" />
                </svg>
              </div>
              <Link href='/dashboard' class="text-xl font-bold text-orange-600">DagiBites</Link>
            </div>

            <!-- Desktop Navigation -->
            <div class="hidden md:flex space-x-8 items-center">
              <template v-if="user && user.role === 'restaurant'">
                <Link href="/restaurant" class="nav-link">Home</Link>
                <Link href="/menuform" class="nav-link">Add Menu</Link>
                <Link href="/rhome" class="nav-link">Dashboard</Link>
                <Link href="/about" class="nav-link">About</Link>
                <Link href="/contactus" class="nav-link">Contact Us</Link>
              </template>

              <template v-if="user && user.role === 'customer'">
                <Link href="/dashboard" class="nav-link">Home</Link>
                <Link href="/restaurantlist" class="nav-link">Restaurants</Link>
                <Link href="/menu" class="nav-link">Menu</Link>
                <Link href="/about" class="nav-link">About</Link>
                <Link href="/contactus" class="nav-link">Contact Us</Link>
              </template>
            </div>

            <!-- User Dropdown -->
            <div class="hidden md:flex items-center">
              <div v-if="user && user.role === 'customer'" class="mr-4">
                <Link href="/cart" class="relative inline-flex items-center text-gray-600 hover:text-orange-600 focus:outline-none">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M2.25 2.25a.75.75 0 0 0 0 1.5h1.386c.17 0 .318.114.362.278l2.558 9.592a3.752 3.752 0 0 0-2.806 3.63c0 .414.336.75.75.75h15.75a.75.75 0 0 0 0-1.5H5.378A2.25 2.25 0 0 1 7.5 15h11.218a.75.75 0 0 0 .674-.421 60.358 60.358 0 0 0 2.96-7.228.75.75 0 0 0-.525-.965A60.864 60.864 0 0 0 5.68 4.509l-.232-.867A1.875 1.875 0 0 0 3.636 2.25H2.25ZM3.75 20.25a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0ZM16.5 20.25a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0Z" />
                  </svg>
                  <span class="ml-1 text-sm">Cart</span>
                  <span v-if="cartCount" class="absolute -top-2 -right-2 inline-flex h-5 min-w-[1.25rem] items-center justify-center rounded-full bg-orange-500 px-1.5 text-xs font-bold text-white">{{ cartCount }}</span>
                </Link>
              </div>
              <Dropdown align="right" width="48">
                <template #trigger>
                  <button class="flex items-center text-sm font-medium text-gray-500 hover:text-gray-700">
                    {{ user?.name }}
                    <svg class="ml-1 w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </template>

                <template #content>
                  <template v-if="user && user.role === 'restaurant'">
                    <DropdownLink href="/restaurant">Home</DropdownLink>
                    <DropdownLink href="/menuform">Add Menu</DropdownLink>
                    <DropdownLink href="/rhome">Dashboard</DropdownLink>
                    <DropdownLink href="/about">About</DropdownLink>
                    <DropdownLink href="/contactus">Contact Us</DropdownLink>
                  </template>

                  <template v-if="user && user.role === 'customer'">
                    <DropdownLink href="/customer">Home</DropdownLink>
                    <DropdownLink href="/restaurantlist">Restaurants</DropdownLink>
                    <DropdownLink href="/menu">Menu</DropdownLink>
                    <DropdownLink href="/about">About</DropdownLink>
                    <DropdownLink href="/contactus">Contact Us</DropdownLink>
                  </template>

                  <hr class="my-2 border-gray-200" />
                  <DropdownLink :href="route('profile.edit', {}, false)">Profile</DropdownLink>
                  <DropdownLink :href="route('logout', {}, false)" method="post" as="button">Log Out</DropdownLink>
                </template>
              </Dropdown>
            </div>

            <!-- Mobile Hamburger -->
            <div class="md:hidden flex items-center">
              <button @click="showingNavigationDropdown = !showingNavigationDropdown" class="text-gray-400 hover:text-gray-600 focus:outline-none">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path :class="{ hidden: showingNavigationDropdown, 'inline-flex': !showingNavigationDropdown }" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                  <path :class="{ hidden: !showingNavigationDropdown, 'inline-flex': showingNavigationDropdown }" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
              <div v-if="user && user.role === 'customer'" class="ml-3 relative">
                <Link href="/cart" class="relative inline-flex items-center text-gray-600 hover:text-orange-600 focus:outline-none">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M2.25 2.25a.75.75 0 0 0 0 1.5h1.386c.17 0 .318.114.362.278l2.558 9.592a3.752 3.752 0 0 0-2.806 3.63c0 .414.336.75.75.75h15.75a.75.75 0 0 0 0-1.5H5.378A2.25 2.25 0 0 1 7.5 15h11.218a.75.75 0 0 0 .674-.421 60.358 60.358 0 0 0 2.96-7.228.75.75 0 0 0-.525-.965A60.864 60.864 0 0 0 5.68 4.509l-.232-.867A1.875 1.875 0 0 0 3.636 2.25H2.25ZM3.75 20.25a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0ZM16.5 20.25a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0Z" />
                  </svg>
                  <span v-if="cartCount" class="absolute -top-2 -right-2 inline-flex h-5 min-w-[1.25rem] items-center justify-center rounded-full bg-orange-500 px-1.5 text-xs font-bold text-white">{{ cartCount }}</span>
                </Link>
              </div>
            </div>
          </div>
        </div>

        <!-- Mobile Dropdown -->
        <div :class="{ block: showingNavigationDropdown, hidden: !showingNavigationDropdown }" class="md:hidden">
          <div class="px-4 pt-4 pb-2 space-y-1">
            <template v-if="user && user.role === 'restaurant'">
              <DropdownLink href="/restaurant">Home</DropdownLink>
              <DropdownLink href="/menuform">Add Menu</DropdownLink>
              <DropdownLink href="/rhome">Dashboard</DropdownLink>
              <DropdownLink href="/about">About</DropdownLink>
              <DropdownLink href="/contactus">Contact Us</DropdownLink>
            </template>

            <template v-if="user && user.role === 'customer'">
              <DropdownLink href="/dashboard">Home</DropdownLink>
              <DropdownLink href="/restaurantlist">Restaurants</DropdownLink>
              <DropdownLink href="/menu">Menu</DropdownLink>
              <DropdownLink href="/about">About</DropdownLink>
              <DropdownLink href="/contactus">Contact Us</DropdownLink>
            </template>
          </div>

          <div class="border-t border-gray-200 py-4 px-4">
            <div class="text-sm font-medium text-gray-700">{{ user?.name }}</div>
            <div class="text-sm text-gray-500">{{ user?.email }}</div>

            <div class="mt-3 space-y-1">
              <ResponsiveNavLink :href="route('profile.edit', {}, false)">Profile</ResponsiveNavLink>
              <ResponsiveNavLink :href="route('logout', {}, false)" method="post" as="button">Log Out</ResponsiveNavLink>
            </div>
          </div>
        </div>
      </nav>

      <!-- Page Heading -->
      <header class="bg-white shadow" v-if="$slots.header">
        <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
          <slot name="header" />
        </div>
      </header>

      <!-- Page Content -->
      <main>
        <slot />
      </main>
    </div>
  </div>
</template>

<style scoped>
@media (max-width: 710px) {
  .hide-at-710 {
    display: none !important;
  }
}

.nav-link {
  @apply text-orange-600 font-medium hover:border-b-2 border-orange-500 transition duration-300 pb-1;
}

nav {
  box-shadow: 0 2px 16px 0 rgba(0,0,0,0.04);
  border-radius: 0 0 1.5rem 1.5rem;
  background: #fff;
}

body, .min-h-screen.bg-gray-100 {
  background: linear-gradient(135deg, #fff7ed 0%, #ffe5b4 100%);
}

/* Navigation link hover/active */
li .group span {
  transition: all 0.3s cubic-bezier(.4,0,.2,1);
}
li .group:hover span, li .group:focus span {
  color: #fff;
  background: #fb923c;
  border-radius: 0.5rem;
  padding: 0.25rem 0.75rem;
  transform: scale(1.08);
  box-shadow: 0 2px 8px 0 rgba(251,146,60,0.12);
}

/* Logo hover */
.bg-orange-500:hover {
  box-shadow: 0 4px 24px 0 #fb923c44;
  transform: scale(1.08) rotate(-3deg);
  transition: all 0.3s cubic-bezier(.4,0,.2,1);
}

/* Dropdown smoothness */
.relative.ms-3 .dropdown-menu {
  transition: opacity 0.2s cubic-bezier(.4,0,.2,1), transform 0.2s cubic-bezier(.4,0,.2,1);
}

/* Hamburger animation */
button[aria-expanded="true"] svg {
  transform: rotate(90deg);
  transition: transform 0.3s cubic-bezier(.4,0,.2,1);
}

/* Responsive tweaks */
@media (max-width: 640px) {
  nav {
    border-radius: 0 0 1rem 1rem;
    padding-bottom: 0.5rem;
  }
  /* Keep logo and hamburger side by side on mobile */
  .flex.h-16 {
    flex-direction: row;
    flex-wrap: wrap;
    height: auto;
    gap: 0.5rem;
    align-items: center;
    justify-content: space-between;
  }
  .sm\:flex {
    flex-direction: column !important;
    align-items: flex-start !important;
    gap: 0.5rem !important;
  }
  .sm\:ms-6 {
    margin-left: 0 !important;
  }
}
</style>
