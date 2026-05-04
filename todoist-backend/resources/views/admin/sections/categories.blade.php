<x-admin.card title="Task categories">
    <x-slot name="actions">
        <a class="btn primary" href="{{ route('admin.categories.create') }}">+ Create category</a>
    </x-slot>
    <p class="muted">Categories are used when you create tasks and workflows (e.g. Operations, Leasing). New categories appear in those forms immediately.</p>
    <table id="categories-data-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>ID</th>
                <th style="width:160px;">Actions</th>
            </tr>
        </thead>
        <tbody id="categories-table-body"></tbody>
    </table>
    <div id="categories-pagination"></div>
</x-admin.card>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var editBase = @json(route('admin.categories.edit', ['id' => '__id__']));
  var loader = window.AdminPages.loadPaginated({
    resource: 'task_categories',
    perPage: {{ $perPage }},
    pageParam: 'task_categories_page',
    targetId: 'categories-table-body',
    paginationId: 'categories-pagination',
    renderItem: function (row) {
      var editUrl = editBase.replace('__id__', row.id);
      return '<tr>'
        + '<td><strong>' + (row.name || '') + '</strong></td>'
        + '<td class="muted">' + (row.id || '') + '</td>'
        + '<td><a class="btn" href="' + editUrl + '">Edit</a> '
        + '<button type="button" class="btn danger" data-del-cat="' + row.id + '">Delete</button></td>'
        + '</tr>';
    },
    loadingRenderer: function () { return window.AdminComponents.tableSkeleton(3, 6); },
    errorRenderer: function (err) { return '<tr><td colspan="3">Failed to load categories: ' + err.message + '</td></tr>'; }
  });
  document.addEventListener('click', function (ev) {
    var btn = ev.target.closest('[data-del-cat]');
    if (!btn) return;
    var id = btn.getAttribute('data-del-cat');
    if (!confirm('Delete this category? Tasks may still store the old name as text.')) return;
    window.AdminApi.remove('task_categories', id).then(function () { loader.reload(); });
  });
});
</script>
