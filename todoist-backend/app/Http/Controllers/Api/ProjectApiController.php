<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Project;
use App\Models\User;
use Illuminate\Http\Request;

class ProjectApiController extends Controller
{
    private function isAdmin(?string $role): bool
    {
        return in_array($role, ['superadmin', 'admin'], true);
    }

    private function canAccessProject(Request $request, Project $project): bool
    {
        $user = $request->user();
        if ($this->isAdmin($user?->role)) {
            return true;
        }

        if ((int) $project->owner_user_id === (int) $user->id) {
            return true;
        }

        return $project->members()->where('users.id', $user->id)->exists();
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = max(1, (int) $request->query('per_page', 12));

        $query = Project::query()
            ->withCount('members')
            ->orderByDesc('created_at');
        if (!$this->isAdmin($user?->role)) {
            $query->where(function ($q) use ($user) {
                $q->where('owner_user_id', $user->id)
                    ->orWhereHas('members', function ($memberQ) use ($user) {
                        $memberQ->where('users.id', $user->id);
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
            'code' => ['nullable', 'string', 'max:40'],
            'category' => ['nullable', 'string', 'max:120'],
            'description' => ['nullable', 'string'],
        ]);

        $project = Project::create(array_merge($data, [
            'owner_user_id' => $user->id,
        ]));

        $project->members()->syncWithoutDetaching([
            $user->id => ['role' => 'owner', 'invited_by_user_id' => $user->id],
        ]);

        return response()->json($project->loadCount('members'), 201);
    }

    public function show(Request $request, Project $project)
    {
        $user = $request->user();
        if (!$this->canAccessProject($request, $project)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        return response()->json($project->load(['members:id,name,email'])->loadCount('members'));
    }

    public function update(Request $request, Project $project)
    {
        $user = $request->user();
        if (!$this->canAccessProject($request, $project)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:190'],
            'code' => ['nullable', 'string', 'max:40'],
            'category' => ['nullable', 'string', 'max:120'],
            'description' => ['nullable', 'string'],
        ]);

        $project->fill($data)->save();
        return response()->json($project->loadCount('members'));
    }

    public function destroy(Request $request, Project $project)
    {
        $user = $request->user();
        if (!$this->canAccessProject($request, $project)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        $project->delete();
        return response()->json(['message' => 'Deleted']);
    }

    public function members(Request $request, Project $project)
    {
        if (!$this->canAccessProject($request, $project)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json([
            'project_id' => $project->id,
            'members' => $project->members()->select('users.id', 'users.name', 'users.email', 'project_members.role')->get(),
        ]);
    }

    public function addMember(Request $request, Project $project)
    {
        $user = $request->user();
        if ((int) $project->owner_user_id !== (int) $user->id && !$this->isAdmin($user?->role)) {
            return response()->json(['message' => 'Only owner can invite members'], 403);
        }

        $data = $request->validate([
            'user_id' => ['required', 'integer', 'exists:users,id'],
            'role' => ['nullable', 'string', 'in:owner,member'],
        ]);

        $member = User::query()->findOrFail((int) $data['user_id']);
        $project->members()->syncWithoutDetaching([
            $member->id => [
                'role' => $data['role'] ?? 'member',
                'invited_by_user_id' => $user->id,
            ],
        ]);

        return response()->json([
            'message' => 'Member added',
            'member' => [
                'id' => $member->id,
                'name' => $member->name,
                'email' => $member->email,
                'role' => $data['role'] ?? 'member',
            ],
        ], 201);
    }
}
