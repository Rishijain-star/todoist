@extends('layouts.auth')

@section('content')

<h1 class="auth-title">Welcome back</h1>
<p class="auth-sub">Superadmin &amp; admin access only.</p>

@if (session('status'))
    <div class="alert ok">{{ session('status') }}</div>
@endif
@if ($errors->any())
    <div class="alert error">{{ $errors->first() }}</div>
@endif

<form method="POST" action="{{ route('admin.login.submit') }}">
    @csrf
    <div class="field-group">

        <div class="field-wrap">
            <label class="field-label">Email</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><path d="M20 4H4a2 2 0 00-2 2v12a2 2 0 002 2h16a2 2 0 002-2V6a2 2 0 00-2-2z"/><path d="M22 6l-10 7L2 6"/></svg>
            </span>
            <input class="field" name="email" type="email" placeholder="you@example.com" value="{{ old('email') }}" required>
        </div>

        <div class="field-wrap">
            <label class="field-label">Password</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            </span>
            <input class="field" name="password" type="password" placeholder="••••••••" id="pw-login" required>
            <button type="button" class="eye-btn" onclick="var i=document.getElementById('pw-login');i.type=i.type==='password'?'text':'password'">
                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
        </div>

    </div>

    <button class="btn" type="submit">Sign in</button>
</form>

<div class="auth-footer">
    <a class="link" href="{{ route('admin.forgot-password') }}">Forgot password?</a>
</div>

<div class="divider"><span>info</span></div>
<p class="footnote">Managers &amp; members should use the mobile app.</p>

@endsection