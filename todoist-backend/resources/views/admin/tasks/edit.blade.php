@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Edit Task</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'tasks', 'per_page' => $perPage]) }}">Back to Tasks</a>
    </div>
    <div class="grid-2">
        <input id="t-title" class="field" placeholder="Title">
        <input id="t-due" class="field" placeholder="Due date">
        <select id="t-priority" class="field"><option>Low</option><option>Medium</option><option>High</option></select>
        <select id="t-status" class="field"><option>Pending</option><option>In Progress</option><option>Done</option><option>Overdue</option></select>
        <select id="t-project" class="field"><option value="">— Project —</option></select>
        <select id="t-workflow" class="field"><option value="">— Workflow —</option></select>
        <select id="t-category" class="field"><option value="">— Category —</option></select>
        <input id="t-team" class="field" placeholder="Team / squad label">
        <select id="t-assignee" class="field"></select>
        <textarea id="t-notes" class="field" rows="4" placeholder="Notes"></textarea>
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="t-delete" class="btn danger" type="button">Delete</button>
        <button id="t-save" class="btn primary" type="button">Save Task</button>
    </div>
    <p id="t-msg" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var taskId = @json($taskId);
  var msgEl = document.getElementById('t-msg');

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
      document.getElementById('t-project').appendChild(o);
    });
    (results[1].data || []).forEach(function (w) {
      var o = document.createElement('option');
      o.value = w.id;
      o.textContent = w.name;
      document.getElementById('t-workflow').appendChild(o);
    });
    (results[2].data || []).forEach(function (c) {
      var o = document.createElement('option');
      o.value = c.name;
      o.textContent = c.name;
      document.getElementById('t-category').appendChild(o);
    });
    (results[3].data || []).filter(function (u) {
      return u.role === 'manager' || u.role === 'member';
    }).forEach(function (u) {
      var o = document.createElement('option');
      o.value = u.name;
      o.textContent = u.name + ' (' + u.role + ')';
      document.getElementById('t-assignee').appendChild(o);
    });
    return window.AdminApi.getOne('tasks', taskId);
  }).then(function (t) {
    document.getElementById('t-title').value = t.title || '';
    document.getElementById('t-due').value = t.due_date || '';
    document.getElementById('t-priority').value = t.priority || 'Medium';
    document.getElementById('t-status').value = t.status || 'Pending';
    document.getElementById('t-project').value = t.project_id || '';
    document.getElementById('t-workflow').value = t.workflow_id || '';
    document.getElementById('t-category').value = t.category || '';
    document.getElementById('t-team').value = t.team || '';
    document.getElementById('t-notes').value = t.notes || '';
    document.getElementById('t-assignee').value = t.assigned_user || '';
  }).catch(function (e) { msgEl.textContent = e.message; });

  document.getElementById('t-save').addEventListener('click', function () {
    msgEl.textContent = 'Saving…';
    window.AdminApi.update('tasks', taskId, {
      title: document.getElementById('t-title').value,
      due_date: document.getElementById('t-due').value,
      priority: document.getElementById('t-priority').value,
      status: document.getElementById('t-status').value,
      project_id: document.getElementById('t-project').value,
      workflow_id: document.getElementById('t-workflow').value,
      category: document.getElementById('t-category').value,
      team: document.getElementById('t-team').value,
      assigned_user: document.getElementById('t-assignee').value,
      notes: document.getElementById('t-notes').value
    }).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'tasks', 'per_page' => $perPage]) }}";
    }).catch(function (e) { msgEl.textContent = e.message; });
  });

  document.getElementById('t-delete').addEventListener('click', function () {
    if (!confirm('Delete this task?')) return;
    window.AdminApi.remove('tasks', taskId).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'tasks', 'per_page' => $perPage]) }}";
    }).catch(function (e) { msgEl.textContent = e.message; });
  });
});
</script>
@endsection
