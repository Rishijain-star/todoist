<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $title ?? 'Admin Auth' }}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        html, body {
            height: 100%;
            font-family: 'Inter', system-ui, sans-serif;
        }

        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: #C9D8F0;
            background-image:
                radial-gradient(ellipse at 20% 50%, rgba(99,91,255,.18) 0%, transparent 55%),
                radial-gradient(ellipse at 80% 20%, rgba(42,159,251,.15) 0%, transparent 50%),
                radial-gradient(ellipse at 60% 90%, rgba(76,69,184,.12) 0%, transparent 45%);
            padding: 32px 20px;
        }

        /* ── SHELL: single centered column ── */
        .auth-shell {
            width: 100%;
            max-width: min(640px, 92vw);
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* ── Brand inside card (centered) ── */
        .auth-brand-inline {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 28px;
        }

        .auth-brand-inline .brand-logo-wrap {
            width: min(220px, 100%);
            min-height: 72px;
            max-height: 100px;
            padding: 8px 12px;
            border-radius: 16px;
            overflow: hidden;
            background: #fff;
            border: 1px solid #edf0f8;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            box-shadow: 0 8px 22px rgba(20,18,80,.08);
        }
        .auth-brand-inline .brand-logo-wrap img {
            max-width: 100%;
            max-height: 84px;
            width: auto;
            height: auto;
            object-fit: contain;
        }
        .auth-brand-inline .brand-logo-wrap svg { width: 40px; height: 40px; }

        .auth-brand-inline h1 {
            font-size: 28px;
            font-weight: 800;
            color: #12163a;
            letter-spacing: -.6px;
            line-height: 1.15;
            margin-bottom: 6px;
        }
        .auth-brand-inline p {
            font-size: 14px;
            color: #6878a8;
            font-weight: 500;
        }

        /* ── CARD ── */
        .auth-card {
            background: #fff;
            border-radius: 28px;
            padding: 44px 40px;
            width: 100%;
            box-shadow:
                0 0 0 1px rgba(180,190,220,.35),
                0 24px 64px rgba(20,18,80,.13),
                0 4px 16px rgba(20,18,80,.07);
        }

        .auth-title {
            font-size: 30px;
            font-weight: 800;
            color: #12163a;
            letter-spacing: -.6px;
            margin-bottom: 6px;
        }
        .auth-sub {
            font-size: 14px;
            color: #8c97bc;
            line-height: 1.55;
            margin-bottom: 32px;
        }

        /* Alerts */
        .alert {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 13.5px;
            font-weight: 500;
            margin-bottom: 20px;
            line-height: 1.4;
        }
        .ok    { background: #f0faf4; color: #176638; border: 1px solid #c3e8d0; }
        .error { background: #fff3f3; color: #be2323; border: 1px solid #ffd6d6; }

        /* Field groups */
        .field-group { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; }

        .field-wrap {
            position: relative;
        }
        .field-label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #8c97bc;
            letter-spacing: .04em;
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        .f-icon {
            position: absolute;
            left: 15px;
            bottom: 13px;
            pointer-events: none;
            display: flex;
        }
        .f-icon svg {
            width: 16px; height: 16px;
            stroke: #b8c0d8; fill: none; stroke-width: 1.8;
        }

        .field {
            width: 100%;
            height: 50px;
            padding: 0 48px 0 44px;
            font-size: 14.5px;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            background: #f5f6fc;
            border: 1.5px solid #e8ebf7;
            border-radius: 14px;
            color: #12163a;
            outline: none;
            transition: border-color .18s, background .18s, box-shadow .18s;
            margin-bottom: 0;
        }
        .field:hover  { border-color: #cdd2f0; background: #f3f4fb; }
        .field:focus  { border-color: #6C63FF; background: #fff; box-shadow: 0 0 0 4px rgba(108,99,255,.10); }
        .field::placeholder { color: #c4cbdf; font-weight: 400; }

        .eye-btn {
            position: absolute;
            right: 15px; bottom: 14px;
            background: none; border: none;
            cursor: pointer; padding: 0;
            display: flex; opacity: .35;
            transition: opacity .15s;
        }
        .eye-btn:hover { opacity: .7; }
        .eye-btn svg { width: 16px; height: 16px; stroke: #3a3d5c; fill: none; stroke-width: 1.8; }

        /* Submit button */
        .btn {
            width: 100%;
            height: 52px;
            background: linear-gradient(135deg, #4538C8 0%, #7B73FF 100%);
            color: #fff;
            border: none;
            border-radius: 14px;
            font-size: 15.5px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            letter-spacing: .01em;
            cursor: pointer;
            box-shadow: 0 10px 28px rgba(69,56,200,.32);
            transition: transform .12s, box-shadow .12s, opacity .12s;
            margin-top: 4px;
        }
        .btn:hover  { transform: translateY(-1px); box-shadow: 0 14px 32px rgba(69,56,200,.38); }
        .btn:active { transform: translateY(0); box-shadow: 0 6px 16px rgba(69,56,200,.28); }

        .btn.loading {
            pointer-events: none;
            opacity: 0.8;
            color: transparent !important;
            position: relative;
        }
        .btn.loading::after {
            content: "";
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin: -10px 0 0 -10px;
            border: 3px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 0.8s linear infinite;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Footer links */
        .auth-footer {
            display: flex;
            justify-content: center;
            margin-top: 18px;
        }
        .link {
            font-size: 14px;
            font-weight: 600;
            color: #5A52E0;
            text-decoration: none;
            transition: color .15s;
        }
        .link:hover { color: #7B73FF; }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #edf0f8;
        }
        .divider span {
            font-size: 11.5px;
            color: #c4cbdf;
            font-weight: 500;
            white-space: nowrap;
        }

        .footnote {
            font-size: 12.5px;
            color: #c4cbdf;
            text-align: center;
            line-height: 1.6;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 860px) {
            body { padding: 20px 16px; background-image: none; background-color: #C9D8F0; }
            .auth-card { padding: 32px 26px; border-radius: 22px; }
            .auth-title { font-size: 26px; }
        }
    </style>
</head>
<body>
    <div class="auth-shell">
        <div class="auth-card">
            <div class="auth-brand-inline">
                <div class="brand-logo-wrap">
                    @php $logoPath = public_path('images/taskerer_logo.png'); @endphp
                    @if(file_exists($logoPath))
                        <img src="{{ asset('images/taskerer_logo.png') }}" alt="Taskerer">
                    @else
                        <svg viewBox="0 0 32 32" fill="none">
                            <polygon points="16,3 2,10 16,17 30,10" fill="white"/>
                            <polyline points="2,17 16,24 30,17" stroke="white" stroke-width="2.2" stroke-linejoin="round" fill="none" opacity=".68"/>
                            <polyline points="2,23 16,30 30,23" stroke="white" stroke-width="2.2" stroke-linejoin="round" fill="none" opacity=".35"/>
                        </svg>
                    @endif
                </div>
                <h1>Taskerer</h1>
                <p>Plan It. Track It. Finish It.</p>
            </div>
            @yield('content')
        </div>
    </div>
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
            btn.addEventListener('click', function() {
                if (this.getAttribute('type') === 'submit') return;
                this.classList.add('loading');
            });
        });
    </script>
</body>
</html>