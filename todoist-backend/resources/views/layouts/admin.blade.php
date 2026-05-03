<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="admin-api-token" content="{{ $apiToken }}">
    <title>{{ $title ?? 'Admin Panel' }}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simple-datatables@9.0.3/dist/style.min.css">
    <style>
        :root {
            --primary:#1867E9;
            --accent:#2A9FFB;
            --bg:#F0F4FA;
            --surface:#FFFFFF;
            --surface-alt:#F6F9FF;
            --border:#E2E8F4;
            --text:#0C1A3A;
            --muted:#64748B;
            --success:#43A047;
            --warn:#F9A800;
            --danger:#F13427;
            --input-bg:#F8FAFD;
            --radius:16px;
            --shadow:0 4px 18px rgba(12,26,58,.06);
        }
        html[data-theme="dark"] {
            --primary:#1867E9;
            --accent:#2A9FFB;
            --bg:#0E1421;
            --surface:#171E2D;
            --surface-alt:#111827;
            --border:#2A3348;
            --text:#EAF0FF;
            --muted:#9AA7C1;
            --success:#43A047;
            --warn:#F9A800;
            --danger:#F13427;
            --input-bg:#141C2B;
            --shadow:none;
        }
        * { box-sizing: border-box; }
        body { margin:0; font-family: Nunito, "Segoe UI", sans-serif; background:var(--bg); color:var(--text); transition: background-color .2s ease, color .2s ease; }
        #page-progress { position: fixed; top: 0; left: 0; height: 3px; width: 0; z-index: 9999; background: linear-gradient(90deg, var(--primary), var(--accent)); transition: width .24s ease; }
        #page-progress.active { width: 85%; }
        #page-progress.done { width: 100%; }
        .layout { display:flex; min-height:100vh; gap:16px; padding:16px; }
        #sidebar-backdrop {
            position: fixed; inset: 0; background: rgba(12, 26, 58, .35); z-index: 998; display: none;
        }
        #sidebar-backdrop.show { display: block; }
        .sidebar { width:250px; background:var(--surface); border:1px solid var(--border); border-radius:20px; padding:14px 12px; box-shadow:var(--shadow); }
        .brand-wrap { display:grid; justify-items:start; margin-bottom:12px; }
        .brand-logo {
            width: 100%;
            max-width: 160px;
            height: auto;
            object-fit: contain;
            border-radius: 12px; border:1px solid var(--border); margin-bottom:8px;
            background: var(--surface-alt);
            padding: 6px;
        }
        .logo { font-size:34px; line-height:1; font-weight:800; letter-spacing:.2px; }
        .sub { color:var(--muted); font-size:12px; margin-bottom:12px; }
        .nav-item { display:flex; gap:10px; align-items:center; text-decoration:none; color:var(--text); padding:10px 12px; border-radius:12px; font-weight:700; margin-bottom:6px; }
        .nav-item.active { color:var(--primary); background:rgba(24,103,233,.10); }
        .main { flex:1; display:flex; flex-direction:column; gap:16px; min-width:0; }
        .topbar { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius); padding:12px 16px; display:flex; align-items:center; justify-content:space-between; gap:12px; box-shadow:var(--shadow); }
        .topbar-left { display:flex; align-items:center; gap:10px; flex: 1; min-width: 0; }
        .topbar-right { display:flex; align-items:center; gap:10px; flex-wrap: wrap; justify-content:flex-end; }
        .topbar-inline { margin:0; }
        .topbar-profile { display:inline-flex; align-items:center; gap:8px; padding:8px 10px; border:1px solid var(--border); border-radius:10px; background:var(--surface); max-width: 320px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .topbar-right > * { flex: 0 0 auto; }
        .btn.icon { width: 40px; padding: 0; }
        .search { flex:1; min-width: 220px; border:1px solid var(--border); border-radius:12px; padding:10px 12px; color:var(--muted); background:var(--input-bg); }
        .field.compact { width:auto; min-width: 110px; margin-bottom:0; padding:8px 10px; }
        .content { display:grid; gap:12px; }
        .card { background:var(--surface); border:1px solid var(--border); border-radius:var(--radius); padding:16px; box-shadow:var(--shadow); }
        .row { display:flex; align-items:center; justify-content:space-between; gap:8px; margin-bottom:10px; }
        .muted { color:var(--muted); }
        .btn { text-decoration:none; display:inline-flex; align-items:center; justify-content:center; border:1px solid var(--border); border-radius:10px; padding:8px 12px; color:var(--text); font-weight:700; background:var(--surface); cursor:pointer; min-height:36px; }
        .btn.primary { border:none; color:#fff; background:linear-gradient(90deg, var(--primary), var(--accent)); }
        .btn.danger { border:none; color:#fff; background:linear-gradient(90deg, #dc3545, #f45a6a); }
        .field { width:100%; border:1px solid var(--border); border-radius:10px; padding:10px; margin-bottom:8px; background:var(--input-bg); color:var(--text); }
        .chip { border-radius:999px; padding:4px 10px; font-size:12px; font-weight:700; display:inline-block; }
        .chip.success { color:var(--success); background:rgba(67,160,71,.14); }
        .chip.warn { color:var(--warn); background:rgba(249,168,0,.15); }
        .chip.danger { color:var(--danger); background:rgba(241,52,39,.14); }
        .chip.primary { color:var(--primary); background:rgba(24,103,233,.14); }
        table { width:100%; border-collapse:collapse; }
        th, td { text-align:left; border-bottom:1px solid var(--border); padding:10px 6px; font-size:14px; }
        th { color:var(--muted); font-size:12px; text-transform:uppercase; letter-spacing:.6px; }
        .kpi-grid { display:grid; grid-template-columns:repeat(4, minmax(120px,1fr)); gap:12px; }
        .kpi-title { color:var(--muted); font-size:13px; } .kpi-value { font-size:28px; font-weight:800; }
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:12px; } .grid-3 { display:grid; grid-template-columns:repeat(3, 1fr); gap:12px; }
        .progress { background:color-mix(in srgb, var(--primary) 14%, var(--surface)); border-radius:999px; height:8px; overflow:hidden; } .progress > span { display:block; height:100%; background:linear-gradient(90deg, var(--primary), var(--accent)); }
        .bar-wrap { display:flex; align-items:end; justify-content:space-between; height:160px; gap:8px; margin-top:12px; }
        .bar-item { flex:1; text-align:center; } .bar { margin:auto; width:18px; border-radius:8px; background:linear-gradient(180deg,var(--accent),var(--primary)); } .bar-label { margin-top:8px; color:var(--muted); font-size:12px; font-weight:700; }
        .pagination { display:flex; justify-content:flex-end; width:100%; gap:8px; margin-top:12px; }
        .pagination a, .pagination span { border:1px solid var(--border); border-radius:8px; padding:6px 10px; text-decoration:none; color:var(--text); font-size:12px; font-weight:700; background:var(--surface); }
        .pagination .active { background:rgba(24,103,233,.10); color:var(--primary); border-color:rgba(24,103,233,.35); }
        .skeleton { position: relative; overflow: hidden; border-radius: 10px; background: var(--surface-alt); }
        .skeleton::after {
            content: ""; position: absolute; inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,.7), transparent);
            transform: translateX(-100%); animation: shimmer 1.1s infinite;
        }
        @keyframes shimmer { 100% { transform: translateX(100%); } }
        .skeleton-line { height: 14px; margin-bottom: 8px; }
        .skeleton-row { height: 42px; margin-bottom: 8px; }
        .datatable-wrapper .datatable-top, .datatable-wrapper .datatable-bottom { padding: 8px 0; }
        .datatable-wrapper .datatable-dropdown label { color: var(--muted); }
        .datatable-wrapper .datatable-input {
            border:1px solid var(--border); border-radius:8px; padding:8px;
            background:var(--input-bg); color:var(--text);
        }
        .datatable-wrapper .datatable-pagination { justify-content:flex-end; }
        .datatable-wrapper .datatable-pagination ul { justify-content:flex-end; width:100%; }
        @media (max-width:1100px){ .kpi-grid,.grid-2,.grid-3{grid-template-columns:1fr 1fr;} }
        @media (max-width:860px){
            .layout{padding:10px;}
            .sidebar{
                display:block; position: fixed; left: -270px; top: 10px; bottom: 10px; z-index: 999; width: 250px;
                transition: left .2s ease;
            }
            .sidebar.open { left: 10px; }
            #sidebar-open-btn, #sidebar-close-btn { display: inline-flex !important; }
            .kpi-grid,.grid-2,.grid-3{grid-template-columns:1fr;}
            .topbar { gap: 10px; flex-wrap: wrap; }
            .topbar-left { width: 100%; }
            .topbar-right { width: 100%; justify-content: flex-start; }
            .topbar .search { width: 100%; min-width: 0; }
        }
        .btn.loading {
            pointer-events: none;
            opacity: 0.8;
            color: transparent !important;
            position: relative;
        }
        .btn.loading::after {
            content: "";
            position: absolute;
            width: 16px;
            height: 16px;
            top: 50%;
            left: 50%;
            margin: -8px 0 0 -8px;
            border: 2px solid rgba(0,0,0,0.1);
            border-radius: 50%;
            border-top-color: var(--primary);
            animation: spin 0.8s linear infinite;
        }
        .btn.primary.loading::after {
            border-color: rgba(255,255,255,0.3);
            border-top-color: #fff;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div id="page-progress"></div>
<div id="sidebar-backdrop"></div>
<div class="layout">
    @include('admin.partials.sidebar', ['section' => $section])
    <main class="main">
        @include('admin.partials.topbar')
        <section class="content">@yield('content')</section>
    </main>
</div>
<script src="{{ asset('js/admin-components.js') }}" defer></script>
<script src="{{ asset('js/admin-api.js') }}" defer></script>
<script src="{{ asset('js/admin-pages.js') }}" defer></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@9.0.3" defer></script>
<script>
  (function () {
    var storedTheme = localStorage.getItem('admin_theme');
    var preferredDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    var nextTheme = storedTheme || (preferredDark ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', nextTheme);

    if (window.__adminProgressInit) return;
    window.__adminProgressInit = true;
    var progress = document.getElementById('page-progress');
    var startedAt = 0;
    function start() {
      var now = Date.now();
      if (now - startedAt < 180) return;
      startedAt = now;
      progress.classList.remove('done');
      progress.classList.add('active');
      progress.style.width = '70%';
    }
    function done() {
      progress.classList.add('done');
      progress.style.width = '100%';
      setTimeout(function () {
        progress.classList.remove('active', 'done');
        progress.style.width = '0';
      }, 250);
    }
    window.addEventListener('load', done);
    document.addEventListener('click', function (event) {
      var link = event.target.closest('a[href]');
      if (!link) return;
      var href = link.getAttribute('href');
      if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;
      if (link.target === '_blank') return;
      start();
    });
    document.addEventListener('submit', function () { start(); });
    window.AdminPageProgress = { start: start, done: done };

    var openBtn = document.getElementById('sidebar-open-btn');
    var closeBtn = document.getElementById('sidebar-close-btn');
    var themeBtn = document.getElementById('theme-toggle-btn');
    var sidebar = document.getElementById('admin-sidebar');
    var backdrop = document.getElementById('sidebar-backdrop');
    if (openBtn && closeBtn && sidebar && backdrop) {
      function openSidebar() { sidebar.classList.add('open'); backdrop.classList.add('show'); }
      function closeSidebar() { sidebar.classList.remove('open'); backdrop.classList.remove('show'); }
      openBtn.addEventListener('click', openSidebar);
      closeBtn.addEventListener('click', closeSidebar);
      backdrop.addEventListener('click', closeSidebar);
    }
    if (themeBtn) {
      function syncThemeLabel() {
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        themeBtn.textContent = isDark ? 'Light' : 'Dark';
      }
      syncThemeLabel();
      themeBtn.addEventListener('click', function () {
        var current = document.documentElement.getAttribute('data-theme') || 'light';
        var updated = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', updated);
        localStorage.setItem('admin_theme', updated);
        syncThemeLabel();
      });
    }
  })();
</script>
    <script>
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
                const btn = this.querySelector('button[type="submit"]');
                if (btn) {
                    btn.classList.add('loading');
                }
            });
        });

        // Add loading state to all buttons and links with .btn class when clicked
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                // Don't add loading if it's a form submit button (handled by form submit)
                if (this.getAttribute('type') === 'submit') return;
                
                // Add loading class
                this.classList.add('loading');
                
                // If it's a link, the navigation will happen anyway
                // If it's a button, it will just show loading
            });
        });
    </script>
</body>
</html>
