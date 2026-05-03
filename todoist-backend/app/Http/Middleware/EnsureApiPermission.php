<?php

namespace App\Http\Middleware;

use App\Support\PermissionMap;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureApiPermission
{
    public function handle(Request $request, Closure $next, string $resource, string $action = 'read'): Response
    {
        $user = $request->user();
        $resourceName = $resource === 'resource'
            ? (string) $request->route('resource', 'dashboard')
            : $resource;
        $permission = $resourceName . '.' . $action;

        if (!$user || !PermissionMap::allows($user->role ?? 'member', $permission)) {
            return response()->json([
                'message' => 'Forbidden',
                'permission' => $permission,
            ], 403);
        }

        return $next($request);
    }
}
