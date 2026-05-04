<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Services\Admin\AdminMockRepository;

class AdminPanelController extends Controller
{
    public function __construct(private readonly AdminMockRepository $repository)
    {
    }

    public function index(Request $request)
    {
        $section = $request->query('section', 'dashboard');
        $allowedSections = [
            'dashboard',
            'users',
            'projects',
            'categories',
            'workflows',
            'templates',
            'tasks',
            'notifications',
            'reports',
            'settings',
        ];

        if (!in_array($section, $allowedSections, true)) {
            $section = 'dashboard';
        }

        $perPage = 12;

        return view('admin.index', [
            'section' => $section,
            'dashboard' => $this->repository->dashboard(),
            'users' => $this->repository->usersPaginated($perPage),
            'projects' => $this->repository->projectsPaginated($perPage),
            'workflows' => $this->repository->workflowsPaginated($perPage),
            'templates' => $this->repository->templatesPaginated($perPage),
            'tasks' => $this->repository->tasksPaginated($perPage),
            'notifications' => $this->repository->notificationsPaginated($perPage),
            'reports' => $this->repository->reports(),
            'perPage' => $perPage,
            'workflowId' => $request->query('workflow'),
            'templateId' => $request->query('template'),
            'taskId' => $request->query('task'),
            'projectId' => $request->query('project'),
            'selectedProject' => $this->repository->findProject($request->query('project')),
            'selectedWorkflow' => $this->repository->findWorkflow($request->query('workflow')),
            'selectedTemplate' => $this->repository->findTemplate($request->query('template')),
            'selectedTask' => $this->repository->findTask($request->query('task')),
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function templateCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.templates.create', [
            'section' => 'templates',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function templateBuilder(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.templates.builder', [
            'section' => 'templates',
            'perPage' => $perPage,
            'templateId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function userCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.users.create', [
            'section' => 'users',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function userEdit(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.users.edit', [
            'section' => 'users',
            'perPage' => $perPage,
            'userId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function taskCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.tasks.create', [
            'section' => 'tasks',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function taskEdit(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.tasks.edit', [
            'section' => 'tasks',
            'perPage' => $perPage,
            'taskId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function projectCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.projects.create', [
            'section' => 'projects',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function projectEdit(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.projects.edit', [
            'section' => 'projects',
            'perPage' => $perPage,
            'projectId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function categoryCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.categories.create', [
            'section' => 'categories',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function categoryEdit(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.categories.edit', [
            'section' => 'categories',
            'perPage' => $perPage,
            'categoryId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function workflowCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.workflows.create', [
            'section' => 'workflows',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function workflowEdit(string $id, Request $request)
    {
        $perPage = 12;

        return view('admin.workflows.edit', [
            'section' => 'workflows',
            'perPage' => $perPage,
            'workflowId' => $id,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    public function notificationCreate(Request $request)
    {
        $perPage = 12;

        return view('admin.notifications.create', [
            'section' => 'notifications',
            'perPage' => $perPage,
            'apiToken' => $this->ensureApiTokenForSessionUser($request),
            'data' => [],
        ]);
    }

    private function ensureApiTokenForSessionUser(Request $request): ?string
    {
        $existing = $request->session()->get('admin_api_token');
        if ($existing) {
            return $existing;
        }

        $email = $request->session()->get('admin_email');
        if (!$email) {
            return null;
        }

        $user = User::query()->where('email', $email)->first();
        if (!$user) {
            return null;
        }

        $token = $user->createToken('web-admin-panel')->plainTextToken;
        $request->session()->put('admin_api_token', $token);
        return $token;
    }
}
