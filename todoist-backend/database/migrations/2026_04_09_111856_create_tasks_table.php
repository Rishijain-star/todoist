<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('project_id')->nullable()->constrained('projects')->nullOnDelete();
            $table->foreignId('workflow_id')->nullable()->constrained('workflows')->nullOnDelete();
            $table->foreignId('task_category_id')->nullable()->constrained('task_categories')->nullOnDelete();
            $table->foreignId('assigned_user_id')->nullable()->constrained('users')->nullOnDelete();

            $table->string('title');
            $table->date('due_date')->nullable();
            $table->string('priority')->default('Medium');
            $table->string('status')->default('Pending');
            $table->string('team')->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['owner_user_id', 'created_at']);
            $table->index(['workflow_id', 'created_at']);
            $table->index(['assigned_user_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
