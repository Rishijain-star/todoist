<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Admin\AdminMockRepository;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AdminApiController extends Controller
{
    public function __construct(private readonly AdminMockRepository $repository)
    {
    }

    public function dashboard()
    {
        return response()->json($this->repository->dashboard());
    }

    public function list(string $resource, Request $request)
    {
        $perPage = (int) $request->query('per_page', 12);
        if ($perPage < 1) {
            $perPage = 12;
        }
        $collection = $this->collectionFor($resource);
        if ($collection === null) {
            return response()->json(['message' => 'Unknown resource'], 404);
        }

        $pageParam = $resource . '_page';
        if ($resource === 'tasks') {
            $projects = $this->collectionFor('projects') ?? collect();
            $workflows = $this->collectionFor('workflows') ?? collect();
            $collection = $collection->map(function ($t) use ($projects, $workflows) {
                $pid = $t['project_id'] ?? '';
                $wid = $t['workflow_id'] ?? '';
                $p = $projects->firstWhere('id', $pid);
                $w = $workflows->firstWhere('id', $wid);

                return array_merge($t, [
                    'project_name' => $p['name'] ?? ($pid ?: ''),
                    'workflow_name' => $w['name'] ?? ($wid ?: ''),
                ]);
            });
        }
        if ($resource === 'templates') {
            $collection = $collection->map(fn ($t) => $this->normalizeTemplatePayload($t));
        }

        // Always return latest items first (newest at top) before pagination.
        $collection = $this->sortNewestFirst($collection);

        $paginator = $this->paginateCollection($collection, $perPage, $pageParam);
        return response()->json($paginator);
    }

    public function show(string $resource, string $id)
    {
        $collection = $this->collectionFor($resource);
        $item = $collection?->firstWhere('id', $id);

        if (!$item) {
            return response()->json(['message' => 'Not found'], 404);
        }

        if ($resource === 'templates') {
            $item = $this->normalizeTemplatePayload($item);
        }

        return response()->json($item);
    }

    public function store(string $resource, Request $request)
    {
        return $this->mutate($resource, $request, null);
    }

    public function update(string $resource, string $id, Request $request)
    {
        return $this->mutate($resource, $request, $id);
    }

    public function destroy(string $resource, string $id)
    {
        $collection = $this->collectionFor($resource);
        if ($collection === null) {
            return response()->json(['message' => 'Unknown resource'], 404);
        }
        $filtered = $collection->reject(fn ($row) => (string) ($row['id'] ?? '') === $id)->values()->all();
        $this->saveFor($resource, $filtered);
        return response()->json(['message' => 'Deleted']);
    }

    public function reports()
    {
        return response()->json($this->repository->reports());
    }

    public function settings()
    {
        return response()->json($this->repository->settings());
    }

    public function updateSettings(Request $request)
    {
        $current = $this->repository->settings();
        $data = array_merge($current, $request->all());
        cache()->put('admin_data.settings', $data);
        return response()->json($data);
    }

    private function mutate(string $resource, Request $request, ?string $id)
    {
        $collection = $this->collectionFor($resource);
        if ($collection === null) {
            return response()->json(['message' => 'Unknown resource'], 404);
        }

        $data = $request->all();
        if ($resource === 'users') {
            return $this->mutateUsers($collection, $data, $id);
        }
        if ($resource === 'projects') {
            $data = array_merge($data, [
                'name' => $data['name'] ?? 'New Project',
                'code' => strtoupper(trim((string) ($data['code'] ?? ''))) ?: 'PRJ',
                'category' => $data['category'] ?? 'General',
                'description' => $data['description'] ?? '',
            ]);
        }
        if ($resource === 'task_categories') {
            $name = trim((string) ($data['name'] ?? ''));
            if ($name === '') {
                return response()->json(['message' => 'Category name is required'], 422);
            }
            $data = array_merge($data, ['name' => $name]);
        }
        if ($resource === 'notifications') {
            $data = array_merge($data, [
                'title' => $data['title'] ?? 'Notification',
                'type' => $data['type'] ?? 'System',
                'message' => $data['message'] ?? '',
                'time' => $data['time'] ?? 'Just now',
            ]);
        }
        if ($resource === 'workflows') {
            $data = array_merge($data, [
                'name' => $data['name'] ?? 'New Workflow',
                'status' => $data['status'] ?? 'Pending',
                'progress' => max(0, min(100, (int) ($data['progress'] ?? 0))),
                'deadline' => $data['deadline'] ?? now()->addWeek()->format('M d, Y'),
                'project_id' => $data['project_id'] ?? '',
                'category' => $data['category'] ?? 'General',
                'assigned' => array_values($data['assigned'] ?? []),
                'tasks' => array_values($data['tasks'] ?? []),
            ]);
        }
        if ($resource === 'tasks') {
            $data = array_merge($data, [
                'title' => $data['title'] ?? 'New Task',
                'due_date' => $data['due_date'] ?? now()->addDays(2)->format('M d, Y'),
                'priority' => $data['priority'] ?? 'Medium',
                'status' => $data['status'] ?? 'Pending',
                'assigned_user' => $data['assigned_user'] ?? 'Unassigned',
                'project_id' => $data['project_id'] ?? '',
                'workflow_id' => $data['workflow_id'] ?? '',
                'category' => $data['category'] ?? 'General',
                'team' => $data['team'] ?? '',
                'notes' => $data['notes'] ?? '',
            ]);
        }
        if ($resource === 'templates') {
            $phases = $data['phases'] ?? [];
            if (empty($phases) && !empty($data['steps']) && is_array($data['steps'])) {
                $phases = [[
                    'id' => 'phase-1',
                    'title' => 'Phase 1',
                    'steps' => array_map(fn ($s, $i) => [
                        'id' => 'step-' . ($i + 1),
                        'title' => is_string($s) ? $s : ('Step ' . ($i + 1)),
                        'type' => 'text',
                        'paragraph' => '',
                        'media' => ['image' => '', 'video' => '', 'audio' => '', 'pdf' => ''],
                        'links' => [],
                    ], $data['steps'], array_keys($data['steps'])),
                ]];
            }
            $data = array_merge($data, [
                'name' => $data['name'] ?? 'New Template',
                'category' => $data['category'] ?? 'General',
                'description' => $data['description'] ?? '',
                'phases' => array_values($phases),
                'steps' => collect($phases)->flatMap(fn ($p) => collect($p['steps'] ?? [])->map(fn ($s) => $s['title'] ?? 'Step'))->values()->all(),
            ]);
        }

        if ($id === null) {
            $data['id'] = $data['id'] ?? uniqid(substr($resource, 0, 2) . '-');
            $collection->push($data);
            $this->saveFor($resource, $collection->all());
            return response()->json($data, 201);
        }

        $updated = $collection->map(function ($row) use ($id, $data) {
            if ((string) ($row['id'] ?? '') === $id) {
                return array_merge($row, $data, ['id' => $id]);
            }
            return $row;
        });

        $this->saveFor($resource, $updated->all());
        return response()->json(['id' => $id]);
    }

    private function mutateUsers(Collection $collection, array $data, ?string $id)
    {
        $role = in_array(($data['role'] ?? 'member'), ['superadmin', 'admin', 'manager', 'member'], true)
            ? $data['role']
            : 'member';
        $status = ($data['status'] ?? 'Active') === 'Inactive' ? 'Inactive' : 'Active';

        if ($id === null) {
            $validatedName = trim((string) ($data['name'] ?? ''));
            $validatedEmail = trim((string) ($data['email'] ?? ''));
            if ($validatedName === '' || $validatedEmail === '') {
                return response()->json(['message' => 'Name and email are required'], 422);
            }
            $tempPassword = (string) ($data['temp_password'] ?? Str::password(10));
            $user = User::query()->updateOrCreate(
                ['email' => $validatedEmail],
                [
                    'name' => $validatedName,
                    'role' => $role,
                    'password' => Hash::make($tempPassword),
                ]
            );
            $entry = [
                'id' => (string) $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'status' => $status,
            ];
            $collection = $collection->reject(fn ($row) => (string) ($row['email'] ?? '') === $user->email)->values();
            $collection->push($entry);
            $this->saveFor('users', $collection->all());

            return response()->json(array_merge($entry, ['temp_password' => $tempPassword]), 201);
        }

        $updated = $collection->map(function ($row) use ($id, $data, $role, $status) {
            if ((string) ($row['id'] ?? '') === $id) {
                return array_merge($row, [
                    'name' => $data['name'] ?? $row['name'],
                    'email' => $data['email'] ?? $row['email'],
                    'role' => $role,
                    'status' => $status,
                ]);
            }
            return $row;
        });
        $this->saveFor('users', $updated->all());
        return response()->json(['id' => $id]);
    }

    private function collectionFor(string $resource): ?Collection
    {
        $key = match ($resource) {
            'users' => 'users',
            'projects' => 'projects',
            'task_categories' => 'task_categories',
            'workflows' => 'workflows',
            'templates' => 'templates',
            'tasks' => 'tasks',
            'notifications' => 'notifications',
            'settings' => 'settings',
            default => null,
        };

        if ($key === null) {
            return null;
        }

        if ($key === 'users') {
            $users = User::query()
                ->orderByDesc('id')
                ->get(['id', 'name', 'email', 'role'])
                ->map(fn (User $user) => [
                    'id' => (string) $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                    'status' => 'Active',
                ]);

            return $users->values();
        }

        $data = collect(cache()->get("admin_data.$key", config("admin_mock.$key", [])));
        return $data;
    }

    private function saveFor(string $resource, array $data): void
    {
        $key = match ($resource) {
            'users' => 'users',
            'projects' => 'projects',
            'task_categories' => 'task_categories',
            'workflows' => 'workflows',
            'templates' => 'templates',
            'tasks' => 'tasks',
            'notifications' => 'notifications',
            default => null,
        };
        if ($key !== null) {
            cache()->put("admin_data.$key", $data);
        }
    }

    private function paginateCollection(Collection $collection, int $perPage, string $pageName): LengthAwarePaginator
    {
        $page = max(1, (int) request()->query($pageName, 1));
        $total = $collection->count();
        $results = $collection->forPage($page, $perPage)->values();

        return new LengthAwarePaginator(
            $results,
            $total,
            $perPage,
            $page,
            [
                'path' => request()->url(),
                'pageName' => $pageName,
                'query' => request()->query(),
            ]
        );
    }

    private function normalizeTemplatePayload(array $template): array
    {
        $phases = $template['phases'] ?? [];
        if (empty($phases) && !empty($template['steps']) && is_array($template['steps'])) {
            $phases = [[
                'id' => 'phase-1',
                'title' => 'Phase 1',
                'steps' => array_values(array_map(function ($step, $index) {
                    return [
                        'id' => 'step-' . ($index + 1),
                        'title' => is_string($step) ? $step : ('Step ' . ($index + 1)),
                        'type' => 'text',
                        'paragraph' => '',
                        'media' => ['image' => '', 'video' => '', 'audio' => '', 'pdf' => ''],
                        'links' => [],
                    ];
                }, $template['steps'], array_keys($template['steps']))),
            ]];
        }

        if (!is_array($phases)) {
            $phases = [];
        }

        $template['phases'] = array_values($phases);
        if (!isset($template['steps']) || !is_array($template['steps'])) {
            $template['steps'] = collect($template['phases'])
                ->flatMap(fn ($p) => collect($p['steps'] ?? [])->map(fn ($s) => $s['title'] ?? 'Step'))
                ->values()
                ->all();
        }

        return $template;
    }

    private function sortNewestFirst(Collection $collection): Collection
    {
        return $collection
            ->values()
            ->sort(function ($a, $b) {
                $aCreated = $this->toComparableTimestamp($a['created_at'] ?? null);
                $bCreated = $this->toComparableTimestamp($b['created_at'] ?? null);
                if ($aCreated !== null || $bCreated !== null) {
                    $aCreated = $aCreated ?? -INF;
                    $bCreated = $bCreated ?? -INF;
                    if ($aCreated === $bCreated) {
                        return strcmp((string) ($b['id'] ?? ''), (string) ($a['id'] ?? ''));
                    }
                    return $bCreated <=> $aCreated;
                }

                $aIdScore = $this->idSortScore($a['id'] ?? null);
                $bIdScore = $this->idSortScore($b['id'] ?? null);
                if ($aIdScore === $bIdScore) {
                    return strcmp((string) ($b['id'] ?? ''), (string) ($a['id'] ?? ''));
                }
                return $bIdScore <=> $aIdScore;
            })
            ->values();
    }

    private function idSortScore(mixed $id): float
    {
        if (!is_string($id) || $id === '') {
            return -INF;
        }
        if (preg_match('/(\d+)\s*$/', $id, $m)) {
            return (float) $m[1];
        }
        return -INF;
    }

    private function toComparableTimestamp(mixed $value): ?float
    {
        if (is_numeric($value)) {
            return (float) $value;
        }
        if (!is_string($value) || trim($value) === '') {
            return null;
        }
        $ts = strtotime($value);
        return $ts === false ? null : (float) $ts;
    }
}
