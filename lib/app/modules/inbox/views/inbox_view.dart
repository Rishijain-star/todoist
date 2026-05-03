import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/user_assets.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/task_action_menu_sheet.dart';
import '../../task/views/add_task_sheet.dart';
import '../../task/views/task_detail_sheet.dart';
import '../../../data/models/task_model.dart';
import '../controllers/inbox_controller.dart';
import 'package:karan/app/services/task_service.dart';

class InboxView extends GetView<InboxController> {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: _InboxAppBar(isDark: isDark),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshTasks(),
        child: Obx(() {
          final h = MediaQuery.sizeOf(context).height * 0.72;
          final loading = controller.isLoading.value;
          final tasks = controller.tasks;

          if (loading) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: h,
                  child: _InboxShimmer(isDark: isDark),
                ),
              ],
            );
          }

          if (tasks.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [SizedBox(height: h, child: const _EmptyInbox())],
            );
          }

          switch (controller.layoutMode.value) {
            case InboxLayoutMode.board:
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: h,
                    child: _TaskBoard(
                      tasks: controller.tasks,
                      onAddTask: () => _openAddTask(context),
                    ),
                  ),
                ],
              );
            case InboxLayoutMode.calendar:
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: h,
                    child: _TaskCalendar(
                      tasks: controller.tasks,
                      onAddTask: () => _openAddTask(context),
                    ),
                  ),
                ],
              );
            case InboxLayoutMode.list:
              return _TaskList(
                tasks: controller.tasks,
                onAddTask: () => _openAddTask(context),
              );
          }
        }),
      ),
    );
  }

  void _openAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(
        onSave: (task) async {
          await controller.createTaskFromSheet(task);
        },
      ),
    );
  }
}

