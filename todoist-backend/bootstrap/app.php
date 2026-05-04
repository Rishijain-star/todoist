<?php

use App\Http\Middleware\EnsureAdminSessionAuthenticated;
use App\Http\Middleware\EnsureApiPermission;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'admin.auth' => EnsureAdminSessionAuthenticated::class,
            'permission' => EnsureApiPermission::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->reportable(function (Throwable $e): void {
            if (app()->runningInConsole()) {
                return;
            }
            $request = request();
            if (!$request instanceof Request || !$request->is('api/*')) {
                return;
            }
            if ($e instanceof ValidationException) {
                return;
            }
            if ($e instanceof HttpExceptionInterface && $e->getStatusCode() < 500) {
                return;
            }
            if ($e instanceof \Illuminate\Auth\AuthenticationException) {
                return;
            }
            if ($e instanceof \Illuminate\Auth\Access\AuthorizationException) {
                return;
            }

            Log::error('[API] '.$e->getMessage(), [
                'exception' => $e::class,
                'file' => $e->getFile().':'.$e->getLine(),
                'url' => $request->fullUrl(),
                'method' => $request->method(),
                'user_id' => $request->user()?->id,
            ]);
        });

        $exceptions->render(function (Throwable $e, Request $request) {
            if (!$request->is('api/*')) {
                return null;
            }
            if ($e instanceof \Illuminate\Auth\AuthenticationException) {
                return response()->json([
                    'message' => 'Unauthenticated',
                    'code' => 401,
                ], 401);
            }
            if ($e instanceof \Illuminate\Auth\Access\AuthorizationException) {
                return response()->json([
                    'message' => 'Forbidden',
                    'code' => 403,
                ], 403);
            }
            if ($e instanceof ValidationException) {
                return null;
            }
            if ($e instanceof HttpExceptionInterface) {
                return null;
            }
            if ($e instanceof \Illuminate\Http\Exceptions\HttpResponseException) {
                return null;
            }
            if (config('app.debug')) {
                return null;
            }

            return response()->json([
                'message' => 'Something went wrong',
                'code' => 500,
            ], 500);
        });
    })->create();
