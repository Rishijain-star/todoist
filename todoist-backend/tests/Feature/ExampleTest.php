<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
// use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    use RefreshDatabase;

    /**
     * A basic test example.
     */
    public function test_admin_login_page_is_accessible(): void
    {
        $response = $this->get('/admin/login');

        $response->assertStatus(200);
    }

    public function test_admin_panel_requires_authentication(): void
    {
        $response = $this->get('/admin');
        $response->assertRedirect(route('admin.login'));
    }

    public function test_api_login_returns_token_and_allows_dashboard_access(): void
    {
        $user = User::query()->firstOrCreate(
            ['email' => 'admin@todoistadmin.com'],
            ['name' => 'Admin User', 'password' => Hash::make('admin123'), 'role' => 'admin']
        );

        $login = $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'admin123',
        ])->assertOk()->json();

        $this->withHeader('Authorization', 'Bearer ' . $login['token'])
            ->getJson('/api/v1/admin/dashboard')
            ->assertOk()
            ->assertJsonStructure(['kpis', 'weekly_tasks', 'workflow_progress', 'activity']);
    }
}
