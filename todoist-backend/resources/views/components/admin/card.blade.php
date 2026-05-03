@props(['title' => null])

<div class="card">
    @if (!empty($title))
        <div class="row" style="margin-bottom: 12px;">
            <h3 style="margin:0;">{{ $title }}</h3>
            @if (isset($actions) && $actions->isNotEmpty())
                <div class="admin-card-actions">{{ $actions }}</div>
            @endif
        </div>
    @endif
    {{ $slot }}
</div>
