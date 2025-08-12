<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\MenuItem;
use Inertia\Inertia;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class MenuController extends Controller
{

    public function index()
{
    $auth = Auth::user();
    $menus = collect();

    if ($auth && $auth->role === 'restaurant') {
        // Get restaurant for the authenticated user
        $restaurant = \App\Models\Restaurant::where('user_id', $auth->id)->first();
        if ($restaurant) {
            // Only show menus for this restaurant with restaurant relationship
            $menus = MenuItem::with('restaurant')->where('restaurant_id', $restaurant->id)->get();
        }
    } else {
        // For customers, show all menus from registered restaurants with restaurant relationship
        $menus = MenuItem::with('restaurant')->whereHas('restaurant')->get();
    }

    return Inertia::render('Customer/Menu', [
        'menus' => $menus,
        'auth' => [
            'user' => $auth,
        ],
    ]);
}
   public function store(Request $request)
{
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'price' => 'required|numeric',
        'picture' => 'required|image|mimes:jpeg,png,jpg|max:2048',
        'description' => 'nullable|string',
    ]);

    // Get the restaurant for the authenticated user
    $restaurant = \App\Models\Restaurant::where('user_id', Auth::id())->first();
    
    if (!$restaurant) {
        return redirect()->back()->with('error', 'Restaurant not found.');
    }

    // Save picture to storage/app/public/menu_images
    $path = $request->file('picture')->store('menu_images', 'public');

    // Save into DB with the image path and restaurant_id
    MenuItem::create([
        'name' => $validated['name'],
        'price' => $validated['price'],
        'picture' => $path,
        'description' => $validated['description'],
        'restaurant_id' => $restaurant->id,
    ]);

    return redirect('/restaurantmenus')->with('success', 'Menu added.');
}


public function edit(MenuItem $menu)
{
    // optional: authorize user
    return Inertia::render('Restaurant/Edit', [
        'menu' => $menu,
    ]);
}

public function update(Request $request, MenuItem $menu)
{
    $data = $request->validate([
        'name' => 'required|string|max:255',
        'description' => 'nullable|string',
        'price' => 'required|numeric',
        'picture' => 'nullable|image|max:2048',
    ]);

    if ($request->hasFile('picture')) {
        // store and set $data['picture']
        $path = $request->file('picture')->store('menus', 'public');
        // optionally delete old file
        $data['picture'] = $path;
    }

    
    $menu->update($data);


    return redirect('/restaurantmenus')->with('success', 'Menu updated.');
}

public function destroy(MenuItem $menu)
{
    // optionally delete image file from storage
    $menu->delete();
    return Inertia::location(route('restaurantmenus.index'));
}

public function customerMenu(string $slug)
{
    $restaurant = \App\Models\Restaurant::where('slug', $slug)->firstOrFail();
    $menus = MenuItem::where('restaurant_id', $restaurant->id)->get();
    return Inertia::render('Customer/Menu', [
        'menus' => $menus,
        'restaurant' => $restaurant,
        'auth' => [
            'user' => Auth::user(),
        ],
    ]);
}

}
