<?php

use App\Http\Controllers\Api\AdminApiController;
use App\Http\Controllers\Api\AuthApiController;
use App\Http\Controllers\Api\ProjectApiController;
use App\Http\Controllers\Api\TaskApiController;
use App\Http\Controllers\Api\TaskCategoryApiController;
use App\Http\Controllers\Api\TemplateApiController;
use App\Http\Controllers\Api\WorkflowApiController;
use Illuminate\Support\Facades\Route;

Route::get('/ping', function () {
    return response()->json(['ok' => true]);
});

Route::prefix('v1')->group(function (): void {
    Route::get('/ping', function () {
        return response()->json(['ok' => true]);
    });

    Route::post('/auth/login', [AuthApiController::class, 'login']);
    Route::post('/auth/register', [AuthApiController::class, 'register']);
    Route::post('/auth/forgot-password', [AuthApiController::class, 'forgotPassword']);
    Route::post('/auth/reset-password', [AuthApiController::class, 'resetPassword']);

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::get('/auth/me', [AuthApiController::class, 'me']);
        Route::post('/auth/logout', [AuthApiController::class, 'logout']);

        // Mobile app APIs (DB-backed)
        Route::apiResource('projects', ProjectApiController::class)->only(['index', 'store', 'show', 'update', 'destroy']);
        Route::get('projects/{project}/members', [ProjectApiController::class, 'members']);
        Route::post('projects/{project}/members', [ProjectApiController::class, 'addMember']);
        Route::apiResource('categories', TaskCategoryApiController::class)->parameters(['categories' => 'category'])->only(['index', 'store', 'show', 'update', 'destroy']);
        Route::apiResource('templates', TemplateApiController::class)->only(['index', 'store', 'show', 'update', 'destroy']);
        Route::apiResource('workflows', WorkflowApiController::class)->only(['index', 'store', 'show', 'update', 'destroy']);
        Route::get('tasks/upcoming', [TaskApiController::class, 'upcoming']);
        Route::apiResource('tasks', TaskApiController::class)->only(['index', 'store', 'show', 'update', 'destroy']);
        Route::post('tasks/{task}/comments', [TaskApiController::class, 'storeComment']);
        Route::post('tasks/{task}/attachments', [TaskApiController::class, 'uploadAttachment']);

        Route::get('/admin/dashboard', [AdminApiController::class, 'dashboard'])
            ->middleware('permission:dashboard,read');
        Route::get('/admin/reports', [AdminApiController::class, 'reports'])
            ->middleware('permission:reports,read');
        Route::get('/admin/settings', [AdminApiController::class, 'settings'])
            ->middleware('permission:settings,read');
        Route::put('/admin/settings', [AdminApiController::class, 'updateSettings'])
            ->middleware('permission:settings,update');

        Route::get('/admin/{resource}', [AdminApiController::class, 'list'])
            ->middleware('permission:resource,read');
        Route::post('/admin/{resource}', [AdminApiController::class, 'store'])
            ->middleware('permission:resource,create');
        Route::get('/admin/{resource}/{id}', [AdminApiController::class, 'show'])
            ->middleware('permission:resource,read');
        Route::put('/admin/{resource}/{id}', [AdminApiController::class, 'update'])
            ->middleware('permission:resource,update');
        Route::delete('/admin/{resource}/{id}', [AdminApiController::class, 'destroy'])
            ->middleware('permission:resource,delete');
    });
});
