<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Restaurant;
use App\Models\MenuItem;
use Illuminate\Http\Request;

class RestaurantApiController extends Controller
{
    /**
     * Get all restaurants with optional filtering
     */
    public function getRestaurants(Request $request)
    {
        $query = Restaurant::query();

        // Search by name
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        // Filter by category
        if ($request->has('category') && $request->category !== 'All') {
            $query->where('category', $request->category);
        }

        // Filter by minimum rating
        if ($request->has('min_rating')) {
            $query->where('rating', '>=', $request->min_rating);
        }

        // Order by rating
        $query->orderBy('rating', 'desc');

        $restaurants = $query->get();

        return response()->json([
            'restaurants' => $restaurants
        ]);
    }

    /**
     * Get all menu items with optional filtering and sorting
     */
    public function getMenus(Request $request)
    {
        $query = MenuItem::query();

        // Search by name or description
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', '%' . $search . '%')
                  ->orWhere('description', 'like', '%' . $search . '%');
            });
        }

        // Sorting
        switch ($request->get('sort', 'name_asc')) {
            case 'price_asc':
                $query->orderBy('price', 'asc');
                break;
            case 'price_desc':
                $query->orderBy('price', 'desc');
                break;
            case 'name_desc':
                $query->orderBy('name', 'desc');
                break;
            case 'name_asc':
            default:
                $query->orderBy('name', 'asc');
                break;
        }

        $menus = $query->get();

        return response()->json([
            'menus' => $menus
        ]);
    }

    /**
     * Get restaurants with their menu items
     */
    public function getRestaurantsWithMenus(Request $request)
    {
        $query = Restaurant::with('menuItems');

        // Apply same filters as getRestaurants
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        if ($request->has('category') && $request->category !== 'All') {
            $query->where('category', $request->category);
        }

        if ($request->has('min_rating')) {
            $query->where('rating', '>=', $request->min_rating);
        }

        $query->orderBy('rating', 'desc');

        $restaurants = $query->get();

        return response()->json([
            'restaurants' => $restaurants
        ]);
    }

    /**
     * Get menus for the authenticated restaurant owner
     */
    public function getRestaurantMenus(Request $request)
    {
        $user = \Illuminate\Support\Facades\Auth::user();
        
        if (!$user || $user->role !== 'restaurant') {
            return response()->json([
                'error' => 'Unauthorized or not a restaurant owner'
            ], 403);
        }

        // Get the restaurant for the authenticated user
        $restaurant = \App\Models\Restaurant::where('user_id', $user->id)->first();
        
        if (!$restaurant) {
            return response()->json([
                'menus' => [],
                'restaurant' => null,
                'message' => 'No restaurant found for this user'
            ]);
        }

        // Get all menu items for this restaurant
        $menus = MenuItem::where('restaurant_id', $restaurant->id)->get();

        return response()->json([
            'menus' => $menus,
            'restaurant' => $restaurant
        ]);
    }

    /**
     * Delete a menu item for the authenticated restaurant owner
     */
    public function deleteMenu($id)
    {
        $user = \Illuminate\Support\Facades\Auth::user();
        
        if (!$user || $user->role !== 'restaurant') {
            return response()->json([
                'error' => 'Unauthorized or not a restaurant owner'
            ], 403);
        }

        // Get the restaurant for the authenticated user
        $restaurant = \App\Models\Restaurant::where('user_id', $user->id)->first();
        
        if (!$restaurant) {
            return response()->json([
                'error' => 'Restaurant not found'
            ], 404);
        }

        // Find the menu item that belongs to this restaurant
        $menu = MenuItem::where('id', $id)
                       ->where('restaurant_id', $restaurant->id)
                       ->first();
        
        if (!$menu) {
            return response()->json([
                'error' => 'Menu item not found'
            ], 404);
        }

        $menu->delete();
        
        return response()->json([
            'success' => true, 
            'message' => 'Menu item deleted successfully'
        ]);
    }
}
