<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\RestaurantController;
use App\Models\MenuItem;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

// Generic dashboard route redirecting based on user role
Route::middleware('auth')->get('/dashboard', function () {
    $user = Auth::user();

    if ($user->role === 'restaurant') {
        return redirect()->route('restaurant.home');
    }

    // Default to customer dashboard if not restaurant
    return redirect()->route('customer.dashboard');
})->name('dashboard');

Route::middleware(['auth'])->group(function () {
    // Restaurant home page
    Route::get('/restaurant', function () {
        return Inertia::render('Restaurant');
    })->name('restaurant.home');
    Route::get('/customer/dashboard', function () {
        return Inertia::render('Customer');
    })->name('customer.dashboard');

    // Show Add Restaurant form
    Route::get('/restaurant/add', function () {
        return Inertia::render('Restaurant/Addrestaurant');
    })->name('restaurants.create');

    // Store Restaurant
    Route::post('/restaurants', [RestaurantController::class, 'store'])->name('restaurants.store');

    // Edit Restaurant
    Route::get('/restaurants/{restaurant}/edit', [RestaurantController::class, 'edit'])->name('restaurants.edit');

    // Update Restaurant
    Route::put('/restaurants/{restaurant}', [RestaurantController::class, 'update'])->name('restaurants.update');

    // Example dashboard route for restaurants (can adjust to your own component)
    Route::get('/restaurant/dashboard', function () {
        return Inertia::render('Restaurant/Rhome');
    })->name('restaurant.dashboard');
});

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});


Route::get('/restaurantlist', [RestaurantController::class, 'index'])->name('restaurantlist.index');

Route::get('/about', function () {
    return Inertia::render('Customer/About');
})->name('about.index');

// Combined restaurants and menus listing for customers
Route::get('/browse', [RestaurantController::class, 'restaurantMenuList'])->name('browse.index');
Route::get('/restaurantmenulist', [RestaurantController::class, 'restaurantMenuList'])->name('restaurantmenulist.index');

// Customer menu page - this was missing
Route::get('/menu', [MenuController::class, 'index'])->name('menu.index');

Route::get('/contactus', function () {
    return Inertia::render('Comp/Contactus');
})->name('contactus.index');

// Cart page
Route::get('/cart', function () {
    return Inertia::render('Customer/Cart', [
        'auth' => Auth::user(),
    ]);
})->name('cart.index');

Route::get('/customers', function () {
    return Inertia::render('Restaurant/Customers');
})->name('customers.index');

Route::get('/staff', function () {
    return Inertia::render('Restaurant/Staff');
})->name('staff.index');



Route::get('/restaurantmenus', function () {
    return Inertia::render('Restaurant/Restaurantmenus');
})->name('restaurantmenus.index');

Route::get('/report', function () {
    return Inertia::render('Restaurant/Report');
})->name('Report.index');

Route::get('/setting', function () {
    $restaurant = \App\Models\Restaurant::where('user_id', Auth::id())->first();

    return Inertia::render('Restaurant/Setting', [
        'restaurant' => $restaurant,
        'auth' => Auth::user(),
    ]);
})->name('Setting.index');

Route::get('/about', function () {
    return Inertia::render('Comp/About');
})->name('About.index');

Route::get('/contactus', function () {
    return Inertia::render('Comp/Contactus');
})->name('ContactUs.index');

Route::get('/menuform', function () {
    return Inertia::render('Restaurant/MenuForm');
})->name('menuform.index');

Route::resource('menus', MenuController::class);


Route::get('/rhome', function () {
    return Inertia::render('Restaurant/Rhome');
})->name('rhome.index');


// Customer menu page for a specific restaurant by slug
Route::get('/restaurants/{slug}/menu', [MenuController::class, 'customerMenu'])->name('menu.customer');

// Public restaurant detail page by slug
Route::get('/restaurants/{slug}', [RestaurantController::class, 'show'])->name('restaurants.show');





require __DIR__ . '/auth.php';

// API Routes for Restaurant and Menu data
Route::prefix('api')->group(function () {
    Route::get('/restaurants', [\App\Http\Controllers\Api\RestaurantApiController::class, 'getRestaurants']);
    Route::get('/menus', [\App\Http\Controllers\Api\RestaurantApiController::class, 'getMenus']);
    Route::get('/restaurants-with-menus', [\App\Http\Controllers\Api\RestaurantApiController::class, 'getRestaurantsWithMenus']);
    Route::get('/restaurant/menus', [\App\Http\Controllers\Api\RestaurantApiController::class, 'getRestaurantMenus']);
    Route::delete('/restaurantmenus/{id}', [\App\Http\Controllers\Api\RestaurantApiController::class, 'deleteMenu']);
});
