import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../models/admin_models.dart';

class AdminMockData {
  static const List<AdminMetric> dashboardMetrics = [
    AdminMetric(
      title: 'Total Users',
      value: '1,284',
      icon: Icons.group_outlined,
      color: AppColors.primaryColor,
    ),
    AdminMetric(
      title: 'Active Workflows',
      value: '42',
      icon: Icons.account_tree_outlined,
      color: AppColors.accentBlue,
    ),
    AdminMetric(
      title: 'Pending Tasks',
      value: '96',
      icon: Icons.pending_actions_outlined,
      color: AppColors.gold,
    ),
    AdminMetric(
      title: 'Overdue Tasks',
      value: '14',
      icon: Icons.warning_amber_rounded,
      color: AppColors.red,
    ),
  ];

  static const List<ChartPoint> weeklyTaskChart = [
    ChartPoint(label: 'Mon', value: 8),
    ChartPoint(label: 'Tue', value: 11),
    ChartPoint(label: 'Wed', value: 9),
    ChartPoint(label: 'Thu', value: 13),
    ChartPoint(label: 'Fri', value: 15),
    ChartPoint(label: 'Sat', value: 6),
    ChartPoint(label: 'Sun', value: 4),
  ];

  static const List<ChartPoint> workflowProgressChart = [
    ChartPoint(label: 'Move-Out', value: 72),
    ChartPoint(label: 'Move-In', value: 64),
    ChartPoint(label: 'Inspection', value: 51),
    ChartPoint(label: 'Maintenance', value: 83),
  ];

  static const List<ActivityRecord> recentActivities = [
    ActivityRecord(
      title: 'Workflow completed',
      subtitle: 'Lease renewal flow for Tower B, Unit 401',
      time: '2 mins ago',
    ),
    ActivityRecord(
      title: 'New user invited',
      subtitle: 'Priya Shah added as Property Manager',
      time: '25 mins ago',
    ),
    ActivityRecord(
      title: 'Template updated',
      subtitle: 'Periodic Inspection checklist revised',
      time: '1 hour ago',
    ),
    ActivityRecord(
      title: 'Task overdue alert',
      subtitle: 'Move-Out: Final utility closure pending',
      time: '2 hours ago',
    ),
  ];

  static const List<UserRecord> users = [
    UserRecord(
      id: 'u1',
      name: 'Karan Jain',
      email: 'karan@taskerer.com',
      role: 'Admin',
      status: 'Active',
    ),
    UserRecord(
      id: 'u2',
      name: 'Priya Shah',
      email: 'priya@taskerer.com',
      role: 'Property Manager',
      status: 'Active',
    ),
    UserRecord(
      id: 'u3',
      name: 'Aman Kapoor',
      email: 'aman@taskerer.com',
      role: 'Operations',
      status: 'Inactive',
    ),
    UserRecord(
      id: 'u4',
      name: 'Sara Wilson',
      email: 'sara@taskerer.com',
      role: 'Support',
      status: 'Active',
    ),
  ];

  static const List<WorkflowRecord> workflows = [
    WorkflowRecord(
      id: 'w1',
      name: 'Move-Out Workflow - Unit 14B',
      status: 'In Progress',
      progress: 68,
      deadline: 'Apr 13, 2026',
      assignedUsers: ['Priya Shah', 'Aman Kapoor'],
      tasks: ['Inspection', 'Meter Reading', 'Deposit Settlement'],
    ),
    WorkflowRecord(
      id: 'w2',
      name: 'Lease Onboarding - Green Heights',
      status: 'On Track',
      progress: 83,
      deadline: 'Apr 9, 2026',
      assignedUsers: ['Sara Wilson'],
      tasks: ['Document KYC', 'Contract Sign', 'Welcome Kit'],
    ),
    WorkflowRecord(
      id: 'w3',
      name: 'Maintenance Request - Block C',
      status: 'Blocked',
      progress: 34,
      deadline: 'Apr 11, 2026',
      assignedUsers: ['Aman Kapoor', 'Rohit Verma'],
      tasks: ['Vendor Assignment', 'Repair', 'Quality Check'],
    ),
  ];

