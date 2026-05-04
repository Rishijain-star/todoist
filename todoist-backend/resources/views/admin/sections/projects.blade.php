<x-admin.card title="Projects">
    <x-slot name="actions">
        <a class="btn primary" href="{{ route('admin.projects.create') }}">+ Add Project</a>
    </x-slot>
    <p class="muted">Organize work by property or program. Link workflows and tasks to a project.</p>
    <table id="projects-data-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Code</th>
                <th>Category</th>
                <th>Description</th>
                <th style="width:120px;">Actions</th>
            </tr>
        </thead>
        <tbody id="projects-table-body"></tbody>
    </table>
    <div id="projects-pagination"></div>
</x-admin.card>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var editBase = @json(route('admin.projects.edit', ['id' => '__id__']));
  window.AdminPages.loadPaginated({
    resource: 'projects',
    perPage: {{ $perPage }},
    pageParam: 'projects_page',
    targetId: 'projects-table-body',
    paginationId: 'projects-pagination',
    renderItem: function (p) {
    var editUrl = editBase.replace('__id__', p.id);
    var desc = (p.description || '').length > 80 ? (p.description || '').substring(0, 80) + '…' : (p.description || '—');
    return '<tr>'
      + '<td><strong>' + (p.name || '') + '</strong></td>'
      + '<td>' + (p.code || '—') + '</td>'
      + '<td>' + (p.category || '—') + '</td>'
      + '<td class="muted">' + desc + '</td>'
      + '<td><a class="btn" href="' + editUrl + '">Edit</a></td>'
      + '</tr>';
  },
  loadingRenderer: function () { return window.AdminComponents.tableSkeleton(5, 5); },
  errorRenderer: function (err) { return '<tr><td colspan="5">Failed to load projects: ' + err.message + '</td></tr>'; }
  });
});
</script>
