import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../task/views/add_task_sheet.dart';
import '../../task/views/task_detail_sheet.dart';

import '../controllers/inbox_controller.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});
  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final _controller = Get.find<InboxController>();
  final _tasks = <Task>[
    Task(
      title: 'Rohit',
      desc: 'Meeting at four pm',
      dueToday: true,
      commentCount: 1,
    ),
    Task(
      title: 'Call client at 3pm',
      desc: '',
      dueToday: true,
      commentCount: 0,
      priority: 1,
    ),
    Task(
      title: 'Review design mockups',
      desc: 'Check all screens and feedback',
      dueToday: false,
      commentCount: 2,
      priority: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: _InboxAppBar(isDark: isDark),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return _InboxShimmer(isDark: isDark);
        }
        return _tasks.isEmpty
            ? _EmptyInbox()
            : _TaskList(tasks: _tasks, onAddTask: _openAddTask);
      }),
      floatingActionButton: GradientFAB(onPressed: _openAddTask),
    );
  }

  void _openAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(
        onSave: (task) {
          setState(() => _tasks.add(task));
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

// ── App Bar ───────────────────────────────────────────────────────────────────
class _InboxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  const _InboxAppBar({required this.isDark});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      title: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            fontFamily: 'Nunito',
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
            const TextSpan(
              text: 'erer',
              style: TextStyle(color: AppColors.accentBlue),
            ),
          ],
        ),
      ),
      actions: [
        AppIconButton(
          icon: Icon(
            Icons.dashboard_customize_outlined,
            size: 17,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        AppIconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 17,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

// ── Empty Inbox ────────────────────────────────────────────────────────────────
class _EmptyInbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Inbox tray illustration
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gold.withOpacity(0.8), AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Drop tasks, plan later',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your inbox is clear.\nAdd something to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                fontFamily: 'Nunito',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Task List ─────────────────────────────────────────────────────────────────
class _TaskList extends StatelessWidget {
  final List<Task> tasks;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
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
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${tasks.length}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
        ...tasks.map(
          (t) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: AppTaskCard(
              title: t.title,
              subtitle: t.desc,
              time: t.dueToday ? 'Today' : null,
              commentCount: t.commentCount,
              dotColor: _priorityColor(t.priority),
              onCheckTap: (v) {
                // Future: Update task status in controller
              },
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => TaskDetailSheet(task: t),
              ),
            ),
          ),
        ),
        // Add task row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: GestureDetector(
            onTap: onAddTask,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
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
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Task Model ────────────────────────────────────────────────────────────────
class Task {
  final String title;
  final String desc;
  final bool dueToday;
  final int commentCount;
  final int priority; // 1=red, 2=gold, 3=blue, 4=none

  Task({
    required this.title,
    required this.desc,
    required this.dueToday,
    required this.commentCount,
    this.priority = 4,
  });
}
