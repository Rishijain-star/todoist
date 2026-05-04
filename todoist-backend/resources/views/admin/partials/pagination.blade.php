@if ($paginator->hasPages())
    <div class="pagination">
        @if ($paginator->onFirstPage())
            <span>Prev</span>
        @else
            <a href="{{ $paginator->previousPageUrl() }}">Prev</a>
        @endif
        @for ($i = 1; $i <= $paginator->lastPage(); $i++)
            @if ($i === $paginator->currentPage())
                <span class="active">{{ $i }}</span>
            @else
                <a href="{{ $paginator->url($i) }}">{{ $i }}</a>
            @endif
        @endfor
        @if ($paginator->hasMorePages())
            <a href="{{ $paginator->nextPageUrl() }}">Next</a>
        @else
            <span>Next</span>
        @endif
    </div>
@endif
