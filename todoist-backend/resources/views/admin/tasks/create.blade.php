@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create Task</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'tasks', 'per_page' => $perPage]) }}">Back to Tasks</a>
    </div>
    <p class="muted">Link the task to a project and workflow, pick a category, and assign someone on your team.</p>
    <div class="grid-2">
        <input id="task-title" class="field" placeholder="Title *">
        <input id="task-due" class="field" placeholder="Due date (e.g. Apr 20, 2026)">
        <select id="task-priority" class="field"><option>Low</option><option selected>Medium</option><option>High</option></select>
        <select id="task-status" class="field"><option selected>Pending</option><option>In Progress</option><option>Done</option><option>Overdue</option></select>
        <select id="task-project" class="field"><option value="">— Project —</option></select>
        <select id="task-workflow" class="field"><option value="">— Workflow (optional) —</option></select>
        <select id="task-category" class="field"><option value="">— Category —</option></select>
        <input id="task-team" class="field" placeholder="Team / squad (e.g. Field Ops)">
        <select id="task-assigned" class="field"><option value="">— Assign to —</option></select>
        <textarea id="task-notes" class="field" rows="3" placeholder="Notes"></textarea>
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="task-create-btn" class="btn primary" type="button">Create Task</button>
    </div>
    <p id="task-create-status" class="muted"></p>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var statusEl = document.getElementById('task-create-status');
  Promise.all([
    window.AdminApi.list('projects', { per_page: 100, projects_page: 1 }),
    window.AdminApi.list('workflows', { per_page: 100, workflows_page: 1 }),
    window.AdminApi.list('task_categories', { per_page: 100, task_categories_page: 1 }),
    window.AdminApi.list('users', { per_page: 100, users_page: 1 })
  ]).then(function (results) {
    (results[0].data || []).forEach(function (p) {
      var o = document.createElement('option');
      o.value = p.id;
      o.textContent = p.name;
      document.getElementById('task-project').appendChild(o);
    });
    (results[1].data || []).forEach(function (w) {
      var o = document.createElement('option');
      o.value = w.id;
      o.textContent = w.name;
      document.getElementById('task-workflow').appendChild(o);
    });
    (results[2].data || []).forEach(function (c) {
      var o = document.createElement('option');
      o.value = c.name;
      o.textContent = c.name;
      document.getElementById('task-category').appendChild(o);
    });
    (results[3].data || []).filter(function (u) {
      return u.role === 'manager' || u.role === 'member';
    }).forEach(function (u) {
      var o = document.createElement('option');
      o.value = u.name;
      o.textContent = u.name + ' (' + u.role + ')';
      document.getElementById('task-assigned').appendChild(o);
    });
  }).catch(function (e) { statusEl.textContent = e.message; });

  document.getElementById('task-create-btn').addEventListener('click', function () {
    var btn = document.getElementById('task-create-btn');
    btn.disabled = true;
    statusEl.textContent = 'Creating task...';
    window.AdminApi.create('tasks', {
      title: document.getElementById('task-title').value,
      due_date: document.getElementById('task-due').value,
      priority: document.getElementById('task-priority').value,
      status: document.getElementById('task-status').value,
      project_id: document.getElementById('task-project').value,
      workflow_id: document.getElementById('task-workflow').value,
      category: document.getElementById('task-category').value,
      team: document.getElementById('task-team').value,
      assigned_user: document.getElementById('task-assigned').value || 'Unassigned',
      notes: document.getElementById('task-notes').value
    }).then(function () {
      statusEl.textContent = 'Task created.';
      window.location.href = "{{ route('admin.panel', ['section' => 'tasks', 'per_page' => $perPage]) }}";
    }).catch(function (error) {
      statusEl.textContent = 'Create failed: ' + error.message;
    }).finally(function () {
      btn.disabled = false;
    });
  });
});
</script>
@endsection
