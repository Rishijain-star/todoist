<?php

namespace App\Models\Admin;

class AdminUser
{
    public function __construct(
        public string $name,
        public string $email,
        public string $role,
        public string $status,
    ) {}
}
