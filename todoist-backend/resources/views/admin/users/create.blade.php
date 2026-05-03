@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create User</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'users', 'per_page' => $perPage]) }}">Back to Users</a>
    </div>
    <div class="grid-2">
        <input id="user-name" class="field" placeholder="Full Name">
        <input id="user-email" class="field" placeholder="Email">
        <select id="user-role" class="field">
            <option>superadmin</option>
            <option>admin</option>
            <option>manager</option>
            <option selected>member</option>
        </select>
        <select id="user-status" class="field"><option selected>Active</option><option>Inactive</option></select>
        <input id="user-temp-password" class="field" placeholder="Temporary Password (optional)">
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="create-user-btn" class="btn primary" type="button">Create User</button>
    </div>
    <p id="user-create-status" class="muted"></p>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var statusEl = document.getElementById('user-create-status');
  var createBtn = document.getElementById('create-user-btn');
  createBtn.addEventListener('click', function () {
    createBtn.disabled = true;
    statusEl.textContent = 'Creating user...';
    window.AdminApi.create('users', {
      name: document.getElementById('user-name').value,
      email: document.getElementById('user-email').value,
      role: document.getElementById('user-role').value,
      status: document.getElementById('user-status').value,
      temp_password: document.getElementById('user-temp-password').value || undefined
    }).then(function (resp) {
      var temp = resp && resp.temp_password ? resp.temp_password : '(auto generated)';
      statusEl.textContent = 'User created. Temporary password: ' + temp;
      setTimeout(function () {
        window.location.href = "{{ route('admin.panel', ['section' => 'users', 'per_page' => $perPage]) }}";
      }, 600);
    }).catch(function (error) {
      statusEl.textContent = 'Create failed: ' + error.message;
    }).finally(function () {
      createBtn.disabled = false;
    });
  });
});
</script>
@endsection
