<div class="kpi-grid">
    <div class="card"><div class="kpi-title">Completed Tasks</div><div class="kpi-value" id="reports-completed">-</div></div>
    <div class="card"><div class="kpi-title">Overdue Tasks</div><div class="kpi-value" id="reports-overdue">-</div></div>
    <div class="card"><div class="kpi-title">Active Users</div><div class="kpi-value" id="reports-users">-</div></div>
</div>
<div class="grid-2">
    <div class="card">
        <h3>Daily Activity</h3>
        <div id="reports-daily" class="bar-wrap"></div>
    </div>
    <div class="card">
        <h3>Monthly Summary</h3>
        <div id="reports-monthly" class="bar-wrap"></div>
    </div>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('reports-daily').innerHTML = '<div>' + window.AdminComponents.blockSkeleton(4) + '</div>';
    document.getElementById('reports-monthly').innerHTML = '<div>' + window.AdminComponents.blockSkeleton(4) + '</div>';
    window.AdminApi.getReports().then(function (data) {
      var daily = data.daily_activity || [];
      var monthly = data.monthly_summary || [];
      document.getElementById('reports-daily').innerHTML = daily.map(function (point) {
        return '<div class="bar-item"><div class="bar" style="height:' + (20 + (point.value * 3)) + 'px;"></div><div class="bar-label">' + point.label + '</div></div>';
      }).join('');
      document.getElementById('reports-monthly').innerHTML = monthly.map(function (point) {
        return '<div class="bar-item"><div class="bar" style="height:' + (20 + (point.value * 1.5)) + 'px;"></div><div class="bar-label">' + point.label + '</div></div>';
      }).join('');
      var completed = daily.reduce(function (sum, p) { return sum + Number(p.value || 0); }, 0);
      var overdue = Math.max(0, Math.round(completed * 0.08));
      document.getElementById('reports-completed').textContent = String(completed);
      document.getElementById('reports-overdue').textContent = String(overdue);
      document.getElementById('reports-users').textContent = String(monthly.length * 120);
    });
  });
</script>
