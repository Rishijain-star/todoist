<aside id="admin-sidebar" class="sidebar">
    <button id="sidebar-close-btn" class="btn" type="button" style="display:none; margin-bottom:10px;">Close</button>
    <div class="brand-wrap">
        <img class="brand-logo" src="{{ asset('images/taskerer_logo.png') }}" alt="Taskerer logo">
        <div class="logo">Taskerer</div>
        <div class="sub">Admin Panel</div>
    </div>
    @php
        $menu = [
            'dashboard' => 'Dashboard',
            'users' => 'Users',
            'projects' => 'Projects',
            'categories' => 'Categories',
            'workflows' => 'Workflows',
            'templates' => 'Templates',
            'tasks' => 'Tasks',
            'notifications' => 'Notifications',
            'reports' => 'Reports',
            'settings' => 'Settings',
        ];
    @endphp
    @foreach ($menu as $key => $label)
        <a class="nav-item {{ $section === $key ? 'active' : '' }}" href="{{ route('admin.panel', ['section' => $key, 'per_page' => $perPage ?? 12]) }}">
            <span>•</span><span>{{ $label }}</span>
        </a>
    @endforeach
</aside>
