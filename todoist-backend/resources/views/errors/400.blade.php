@extends('errors.layout')

@section('title', 'Bad request')

@section('content')
    <div class="code warn">400</div>
    <h1>Bad request</h1>
    <p class="detail">The server could not understand this request. Often this is a broken link, invalid form data, or a malformed URL.</p>
    @if (isset($exception) && config('app.debug') && $exception->getMessage())
        <p class="tech">{{ $exception->getMessage() }}</p>
    @endif
@endsection
