@extends('layouts.admin')

@section('content')
<div class="card">
    <div class="row">
        <h3 style="margin:0;">Create Template Wizard</h3>
        <a class="btn" href="{{ route('admin.panel', ['section' => 'templates', 'per_page' => $perPage]) }}">Back to List</a>
    </div>
    <p class="muted">Create a structured template with phases, steps, paragraph content, links, and media (image/video/audio/pdf).</p>

    <h4 style="margin:8px 0;">1) Template Basics</h4>
    <div class="grid-2">
        <input id="tpl-name" class="field" placeholder="Template name">
        <input id="tpl-category" class="field" placeholder="Category">
        <input id="tpl-description" class="field" placeholder="Description">
    </div>

    <h4 style="margin:8px 0;">2) Phase & Step Selection</h4>
    <div class="grid-2">
        <select id="tpl-phase-select" class="field"></select>
        <input id="tpl-phase-title" class="field" placeholder="Phase title">
        <select id="tpl-step-select" class="field"></select>
        <input id="tpl-step-title" class="field" placeholder="Step title">
    </div>

    <h4 style="margin:8px 0;">3) Step Content</h4>
    <div class="grid-2">
        <select id="tpl-step-type" class="field">
            <option value="text">Text</option>
            <option value="link">Link</option>
            <option value="image">Image</option>
            <option value="video">Video</option>
            <option value="audio">Audio</option>
            <option value="pdf">PDF</option>
        </select>
        <input id="tpl-link" class="field" placeholder="Link URL">
    </div>
    <textarea id="tpl-step-paragraph" class="field" rows="5" placeholder="Paragraph / rich text style content"></textarea>
    <div class="grid-2">
        <input id="tpl-image" class="field" placeholder="Image URL">
        <input id="tpl-video" class="field" placeholder="Video URL">
        <input id="tpl-audio" class="field" placeholder="Audio URL">
        <input id="tpl-pdf" class="field" placeholder="PDF URL">
    </div>
    <div class="grid-2">
        <div>
            <label class="muted">Upload Image</label>
            <input id="tpl-image-file" class="field" type="file" accept="image/*">
        </div>
        <div>
            <label class="muted">Upload Video</label>
            <input id="tpl-video-file" class="field" type="file" accept="video/*">
        </div>
        <div>
            <label class="muted">Upload Audio</label>
            <input id="tpl-audio-file" class="field" type="file" accept="audio/*">
        </div>
        <div>
            <label class="muted">Upload PDF</label>
            <input id="tpl-pdf-file" class="field" type="file" accept="application/pdf">
        </div>
    </div>
    <div class="row" style="justify-content:flex-end; flex-wrap:wrap;">
        <button id="tpl-add-phase" class="btn" type="button">+ Add Phase</button>
        <button id="tpl-add-step" class="btn" type="button">+ Add Step</button>
        <button id="tpl-delete-step" class="btn danger" type="button">Delete Step</button>
        <button id="tpl-save-step" class="btn" type="button">Save Step</button>
        <button id="tpl-create-template" class="btn primary" type="button">Create Template</button>
    </div>
    <p id="template-status" class="muted"></p>
</div>

<div class="card">
    <h4 style="margin-top:0;">Wizard Preview</h4>
    <div id="tpl-preview"></div>
</div>

