<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';

const form = useForm({
    name: '',
    email: '',
    password: '',
    password_confirmation: '',
    role: 'customer',
});

const isLoaded = ref(false);

onMounted(() => {
    // Trigger entrance animation
    setTimeout(() => {
        isLoaded.value = true;
    }, 100);
});

const submit = () => {
    form.post(route('register'), {
        onFinish: () => form.reset('password', 'password_confirmation'),
        onSuccess: () => {
            if (form.role === 'restaurant') {
                window.location.href = route('restaurants.create');
            } else {
                window.location.href = route('customer.dashboard');
            }
        },
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Register" />
        
            <!-- Enhanced Background with multiple layers - Fixed to cover everything -->
            <div class="fixed inset-0 z-0">
                <div 
                    class="fixed inset-0 bg-cover bg-center bg-no-repeat"
                    style="background-image: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');"
                ></div>
                <div class="fixed inset-0 bg-gradient-to-br from-slate-900/70 via-slate-800/50 to-slate-900/70"></div>
                <div class="fixed inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-orange-900/20 via-transparent to-transparent"></div>
            </div>

            <!-- Static background elements (removed animations) -->
            <div class="absolute inset-0 overflow-hidden">
                <!-- Removed animated floating shapes for static background -->
            </div>

            <!-- Registration Form Container -->
            <div class="relative z-10 w-full max-w-md mx-4 h-[90vh] flex items-center justify-center">
                <div 
                    :class="[
                        'transform transition-all duration-1000 ease-out w-full',
                        isLoaded ? 'translate-y-0 opacity-100 scale-100' : 'translate-y-10 opacity-0 scale-95'
                    ]"
                >
                    <form 
                        @submit.prevent="submit" 
                        class="relative bg-white/10 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl max-h-[85vh] overflow-y-auto"
                    >
                        <div class="p-8 md:p-10 space-y-6">
                        <!-- Enhanced Form Header -->
                        <div class="text-center space-y-3">
                            <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-orange-500 via-red-500 to-pink-500 rounded-2xl mb-4 shadow-lg shadow-orange-500/25">
                                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                            </div>
                            <h2 class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-white via-gray-100 to-gray-200 bg-clip-text text-transparent">
                                Join FoodieHub
                            </h2>
                            <p class="text-gray-300 text-sm md:text-base font-light">Create your account to start ordering delicious food</p>
                        </div>

                        <!-- Enhanced Name Field -->
                        <div class="space-y-2">
                            <InputLabel for="name" value="Full Name" class="text-white/90 font-medium" />
                            <div class="relative">
                                <TextInput
                                    id="name"
                                    type="text"
                                    class="w-full px-4 py-3 bg-white/[0.15] border border-white/25 rounded-xl text-white placeholder-gray-300/80 focus:ring-2 focus:ring-orange-500/50 focus:border-orange-400/50 transition-all duration-300 backdrop-blur-sm"
                                    v-model="form.name"
                                    required
                                    autofocus
                                    autocomplete="name"
                                    placeholder="Enter your full name"
                                />
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                    </svg>
                                </div>
                            </div>
                            <InputError class="mt-1" :message="form.errors.name" />
                        </div>

                        <!-- Role Selection -->
                        <div class="space-y-2">
                            <label for="role" class="block text-sm font-medium text-white">I want to register as</label>
                            <div class="grid grid-cols-2 gap-3">
                                <button
                                    type="button"
                                    @click="form.role = 'customer'"
                                    :class="[
                                        'relative px-4 py-3 rounded-xl border-2 transition-all duration-300',
                                        form.role === 'customer' 
                                            ? 'border-orange-500 bg-orange-500/20 text-white shadow-lg shadow-orange-500/30' 
                                            : 'border-white/30 bg-white/10 text-gray-300 hover:border-white/50'
                                    ]"
                                >
                                    <div class="flex flex-col items-center space-y-1">
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path>
                                        </svg>
                                        <span class="text-sm font-medium">Customer</span>
                                    </div>
                                </button>
                                <button
                                    type="button"
                                    @click="form.role = 'restaurant'"
                                    :class="[
                                        'relative px-4 py-3 rounded-xl border-2 transition-all duration-300',
                                        form.role === 'restaurant' 
                                            ? 'border-orange-500 bg-orange-500/20 text-white shadow-lg shadow-orange-500/30' 
                                            : 'border-white/30 bg-white/10 text-gray-300 hover:border-white/50'
                                    ]"
                                >
                                    <div class="flex flex-col items-center space-y-1">
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                                        </svg>
                                        <span class="text-sm font-medium">Restaurant</span>
                                    </div>
                                </button>
                            </div>
                        </div>

                        <!-- Enhanced Email Field -->
                        <div class="space-y-2">
                            <InputLabel for="email" value="Email Address" class="text-white/90 font-medium" />
                            <div class="relative">
                                <TextInput
                                    id="email"
                                    type="email"
                                    class="w-full px-4 py-3 bg-white/[0.15] border border-white/25 rounded-xl text-white placeholder-gray-300/80 focus:ring-2 focus:ring-orange-500/50 focus:border-orange-400/50 transition-all duration-300 backdrop-blur-sm"
                                    v-model="form.email"
                                    required
                                    autocomplete="username"
                                    placeholder="Enter your email"
                                />
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                    <svg class="h-5 w-5 text-gray-400/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                    </svg>
                                </div>
                            </div>
                            <InputError class="mt-1" :message="form.errors.email" />
                        </div>

                        <!-- Enhanced Password Field -->
                        <div class="space-y-2">
                            <InputLabel for="password" value="Password" class="text-white/90 font-medium" />
                            <div class="relative">
                                <TextInput
                                    id="password"
                                    type="password"
                                    class="w-full px-4 py-3 bg-white/[0.15] border border-white/25 rounded-xl text-white placeholder-gray-300/80 focus:ring-2 focus:ring-orange-500/50 focus:border-orange-400/50 transition-all duration-300 backdrop-blur-sm"
                                    v-model="form.password"
                                    required
                                    autocomplete="new-password"
                                    placeholder="Create a strong password"
                                />
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                    <svg class="h-5 w-5 text-gray-400/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                                    </svg>
                                </div>
                            </div>
                            <InputError class="mt-1" :message="form.errors.password" />
                        </div>

                        <!-- Enhanced Confirm Password Field -->
                        <div class="space-y-2">
                            <InputLabel for="password_confirmation" value="Confirm Password" class="text-white/90 font-medium" />
                            <div class="relative">
                                <TextInput
                                    id="password_confirmation"
                                    type="password"
                                    class="w-full px-4 py-3 bg-white/[0.15] border border-white/25 rounded-xl text-white placeholder-gray-300/80 focus:ring-2 focus:ring-orange-500/50 focus:border-orange-400/50 transition-all duration-300 backdrop-blur-sm"
                                    v-model="form.password_confirmation"
                                    required
                                    autocomplete="new-password"
                                    placeholder="Confirm your password"
                                />
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                    <svg class="h-5 w-5 text-gray-400/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                </div>
                            </div>
                            <InputError class="mt-1" :message="form.errors.password_confirmation" />
                        </div>

                        <!-- Submit Button -->
                        <div class="space-y-4 pt-4">
                            <PrimaryButton
                                class="w-full py-3 px-4 bg-gradient-to-r from-orange-500 to-red-500 hover:from-orange-600 hover:to-red-600 text-white font-bold rounded-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
                                :class="{ 'opacity-75': form.processing }"
                                :disabled="form.processing"
                            >
                                <span v-if="!form.processing" class="flex items-center justify-center">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path>
                                    </svg>
                                    Create Account
                                </span>
                                <span v-else class="flex items-center justify-center">
                                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    Creating Account...
                                </span>
                            </PrimaryButton>

                            <div class="text-center">
                                <Link
                                    :href="route('login')"
                                    class="text-gray-300 hover:text-white transition-colors duration-300 text-sm"
                                >
                                    Already have an account? 
                                    <span class="text-orange-400 hover:text-orange-300 font-semibold">Sign in here</span>
                                </Link>
                            </div>
                        </div>
                        </div>
                    </form>
                </div>
            </div>
        
    </GuestLayout>
</template>

<style scoped>
/* Form input styling */
input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
input:-webkit-autofill:active {
    -webkit-background-clip: text;
    -webkit-text-fill-color: #ffffff;
    transition: background-color 5000s ease-in-out 0s;
    box-shadow: inset 0 0 20px 20px rgba(255, 255, 255, 0.1);
}

/* Custom scrollbar for webkit browsers */
::-webkit-scrollbar {
    width: 6px;
}

::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
}

::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.3);
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: rgba(255, 255, 255, 0.5);
}
</style>
