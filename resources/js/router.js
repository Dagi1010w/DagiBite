// resources/js/router.js
import { createRouter, createWebHistory } from 'vue-router';
import Customer from './Pages/Customer.vue';
import Restaurant from './Pages/Restaurant.vue';

const routes = [
  {
    path: '/dashboard',
    name: 'dashboard',
    component: () => {
      const role = localStorage.getItem('userRole');
      return role === 'restaurant' ? Restaurant : Customer;
    },
    meta: { requiresAuth: true }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAuth && !localStorage.getItem('authToken')) {
    next('/login');
  } else {
    next();
  }
});

export default router;