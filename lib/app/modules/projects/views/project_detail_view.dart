import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/task_action_menu_sheet.dart';
import '../../../data/models/task_model.dart';
import '../controllers/projects_controller.dart';
import '../../task/views/task_detail_sheet.dart';
import '../../task/views/add_task_sheet.dart';
import 'package:karan/app/services/task_service.dart';
import '../../inbox/controllers/inbox_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectDetailView extends StatefulWidget {
  final Project project;
  const ProjectDetailView({super.key, required this.project});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  final ProjectsController controller = Get.find<ProjectsController>();
  @override
  void initState() {
    super.initState();
  }

  void _showInviteMember(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                child: Text(
                  'Invite to Project',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientButton(
                  label: 'Send Invite',
                  height: 46,
                  onPressed: () {
                    if (ctrl.text.isNotEmpty) {
                      Get.back();
                      Get.snackbar(
                        'Invitation Sent',
                        'An invite to this project has been sent to ${ctrl.text}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primaryColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_rounded, color: titleColor, size: 24.sp),
        ),
        title: Obx(() {
          final project =
              controller.projects.firstWhereOrNull(
                (p) => p.id == widget.project.id,
              ) ??
              widget.project;
          return Text(
            project.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => _showInviteMember(context),
            icon: Icon(
              Icons.person_add_alt_1_rounded,
              color: titleColor,
              size: 20.sp,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list_alt_rounded, color: titleColor, size: 20.sp),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: titleColor, size: 20.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final project =
              controller.projects.firstWhereOrNull(
                (p) => p.id == widget.project.id,
              ) ??
              widget.project;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            itemCount: project.phases.length,
            itemBuilder: (context, index) {
              final phase = project.phases[index];
              return _PhaseSection(
                project: project,
                phase: phase,
                isDark: isDark,
                onTaskToggle: (taskId, isCompleted) {
                  Get.find<TaskService>().toggleTaskCompletion(
                    taskId,
                    isCompleted,
                  );
                },
                onTaskTap: (task) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => TaskDetailSheet(
                      task: task,
                      onUpdate: (updatedTask) {
                        final updatedPhases = project.phases.map((p) {
                          if (p.id == phase.id) {
                            final updatedTasks = p.tasks.map((t) {
                              if (t.id == task.id) {
                                return updatedTask;
                              }
                              return t;
                            }).toList();
                            return p.copyWith(tasks: updatedTasks);
                          }
                          return p;
                        }).toList();
                        controller.updateProject(
                          project.copyWith(phases: updatedPhases),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'project_detail_add_fab',
        onPressed: () {
          final project =
              controller.projects.firstWhereOrNull(
                (p) => p.id == widget.project.id,
              ) ??
              widget.project;
          if (project.phases.isEmpty) return;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddTaskSheet(
              onSave: (task) async {
                await Get.find<InboxController>().createTaskFromSheet(
                  task,
                  projectId: project.id,
                );
              },
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.add, color: Colors.white, size: 24.sp),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _MenuRow({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDestructive ? Colors.red : AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _PhaseSection extends StatelessWidget {
  final Project project;
  final Phase phase;
  final bool isDark;
  final Function(String taskId, bool isCompleted) onTaskToggle;
  final Function(Task task) onTaskTap;

  const _PhaseSection({
    required this.project,
    required this.phase,
    required this.isDark,
    required this.onTaskToggle,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final totalCount = phase.tasks.length;
    final controller = Get.find<ProjectsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Text(
                phase.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: muted, size: 20),
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'add':
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddTaskSheet(
                          onSave: (task) async {
                            await Get.find<InboxController>()
                                .createTaskFromSheet(
                              task,
                              projectId: project.id,
                            );
                          },
                        ),
                      );
                      break;
                    case 'link':
                      controller.copyPhaseLink(phase.id);
                      break;
                    case 'rename':
                      _showRenameDialog(context, controller);
                      break;
                    case 'reorder':
                      // Placeholder
                      break;
                    case 'move':
                      // Placeholder
                      break;
                    case 'duplicate':
                      controller.duplicatePhase(project.id, phase.id);
                      break;
                    case 'archive':
                      controller.archivePhase(project.id, phase.id);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(context, controller);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'add',
                    child: _MenuRow(icon: Icons.add_rounded, label: 'Add task'),
                  ),
                  PopupMenuItem(
                    value: 'link',
                    child: _MenuRow(
                      icon: Icons.link_rounded,
                      label: 'Copy link to section',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'rename',
                    child: _MenuRow(
                      icon: Icons.edit_rounded,
                      label: 'Rename section',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'reorder',
                    child: _MenuRow(
                      icon: Icons.reorder_rounded,
                      label: 'Reorder section',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'move',
                    child: _MenuRow(
                      icon: Icons.drive_file_move_outline,
                      label: 'Move section',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: _MenuRow(
                      icon: Icons.copy_rounded,
                      label: 'Duplicate section',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'archive',
                    child: _MenuRow(
                      icon: Icons.archive_outlined,
                      label: 'Archive section',
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    child: _MenuRow(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete section',
                      isDestructive: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...phase.tasks.map((task) => _buildTaskCard(context, task, isDark)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, bool isDark) {
    return AppTaskCard(
      title: task.title,
      subtitle: task.desc,
      time: task.time,
      isDone: task.isCompleted,
      onCheckTap: (v) => onTaskToggle(task.id, v),
      onTap: () => onTaskTap(task),
      onMoreTap: () => _showTaskMenu(context, task),
      subtasks: task.subtasks
          .map((st) => _buildTaskCard(context, st, isDark))
          .toList(),
    );
  }

  void _showTaskMenu(BuildContext context, Task task) {
    showTaskActionMenu(
      context,
      task: task,
      onEditTask: () => onTaskTap(task),
    );
  }

  void _showRenameDialog(BuildContext context, ProjectsController controller) {
    final textController = TextEditingController(text: phase.title);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: const Text(
          'Rename Section',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter section title'),
          style: const TextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.renamePhase(
                  project.id,
                  phase.id,
                  textController.text.trim(),
                );
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Rename',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ProjectsController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: const Text(
          'Delete Section',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to delete "${phase.title}" and all its tasks?',
          style: const TextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deletePhase(project.id, phase.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
