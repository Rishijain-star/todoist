<?php

namespace App\Support;

class PermissionMap
{
    public static function allows(string $role, string $permission): bool
    {
        $rolePermissions = config("permissions.roles.$role", []);
        if (in_array('*', $rolePermissions, true)) {
            return true;
        }
        if (in_array($permission, $rolePermissions, true)) {
            return true;
        }

        [$resource] = explode('.', $permission);
        return in_array($resource . '.*', $rolePermissions, true);
    }
}
