<script setup>
import Checkbox from '@/Components/Checkbox.vue';
import GuestLayout from '@/Layouts/GuestLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: {
        type: Boolean,
    },
    status: {
        type: String,
    },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
        // Server-side will handle role-based redirection
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Log in" />
        
        <!-- Enhanced Background with multiple layers - Fixed to cover everything -->
        <div class="fixed inset-0 z-0">
            <div 
                class="fixed inset-0 bg-cover bg-center bg-no-repeat"
                style="background-image: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');"
            ></div>
            <div class="fixed inset-0 bg-gradient-to-br from-slate-900/70 via-slate-800/50 to-slate-900/70"></div>
            <div class="fixed inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-orange-900/20 via-transparent to-transparent"></div>
        </div>

        <!-- Static background elements -->
        <div class="absolute inset-0 overflow-hidden">
            <!-- Removed animated floating shapes for static background -->
        </div>

        <!-- Login Form Container -->
        <div class="relative z-10 w-full max-w-md mx-4 h-[90vh] flex items-center justify-center">
            <div class="w-full">
                <form 
                    @submit.prevent="submit" 
                    class="relative bg-white/10 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl max-h-[85vh] overflow-y-auto"
                >
                    <div class="p-8 md:p-10 space-y-6">
                        <!-- Enhanced Form Header -->
                        <div class="text-center space-y-3">
                            <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-orange-500 via-red-500 to-pink-500 rounded-2xl mb-4 shadow-lg shadow-orange-500/25">
                                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path>
                                </svg>
                            </div>
                            <h2 class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-white via-gray-100 to-gray-200 bg-clip-text text-transparent">
                                Welcome Back
                            </h2>
                            <p class="text-gray-300 text-sm md:text-base font-light">Sign in to your account to continue</p>
                        </div>

                        <div v-if="status" class="mb-4 text-sm font-medium text-green-600 text-center">
                            {{ status }}
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
                                    autofocus
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
                                    autocomplete="current-password"
                                    placeholder="Enter your password"
                                />
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                    <svg class="h-5 w-5 text-gray-400/70" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                                    </svg>
                                </div>
                            </div>
                            <InputError class="mt-1" :message="form.errors.password" />
                        </div>

                        <!-- Remember Me and Forgot Password -->
                        <div class="flex items-center justify-between mt-4">
                            <label class="flex items-center">
                                <Checkbox name="remember" v-model:checked="form.remember" />
                                <span class="ms-2 text-sm text-gray-300">Remember me</span>
                            </label>

                            <Link
                                v-if="canResetPassword"
                                :href="route('password.request')"
                                class="text-sm text-orange-400 hover:text-orange-300 transition-colors duration-300"
                            >
                                Forgot your password?
                            </Link>
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
                                    Sign In
                                </span>
                                <span v-else class="flex items-center justify-center">
                                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    Signing In...
                                </span>
                            </PrimaryButton>

                            <div class="text-center">
                                <Link
                                    :href="route('register')"
                                    class="text-gray-300 hover:text-white transition-colors duration-300 text-sm"
                                >
                                    Don't have an account? 
                                    <span class="text-orange-400 hover:text-orange-300 font-semibold">Sign up here</span>
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
