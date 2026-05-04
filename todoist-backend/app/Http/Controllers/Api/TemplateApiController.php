<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Template;
use App\Models\User;
use Illuminate\Http\Request;

class TemplateApiController extends Controller
{
    private function isAdminRole(?string $role): bool
    {
        return in_array($role, ['superadmin', 'admin'], true);
    }

    /**
     * List templates owned by the current user OR created by admin/superadmin (library).
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = max(1, (int) $request->query('per_page', 12));

        $query = Template::query()
            ->with('owner:id,name,email,role')
            ->orderByDesc('created_at');

        if (!$this->isAdminRole($user?->role)) {
            $query->where(function ($q) use ($user) {
                $q->where('owner_user_id', $user->id)
                    ->orWhereHas('owner', function ($sub) {
                        $sub->whereIn('role', ['admin', 'superadmin']);
                    });
            });
        }

        return response()->json($query->paginate($perPage));
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $data = $request->validate([
            'name' => ['required', 'string', 'max:190'],
            'category' => ['nullable', 'string', 'max:120'],
            'description' => ['nullable', 'string'],
            'phases' => ['nullable', 'array'],
        ]);

        $template = Template::create([
            'owner_user_id' => $user->id,
            'name' => $data['name'],
            'category' => $data['category'] ?? null,
            'description' => $data['description'] ?? null,
            'phases' => $data['phases'] ?? [],
        ]);

        return response()->json($template, 201);
    }

    public function show(Request $request, Template $template)
    {
        $user = $request->user();
        if (!$this->userCanView($user, $template)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($template);
    }

    public function update(Request $request, Template $template)
    {
        $user = $request->user();
        if (!$this->userCanMutate($user, $template)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:190'],
            'category' => ['nullable', 'string', 'max:120'],
            'description' => ['nullable', 'string'],
            'phases' => ['nullable', 'array'],
        ]);

        $template->fill($data);
        if (array_key_exists('phases', $data)) {
            $template->phases = $data['phases'] ?? [];
        }
        $template->save();

        return response()->json($template);
    }

    public function destroy(Request $request, Template $template)
    {
        $user = $request->user();
        if (!$this->userCanMutate($user, $template)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $template->delete();

        return response()->json(['message' => 'Deleted']);
    }

    private function userCanView(?User $user, Template $template): bool
    {
        if ($this->isAdminRole($user?->role)) {
            return true;
        }
        if ((int) $template->owner_user_id === (int) $user?->id) {
            return true;
        }

        $owner = $template->relationLoaded('owner') ? $template->owner : $template->owner()->first();

        return $owner && $this->isAdminRole($owner->role);
    }

    private function userCanMutate(?User $user, Template $template): bool
    {
        if ($this->isAdminRole($user?->role)) {
            return true;
        }

        return (int) $template->owner_user_id === (int) $user?->id;
    }
}
