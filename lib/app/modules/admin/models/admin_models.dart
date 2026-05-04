import 'package:flutter/material.dart';

enum AdminSection {
  dashboard,
  users,
  workflows,
  templates,
  tasks,
  notifications,
  reports,
  settings,
}

extension AdminSectionX on AdminSection {
  String get label {
    switch (this) {
      case AdminSection.dashboard:
        return 'Dashboard';
      case AdminSection.users:
        return 'Users';
      case AdminSection.workflows:
        return 'Workflows';
      case AdminSection.templates:
        return 'Templates';
      case AdminSection.tasks:
        return 'Tasks';
      case AdminSection.notifications:
        return 'Notifications';
      case AdminSection.reports:
        return 'Reports';
      case AdminSection.settings:
        return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminSection.dashboard:
        return Icons.grid_view_rounded;
      case AdminSection.users:
        return Icons.group_outlined;
      case AdminSection.workflows:
        return Icons.account_tree_outlined;
      case AdminSection.templates:
        return Icons.dashboard_customize_outlined;
      case AdminSection.tasks:
        return Icons.task_alt_outlined;
      case AdminSection.notifications:
        return Icons.notifications_none_rounded;
      case AdminSection.reports:
        return Icons.analytics_outlined;
      case AdminSection.settings:
        return Icons.settings_outlined;
    }
  }
}

class AdminMetric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AdminMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class ChartPoint {
  final String label;
  final double value;

  const ChartPoint({required this.label, required this.value});
}

class ActivityRecord {
  final String title;
  final String subtitle;
  final String time;

  const ActivityRecord({
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class UserRecord {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;

  const UserRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });
}

class WorkflowRecord {
  final String id;
  final String name;
  final String status;
  final int progress;
  final String deadline;
  final List<String> assignedUsers;
  final List<String> tasks;

  const WorkflowRecord({
    required this.id,
    required this.name,
    required this.status,
    required this.progress,
    required this.deadline,
    required this.assignedUsers,
    required this.tasks,
  });
}

class TemplateRecord {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> steps;

  const TemplateRecord({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.steps,
  });
}

class TaskRecord {
  final String id;
  final String title;
  final String dueDate;
  final String priority;
  final String status;
  final String assignedUser;
  final String notes;

  const TaskRecord({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedUser,
    required this.notes,
  });
}

class AdminNotification {
  final String id;
  final String title;
  final String type;
  final String message;
  final String time;

  const AdminNotification({
    required this.id,
    required this.title,
    required this.type,
    required this.message,
    required this.time,
  });
}
