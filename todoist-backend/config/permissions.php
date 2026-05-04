<?php

return [
    'roles' => [
        'superadmin' => ['*'],
        'admin' => [
            'dashboard.read',
            'users.*',
            'projects.*',
            'task_categories.*',
            'workflows.*',
            'templates.*',
            'tasks.*',
            'notifications.*',
            'reports.*',
            'settings.*',
        ],
        'manager' => [
            'dashboard.read',
            'users.read',
            'users.create',
            'users.update',
            'projects.*',
            'task_categories.read',
            'workflows.*',
            'templates.*',
            'tasks.*',
            'notifications.read',
            'reports.read',
            'settings.read',
        ],
        'member' => [
            'dashboard.read',
            'users.read',
            'workflows.read',
            'templates.read',
            'tasks.read',
            'tasks.update',
            'notifications.read',
            'reports.read',
        ],
    ],
];
