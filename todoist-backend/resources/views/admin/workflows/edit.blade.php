@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 id="wf-title-display" style="margin:0;">Workflow</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'workflows', 'per_page' => $perPage]) }}">Back to Workflows</a>
    </div>
    <div class="row"><span id="wf-chip" class="chip warn"></span><span class="muted" id="wf-deadline-line"></span></div>
    <div class="progress"><span id="workflow-progress-bar" style="width:0%"></span></div>
    <p><strong>Progress:</strong> <span id="workflow-progress-text">0</span>%</p>
    <div class="grid-2">
        <input id="workflow-progress-input" class="field" type="number" min="0" max="100" value="0" placeholder="Progress">
        <select id="wf-project" class="field"><option value="">— Project —</option></select>
        <select id="wf-category" class="field"><option value="">— Category —</option></select>
    </div>
    <h4>Steps</h4>
    <ul id="workflow-task-list"></ul>
    <div class="row" style="justify-content:flex-end;">
        <button id="workflow-delete-btn" class="btn danger" type="button">Delete</button>
        <button id="workflow-save-btn" class="btn primary" type="button">Save</button>
    </div>
    <p id="workflow-save-status" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var workflowId = @json($workflowId);
  var saveBtn = document.getElementById('workflow-save-btn');
  var deleteBtn = document.getElementById('workflow-delete-btn');
  var statusEl = document.getElementById('workflow-save-status');
  var progressInput = document.getElementById('workflow-progress-input');
  var projSel = document.getElementById('wf-project');
  var catSel = document.getElementById('wf-category');

  window.AdminApi.list('projects', { per_page: 100, projects_page: 1 }).then(function (payload) {
    (payload.data || []).forEach(function (p) {
      var o = document.createElement('option');
      o.value = p.id;
      o.textContent = p.name;
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

  window.AdminApi.getOne('workflows', workflowId).then(function (w) {
    document.getElementById('wf-title-display').textContent = w.name || 'Workflow';
    document.getElementById('wf-chip').textContent = w.status || '';
    document.getElementById('wf-deadline-line').textContent = 'Deadline: ' + (w.deadline || '—');
    var pr = parseInt(w.progress || 0, 10);
    progressInput.value = pr;
    document.getElementById('workflow-progress-text').textContent = String(pr);
    document.getElementById('workflow-progress-bar').style.width = pr + '%';
    projSel.value = w.project_id || '';
    catSel.value = w.category || '';
    document.getElementById('workflow-task-list').innerHTML = (w.tasks || []).map(function (t) { return '<li>' + t + '</li>'; }).join('') || '<li class="muted">None</li>';
  }).catch(function (e) { statusEl.textContent = e.message; });

  saveBtn.addEventListener('click', function () {
    var progress = Math.max(0, Math.min(100, parseInt(progressInput.value || '0', 10)));
    saveBtn.disabled = true;
    statusEl.textContent = 'Saving…';
    window.AdminApi.update('workflows', workflowId, {
      progress: progress,
      project_id: projSel.value,
      category: catSel.value
    }).then(function () {
      document.getElementById('workflow-progress-text').textContent = String(progress);
      document.getElementById('workflow-progress-bar').style.width = progress + '%';
      statusEl.textContent = 'Saved.';
    }).catch(function (error) {
      statusEl.textContent = error.message;
    }).finally(function () { saveBtn.disabled = false; });
  });

  deleteBtn.addEventListener('click', function () {
    if (!confirm('Delete this workflow?')) return;
    deleteBtn.disabled = true;
    window.AdminApi.remove('workflows', workflowId).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'workflows', 'per_page' => $perPage]) }}";
    }).catch(function (e) {
      statusEl.textContent = e.message;
      deleteBtn.disabled = false;
    });
  });
});
</script>
@endsection
