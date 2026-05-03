<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TaskApiController extends Controller
{
    private function isAdmin(?string $role): bool
    {
        return in_array($role, ['superadmin', 'admin'], true);
    }

    private function canAccessTask(Request $request, Task $task): bool
    {
        $user = $request->user();
        if ($this->isAdmin($user?->role)) {
            return true;
        }

        if ((int) $task->owner_user_id === (int) $user->id || (int) ($task->assigned_user_id ?? 0) === (int) $user->id) {
            return true;
        }

        if ($task->project_id) {
            return $task->project?->members()->where('users.id', $user->id)->exists() ?? false;
        }

        return false;
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = max(1, (int) $request->query('per_page', 12));

        $query = Task::query()
            ->with(['project', 'workflow', 'category', 'assignedUser', 'attachments', 'comments.user', 'subtasks.assignedUser', 'subtasks.attachments'])
            ->whereNull('parent_task_id')
            ->orderByDesc('created_at');

        if (!$this->isAdmin($user?->role)) {
            $query->where(function ($q) use ($user) {
                $q->where('owner_user_id', $user->id)
                    ->orWhere('assigned_user_id', $user->id)
                    ->orWhereHas('project.members', function ($memberQ) use ($user) {
                        $memberQ->where('users.id', $user->id);
                    });
            });
        }

        if ($request->filled('status')) {
            $query->where('status', (string) $request->query('status'));
        }
        foreach (['project_id', 'workflow_id', 'task_category_id', 'assigned_user_id'] as $key) {
            if ($request->filled($key)) {
                $query->where($key, (int) $request->query($key));
            }
        }

        return response()->json($query->paginate($perPage));
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $data = $request->validate([
            'title' => ['required', 'string', 'max:190'],
            'due_date' => ['nullable', 'date'],
            'priority' => ['nullable', 'string', 'max:40'],
            'status' => ['nullable', 'string', 'max:40'],
            'team' => ['nullable', 'string', 'max:120'],
            'notes' => ['nullable', 'string'],
            'project_id' => ['nullable', 'integer', 'exists:projects,id'],
            'workflow_id' => ['nullable', 'integer', 'exists:workflows,id'],
            'task_category_id' => ['nullable', 'integer', 'exists:task_categories,id'],
            'assigned_user_id' => ['nullable', 'integer', 'exists:users,id'],
            'parent_task_id' => ['nullable', 'integer', 'exists:tasks,id'],
        ]);

        $task = Task::create([
            'owner_user_id' => $user->id,
            'project_id' => $data['project_id'] ?? null,
            'workflow_id' => $data['workflow_id'] ?? null,
            'task_category_id' => $data['task_category_id'] ?? null,
            'assigned_user_id' => $data['assigned_user_id'] ?? null,
            'parent_task_id' => $data['parent_task_id'] ?? null,
            'title' => $data['title'],
            'due_date' => $data['due_date'] ?? null,
            'priority' => $data['priority'] ?? 'Medium',
            'status' => $data['status'] ?? 'Pending',
            'team' => $data['team'] ?? null,
            'notes' => $data['notes'] ?? null,
        ]);

        return response()->json($task->load(['project', 'workflow', 'category', 'assignedUser', 'attachments', 'subtasks']), 201);
    }

    public function show(Request $request, Task $task)
    {
        if (!$this->canAccessTask($request, $task)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        return response()->json($task->load([
            'project',
            'workflow',
            'category',
            'assignedUser',
            'attachments',
            'comments.user',
            'subtasks.assignedUser',
            'subtasks.attachments',
            'subtasks.comments.user',
        ]));
    }

    public function storeComment(Request $request, Task $task)
    {
        if (!$this->canAccessTask($request, $task)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'body' => ['required', 'string', 'max:5000'],
        ]);

        $comment = $task->comments()->create([
            'user_id' => $request->user()->id,
            'body' => $data['body'],
        ]);

        return response()->json($comment->load('user:id,name,email'), 201);
    }

    public function update(Request $request, Task $task)
    {
        $user = $request->user();

        if (!$this->canAccessTask($request, $task)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'title' => ['sometimes', 'required', 'string', 'max:190'],
            'due_date' => ['nullable', 'date'],
            'priority' => ['nullable', 'string', 'max:40'],
            'status' => ['nullable', 'string', 'max:40'],
            'team' => ['nullable', 'string', 'max:120'],
            'notes' => ['nullable', 'string'],
            'project_id' => ['nullable', 'integer', 'exists:projects,id'],
            'workflow_id' => ['nullable', 'integer', 'exists:workflows,id'],
            'task_category_id' => ['nullable', 'integer', 'exists:task_categories,id'],
            'assigned_user_id' => ['nullable', 'integer', 'exists:users,id'],
            'parent_task_id' => ['nullable', 'integer', 'exists:tasks,id'],
        ]);

        // Members cannot change assignee; admins/managers can assign any valid user.
        if (($user?->role === 'member') && array_key_exists('assigned_user_id', $data)) {
            unset($data['assigned_user_id']);
        }

        $task->fill($data)->save();
        return response()->json($task->load(['project', 'workflow', 'category', 'assignedUser', 'attachments', 'subtasks']));
    }

    public function destroy(Request $request, Task $task)
    {
        if (!$this->canAccessTask($request, $task)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }
        $task->delete();
        return response()->json(['message' => 'Deleted']);
    }

    public function upcoming(Request $request)
    {
        $perPage = max(1, (int) $request->query('per_page', 50));
        $from = now()->startOfDay();
        $to = now()->addDays(30)->endOfDay();

        $request->merge(['status' => $request->query('status', 'Pending')]);

        $query = Task::query()
            ->with(['project', 'assignedUser', 'attachments', 'comments.user'])
            ->whereNull('parent_task_id')
            ->whereNotNull('due_date')
            ->whereBetween('due_date', [$from->toDateString(), $to->toDateString()])
            ->orderBy('due_date');

        $user = $request->user();
        if (!$this->isAdmin($user?->role)) {
            $query->where(function ($q) use ($user) {
                $q->where('owner_user_id', $user->id)
                    ->orWhere('assigned_user_id', $user->id)
                    ->orWhereHas('project.members', function ($memberQ) use ($user) {
                        $memberQ->where('users.id', $user->id);
                    });
            });
        }

        return response()->json($query->paginate($perPage));
    }

    public function uploadAttachment(Request $request, Task $task)
    {
        if (!$this->canAccessTask($request, $task)) {
            return response()->json(['message' => 'Forbidden'], 403);
        }

        $data = $request->validate([
            'file' => ['required', 'file', 'max:10240'],
        ]);

        $file = $data['file'];
        $path = $file->store('task-attachments', 'public');

        $attachment = $task->attachments()->create([
            'uploaded_by_user_id' => $request->user()->id,
            'disk' => 'public',
            'path' => $path,
            'original_name' => $file->getClientOriginalName(),
            'mime_type' => $file->getMimeType(),
            'size_bytes' => $file->getSize(),
        ]);

        return response()->json([
            'message' => 'Attachment uploaded',
            'attachment' => $attachment,
            'url' => Storage::disk('public')->url($attachment->path),
        ], 201);
    }
}
