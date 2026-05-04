<?php

namespace App\Models\Admin;

class TaskItem
{
    public function __construct(
        public string $id,
        public string $title,
        public string $dueDate,
        public string $priority,
        public string $status,
        public string $assignedUser,
        public string $notes,
    ) {}
}
