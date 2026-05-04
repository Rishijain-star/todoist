<div class="grid-2">
    <div class="card">
        <h3>General Settings</h3>
        <input id="set-org" class="field" placeholder="Organization Name">
        <input id="set-timezone" class="field" placeholder="Timezone">
        <button id="save-general-btn" class="btn primary" type="button">Save General</button>
    </div>
    <div class="card">
        <h3>Notification Settings</h3>
        <label><input id="set-email-notif" type="checkbox"> Email notifications</label><br><br>
        <label><input id="set-push-notif" type="checkbox"> Push notifications</label><br><br>
        <button id="save-notification-btn" class="btn primary" type="button">Save Notifications</button>
    </div>
</div>
<div class="card">
    <h3>Twilio / SMS Config</h3>
    <input id="set-twilio-sid" class="field" placeholder="Account SID">
    <input id="set-twilio-token" class="field" placeholder="Auth Token">
    <input id="set-twilio-from" class="field" placeholder="From Number">
    <button id="save-sms-btn" class="btn primary" type="button">Save SMS Config</button>
    <p id="settings-status" class="muted" style="margin-top:8px;"></p>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var fields = {
    organization_name: document.getElementById('set-org'),
    timezone: document.getElementById('set-timezone'),
    email_notifications: document.getElementById('set-email-notif'),
    push_notifications: document.getElementById('set-push-notif'),
    twilio_sid: document.getElementById('set-twilio-sid'),
    twilio_token: document.getElementById('set-twilio-token'),
    twilio_from: document.getElementById('set-twilio-from')
  };
  var statusEl = document.getElementById('settings-status');

  function fill(data) {
    fields.organization_name.value = data.organization_name || '';
    fields.timezone.value = data.timezone || '';
    fields.email_notifications.checked = !!data.email_notifications;
    fields.push_notifications.checked = !!data.push_notifications;
    fields.twilio_sid.value = data.twilio_sid || '';
    fields.twilio_token.value = data.twilio_token || '';
    fields.twilio_from.value = data.twilio_from || '';
  }

  function save() {
    statusEl.textContent = 'Saving settings...';
    return window.AdminApi.updateSettings({
      organization_name: fields.organization_name.value,
      timezone: fields.timezone.value,
      email_notifications: fields.email_notifications.checked,
      push_notifications: fields.push_notifications.checked,
      twilio_sid: fields.twilio_sid.value,
      twilio_token: fields.twilio_token.value,
      twilio_from: fields.twilio_from.value
    }).then(function () {
      statusEl.textContent = 'Settings updated successfully.';
    }).catch(function (error) {
      statusEl.textContent = 'Settings update failed: ' + error.message;
    });
  }

  window.AdminApi.getSettings().then(fill);
  document.getElementById('save-general-btn').addEventListener('click', save);
  document.getElementById('save-notification-btn').addEventListener('click', save);
  document.getElementById('save-sms-btn').addEventListener('click', save);
});
</script>
