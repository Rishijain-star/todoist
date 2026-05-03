@extends('layouts.auth')

@section('content')

<h1 class="auth-title">Change password</h1>
<p class="auth-sub">Keep your account secure with a strong, unique password.</p>

@if (session('status'))
    <div class="alert ok">{{ session('status') }}</div>
@endif
@if ($errors->any())
    <div class="alert error">{{ $errors->first() }}</div>
@endif

<form method="POST" action="{{ route('admin.change-password.submit') }}">
    @csrf
    <div class="field-group">

        <div class="field-wrap">
            <label class="field-label">Current password</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            </span>
            <input class="field" name="current_password" type="password" placeholder="••••••••" id="pw1" required>
            <button type="button" class="eye-btn" onclick="var i=document.getElementById('pw1');i.type=i.type==='password'?'text':'password'">
                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
        </div>

        <div class="field-wrap">
            <label class="field-label">New password</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            </span>
            <input class="field" name="new_password" type="password" placeholder="••••••••" id="pw2" required>
            <button type="button" class="eye-btn" onclick="var i=document.getElementById('pw2');i.type=i.type==='password'?'text':'password'">
                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
        </div>

        <div class="field-wrap">
            <label class="field-label">Confirm new password</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
            </span>
            <input class="field" name="new_password_confirmation" type="password" placeholder="••••••••" id="pw3" required>
            <button type="button" class="eye-btn" onclick="var i=document.getElementById('pw3');i.type=i.type==='password'?'text':'password'">
                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
        </div>

    </div>

    <button class="btn" type="submit">Update password</button>
</form>

<div class="auth-footer">
    <a class="link" href="{{ route('admin.panel') }}">← Back to panel</a>
</div>

@endsection