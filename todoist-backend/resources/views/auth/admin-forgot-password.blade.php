@extends('layouts.auth')

@section('content')

<h1 class="auth-title">Reset password</h1>
<p class="auth-sub">Enter your email address and we'll send you a link to reset your password.</p>

@if (session('status'))
    <div class="alert ok">{{ session('status') }}</div>
@endif
@if ($errors->any())
    <div class="alert error">{{ $errors->first() }}</div>
@endif

<form method="POST" action="{{ route('admin.forgot-password.submit') }}">
    @csrf
    <div class="field-group">

        <div class="field-wrap">
            <label class="field-label">Email address</label>
            <span class="f-icon">
                <svg viewBox="0 0 24 24"><path d="M20 4H4a2 2 0 00-2 2v12a2 2 0 002 2h16a2 2 0 002-2V6a2 2 0 00-2-2z"/><path d="M22 6l-10 7L2 6"/></svg>
            </span>
            <input class="field" name="email" type="email" placeholder="you@example.com" required>
        </div>

    </div>

    <button class="btn" type="submit">Send reset link</button>
</form>

<div class="auth-footer">
    <a class="link" href="{{ route('admin.login') }}">← Back to login</a>
</div>

@endsection