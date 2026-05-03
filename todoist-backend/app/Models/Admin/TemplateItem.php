<?php

namespace App\Models\Admin;

class TemplateItem
{
    public function __construct(
        public string $id,
        public string $name,
        public string $category,
        public string $description,
        public array $steps,
    ) {}
}
