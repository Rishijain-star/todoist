(function () {
  function loadPaginated(config) {
    var page = config.initialPage || 1;
    var inFlight = false;

    function load(nextPage) {
      if (inFlight) return;
      page = nextPage || 1;
      var query = Object.assign({}, config.query || {});
      query.per_page = config.perPage || 12;
      query[config.pageParam] = page;
      var target = document.getElementById(config.targetId);
      if (target && config.loadingRenderer) {
        target.innerHTML = config.loadingRenderer();
      }
      inFlight = true;

      window.AdminApi.list(config.resource, query).then(function (payload) {
        var rows = payload.data || [];
        var target = document.getElementById(config.targetId);
        if (!target) return;
        target.innerHTML = rows.map(config.renderItem).join('');
        if (config.afterRender) {
          config.afterRender(payload);
        }
        window.AdminComponents.setPagination(
          config.paginationId,
          { current_page: payload.current_page, last_page: payload.last_page },
          load,
          config.paginationId
        );
      }).catch(function (error) {
        var target = document.getElementById(config.targetId);
        if (target) {
          target.innerHTML = config.errorRenderer
            ? config.errorRenderer(error)
            : '<tr><td colspan="8">Failed: ' + error.message + '</td></tr>';
        }
      }).finally(function () {
        inFlight = false;
      });
    }

    load(page);
    return { reload: function () { load(page); }, load: load };
  }

  window.AdminPages = {
    loadPaginated: loadPaginated
  };
})();
