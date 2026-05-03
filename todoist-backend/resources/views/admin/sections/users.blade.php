<x-admin.card title="User Management">
    <x-slot name="actions">
        <a class="btn primary" href="{{ route('admin.users.create', ['per_page' => $perPage]) }}">+ Add User</a>
    </x-slot>
    <table id="users-data-table">
        <thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Actions</th></tr></thead>
        <tbody id="users-table-body"></tbody>
    </table>
    <div id="users-pagination"></div>
</x-admin.card>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var editUserBase = @json(route('admin.users.edit', ['id' => '__id__', 'per_page' => $perPage]));
    var loader = window.AdminPages.loadPaginated({
      resource: 'users',
      perPage: {{ $perPage }},
      pageParam: 'users_page',
      targetId: 'users-table-body',
      paginationId: 'users-pagination',
      renderItem: function (user) {
        var editUrl = editUserBase.replace('__id__', user.id);
        return '<tr>'
          + '<td>' + user.name + '</td>'
          + '<td>' + user.email + '</td>'
          + '<td>' + user.role + '</td>'
          + '<td>' + window.AdminComponents.statusChip(user.status) + '</td>'
          + '<td><a class="btn" href="' + editUrl + '">Edit</a> <button class="btn danger" data-delete-user="' + user.id + '" type="button">Delete</button></td>'
          + '</tr>';
      },
      loadingRenderer: function () {
        return window.AdminComponents.tableSkeleton(5, 6);
      },
      errorRenderer: function (error) {
        return '<tr><td colspan="5">Failed to load users: ' + error.message + '</td></tr>';
      }
    });

    document.addEventListener('click', function (event) {
      var button = event.target.closest('[data-delete-user]');
      if (button) {
        var userId = button.getAttribute('data-delete-user');
        if (!confirm('Delete this user?')) return;
        window.AdminApi.remove('users', userId).then(function () {
          loader.reload();
        });
      }
    });
  });
</script>