<div class="card">
    <h4 style="margin-top:0;">Steps In Current Phase</h4>
    <div id="tpl-step-list"></div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var statusEl = document.getElementById('template-status');
  var selectedPhaseIndex = 0;
  var selectedStepIndex = 0;
  var state = {
    name: '',
    category: '',
    description: '',
    phases: [{
      id: 'phase-1',
      title: 'Phase 1',
      steps: [{
        id: 'step-1',
        title: 'Step 1',
        type: 'text',
        paragraph: '',
        media: { image: '', video: '', audio: '', pdf: '' },
        links: []
      }]
    }]
  };

  function bindTopFields() {
    document.getElementById('tpl-name').value = state.name;
    document.getElementById('tpl-category').value = state.category;
    document.getElementById('tpl-description').value = state.description;
  }
  function renderPhaseSelect() {
    var phaseSelect = document.getElementById('tpl-phase-select');
    phaseSelect.innerHTML = state.phases.map(function (phase, idx) {
      return '<option value="' + idx + '">' + phase.title + '</option>';
    }).join('');
    phaseSelect.value = String(selectedPhaseIndex);
  }
  function renderStepSelect() {
    var phase = state.phases[selectedPhaseIndex];
    var stepSelect = document.getElementById('tpl-step-select');
    stepSelect.innerHTML = phase.steps.map(function (step, idx) {
      return '<option value="' + idx + '">' + step.title + '</option>';
    }).join('');
    if (selectedStepIndex >= phase.steps.length) selectedStepIndex = 0;
    stepSelect.value = String(selectedStepIndex);
  }
  function loadCurrentStepToForm() {
    var phase = state.phases[selectedPhaseIndex];
    var step = phase.steps[selectedStepIndex];
    document.getElementById('tpl-phase-title').value = phase.title;
    document.getElementById('tpl-step-title').value = step.title;
    document.getElementById('tpl-step-type').value = step.type || 'text';
    document.getElementById('tpl-step-paragraph').value = step.paragraph || '';
    document.getElementById('tpl-link').value = (step.links && step.links[0]) || '';
    document.getElementById('tpl-image').value = step.media.image || '';
    document.getElementById('tpl-video').value = step.media.video || '';
    document.getElementById('tpl-audio').value = step.media.audio || '';
    document.getElementById('tpl-pdf').value = step.media.pdf || '';
  }
  function saveCurrentStepFromForm() {
    state.name = document.getElementById('tpl-name').value;
    state.category = document.getElementById('tpl-category').value;
    state.description = document.getElementById('tpl-description').value;
    var phase = state.phases[selectedPhaseIndex];
    phase.title = document.getElementById('tpl-phase-title').value || phase.title;
    var step = phase.steps[selectedStepIndex];
    step.title = document.getElementById('tpl-step-title').value || step.title;
    step.type = document.getElementById('tpl-step-type').value;
    step.paragraph = document.getElementById('tpl-step-paragraph').value;
    step.links = [document.getElementById('tpl-link').value].filter(Boolean);
    step.media = {
      image: document.getElementById('tpl-image').value,
      video: document.getElementById('tpl-video').value,
      audio: document.getElementById('tpl-audio').value,
      pdf: document.getElementById('tpl-pdf').value
    };
  }
  function renderPreview() {
    document.getElementById('tpl-preview').innerHTML = state.phases.map(function (phase) {
      return '<div style="margin-bottom:12px; padding:10px; border:1px solid #E2E8F4; border-radius:10px;"><strong>' + phase.title + '</strong><ul>'
        + phase.steps.map(function (step) {
          var link = (step.links && step.links[0]) ? ('<div class="muted">Link: ' + step.links[0] + '</div>') : '';
          var media = [];
          if (step.media && step.media.image) media.push('Image');
          if (step.media && step.media.video) media.push('Video');
          if (step.media && step.media.audio) media.push('Audio');
          if (step.media && step.media.pdf) media.push('PDF');
          var mediaText = media.length ? ('<div class="muted">Media: ' + media.join(', ') + '</div>') : '<div class="muted">Media: none</div>';
          return '<li style="margin-bottom:8px;"><b>' + step.title + '</b> [' + step.type + ']<div>' + (step.paragraph || '') + '</div>' + link + mediaText + '</li>';
        }).join('')
        + '</ul></div>';
    }).join('');
  }
  function renderStepList() {
    var phase = state.phases[selectedPhaseIndex];
    document.getElementById('tpl-step-list').innerHTML = (phase.steps || []).map(function (step, idx) {
      var mediaCount = ['image','video','audio','pdf'].filter(function (k) { return !!(step.media && step.media[k]); }).length;
      return '<div class="row" style="padding:8px;border:1px solid #E2E8F4;border-radius:8px;">'
        + '<div><strong>' + (idx + 1) + '. ' + step.title + '</strong><br><span class="muted">Type: ' + step.type + ' · Media: ' + mediaCount + '</span></div>'
        + '<button class="btn" type="button" data-go-step="' + idx + '">Edit</button>'
        + '</div>';
    }).join('');
  }
  function renderAll() { bindTopFields(); renderPhaseSelect(); renderStepSelect(); loadCurrentStepToForm(); renderPreview(); renderStepList(); }

  function attachFileInput(inputId, mediaKey) {
    var el = document.getElementById(inputId);
    el.addEventListener('change', function (event) {
      var file = event.target.files && event.target.files[0];
      if (!file) return;
      var reader = new FileReader();
      reader.onload = function () {
        saveCurrentStepFromForm();
        var phase = state.phases[selectedPhaseIndex];
        var step = phase.steps[selectedStepIndex];
        step.media[mediaKey] = String(reader.result || '');
        if (mediaKey === 'image') document.getElementById('tpl-image').value = step.media[mediaKey];
        if (mediaKey === 'video') document.getElementById('tpl-video').value = step.media[mediaKey];
        if (mediaKey === 'audio') document.getElementById('tpl-audio').value = step.media[mediaKey];
        if (mediaKey === 'pdf') document.getElementById('tpl-pdf').value = step.media[mediaKey];
        statusEl.textContent = mediaKey.toUpperCase() + ' uploaded for current step.';
        renderStepList();
      };
      reader.readAsDataURL(file);
    });
  }

  document.getElementById('tpl-phase-select').addEventListener('change', function () {
    saveCurrentStepFromForm();
    selectedPhaseIndex = parseInt(this.value, 10) || 0;
    selectedStepIndex = 0;
    renderAll();
  });
  document.getElementById('tpl-step-select').addEventListener('change', function () {
    saveCurrentStepFromForm();
    selectedStepIndex = parseInt(this.value, 10) || 0;
    loadCurrentStepToForm();
  });
  document.getElementById('tpl-add-phase').addEventListener('click', function () {
    saveCurrentStepFromForm();
    state.phases.push({
      id: 'phase-' + (state.phases.length + 1),
      title: 'Phase ' + (state.phases.length + 1),
      steps: [{ id: 'step-1', title: 'Step 1', type: 'text', paragraph: '', media: { image: '', video: '', audio: '', pdf: '' }, links: [] }]
    });
    selectedPhaseIndex = state.phases.length - 1;
    selectedStepIndex = 0;
    renderAll();
  });
  document.getElementById('tpl-add-step').addEventListener('click', function () {
    saveCurrentStepFromForm();
    var phase = state.phases[selectedPhaseIndex];
    phase.steps.push({ id: 'step-' + (phase.steps.length + 1), title: 'Step ' + (phase.steps.length + 1), type: 'text', paragraph: '', media: { image: '', video: '', audio: '', pdf: '' }, links: [] });
    selectedStepIndex = phase.steps.length - 1;
    renderAll();
  });
  document.getElementById('tpl-delete-step').addEventListener('click', function () {
    var phase = state.phases[selectedPhaseIndex];
    if (phase.steps.length <= 1) return;
    phase.steps.splice(selectedStepIndex, 1);
    selectedStepIndex = Math.max(0, selectedStepIndex - 1);
    renderAll();
  });
  document.getElementById('tpl-save-step').addEventListener('click', function () {
    saveCurrentStepFromForm();
    renderPreview();
    statusEl.textContent = 'Step saved.';
  });
  document.getElementById('tpl-create-template').addEventListener('click', function () {
    saveCurrentStepFromForm();
    statusEl.textContent = 'Creating template...';
    window.AdminApi.create('templates', state).then(function (created) {
      statusEl.textContent = 'Template created. Opening builder...';
      var url = @json(route('admin.templates.builder', ['id' => '__id__', 'per_page' => $perPage]));
      window.location.href = url.replace('__id__', created.id);
    }).catch(function (error) {
      statusEl.textContent = 'Create failed: ' + error.message;
    });
  });
  document.addEventListener('click', function (event) {
    var go = event.target.closest('[data-go-step]');
    if (!go) return;
    saveCurrentStepFromForm();
    selectedStepIndex = parseInt(go.getAttribute('data-go-step'), 10) || 0;
    renderAll();
  });
  attachFileInput('tpl-image-file', 'image');
  attachFileInput('tpl-video-file', 'video');
  attachFileInput('tpl-audio-file', 'audio');
  attachFileInput('tpl-pdf-file', 'pdf');

  renderAll();
});
</script>
@endsection
