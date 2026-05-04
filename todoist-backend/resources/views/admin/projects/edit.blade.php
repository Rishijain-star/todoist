@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Edit Project</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'projects', 'per_page' => $perPage]) }}">Back to Projects</a>
    </div>
    <div class="grid-2">
        <input id="proj-name" class="field" placeholder="Project name">
        <input id="proj-code" class="field" placeholder="Short code">
        <input id="proj-category" class="field" placeholder="Category">
        <textarea id="proj-desc" class="field" rows="3" placeholder="Description"></textarea>
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="proj-save" class="btn primary" type="button">Save Changes</button>
    </div>
    <p id="proj-status" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var id = @json($projectId);
  var statusEl = document.getElementById('proj-status');
  window.AdminApi.getOne('projects', id).then(function (p) {
    document.getElementById('proj-name').value = p.name || '';
    document.getElementById('proj-code').value = p.code || '';
    document.getElementById('proj-category').value = p.category || '';
    document.getElementById('proj-desc').value = p.description || '';
  }).catch(function (e) { statusEl.textContent = e.message; });
  document.getElementById('proj-save').addEventListener('click', function () {
    statusEl.textContent = 'Saving…';
    window.AdminApi.update('projects', id, {
      name: document.getElementById('proj-name').value,
      code: document.getElementById('proj-code').value,
      category: document.getElementById('proj-category').value,
      description: document.getElementById('proj-desc').value
    }).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'projects', 'per_page' => $perPage]) }}";
    }).catch(function (e) { statusEl.textContent = e.message; });
  });
});
</script>
@endsection
