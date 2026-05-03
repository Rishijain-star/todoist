<?php

namespace App\Models\Admin;

class Workflow
{
    public function __construct(
        public string $id,
        public string $name,
        public string $status,
        public int $progress,
        public string $deadline,
        public array $assigned,
        public array $tasks,
    ) {}
}
