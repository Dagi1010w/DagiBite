<?php

namespace App\Http\Controllers;

use App\Models\Restaurant;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class RestaurantController extends Controller
{
    /**
     * Combined list of restaurants and menus for a customer landing page.
     */
    public function restaurantMenuList()
    {
        $restaurants = \App\Models\Restaurant::select('id','name','description','category','rating','logo_path','slug')
            ->orderBy('name')
            ->get();
        $menus = \App\Models\MenuItem::select('id','name','description','price','picture','restaurant_id')
            ->latest('id')
            ->take(30)
            ->get();

        return inertia('Customer/RestaurantMenuList', [
            'restaurants' => $restaurants,
            'menus' => $menus,
            'auth' => Auth::user(),
        ]);
    }

    /**
     * Show a single restaurant by slug for customers.
     */
    public function show(string $slug)
    {
        $restaurant = Restaurant::where('slug', $slug)
            ->select('id','name','description','category','rating','logo_path','slug','address','phone')
            ->firstOrFail();

        return inertia('Customer/View', [
            'restaurant' => $restaurant,
            'auth' => Auth::user(),
        ]);
    }

    /**
     * Display a listing of restaurants to customers.
     */
    public function index()
    {
        $restaurants = Restaurant::select('id','name','description','category','rating','logo_path','slug','address','phone')
            ->orderBy('name')
            ->get();

        return inertia('Customer/RestaurantList', [
            'restaurants' => $restaurants,
            'auth' => Auth::user(),
        ]);
    }

    /**
     * Store a newly created restaurant in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:5000'],
            'category' => ['nullable', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:30', 'unique:restaurants,phone'],
            'address' => ['nullable', 'string', 'max:1000'],
            'rating' => ['nullable', 'numeric', 'min:0', 'max:9.99'],
            'slug' => ['required', 'string', 'max:100', 'alpha_dash', 'unique:restaurants,slug'],
            // Use file + mimes to allow SVG as well; image rule alone would reject svg
            'logo' => ['nullable', 'file', 'mimes:jpg,jpeg,png,webp,svg', 'max:2048'],
        ]);

        // Ensure slug is clean (in case client sent with trailing spaces/case)
        $validated['slug'] = Str::slug($validated['slug'] ?: $validated['name']);

        // Handle file upload if present
        $logoPath = null;
        if ($request->hasFile('logo')) {
            $logoPath = $request->file('logo')->store('restaurants', 'public');
        }

        $restaurant = new Restaurant();
        $restaurant->user_id = Auth::id();
        $restaurant->name = $validated['name'];
        $restaurant->description = $validated['description'] ?? null;
        $restaurant->category = $validated['category'] ?? null;
        $restaurant->phone = $validated['phone'] ?? null;
        $restaurant->address = $validated['address'] ?? null;
        $restaurant->logo_path = $logoPath;
        $restaurant->rating = isset($validated['rating']) ? (float) $validated['rating'] : 0;
        $restaurant->slug = $validated['slug'];
        $restaurant->save();

        return redirect()->route('restaurant.home')->with('success', 'Restaurant created successfully.');
    }

    /**
     * Show the form for editing the specified restaurant.
     */
    public function edit(Restaurant $restaurant)
    {
        // Ensure the user owns this restaurant
        if ($restaurant->user_id !== Auth::id()) {
            abort(403, 'Unauthorized action.');
        }

        return inertia('Restaurant/EditRestaurant', [
            'restaurant' => $restaurant,
        ]);
    }

    /**
     * Update the specified restaurant in storage.
     */
    public function update(Request $request, Restaurant $restaurant)
    {
        // Ensure the user owns this restaurant
        if ($restaurant->user_id !== Auth::id()) {
            abort(403, 'Unauthorized action.');
        }

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:5000'],
            'category' => ['nullable', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:30', 'unique:restaurants,phone,' . $restaurant->id],
            'address' => ['nullable', 'string', 'max:1000'],
            'rating' => ['nullable', 'numeric', 'min:0', 'max:9.99'],
            'slug' => ['required', 'string', 'max:100', 'alpha_dash', 'unique:restaurants,slug,' . $restaurant->id],
            'logo' => ['nullable', 'file', 'mimes:jpg,jpeg,png,webp,svg', 'max:2048'],
        ]);

        // Ensure slug is clean
        $validated['slug'] = Str::slug($validated['slug'] ?: $validated['name']);

        // Handle file upload if present
        if ($request->hasFile('logo')) {
            // Delete old logo if exists
            if ($restaurant->logo_path) {
                Storage::disk('public')->delete($restaurant->logo_path);
            }
            $restaurant->logo_path = $request->file('logo')->store('restaurants', 'public');
        }

        $restaurant->name = $validated['name'];
        $restaurant->description = $validated['description'] ?? null;
        $restaurant->category = $validated['category'] ?? null;
        $restaurant->phone = $validated['phone'] ?? null;
        $restaurant->address = $validated['address'] ?? null;
        $restaurant->rating = isset($validated['rating']) ? (float) $validated['rating'] : 0;
        $restaurant->slug = $validated['slug'];
        $restaurant->save();

        return redirect()->route('restaurant.home')->with('success', 'Restaurant updated successfully.');
    }
}