class _InboxShimmer extends StatelessWidget {
  final bool isDark;
  const _InboxShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Row(
              children: const [
                ShimmerBox(
                  height: 10,
                  width: 80,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(width: 8),
                ShimmerBox(
                  height: 10,
                  width: 20,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          AppTaskCard.shimmer(isDark: isDark),
          AppTaskCard.shimmer(isDark: isDark),
          AppTaskCard.shimmer(isDark: isDark),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Row(
              children: const [
                ShimmerBox(
                  height: 10,
                  width: 60,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          AppTaskCard.shimmer(isDark: isDark),
        ],
      ),
    );
  }
}

class _InboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  const _InboxAppBar({required this.isDark});

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    final subtitleColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textPrimary;
    return AppBar(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      elevation: 0,
      titleSpacing: 24,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                height: 1.05,
              ),
              children: [
                TextSpan(
                  text: 'Task',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: 'er',
                  style: TextStyle(color: AppColors.brandAccent),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Inbox',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: subtitleColor,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              AppIconButton(
                icon: Icon(
                  Icons.grid_view_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                onTap: () => _showDisplaySettings(context, isDark),
              ),
              const SizedBox(width: 12),
              AppIconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDisplaySettings(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DisplaySettingsSheet(isDark: isDark),
    );
  }
}

class _DisplaySettingsSheet extends StatefulWidget {
  final bool isDark;
  const _DisplaySettingsSheet({required this.isDark});

  @override
  State<_DisplaySettingsSheet> createState() => _DisplaySettingsSheetState();
}

class _DisplaySettingsSheetState extends State<_DisplaySettingsSheet> {
  int _layout = Get.find<InboxController>().layoutMode.value.index;
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = widget.isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              children: [
                Text(
                  'Display',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const Spacer(),
                Icon(Icons.help_outline_rounded, color: muted, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LAYOUT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _LayoutItem(
                      icon: Icons.format_list_bulleted_rounded,
                      label: 'List',
                      isSelected: _layout == 0,
                      isDark: widget.isDark,
                      onTap: () => setState(() => _layout = 0),
                    ),
                    _LayoutItem(
                      icon: Icons.dashboard_customize_outlined,
                      label: 'Board',
                      isSelected: _layout == 1,
                      isDark: widget.isDark,
                      onTap: () => setState(() => _layout = 1),
                    ),
                    _LayoutItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'Calendar',
                      isSelected: _layout == 2,
                      isDark: widget.isDark,
                      onTap: () => setState(() => _layout = 2),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: muted,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Completed tasks',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _showCompleted,
                      activeColor: AppColors.primaryColor,
                      onChanged: (v) => setState(() => _showCompleted = v),
                    ),
                  ],
                ),
                const Divider(height: 48),
                Text(
                  'SORT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                _SettingRow(
                  icon: Icons.layers_outlined,
                  label: 'Grouping',
                  value: 'None',
                  isDark: widget.isDark,
                ),
                const SizedBox(height: 20),
                _SettingRow(
                  icon: Icons.swap_vert_rounded,
                  label: 'Sorting',
                  value: 'Manual',
                  isDark: widget.isDark,
                ),
                const Divider(height: 48),
                Text(
                  'FILTER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: muted,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                _SettingRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: 'All',
                  isDark: widget.isDark,
                ),
                const SizedBox(height: 20),
                _SettingRow(
                  icon: Icons.flag_outlined,
                  label: 'Priority',
                  value: 'All',
                  isDark: widget.isDark,
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Done',
                  onPressed: () {
                    final controller = Get.find<InboxController>();
                    controller.setLayoutMode(InboxLayoutMode.values[_layout]);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskBoard extends StatelessWidget {
  final RxList<Task> tasks;
  final VoidCallback onAddTask;
  const _TaskBoard({required this.tasks, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final sections = {
      'Pending': tasks
          .where((t) => t.status.toLowerCase().contains('pending'))
          .toList(),
      'In Progress': tasks
          .where((t) => t.status.toLowerCase().contains('progress'))
          .toList(),
      'Done': tasks
          .where(
            (t) => t.isCompleted || t.status.toLowerCase().contains('done'),
          )
          .toList(),
    };
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      children: sections.entries.map((entry) {
        return Container(
          width: 280,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(
                child: ListView(
                  children: entry.value
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AppTaskCard(
                            title: t.title,
                            subtitle: t.desc,
                            category: t.status,
                            isDone: t.isCompleted,
                            onCheckTap: (v) => Get.find<TaskService>()
                                .toggleTaskCompletion(t.id, v),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TaskCalendar extends StatelessWidget {
  final RxList<Task> tasks;
  final VoidCallback onAddTask;
  const _TaskCalendar({required this.tasks, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Task>>{};
    for (final task in tasks) {
      final key = task.dueDate == null
          ? 'No date'
          : '${task.dueDate!.year}-${task.dueDate!.month.toString().padLeft(2, '0')}-${task.dueDate!.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(task);
    }
    final keys = grouped.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final dayTasks = grouped[key]!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(key, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              ...dayTasks.map(
                (t) => AppTaskCard(
                  title: t.title,
                  subtitle: t.desc,
                  category: t.status,
                  isDone: t.isCompleted,
                  onCheckTap: (v) =>
                      Get.find<TaskService>().toggleTaskCompletion(t.id, v),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LayoutItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LayoutItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColors.primaryColor
        : (isDark ? AppColors.darkTextMuted : AppColors.textMuted);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : (isDark
                        ? AppColors.darkBackground
                        : AppColors.backgroundLight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            size: 18,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Row(
      children: [
        Icon(icon, color: muted, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final imgW = (w * 0.68).clamp(180.0, 280.0);
        final imgH = (constraints.maxHeight * 0.36).clamp(190.0, 300.0);
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: imgW,
                  height: imgH,
                  child: Image.asset(
                    UserAssets.inboxEmptyIllustration,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your inbox is clear. Add something to get started.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: bodyColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  final RxList<Task> tasks;
  final VoidCallback onAddTask;
  const _TaskList({required this.tasks, required this.onAddTask});

  Color? _priorityColor(int p) {
    switch (p) {
      case 1:
        return AppColors.red;
      case 2:
        return AppColors.gold;
      case 3:
        return AppColors.primaryColor;
      default:
        return null;
    }
  }

  Widget _buildTaskCard(
    BuildContext context,
    Task t,
    bool isDark,
    bool hideCompletedSubtasks,
  ) {
    final subs = hideCompletedSubtasks
        ? t.subtasks.where((s) => !s.isCompleted).toList()
        : t.subtasks;
    return AppTaskCard(
      title: t.title,
      subtitle: t.desc,
      time: t.time ?? (t.dueToday ? 'Today' : null),
      category: t.status,
      commentCount: t.commentCount,
      dotColor: _priorityColor(t.priority),
      isDone: t.isCompleted,
      onCheckTap: (v) {
        Get.find<TaskService>().toggleTaskCompletion(t.id, v);
      },
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => TaskDetailSheet(task: t),
      ),
      onMoreTap: () => _showTaskMenu(context, t),
      subtasks: subs
          .map(
            (st) => _buildTaskCard(
              context,
              st,
              isDark,
              hideCompletedSubtasks,
            ),
          )
          .toList(),
    );
  }

  void _showTaskMenu(BuildContext context, Task task) {
    showTaskActionMenu(context, task: task);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inbox = Get.find<InboxController>();
    return Obx(
      () {
        final hide = inbox.hideCompletedSubtasks.value;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            child: Row(
              children: [
                Text(
                  'NO SECTION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${tasks.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          ...tasks.map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _buildTaskCard(context, t, isDark, hide),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: GestureDetector(
              onTap: onAddTask,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 13,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Add task',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        );
      },
    );
  }
}
