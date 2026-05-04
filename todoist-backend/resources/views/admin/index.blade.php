@extends('layouts.admin')

@section('content')
    @includeIf('admin.sections.' . $section)
@endsection
