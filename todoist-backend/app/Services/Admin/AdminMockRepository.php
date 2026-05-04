<?php

namespace App\Services\Admin;

use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class AdminMockRepository
{
    public function all(): array
    {
        return [
            'users' => $this->collection('users')->all(),
            'projects' => $this->collection('projects')->all(),
            'task_categories' => $this->collection('task_categories')->all(),
            'workflows' => $this->collection('workflows')->all(),
            'templates' => $this->collection('templates')->all(),
            'tasks' => $this->collection('tasks')->all(),
            'notifications' => $this->collection('notifications')->all(),
            'settings' => $this->settings(),
        ];
    }

    public function dashboard(): array
    {
        $users = $this->collection('users');
        $workflows = $this->collection('workflows');
        $tasks = $this->collection('tasks');
        $notifications = $this->collection('notifications');

        $weeklyTasks = $tasks->take(7)->values()->map(function ($task, $index) {
            $days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            return ['label' => $days[$index % 7], 'value' => ($index + 2) * 2];
        })->all();
        if (count($weeklyTasks) < 7) {
            $weeklyTasks = config('admin_mock.weekly_tasks', []);
        }

        $workflowProgress = $workflows->map(fn ($w) => [
            'label' => $w['name'] ?? 'Workflow',
            'value' => (int) ($w['progress'] ?? 0),
        ])->take(6)->values()->all();

        $activity = $notifications->map(fn ($n) => [
            'title' => $n['title'] ?? 'Activity',
            'subtitle' => $n['message'] ?? '',
            'time' => $n['time'] ?? 'now',
        ])->take(6)->values()->all();

        return [
            'kpis' => [
                ['title' => 'Total Users', 'value' => (string) $users->count()],
                ['title' => 'Active Workflows', 'value' => (string) $workflows->whereNotIn('status', ['Done'])->count()],
                ['title' => 'Pending Tasks', 'value' => (string) $tasks->whereIn('status', ['Pending', 'In Progress'])->count()],
                ['title' => 'Overdue Tasks', 'value' => (string) $tasks->where('status', 'Overdue')->count()],
            ],
            'weekly_tasks' => $weeklyTasks,
            'workflow_progress' => $workflowProgress,
            'activity' => $activity,
        ];
    }

    public function usersPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('users')->all(), $perPage, 'users_page');
    }

    public function projectsPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('projects')->all(), $perPage, 'projects_page');
    }

    public function workflowsPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('workflows')->all(), $perPage, 'workflows_page');
    }

    public function templatesPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('templates')->all(), $perPage, 'templates_page');
    }

    public function tasksPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('tasks')->all(), $perPage, 'tasks_page');
    }

    public function notificationsPaginated(int $perPage = 10): LengthAwarePaginator
    {
        return $this->paginate($this->collection('notifications')->all(), $perPage, 'notifications_page');
    }

    public function reports(): array
    {
        $tasks = $this->collection('tasks');
        $completed = $tasks->where('status', 'Done')->count();
        $overdue = $tasks->where('status', 'Overdue')->count();
        $daily = [
            ['label' => 'Mon', 'value' => max(1, $completed)],
            ['label' => 'Tue', 'value' => max(1, $completed + 2)],
            ['label' => 'Wed', 'value' => max(1, $completed + 1)],
            ['label' => 'Thu', 'value' => max(1, $completed + 3)],
            ['label' => 'Fri', 'value' => max(1, $completed + 2)],
        ];
        $monthly = config('admin_mock.monthly_summary', []);
        return [
            'daily_activity' => $daily,
            'monthly_summary' => $monthly,
            'stats' => [
                'completed' => $completed,
                'overdue' => $overdue,
                'active_users' => $this->collection('users')->where('status', 'Active')->count(),
            ],
        ];
    }

    public function findProject(?string $id): ?array
    {
        if (!$id) {
            return null;
        }

        return $this->collection('projects')->firstWhere('id', $id);
    }

    public function findWorkflow(?string $id): ?array
    {
        if (!$id) {
            return null;
        }
        return $this->collection('workflows')->firstWhere('id', $id);
    }

    public function findTemplate(?string $id): ?array
    {
        if (!$id) {
            return null;
        }
        return $this->collection('templates')->firstWhere('id', $id);
    }

    public function findTask(?string $id): ?array
    {
        if (!$id) {
            return null;
        }
        return $this->collection('tasks')->firstWhere('id', $id);
    }

    public function settings(): array
    {
        return cache()->get('admin_data.settings', config('admin_mock.settings', []));
    }

    private function collection(string $key): Collection
    {
        return collect(cache()->get("admin_data.$key", config("admin_mock.$key", [])));
    }

    private function paginate(array $items, int $perPage, string $pageName): LengthAwarePaginator
    {
        $page = max(1, (int) request()->query($pageName, 1));
        $collection = Collection::make($items);
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
}
