(function () {
  function chip(label, type) {
    return '<span class="chip ' + type + '">' + label + '</span>';
  }

  function statusChip(status) {
    if (status === 'Active' || status === 'Done' || status === 'On Track') return chip(status, 'success');
    if (status === 'Overdue' || status === 'Blocked' || status === 'Inactive') return chip(status, 'danger');
    return chip(status, 'warn');
  }

  function renderSimplePagination(meta, onPageChange, prefix) {
    if (!meta || !meta.last_page || meta.last_page <= 1) return '';
    var safePrefix = prefix || 'pg';
    var html = '<div class="pagination">';
    var prevDisabled = meta.current_page <= 1;
    var nextDisabled = meta.current_page >= meta.last_page;
    html += prevDisabled
      ? '<span>Prev</span>'
      : '<a href="#" data-page="' + (meta.current_page - 1) + '" data-prefix="' + safePrefix + '">Prev</a>';
    for (var i = 1; i <= meta.last_page; i++) {
      html += '<a href="#" class="' + (i === meta.current_page ? 'active' : '') + '" data-page="' + i + '" data-prefix="' + safePrefix + '">' + i + '</a>';
    }
    html += nextDisabled
      ? '<span>Next</span>'
      : '<a href="#" data-page="' + (meta.current_page + 1) + '" data-prefix="' + safePrefix + '">Next</a>';
    html += '</div>';
    setTimeout(function () {
      document.querySelectorAll('.pagination a[data-page][data-prefix="' + safePrefix + '"]').forEach(function (el) {
        el.addEventListener('click', function (e) {
          e.preventDefault();
          onPageChange(parseInt(el.getAttribute('data-page'), 10));
        });
      });
    }, 0);
    return html;
  }

  function setPagination(containerId, meta, onPageChange, prefix) {
    var el = document.getElementById(containerId);
    if (!el) return;
    el.innerHTML = renderSimplePagination(meta, onPageChange, prefix || containerId);
  }

  function tableSkeleton(columns, rows) {
    var colCount = columns || 5;
    var rowCount = rows || 6;
    var html = '';
    for (var i = 0; i < rowCount; i++) {
      html += '<tr>';
      for (var j = 0; j < colCount; j++) {
        html += '<td><div class="skeleton skeleton-row"></div></td>';
      }
      html += '</tr>';
    }
    return html;
  }

  function blockSkeleton(lines) {
    var count = lines || 4;
    var html = '';
    for (var i = 0; i < count; i++) {
      html += '<div class="skeleton skeleton-line" style="width:' + (90 - (i * 7)) + '%"></div>';
    }
    return html;
  }

  function initDataTable(tableId) {
    var table = document.getElementById(tableId);
    if (!table || typeof simpleDatatables === 'undefined') return;
    window.__adminDatatables = window.__adminDatatables || {};
    var existing = window.__adminDatatables[tableId];
    if (existing && typeof existing.destroy === 'function') {
      existing.destroy();
    }
    // Lightweight enhancement: sorting + search, pagination handled by API.
    window.__adminDatatables[tableId] = new simpleDatatables.DataTable(table, {
      searchable: true,
      fixedHeight: false,
      perPage: 1000,
      perPageSelect: false,
      sortable: true
    });
  }

  window.AdminComponents = {
    chip: chip,
    statusChip: statusChip,
    renderSimplePagination: renderSimplePagination,
    setPagination: setPagination,
    tableSkeleton: tableSkeleton,
    blockSkeleton: blockSkeleton,
    initDataTable: initDataTable
  };
})();
