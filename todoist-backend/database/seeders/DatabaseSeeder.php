<?php

namespace Database\Seeders;

use App\Models\Project;
use App\Models\Task;
use App\Models\TaskCategory;
use App\Models\Template;
use App\Models\User;
use App\Models\Workflow;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $superadmin = User::query()->updateOrCreate(
            ['email' => 'superadmin@todoistadmin.com'],
            ['name' => 'Super Admin', 'password' => Hash::make('superadmin123'), 'role' => 'superadmin']
        );
        $admin = User::query()->updateOrCreate(
            ['email' => 'admin@todoistadmin.com'],
            ['name' => 'Admin User', 'password' => Hash::make('admin123'), 'role' => 'admin']
        );
        $manager = User::query()->updateOrCreate(
            ['email' => 'manager@todoistadmin.com'],
            ['name' => 'Manager User', 'password' => Hash::make('manager123'), 'role' => 'manager']
        );
        $member = User::query()->updateOrCreate(
            ['email' => 'member@todoistadmin.com'],
            ['name' => 'Member User', 'password' => Hash::make('member123'), 'role' => 'member']
        );

        // Seed core data for mobile APIs (per-user ownership). Keep it idempotent.
        $owner = $superadmin;

        $categories = [
            'Operations',
            'Leasing',
            'Finance',
            'Maintenance',
            'Compliance',
        ];
        foreach ($categories as $catName) {
            TaskCategory::query()->firstOrCreate(
                ['owner_user_id' => $owner->id, 'name' => $catName],
                ['owner_user_id' => $owner->id, 'name' => $catName]
            );
        }

        $proj1 = Project::query()->firstOrCreate(
            ['owner_user_id' => $owner->id, 'code' => 'GH'],
            [
                'owner_user_id' => $owner->id,
                'name' => 'Green Heights Estate',
                'code' => 'GH',
                'category' => 'Residential',
                'description' => 'Primary residential tower portfolio.',
            ]
        );
        $proj2 = Project::query()->firstOrCreate(
            ['owner_user_id' => $owner->id, 'code' => 'MBP'],
            [
                'owner_user_id' => $owner->id,
                'name' => 'Metro Business Park',
                'code' => 'MBP',
                'category' => 'Commercial',
                'description' => 'Office and retail mixed-use campus.',
            ]
        );

        $leasing = TaskCategory::query()->where('owner_user_id', $owner->id)->where('name', 'Leasing')->first();
        $ops = TaskCategory::query()->where('owner_user_id', $owner->id)->where('name', 'Operations')->first();

        $template = Template::query()->firstOrCreate(
            ['owner_user_id' => $owner->id, 'name' => 'Lease Onboarding'],
            [
                'owner_user_id' => $owner->id,
                'name' => 'Lease Onboarding',
                'category' => 'Leasing',
                'description' => 'Onboarding flow for new lease activation.',
                'phases' => [
                    [
                        'id' => 'phase-1',
                        'title' => 'Phase 1',
                        'steps' => [
                            [
                                'id' => 'step-1',
                                'title' => 'Document KYC',
                                'type' => 'text',
                                'paragraph' => 'Collect and verify ID documents.',
                                'media' => ['image' => '', 'video' => '', 'audio' => '', 'pdf' => ''],
                                'links' => [],
                            ],
                            [
                                'id' => 'step-2',
                                'title' => 'Contract Sign',
                                'type' => 'text',
                                'paragraph' => 'Send agreement for signature.',
                                'media' => ['image' => '', 'video' => '', 'audio' => '', 'pdf' => ''],
                                'links' => [],
                            ],
                        ],
                    ],
                ],
            ]
        );

        $wf = Workflow::query()->firstOrCreate(
            ['owner_user_id' => $owner->id, 'name' => 'Lease Onboarding - Green Heights'],
            [
                'owner_user_id' => $owner->id,
                'project_id' => $proj1->id,
                'task_category_id' => $leasing?->id,
                'template_id' => $template->id,
                'name' => 'Lease Onboarding - Green Heights',
                'status' => 'On Track',
                'progress' => 83,
                'deadline' => now()->addDays(2)->toDateString(),
                'steps' => ['Document KYC', 'Contract Sign', 'Welcome Kit'],
            ]
        );

        Task::query()->firstOrCreate(
            ['owner_user_id' => $owner->id, 'title' => 'Finalize move-out inspection'],
            [
                'owner_user_id' => $owner->id,
                'project_id' => $proj1->id,
                'workflow_id' => $wf->id,
                'task_category_id' => $ops?->id,
                'assigned_user_id' => $manager->id,
                'title' => 'Finalize move-out inspection',
                'due_date' => now()->addDay()->toDateString(),
                'priority' => 'High',
                'status' => 'Pending',
                'team' => 'Field Ops',
                'notes' => Str::limit('Tenant requested evening slot for final walkthrough.', 240, ''),
            ]
        );
    }
}
