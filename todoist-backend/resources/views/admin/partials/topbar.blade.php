@php
  $email = session('admin_email', 'Admin');
  $isPanel = request()->routeIs('admin.panel');
  $activeSection = $isPanel ? (string) request()->query('section', 'dashboard') : null;
  $perPageValue = (int) request()->query('per_page', $perPage ?? 12);
  if ($perPageValue < 1) { $perPageValue = 12; }
@endphp

<div class="topbar">
  <div class="topbar-left">
    <button id="sidebar-open-btn" class="btn icon" type="button" style="display:none;">☰</button>
   
  </div>

  <div class="topbar-right">
    

    <button id="theme-toggle-btn" class="btn" type="button">Dark</button>
   

    <div class="topbar-profile" title="{{ $email }}">
      <strong>{{ $email }}</strong>
      <span class="muted">▾</span>
    </div>

    <a class="btn" href="{{ route('admin.change-password') }}">Change Password</a>
    <form method="POST" action="{{ route('admin.logout') }}">
      @csrf
      <button class="btn" type="submit">Logout</button>
    </form>
  </div>
</div>
