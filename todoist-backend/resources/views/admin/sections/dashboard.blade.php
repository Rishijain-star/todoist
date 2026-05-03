<div id="dashboard-kpi" class="kpi-grid"></div>
<div class="grid-2">
    <div class="card">
        <h3>Tasks Completed (Weekly)</h3>
        <div id="dashboard-weekly-bars" class="bar-wrap"></div>
    </div>
    <div class="card">
        <h3>Workflow Progress Overview</h3>
        <div id="dashboard-workflow-progress"></div>
    </div>
</div>
<div class="card">
    <h3>Recent Activity</h3>
    <div id="dashboard-activity"></div>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('dashboard-kpi').innerHTML = '<div class="card">' + window.AdminComponents.blockSkeleton(3) + '</div><div class="card">' + window.AdminComponents.blockSkeleton(3) + '</div><div class="card">' + window.AdminComponents.blockSkeleton(3) + '</div><div class="card">' + window.AdminComponents.blockSkeleton(3) + '</div>';
    document.getElementById('dashboard-weekly-bars').innerHTML = '<div>' + window.AdminComponents.blockSkeleton(5) + '</div>';
    document.getElementById('dashboard-workflow-progress').innerHTML = window.AdminComponents.blockSkeleton(5);
    document.getElementById('dashboard-activity').innerHTML = window.AdminComponents.blockSkeleton(6);
    window.AdminApi.getDashboard().then(function (data) {
      document.getElementById('dashboard-kpi').innerHTML = (data.kpis || []).map(function (kpi) {
        return '<div class="card"><div class="kpi-title">' + kpi.title + '</div><div class="kpi-value">' + kpi.value + '</div></div>';
      }).join('');
      document.getElementById('dashboard-weekly-bars').innerHTML = (data.weekly_tasks || []).map(function (point) {
        return '<div class="bar-item"><div class="bar" style="height:' + (20 + (point.value * 7)) + 'px;"></div><div class="bar-label">' + point.label + '</div></div>';
      }).join('');
      document.getElementById('dashboard-workflow-progress').innerHTML = (data.workflow_progress || []).map(function (point) {
        return '<div class="row"><span>' + point.label + '</span><strong>' + point.value + '%</strong></div><div class="progress"><span style="width:' + point.value + '%"></span></div>';
      }).join('');
      document.getElementById('dashboard-activity').innerHTML = (data.activity || []).map(function (activity) {
        return '<div class="row"><div><strong>' + activity.title + '</strong><br><span class="muted">' + activity.subtitle + '</span></div><span class="muted">' + activity.time + '</span></div>';
      }).join('');
    });
  });
</script>
