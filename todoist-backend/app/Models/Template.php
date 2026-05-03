<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Template extends Model
{
    protected $fillable = [
        'owner_user_id',
        'name',
        'category',
        'description',
        'phases',
    ];

    protected $casts = [
        'phases' => 'array',
    ];

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_user_id');
    }

    public function workflows(): HasMany
    {
        return $this->hasMany(Workflow::class);
    }
}
