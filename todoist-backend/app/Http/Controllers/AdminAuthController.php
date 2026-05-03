<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\View\View;

class AdminAuthController extends Controller
{
    public function showLogin(): View
    {
        return view('auth.admin-login');
    }

    public function login(Request $request): RedirectResponse
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string', 'min:6'],
        ]);

        // Frontend-side mock auth only.
        $user = User::query()->where('email', $credentials['email'])->first();
        if (!$user || !Hash::check($credentials['password'], $user->password)) {
            return back()->withErrors(['email' => 'Invalid admin credentials'])->withInput();
        }
        if (!in_array($user->role, ['superadmin', 'admin'], true)) {
            return back()->withErrors([
                'email' => 'Web admin login is only for superadmin/admin. Use mobile app for manager/member.',
            ])->withInput();
        }

        $request->session()->put('admin_logged_in', true);
        $request->session()->put('admin_email', $user->email);
        $request->session()->put('admin_role', $user->role);

        return redirect()->route('admin.panel')->with('status', 'Login successful');
    }

    public function showForgotPassword(): View
    {
        return view('auth.admin-forgot-password');
    }

    public function sendForgotPassword(Request $request): RedirectResponse
    {
        $request->validate([
            'email' => ['required', 'email'],
        ]);

        return back()->with('status', 'Password reset link sent (mock UI only).');
    }

    public function showChangePassword(): View
    {
        return view('auth.admin-change-password');
    }

    public function changePassword(Request $request): RedirectResponse
    {
        $request->validate([
            'current_password' => ['required', 'string', 'min:6'],
            'new_password' => ['required', 'string', 'min:6', 'confirmed'],
        ]);

        return back()->with('status', 'Password updated (mock UI only).');
    }

    public function logout(Request $request): RedirectResponse
    {
        $request->session()->forget(['admin_logged_in', 'admin_email', 'admin_role', 'admin_api_token']);
        return redirect()->route('admin.login')->with('status', 'Logged out successfully');
    }
}
