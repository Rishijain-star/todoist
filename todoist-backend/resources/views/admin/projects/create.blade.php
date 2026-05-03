@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Add Project</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'projects', 'per_page' => $perPage]) }}">Back to Projects</a>
    </div>
    <div class="grid-2">
        <input id="proj-name" class="field" placeholder="Project name *" required>
        <input id="proj-code" class="field" placeholder="Short code (e.g. GH)">
        <input id="proj-category" class="field" placeholder="Category (e.g. Residential, Commercial)">
        <textarea id="proj-desc" class="field" rows="3" placeholder="Description"></textarea>
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="proj-save" class="btn primary" type="button">Create Project</button>
    </div>
    <p id="proj-status" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var statusEl = document.getElementById('proj-status');
  document.getElementById('proj-save').addEventListener('click', function () {
    statusEl.textContent = 'Saving…';
    window.AdminApi.create('projects', {
      name: document.getElementById('proj-name').value,
      code: document.getElementById('proj-code').value,
      category: document.getElementById('proj-category').value,
      description: document.getElementById('proj-desc').value
    }).then(function () {
      statusEl.textContent = 'Created.';
      window.location.href = "{{ route('admin.panel', ['section' => 'projects', 'per_page' => $perPage]) }}";
    }).catch(function (e) { statusEl.textContent = e.message; });
  });
});
</script>
@endsection
