@extends('errors.layout')

@section('title', 'Session expired')

@section('content')
    <div class="code">419</div>
    <h1>Page expired</h1>
    <p class="detail">Your session token is missing or out of date. Refresh the page or sign in again, then retry.</p>
@endsection
