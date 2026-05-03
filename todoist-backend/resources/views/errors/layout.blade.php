<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield('title', 'Error') · Taskerer</title>
    <style>
        :root {
            --primary:#1867E9;
            --accent:#2A9FFB;
            --text:#0C1A3A;
            --muted:#64748B;
            --border:#E2E8F4;
            --surface:#fff;
            --danger:#F13427;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Nunito, "Segoe UI", system-ui, sans-serif;
            background: linear-gradient(145deg, #F5F8FF 0%, #EEF3FC 45%, #E8EEF9 100%);
            padding: 24px 16px;
        }
        .shell { width: 100%; max-width: min(440px, 100%); }
        .box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 32px 28px;
            text-align: center;
            box-shadow: 0 16px 40px rgba(12, 26, 58, .1);
        }
        .logo {
            width: 72px;
            height: auto;
            margin: 0 auto 18px;
            border-radius: 14px;
            display: block;
            border: 1px solid var(--border);
            padding: 6px;
            background: #fff;
        }
        .code {
            font-size: 48px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: -2px;
            line-height: 1;
            margin-bottom: 10px;
        }
        .code.warn { color: var(--danger); }
        h1 {
            font-size: 20px;
            font-weight: 800;
            margin: 0 0 10px;
            color: var(--text);
        }
        p.detail {
            color: var(--muted);
            margin: 0 0 20px;
            line-height: 1.55;
            font-size: 15px;
        }
        p.tech {
            font-size: 12px;
            color: #94a3b8;
            text-align: left;
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 10px 12px;
            margin: 0 0 16px;
            word-break: break-word;
            max-height: 120px;
            overflow: auto;
        }
        .actions { display: flex; flex-direction: column; gap: 10px; align-items: center; }
        a.btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 200px;
            padding: 12px 20px;
            border-radius: 12px;
            background: linear-gradient(90deg, var(--primary), var(--accent));
            color: #fff !important;
            font-weight: 700;
            text-decoration: none;
            font-size: 15px;
        }
        a.sub {
            color: var(--primary);
            font-weight: 700;
            text-decoration: none;
            font-size: 14px;
        }
        a.sub:hover { text-decoration: underline; }

        .btn.loading {
            pointer-events: none;
            opacity: 0.8;
            color: transparent !important;
            position: relative;
        }
        .btn.loading::after {
            content: "";
            position: absolute;
            width: 18px;
            height: 18px;
            top: 50%;
            left: 50%;
            margin: -9px 0 0 -9px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="shell">
        <div class="box">
            @php $logoPath = public_path('images/taskerer_logo.png'); @endphp
            @if(file_exists($logoPath))
                <img src="{{ asset('images/taskerer_logo.png') }}" class="logo" alt="Taskerer">
            @else
                <div class="logo">
                    <svg viewBox="0 0 32 32" fill="none">
                        <polygon points="16,3 2,10 16,17 30,10" fill="#1867E9"/>
                        <polyline points="2,17 16,24 30,17" stroke="#1867E9" stroke-width="2.2" stroke-linejoin="round" fill="none" opacity=".68"/>
                    </svg>
                </div>
            @endif
            @yield('content')
            <div class="actions">
                <a href="{{ url('/admin') }}" class="btn show-loading">Go to admin</a>
                <a href="{{ url('/admin/login') }}" class="sub show-loading">← Login</a>
            </div>
        </div>
    </div>
    <script>
        document.querySelectorAll('.show-loading').forEach(btn => {
            btn.addEventListener('click', function() {
                this.classList.add('loading');
            });
        });
    </script>
</body>
</html>
