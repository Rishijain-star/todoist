<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TaskCategory extends Model
{
    protected $fillable = [
        'owner_user_id',
        'name',
    ];

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_user_id');
    }

    public function workflows(): HasMany
    {
        return $this->hasMany(Workflow::class);
    }

    public function tasks(): HasMany
    {
        return $this->hasMany(Task::class);
    }
}
