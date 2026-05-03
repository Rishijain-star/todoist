(function () {
  function buildHeaders() {
    var tokenMeta = document.querySelector('meta[name="admin-api-token"]');
    var token = tokenMeta ? tokenMeta.getAttribute('content') : '';
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': token ? ('Bearer ' + token) : '',
    };
  }

  async function request(url, options) {
    var response = await fetch(url, Object.assign({ headers: buildHeaders() }, options || {}));
    var json = await response.json().catch(function () { return null; });
    if (!response.ok) {
      throw new Error((json && json.message) || 'API request failed');
    }
    return json;
  }

  window.AdminApi = {
    getDashboard: function () { return request('/api/v1/admin/dashboard'); },
    getReports: function () { return request('/api/v1/admin/reports'); },
    getSettings: function () { return request('/api/v1/admin/settings'); },
    updateSettings: function (payload) {
      return request('/api/v1/admin/settings', { method: 'PUT', body: JSON.stringify(payload || {}) });
    },
    list: function (resource, query) {
      var params = new URLSearchParams(query || {});
      return request('/api/v1/admin/' + resource + (params.toString() ? ('?' + params.toString()) : ''));
    },
    getOne: function (resource, id) { return request('/api/v1/admin/' + resource + '/' + id); },
    create: function (resource, payload) {
      return request('/api/v1/admin/' + resource, { method: 'POST', body: JSON.stringify(payload || {}) });
    },
    update: function (resource, id, payload) {
      return request('/api/v1/admin/' + resource + '/' + id, { method: 'PUT', body: JSON.stringify(payload || {}) });
    },
    remove: function (resource, id) {
      return request('/api/v1/admin/' + resource + '/' + id, { method: 'DELETE' });
    }
  };
})();
