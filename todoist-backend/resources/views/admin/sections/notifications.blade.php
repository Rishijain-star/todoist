<div class="card">
    <div class="row">
        <h3 style="margin:0;">Notifications</h3>
        <a class="btn primary" href="{{ route('admin.notifications.create', ['per_page' => $perPage]) }}">+ Add Notification</a>
    </div>
    <p class="muted">In-app notices for tasks, workflows, and system events.</p>
    <div id="notifications-list"></div>
    <div id="notifications-pagination"></div>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var loader = window.AdminPages.loadPaginated({
      resource: 'notifications',
      perPage: {{ $perPage }},
      pageParam: 'notifications_page',
      targetId: 'notifications-list',
      paginationId: 'notifications-pagination',
      renderItem: function (item) {
        return '<div class="row" style="align-items:flex-start; padding:12px 0; border-bottom:1px solid var(--border);">'
          + '<div><strong>' + item.title + '</strong> <span class="chip primary">' + item.type + '</span><br><span class="muted">' + item.message + '</span></div>'
          + '<div style="text-align:right;"><span class="muted">' + item.time + '</span><br>'
          + '<button type="button" class="btn danger" style="margin-top:8px;" data-del-n="' + item.id + '">Delete</button></div>'
          + '</div>';
      },
      loadingRenderer: function () {
        return '<div>' + window.AdminComponents.blockSkeleton(4) + '</div>';
      },
      errorRenderer: function (error) {
        return '<div class="muted">Failed to load notifications: ' + error.message + '</div>';
      }
    });
    document.addEventListener('click', function (ev) {
      var btn = ev.target.closest('[data-del-n]');
      if (!btn) return;
      var id = btn.getAttribute('data-del-n');
      if (!confirm('Delete this notification?')) return;
      window.AdminApi.remove('notifications', id).then(function () { loader.reload(); });
    });
  });
</script>
