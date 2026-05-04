<div class="card">
    <div class="row">
        <h3 style="margin:0;">Workflows</h3>
        <a class="btn primary" href="{{ route('admin.workflows.create', ['per_page' => $perPage]) }}">+ Create Workflow</a>
    </div>
    <p class="muted">Each workflow can be tied to a project and category. Open a workflow to update progress and assignments.</p>
    <div id="workflow-grid" class="grid-3"></div>
    <div id="workflows-pagination"></div>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var editBase = @json(route('admin.workflows.edit', ['id' => '__id__', 'per_page' => $perPage]));
    document.getElementById('workflow-grid').innerHTML = '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>';
    window.AdminPages.loadPaginated({
      resource: 'workflows',
      perPage: {{ $perPage }},
      pageParam: 'workflows_page',
      targetId: 'workflow-grid',
      paginationId: 'workflows-pagination',
      renderItem: function (workflow) {
        var editUrl = editBase.replace('__id__', workflow.id);
        var cat = workflow.category ? '<span class="chip primary">' + workflow.category + '</span> ' : '';
        return '<div class="card">'
          + '<h3>' + workflow.name + '</h3>'
          + '<div class="row">' + cat + '<span class="chip warn">' + workflow.status + '</span><strong>' + workflow.progress + '%</strong></div>'
          + '<div class="progress"><span style="width:' + workflow.progress + '%"></span></div>'
          + '<p class="muted">Deadline: ' + workflow.deadline + '</p>'
          + '<div class="row" style="justify-content:flex-end"><a class="btn" href="' + editUrl + '">Open / Edit</a></div>'
          + '</div>';
      },
      errorRenderer: function (error) {
        return '<div class="card">Failed to load workflows: ' + error.message + '</div>';
      },
      loadingRenderer: function () {
        return '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>'
             + '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>'
             + '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>';
      }
    });
  });
</script>
