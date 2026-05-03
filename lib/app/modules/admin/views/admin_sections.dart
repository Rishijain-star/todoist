import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../controllers/admin_controller.dart';
import '../widgets/admin_components.dart';

class DashboardSection extends StatelessWidget {
  final AdminController controller;
  const DashboardSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.dashboardMetrics
              .map(
                (metric) => SizedBox(
                  width: 220,
                  child: AdminSurfaceCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: metric.color.withValues(alpha: 0.14),
                          child: Icon(metric.icon, color: metric.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(metric.value, style: Theme.of(context).textTheme.titleLarge),
                              Text(metric.title, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tasks Completed (Weekly)', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    AdminSimpleBarChart(
                      points: controller.weeklyTaskChart,
                      maxValue: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Workflow Progress Overview', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...controller.workflowProgressChart.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(item.label, style: Theme.of(context).textTheme.bodyMedium)),
                                Text('${item.value.toInt()}%'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: item.value / 100,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...controller.activities.map(
                (activity) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bolt_rounded, color: AppColors.primaryColor),
                  title: Text(activity.title),
                  subtitle: Text(activity.subtitle),
                  trailing: Text(activity.time),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UsersSection extends StatelessWidget {
  final AdminController controller;
  const UsersSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Add User'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(decoration: InputDecoration(labelText: 'Name')),
                    SizedBox(height: 10),
                    TextField(decoration: InputDecoration(labelText: 'Email')),
                    SizedBox(height: 10),
                    TextField(decoration: InputDecoration(labelText: 'Role')),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
                ],
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add User'),
          ),
        ),
        const SizedBox(height: 10),
        AdminSurfaceCard(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: controller.users
                  .map(
                    (user) => DataRow(
                      cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.role)),
                        DataCell(AdminStatusChip(label: user.status)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_outlined)),
                              IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
                              IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class WorkflowsSection extends StatelessWidget {
  final AdminController controller;
  const WorkflowsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedWorkflow;
    if (selected != null) {
      return ListView(
        children: [
          TextButton.icon(
            onPressed: controller.closeWorkflowDetail,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to workflows'),
          ),
          const SizedBox(height: 8),
          AdminSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selected.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Row(children: [AdminStatusChip(label: selected.status), const SizedBox(width: 10), Text('Deadline: ${selected.deadline}')]),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: selected.progress / 100, minHeight: 10, borderRadius: BorderRadius.circular(8)),
                const SizedBox(height: 8),
                Text('Progress: ${selected.progress}%'),
                const SizedBox(height: 12),
                Text('Assigned Users', style: Theme.of(context).textTheme.titleMedium),
                ...selected.assignedUsers.map((user) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.person_outline), title: Text(user))),
                const SizedBox(height: 8),
                Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
                ...selected.tasks.map((task) => CheckboxListTile(value: true, onChanged: (_) {}, title: Text(task), controlAffinity: ListTileControlAffinity.leading)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.workflows
              .map(
                (workflow) => SizedBox(
                  width: 300,
                  child: AdminSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workflow.name, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(children: [AdminStatusChip(label: workflow.status), const Spacer(), Text('${workflow.progress}%')]),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: workflow.progress / 100, minHeight: 8, borderRadius: BorderRadius.circular(8)),
                        const SizedBox(height: 8),
                        Text('Deadline: ${workflow.deadline}'),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => controller.openWorkflowDetail(workflow.id),
                            child: const Text('View Details'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class TemplatesSection extends StatelessWidget {
  final AdminController controller;
  const TemplatesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedTemplate;
    if (selected != null) {
      return ListView(
        children: [
          TextButton.icon(
            onPressed: controller.closeTemplateDetail,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to template library'),
          ),
          const SizedBox(height: 8),
          AdminSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selected.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(selected.description),
                const SizedBox(height: 12),
                ...selected.steps.asMap().entries.map(
                  (entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(radius: 13, child: Text('${entry.key + 1}')),
                    title: Text(entry.value),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return ListView(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.templates.take(10).map((template) {
            return SizedBox(
              width: 270,
              child: AdminSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(template.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(template.category, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(template.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => controller.openTemplateDetail(template.id),
                        child: const Text('Open'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TasksSection extends StatelessWidget {
  final AdminController controller;
  const TasksSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedTask;
    if (selected != null) {
      return ListView(
        children: [
          TextButton.icon(
            onPressed: controller.closeTaskDetail,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to tasks'),
          ),
          const SizedBox(height: 8),
          AdminSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selected.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Row(children: [AdminStatusChip(label: selected.status), const SizedBox(width: 8), Text('Due: ${selected.dueDate}')]),
                const SizedBox(height: 12),
                const TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Notes')),
                const SizedBox(height: 12),
                const TextField(maxLines: 2, decoration: InputDecoration(labelText: 'Comments')),
                const SizedBox(height: 12),
                OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file_outlined), label: const Text('Upload Files')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selected.status,
                  items: const ['Pending', 'In Progress', 'Done', 'Overdue']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (_) {},
                  decoration: const InputDecoration(labelText: 'Status Update'),
                ),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Reminder UI (date/time placeholder)')),
              ],
            ),
          ),
        ],
      );
    }
    return ListView(
      children: [
        AdminSurfaceCard(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Due Date')),
                DataColumn(label: Text('Priority')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Assigned User')),
              ],
              rows: controller.tasks
                  .map(
                    (task) => DataRow(
                      onSelectChanged: (_) => controller.openTaskDetail(task.id),
                      cells: [
                        DataCell(Text(task.title)),
                        DataCell(Text(task.dueDate)),
                        DataCell(Text(task.priority)),
                        DataCell(AdminStatusChip(label: task.status)),
                        DataCell(Text(task.assignedUser)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationsSection extends StatelessWidget {
  final AdminController controller;
  const NotificationsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminSurfaceCard(
          child: Row(
            children: [
              const Icon(Icons.notifications_outlined, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text('Bell dropdown preview', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...controller.notifications.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AdminSurfaceCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.notifications_none_rounded)),
                title: Text(item.title),
                subtitle: Text(item.message),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [AdminStatusChip(label: item.type), const SizedBox(height: 6), Text(item.time)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportsSection extends StatelessWidget {
  final AdminController controller;
  const ReportsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _ReportMetric(title: 'Completed Tasks', value: '1,120'),
            _ReportMetric(title: 'Overdue Tasks', value: '73'),
            _ReportMetric(title: 'Active Users', value: '894'),
          ],
        ),
        const SizedBox(height: 16),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daily Activity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AdminSimpleBarChart(
                points: controller.reportsDailyChart,
                maxValue: 32,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monthly Summary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AdminSimpleBarChart(
                points: controller.reportsMonthlyChart,
                maxValue: 90,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportMetric extends StatelessWidget {
  final String title;
  final String value;
  const _ReportMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: AdminSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('General Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(labelText: 'Organization Name')),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(labelText: 'Default Timezone')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Email notifications')),
              SwitchListTile(value: true, onChanged: (_) {}, title: const Text('Push notifications')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Twilio / SMS Config (Placeholder)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(labelText: 'Account SID')),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(labelText: 'Auth Token')),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(labelText: 'From Number')),
            ],
          ),
        ),
      ],
    );
  }
}
