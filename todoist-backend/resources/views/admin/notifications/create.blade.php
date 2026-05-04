@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create Notification</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'notifications', 'per_page' => $perPage]) }}">Back</a>
    </div>
    <div class="grid-2">
        <input id="n-title" class="field" placeholder="Title">
        <select id="n-type" class="field">
            <option>Task</option>
            <option>Workflow</option>
            <option>System</option>
        </select>
        <textarea id="n-msg" class="field" rows="3" placeholder="Message" style="grid-column:1/-1;"></textarea>
        <input id="n-time" class="field" placeholder="Time label (e.g. Just now)">
    </div>
    <div class="row" style="justify-content:flex-end;">
        <button id="n-save" class="btn primary" type="button">Publish</button>
    </div>
    <p id="n-status" class="muted"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('n-save').addEventListener('click', function () {
    document.getElementById('n-status').textContent = 'Saving…';
    window.AdminApi.create('notifications', {
      title: document.getElementById('n-title').value,
      type: document.getElementById('n-type').value,
      message: document.getElementById('n-msg').value,
      time: document.getElementById('n-time').value || 'Just now'
    }).then(function () {
      window.location.href = "{{ route('admin.panel', ['section' => 'notifications', 'per_page' => $perPage]) }}";
    }).catch(function (e) { document.getElementById('n-status').textContent = e.message; });
  });
});
</script>
@endsection
