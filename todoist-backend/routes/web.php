<?php

use App\Http\Controllers\AdminAuthController;
use App\Http\Controllers\AdminPanelController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect()->route('admin.login');
});

Route::get('/admin/login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
Route::post('/admin/login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
Route::get('/admin/forgot-password', [AdminAuthController::class, 'showForgotPassword'])->name('admin.forgot-password');
Route::post('/admin/forgot-password', [AdminAuthController::class, 'sendForgotPassword'])->name('admin.forgot-password.submit');

Route::middleware('admin.auth')->group(function (): void {
    Route::get('/admin', [AdminPanelController::class, 'index'])->name('admin.panel');
    Route::get('/admin/users/create', [AdminPanelController::class, 'userCreate'])->name('admin.users.create');
    Route::get('/admin/users/{id}/edit', [AdminPanelController::class, 'userEdit'])->name('admin.users.edit');
    Route::get('/admin/tasks/create', [AdminPanelController::class, 'taskCreate'])->name('admin.tasks.create');
    Route::get('/admin/tasks/{id}/edit', [AdminPanelController::class, 'taskEdit'])->name('admin.tasks.edit');
    Route::get('/admin/projects/create', [AdminPanelController::class, 'projectCreate'])->name('admin.projects.create');
    Route::get('/admin/projects/{id}/edit', [AdminPanelController::class, 'projectEdit'])->name('admin.projects.edit');
    Route::get('/admin/categories/create', [AdminPanelController::class, 'categoryCreate'])->name('admin.categories.create');
    Route::get('/admin/categories/{id}/edit', [AdminPanelController::class, 'categoryEdit'])->name('admin.categories.edit');
    Route::get('/admin/workflows/create', [AdminPanelController::class, 'workflowCreate'])->name('admin.workflows.create');
    Route::get('/admin/workflows/{id}/edit', [AdminPanelController::class, 'workflowEdit'])->name('admin.workflows.edit');
    Route::get('/admin/notifications/create', [AdminPanelController::class, 'notificationCreate'])->name('admin.notifications.create');
    Route::get('/admin/templates/create', [AdminPanelController::class, 'templateCreate'])->name('admin.templates.create');
    Route::get('/admin/templates/{id}/builder', [AdminPanelController::class, 'templateBuilder'])->name('admin.templates.builder');
    Route::get('/admin/change-password', [AdminAuthController::class, 'showChangePassword'])->name('admin.change-password');
    Route::post('/admin/change-password', [AdminAuthController::class, 'changePassword'])->name('admin.change-password.submit');
    Route::post('/admin/logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
});
