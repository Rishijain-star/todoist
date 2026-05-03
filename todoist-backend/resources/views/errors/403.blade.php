@extends('errors.layout')

@section('title', 'Forbidden')

@section('content')
    <div class="code warn">403</div>
    <h1>Access denied</h1>
    <p class="detail">You do not have permission to open this page. Sign in with an admin or superadmin account, or go back to a section you are allowed to use.</p>
    @if (isset($exception) && config('app.debug') && $exception->getMessage())
        <p class="tech">{{ $exception->getMessage() }}</p>
    @endif
@endsection
