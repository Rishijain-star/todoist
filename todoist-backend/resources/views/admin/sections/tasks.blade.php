<div class="card">
    <div class="row">
        <h3 style="margin:0;">Task Management</h3>
        <a class="btn primary" href="{{ route('admin.tasks.create', ['per_page' => $perPage]) }}">+ Create Task</a>
    </div>
    <p class="muted">Tasks can be linked to a project, workflow, and category. Assign a teammate and optional team label.</p>
    <div style="overflow-x:auto;">
        <table id="tasks-data-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Project</th>
                    <th>Workflow</th>
                    <th>Category</th>
                    <th>Team</th>
                    <th>Due</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Assignee</th>
                    <th style="min-width:100px;">Actions</th>
                </tr>
            </thead>
            <tbody id="tasks-table-body"></tbody>
        </table>
    </div>
    <div id="tasks-pagination"></div>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var editBase = @json(route('admin.tasks.edit', ['id' => '__id__', 'per_page' => $perPage]));
    var loader = window.AdminPages.loadPaginated({
      resource: 'tasks',
      perPage: {{ $perPage }},
      pageParam: 'tasks_page',
      targetId: 'tasks-table-body',
      paginationId: 'tasks-pagination',
      renderItem: function (task) {
        var editUrl = editBase.replace('__id__', task.id);
        return '<tr>'
          + '<td><strong>' + (task.title || '') + '</strong></td>'
          + '<td class="muted">' + (task.project_name || task.project_id || '—') + '</td>'
          + '<td class="muted">' + (task.workflow_name || task.workflow_id || '—') + '</td>'
          + '<td>' + (task.category || '—') + '</td>'
          + '<td>' + (task.team || '—') + '</td>'
          + '<td>' + (task.due_date || '') + '</td>'
          + '<td>' + (task.priority || '') + '</td>'
          + '<td>' + window.AdminComponents.statusChip(task.status) + '</td>'
          + '<td>' + (task.assigned_user || '') + '</td>'
          + '<td><a class="btn" href="' + editUrl + '">Edit</a></td>'
          + '</tr>';
      },
      loadingRenderer: function () {
        return window.AdminComponents.tableSkeleton(10, 5);
      },
      errorRenderer: function (error) {
        return '<tr><td colspan="10">Failed to load tasks: ' + error.message + '</td></tr>';
      }
    });
  });
</script>
