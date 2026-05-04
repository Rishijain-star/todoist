@extends('errors.layout')

@section('title', 'Server error')

@section('content')
    <div class="code warn">500</div>
    <h1>Something went wrong</h1>
    @if (isset($exception) && config('app.debug'))
        <p class="detail" style="margin-bottom:8px;">Exception details (shown because <code>APP_DEBUG</code> is true):</p>
        <p class="tech">{{ $exception->getMessage() }}</p>
        <p class="tech" style="font-size:11px;">{{ $exception->getFile() }}:{{ $exception->getLine() }}</p>
    @else
        <p class="detail">An unexpected error occurred. Please try again in a moment. If it keeps happening, contact your administrator.</p>
    @endif
@endsection