  static const List<TemplateRecord> templates = [
    TemplateRecord(
      id: 't1',
      name: 'Move-Out Workflow',
      category: 'Tenancy',
      description: 'Checklist for smooth tenant move-out and closure.',
      steps: ['Notice confirmation', 'Inspection', 'Settlement', 'Handover'],
    ),
    TemplateRecord(
      id: 't2',
      name: 'Move-In Workflow',
      category: 'Tenancy',
      description: 'Structured move-in flow for new tenants.',
      steps: ['Agreement sign', 'Access setup', 'Orientation', 'Welcome note'],
    ),
    TemplateRecord(
      id: 't3',
      name: 'Periodic Inspection',
      category: 'Operations',
      description: 'Routine inspection checklist for units and common areas.',
      steps: ['Schedule visit', 'Safety checks', 'Notes', 'Report generation'],
    ),
    TemplateRecord(
      id: 't4',
      name: 'Maintenance Request',
      category: 'Operations',
      description: 'Process template for resident maintenance requests.',
      steps: ['Ticket intake', 'Assign vendor', 'Resolve issue', 'Confirm closure'],
    ),
    TemplateRecord(
      id: 't5',
      name: 'Lease Onboarding',
      category: 'Leasing',
      description: 'Onboarding flow for new lease activation.',
      steps: ['KYC', 'Payment setup', 'Move-in prep', 'Tenant kickoff'],
    ),
    TemplateRecord(
      id: 't6',
      name: 'Lease Renewal',
      category: 'Leasing',
      description: 'Renewal sequence with reminders and approvals.',
      steps: ['Renewal reminder', 'Negotiation', 'Contract update', 'Sign-off'],
    ),
    TemplateRecord(
      id: 't7',
      name: 'Rent Arrears Follow-Up',
      category: 'Finance',
      description: 'Follow-up cadence for overdue rent collections.',
      steps: ['Soft reminder', 'Call follow-up', 'Escalation', 'Resolution log'],
    ),
    TemplateRecord(
      id: 't8',
      name: 'Owner Update Checklist',
      category: 'Stakeholder',
      description: 'Periodic status updates for property owners.',
      steps: ['Performance summary', 'Open issues', 'Financial note', 'Next actions'],
    ),
  ];

  static const List<TaskRecord> tasks = [
    TaskRecord(
      id: 'tk1',
      title: 'Finalize move-out inspection',
      dueDate: 'Apr 7, 2026',
      priority: 'High',
      status: 'Pending',
      assignedUser: 'Priya Shah',
      notes: 'Tenant requested evening slot for final walkthrough.',
    ),
    TaskRecord(
      id: 'tk2',
      title: 'Upload lease renewal draft',
      dueDate: 'Apr 8, 2026',
      priority: 'Medium',
      status: 'In Progress',
      assignedUser: 'Karan Jain',
      notes: 'Add updated parking clause before review.',
    ),
    TaskRecord(
      id: 'tk3',
      title: 'Vendor follow-up for HVAC repair',
      dueDate: 'Apr 6, 2026',
      priority: 'High',
      status: 'Overdue',
      assignedUser: 'Aman Kapoor',
      notes: 'Escalate if no response by noon.',
    ),
    TaskRecord(
      id: 'tk4',
      title: 'Send owner monthly summary',
      dueDate: 'Apr 10, 2026',
      priority: 'Low',
      status: 'Done',
      assignedUser: 'Sara Wilson',
      notes: 'Attach occupancy trend chart snapshot.',
    ),
  ];

  static const List<AdminNotification> notifications = [
    AdminNotification(
      id: 'n1',
      title: 'Task update',
      type: 'Task',
      message: 'Finalize move-out inspection was marked In Progress.',
      time: '5 mins ago',
    ),
    AdminNotification(
      id: 'n2',
      title: 'Workflow update',
      type: 'Workflow',
      message: 'Lease Onboarding reached 83% completion.',
      time: '40 mins ago',
    ),
    AdminNotification(
      id: 'n3',
      title: 'System alert',
      type: 'System',
      message: 'Reminder queue reached 90% daily threshold.',
      time: '2 hours ago',
    ),
  ];

  static const List<ChartPoint> reportsDailyChart = [
    ChartPoint(label: 'Mon', value: 24),
    ChartPoint(label: 'Tue', value: 29),
    ChartPoint(label: 'Wed', value: 18),
    ChartPoint(label: 'Thu', value: 31),
    ChartPoint(label: 'Fri', value: 26),
  ];

  static const List<ChartPoint> reportsMonthlyChart = [
    ChartPoint(label: 'Jan', value: 72),
    ChartPoint(label: 'Feb', value: 68),
    ChartPoint(label: 'Mar', value: 80),
    ChartPoint(label: 'Apr', value: 76),
  ];
}
