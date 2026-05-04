@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create category</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'categories', 'per_page' => $perPage]) }}">Back to Categories</a>
    </div>
    <p class="muted">Choose a clear label. It will show in task and workflow dropdowns.</p>
    <input id="cat-name" class="field" placeholder="Category name (e.g. Compliance)" maxlength="120">
    <div class="row" style="justify-content:flex-end;">
        <button id="cat-save" class="btn primary" type="button">Create</button>
    </div>
    <p id="cat-msg" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var msg = document.getElementById('cat-msg');
  document.getElementById('cat-save').addEventListener('click', function () {
    var name = document.getElementById('cat-name').value.trim();
    if (!name) {
      msg.textContent = 'Enter a category name.';
      return;
    }
    msg.textContent = 'Saving…';
    window.AdminApi.create('task_categories', { name: name }).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'categories', 'per_page' => $perPage]) }}";
    }).catch(function (e) { msg.textContent = e.message; });
  });
});
</script>
@endsection
