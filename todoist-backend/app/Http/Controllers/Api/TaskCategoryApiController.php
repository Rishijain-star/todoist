<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TaskCategory;
use Illuminate\Http\Request;

class TaskCategoryApiController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = max(1, (int) $request->query('per_page', 12));

        $query = TaskCategory::query()->orderByDesc('created_at');
        if (!in_array($user?->role, ['superadmin', 'admin'], true)) {
            $query->where('owner_user_id', $user->id);
        }

        return response()->json($query->paginate($perPage));
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
        ]);

        $category = TaskCategory::create([
            'owner_user_id' => $user->id,
            'name' => trim($data['name']),
        ]);

        return response()->json($category, 201);
    }

    public function show(Request $request, TaskCategory $category)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $category->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        return response()->json($category);
    }

    public function update(Request $request, TaskCategory $category)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $category->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'name' => ['required', 'string', 'max:120'],
        ]);

        $category->name = trim($data['name']);
        $category->save();

        return response()->json($category);
    }

    public function destroy(Request $request, TaskCategory $category)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $category->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        $category->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
