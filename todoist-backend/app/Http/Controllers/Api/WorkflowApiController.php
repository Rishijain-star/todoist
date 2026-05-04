<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Workflow;
use Illuminate\Http\Request;

class WorkflowApiController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = max(1, (int) $request->query('per_page', 12));

        $query = Workflow::query()
            ->with(['project', 'category', 'template'])
            ->orderByDesc('created_at');

        if (!in_array($user?->role, ['superadmin', 'admin'], true)) {
            $query->where('owner_user_id', $user->id);
        }

        return response()->json($query->paginate($perPage));
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $data = $request->validate([
            'name' => ['required', 'string', 'max:190'],
            'status' => ['nullable', 'string', 'max:40'],
            'progress' => ['nullable', 'integer', 'min:0', 'max:100'],
            'deadline' => ['nullable', 'date'],
            'project_id' => ['nullable', 'integer', 'exists:projects,id'],
            'task_category_id' => ['nullable', 'integer', 'exists:task_categories,id'],
            'template_id' => ['nullable', 'integer', 'exists:templates,id'],
            'steps' => ['nullable', 'array'],
        ]);

        $workflow = Workflow::create([
            'owner_user_id' => $user->id,
            'project_id' => $data['project_id'] ?? null,
            'task_category_id' => $data['task_category_id'] ?? null,
            'template_id' => $data['template_id'] ?? null,
            'name' => $data['name'],
            'status' => $data['status'] ?? 'Pending',
            'progress' => (int) ($data['progress'] ?? 0),
            'deadline' => $data['deadline'] ?? null,
            'steps' => $data['steps'] ?? [],
        ]);

        return response()->json($workflow->load(['project', 'category', 'template']), 201);
    }

    public function show(Request $request, Workflow $workflow)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $workflow->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($workflow->load(['project', 'category', 'template']));
    }

    public function update(Request $request, Workflow $workflow)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $workflow->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'max:190'],
            'status' => ['nullable', 'string', 'max:40'],
            'progress' => ['nullable', 'integer', 'min:0', 'max:100'],
            'deadline' => ['nullable', 'date'],
            'project_id' => ['nullable', 'integer', 'exists:projects,id'],
            'task_category_id' => ['nullable', 'integer', 'exists:task_categories,id'],
            'template_id' => ['nullable', 'integer', 'exists:templates,id'],
            'steps' => ['nullable', 'array'],
        ]);

        $workflow->fill($data);
        if (array_key_exists('steps', $data)) {
            $workflow->steps = $data['steps'] ?? [];
        }
        $workflow->save();

        return response()->json($workflow->load(['project', 'category', 'template']));
    }

    public function destroy(Request $request, Workflow $workflow)
    {
        $user = $request->user();
        if (!in_array($user?->role, ['superadmin', 'admin'], true) && (int) $workflow->owner_user_id !== (int) $user->id) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $workflow->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
