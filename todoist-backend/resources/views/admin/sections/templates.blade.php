<div class="card">
    <div class="row">
        <h3 style="margin:0;">Template Library</h3>
        <a class="btn primary" href="{{ route('admin.templates.create', ['per_page' => $perPage]) }}">Create New Template</a>
    </div>
    <p class="muted">Templates are managed through dedicated builder pages.</p>
</div>
<div id="template-grid" class="grid-3"></div>
<div id="templates-pagination"></div>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('template-grid').innerHTML = '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>';
    var templateBuilderBase = @json(route('admin.templates.builder', ['id' => '__id__', 'per_page' => $perPage]));
    window.AdminPages.loadPaginated({
      resource: 'templates',
      perPage: {{ $perPage }},
      pageParam: 'templates_page',
      targetId: 'template-grid',
      paginationId: 'templates-pagination',
      renderItem: function (template) {
        var builderUrl = templateBuilderBase.replace('__id__', template.id);
        return '<div class="card">'
          + '<h3>' + template.name + '</h3>'
          + '<p class="muted">' + template.category + '</p>'
          + '<p>' + template.description + '</p>'
          + '<div class="row" style="justify-content:flex-end"><a class="btn" href="' + builderUrl + '">Open Builder</a></div>'
          + '</div>';
      },
      errorRenderer: function (error) {
        return '<div class="card">Failed to load templates: ' + error.message + '</div>';
      },
      loadingRenderer: function () {
        return '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>'
             + '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>'
             + '<div class="card">' + window.AdminComponents.blockSkeleton(6) + '</div>';
      }
    });
  });
</script>
