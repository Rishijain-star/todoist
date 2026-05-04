@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create Workflow</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'workflows', 'per_page' => $perPage]) }}">Back to Workflows</a>
    </div>
    <p class="muted">Assign a project and category, then add team members and checklist steps.</p>
    <div class="grid-2">
        <input id="wf-name" class="field" placeholder="Workflow name *">
        <input id="wf-deadline" class="field" placeholder="Deadline (e.g. Apr 25, 2026)">
        <select id="wf-state" class="field">
            <option>Pending</option>
            <option>In Progress</option>
            <option selected>On Track</option>
            <option>Blocked</option>
        </select>
        <input id="wf-progress" class="field" type="number" min="0" max="100" value="0" placeholder="Progress %">
        <select id="wf-project" class="field"><option value="">— Project —</option></select>
        <select id="wf-category" class="field"><option value="">— Category —</option></select>
        <input id="wf-tasks" class="field" placeholder="Step names (comma separated)">
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="wf-save" class="btn primary" type="button">Create Workflow</button>
    </div>
    <p id="wf-msg" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var msgEl = document.getElementById('wf-msg');
  var projSel = document.getElementById('wf-project');
  var catSel = document.getElementById('wf-category');
  window.AdminApi.list('projects', { per_page: 100, projects_page: 1 }).then(function (payload) {
    (payload.data || []).forEach(function (p) {
      var o = document.createElement('option');
      o.value = p.id;
      o.textContent = p.name + ' (' + (p.code || p.id) + ')';
      projSel.appendChild(o);
    });
  });
  window.AdminApi.list('task_categories', { per_page: 100, task_categories_page: 1 }).then(function (payload) {
    (payload.data || []).forEach(function (c) {
      var o = document.createElement('option');
      o.value = c.name;
      o.textContent = c.name;
      catSel.appendChild(o);
    });
  });
  document.getElementById('wf-save').addEventListener('click', function () {
    msgEl.textContent = 'Creating…';
    window.AdminApi.create('workflows', {
      name: document.getElementById('wf-name').value,
      deadline: document.getElementById('wf-deadline').value,
      status: document.getElementById('wf-state').value,
      progress: parseInt(document.getElementById('wf-progress').value || '0', 10),
      project_id: document.getElementById('wf-project').value,
      category: document.getElementById('wf-category').value,
      tasks: document.getElementById('wf-tasks').value.split(',').map(function (s) { return s.trim(); }).filter(Boolean)
    }).then(function (created) {
      window.location.href = "{{ route('admin.workflows.edit', ['id' => '__id__']) }}".replace('__id__', created.id);
    }).catch(function (e) { msgEl.textContent = e.message; });
  });
});
</script>
@endsection
