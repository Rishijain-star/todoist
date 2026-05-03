import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/task_model.dart';
import '../../modules/inbox/controllers/inbox_controller.dart';
import '../const/app_colors.dart';
import '../const/user_assets.dart';
import '../../modules/task/views/task_detail_sheet.dart';
import 'app_widgets.dart';

/// Standard task overflow menu — design-system PNG icons + high-contrast labels.
void showTaskActionMenu(
  BuildContext rootContext, {
  required Task task,
  bool nestedInDetailSheet = false,
  /// When set, called instead of opening [TaskDetailSheet] for Edit.
  VoidCallback? onEditTask,
}) {
  showModalBottomSheet<void>(
    context: rootContext,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => TaskActionMenuSheet(
      task: task,
      rootContext: rootContext,
      sheetContext: sheetContext,
      nestedInDetailSheet: nestedInDetailSheet,
      onEditTask: onEditTask,
    ),
  );
}

class TaskActionMenuSheet extends StatelessWidget {
  final Task task;
  final BuildContext rootContext;
  final BuildContext sheetContext;
  final bool nestedInDetailSheet;
  final VoidCallback? onEditTask;

  const TaskActionMenuSheet({
    super.key,
    required this.task,
    required this.rootContext,
    required this.sheetContext,
    this.nestedInDetailSheet = false,
    this.onEditTask,
  });

  static const double _iconBox = 24;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.card;
    final border = isDark ? AppColors.darkBorderLight : AppColors.borderLight;
    final inbox = Get.find<InboxController>();

    final titleStyle = GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
    );
    final subtitleStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.darkTextMuted : AppColors.textSecondary,
    );

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: border.withValues(alpha: 0.6))),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          _MenuRow(
            asset: UserAssets.iconTaskEdit,
            title: 'Edit Task',
            subtitle: 'Change title, notes, and due date',
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            onTap: () {
              Navigator.pop(sheetContext);
              if (onEditTask != null) {
                Future.microtask(() => onEditTask!());
              } else {
                Future.microtask(
                  () => showModalBottomSheet<void>(
                    context: rootContext,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => TaskDetailSheet(task: task),
                  ),
                );
              }
            },
          ),
          _MenuRow(
            asset: UserAssets.iconTaskDuplicate,
            title: 'Duplicate Task',
            subtitle: 'Create a copy in your inbox',
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            onTap: () {
              Navigator.pop(sheetContext);
              inbox.duplicateTask(task);
              Get.snackbar(
                'Duplicated',
                'Task duplicated successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryColor,
                colorText: AppColors.white,
                margin: const EdgeInsets.all(16),
              );
            },
          ),
          _MenuRow(
            asset: UserAssets.iconTaskLink,
            title: 'Copy Link to Task',
            subtitle: 'Clipboard deep link',
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            onTap: () async {
              final link = 'https://taskerer.net/task/${task.id}';
              await Clipboard.setData(ClipboardData(text: link));
              if (sheetContext.mounted) Navigator.pop(sheetContext);
              Get.snackbar(
                'Copied',
                'Task link copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryColor,
                colorText: AppColors.white,
                margin: const EdgeInsets.all(16),
              );
            },
          ),
          Obx(
            () => _MenuRow(
              asset: UserAssets.iconTaskHideSubtasks,
              title: 'Hide Completed Subtasks',
              subtitle: inbox.hideCompletedSubtasks.value
                  ? 'Filter is on — tap to show all'
                  : 'Tap to hide done subtasks',
              titleStyle: titleStyle,
              subtitleStyle: subtitleStyle,
              onTap: () {
                final wasOn = inbox.hideCompletedSubtasks.value;
                Navigator.pop(sheetContext);
                inbox.toggleHideCompletedSubtasks();
                Get.snackbar(
                  wasOn ? 'Showing all' : 'Filtered',
                  wasOn
                      ? 'All subtasks are visible again'
                      : 'Completed subtasks are hidden in lists',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primaryColor,
                  colorText: AppColors.white,
                  margin: const EdgeInsets.all(16),
                );
              },
            ),
          ),
          _MenuRow(
            asset: UserAssets.iconTaskActivity,
            title: 'View Activity',
            subtitle: 'Comments and updates',
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            onTap: () {
              Navigator.pop(sheetContext);
              _showActivityDialog(rootContext, task, isDark);
            },
          ),
          _MenuRow(
            asset: UserAssets.iconTaskEmail,
            title: 'Email to This Task',
            subtitle: 'Open your mail app',
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            onTap: () async {
              final subject = 'Task: ${task.title}';
              final body =
                  'Open in Tasker:\nhttps://taskerer.net/task/${task.id}';
              final uri = Uri(
                scheme: 'mailto',
                path: '',
                queryParameters: <String, String>{
                  'subject': subject,
                  'body': body,
                },
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else if (rootContext.mounted) {
                Get.snackbar(
                  'Email',
                  'No mail app available. Link is in the task details.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              }
              if (sheetContext.mounted) Navigator.pop(sheetContext);
            },
          ),
          const Divider(height: 1),
          _MenuRow(
            asset: UserAssets.iconTaskDelete,
            title: 'Delete Task',
            subtitle: 'Remove from your inbox',
            titleStyle: titleStyle.copyWith(color: AppColors.red),
            subtitleStyle: subtitleStyle,
            onTap: () => _confirmDelete(
              rootContext,
              sheetContext,
              task,
              nestedInDetailSheet,
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDialog(BuildContext context, Task task, bool isDark) {
    final fmt = DateFormat.MMMd().add_jm();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.card,
        title: Text(
          'Activity',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: task.comments.isEmpty
              ? Text(
                  'No comments yet. Open the task to add activity.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  children: task.comments
                      .map(
                        (c) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            c.userName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            c.text,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          trailing: Text(
                            fmt.format(c.timestamp),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext rootContext,
    BuildContext sheetContext,
    Task task,
    bool nestedInDetailSheet,
  ) async {
    final isDark = Theme.of(rootContext).brightness == Brightness.dark;
    final ok = await showDialog<bool>(
      context: rootContext,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.card,
        title: Text(
          'Delete task?',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: Text(
          '“${task.title}” will be removed from your inbox.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;
    if (!sheetContext.mounted) return;
    Navigator.pop(sheetContext);
    if (nestedInDetailSheet && rootContext.mounted) {
      Navigator.pop(rootContext);
    }
    Get.find<InboxController>().deleteTask(task.id);
    Get.snackbar(
      'Deleted',
      'Task removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: TaskActionMenuSheet._iconBox,
              height: TaskActionMenuSheet._iconBox,
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: subtitleStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
