@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Edit User</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'users', 'per_page' => $perPage]) }}">Back to Users</a>
    </div>
    <div class="grid-2">
        <input id="user-name" class="field" placeholder="Full Name">
        <input id="user-email" class="field" placeholder="Email">
        <select id="user-role" class="field">
            <option>superadmin</option>
            <option>admin</option>
            <option>manager</option>
            <option>member</option>
        </select>
        <select id="user-status" class="field"><option>Active</option><option>Inactive</option></select>
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="update-user-btn" class="btn primary" type="button">Update User</button>
    </div>
    <p id="user-edit-status" class="muted"></p>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var userId = @json($userId);
  var statusEl = document.getElementById('user-edit-status');
  var updateBtn = document.getElementById('update-user-btn');
  window.AdminApi.getOne('users', userId).then(function (user) {
    document.getElementById('user-name').value = user.name || '';
    document.getElementById('user-email').value = user.email || '';
    document.getElementById('user-role').value = user.role || 'member';
    document.getElementById('user-status').value = user.status || 'Active';
  }).catch(function (error) {
    statusEl.textContent = 'Failed to load user: ' + error.message;
  });

  updateBtn.addEventListener('click', function () {
    updateBtn.disabled = true;
    statusEl.textContent = 'Updating user...';
    window.AdminApi.update('users', userId, {
      name: document.getElementById('user-name').value,
      email: document.getElementById('user-email').value,
      role: document.getElementById('user-role').value,
      status: document.getElementById('user-status').value
    }).then(function () {
      statusEl.textContent = 'User updated successfully.';
      setTimeout(function () {
        window.location.href = "{{ route('admin.panel', ['section' => 'users', 'per_page' => $perPage]) }}";
      }, 600);
    }).catch(function (error) {
      statusEl.textContent = 'Update failed: ' + error.message;
    }).finally(function () {
      updateBtn.disabled = false;
    });
  });
});
</script>
@endsection
