@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Edit category</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'categories', 'per_page' => $perPage]) }}">Back to Categories</a>
    </div>
    <p class="muted">Updating the name changes the label in dropdowns for new selections. Existing tasks keep the text they already had.</p>
    <input id="cat-name" class="field" placeholder="Category name" maxlength="120">
    <div class="row" style="justify-content:flex-end;">
        <button id="cat-save" class="btn primary" type="button">Save</button>
    </div>
    <p id="cat-msg" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var id = @json($categoryId);
  var msg = document.getElementById('cat-msg');
  window.AdminApi.getOne('task_categories', id).then(function (row) {
    document.getElementById('cat-name').value = row.name || '';
  }).catch(function (e) { msg.textContent = e.message; });
  document.getElementById('cat-save').addEventListener('click', function () {
    var name = document.getElementById('cat-name').value.trim();
    if (!name) {
      msg.textContent = 'Enter a category name.';
      return;
    }
    msg.textContent = 'Saving…';
    window.AdminApi.update('task_categories', id, { name: name }).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'categories', 'per_page' => $perPage]) }}";
    }).catch(function (e) { msg.textContent = e.message; });
  });
});
</script>
@endsection
