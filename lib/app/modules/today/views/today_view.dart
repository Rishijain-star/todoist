import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/task_action_menu_sheet.dart';
import '../../../data/models/task_model.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../task/views/task_detail_sheet.dart';
import '../controllers/today_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import 'package:karan/app/services/task_service.dart';

// ═══════════════════════════════════════════════════
//  TODAY VIEW
// ═══════════════════════════════════════════════════
class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  final TodayController controller = Get.find<TodayController>();
  final SettingsController settings = Get.find<SettingsController>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final userName = 'Rohit'; // Matches the screenshot

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundLight,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 24,
        title: Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.REPORTS); // Or actual notification route if it exists
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    // Open display settings or filters
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        Future<void> onRefresh() =>
            Get.find<InboxController>().refreshTasks();

        if (controller.isLoading.value) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          );
        }

        if (controller.todayTasks.isEmpty && controller.overdueTasks.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.72,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  // Illustration Placeholder
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.cruelty_free_rounded,
                          size: 80,
                          color: AppColors.accentBlue.withOpacity(0.2),
                        ),
                        Positioned(
                          top: 30,
                          right: 30,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                      children: [
                        const TextSpan(
                          text: 'All clear, ',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: '$userName!',
                          style: const TextStyle(color: AppColors.accentBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nothing scheduled today. Relax and recharge — you\'ve earned it!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text(
                      'Share #TaskererZero',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentBlue,
                      side: BorderSide(
                        color: AppColors.accentBlue.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: _TodayMainContent(
            isDark: isDark,
            textColor: textColor,
            currentLayout: 0,
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
          ),
        );
      }),
    );
  }
}

class _TodayMainContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final int currentLayout;
  final bool isNextDay;
  final ScrollPhysics? scrollPhysics;

  const _TodayMainContent({
    required this.isDark,
    required this.textColor,
    required this.currentLayout,
    this.isNextDay = false,
    this.scrollPhysics,
  });

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    bool isDark,
    bool hideCompletedSubtasks,
  ) {
    final subs = hideCompletedSubtasks
        ? task.subtasks.where((s) => !s.isCompleted).toList()
        : task.subtasks;
    return AppTaskCard(
      title: task.title,
      subtitle: task.desc,
      time: task.time ?? (task.dueToday ? 'Today' : null),
      category: task.status,
      dotColor: task.priority == 1
          ? AppColors.red
          : task.priority == 2
          ? AppColors.gold
          : task.priority == 3
          ? AppColors.primaryColor
          : null,
      isDone: task.isCompleted,
      isOverdue: !isNextDay && task.dueDate != null && task.dueDate!.isBefore(DateTime.now()),
      onCheckTap: (v) {
        Get.find<TaskService>().toggleTaskCompletion(task.id, v);
      },
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => TaskDetailSheet(task: task),
      ),
      onMoreTap: () => showTaskActionMenu(context, task: task),
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayController>();
    return SingleChildScrollView(
      physics: scrollPhysics,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Today Title and Task Count
          Text(
            isNextDay ? 'Tomorrow' : 'Today',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Text(
            isNextDay ? '5 tasks' : '3 tasks',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),

          if (!isNextDay)
            Obx(
              () => AppSummaryCard(
                greeting: 'Good Morning',
                name: 'Karan',
                date: 'Sun, 8 Mar',
                completedTasks: controller.completedCount,
                totalTasks: controller.totalCount,
                motivation:
                    '${controller.totalCount - controller.completedCount} more to go — you\'re killing it!',
              ),
            ),
          const SizedBox(height: 32),

          // Overdue Section (Image 2)
          Obx(() {
            if (isNextDay || controller.overdueTasks.isEmpty) {
              return const SizedBox.shrink();
            }
            final hide =
                Get.find<InboxController>().hideCompletedSubtasks.value;
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Overdue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.overdueTasks.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Reschedule',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...controller.overdueTasks.map(
                  (task) =>
                      _buildTaskCard(context, task, isDark, hide),
                ),
                const SizedBox(height: 24),
              ],
            );
          }),

          // Today's Tasks Header
          Row(
            children: [
              Text(
                isNextDay ? 'Tomorrow\'s Tasks' : 'Today\'s Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                'View all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Obx(
            () {
              final hide =
                  Get.find<InboxController>().hideCompletedSubtasks.value;
              return Column(
                children: controller.todayTasks
                    .map(
                      (task) =>
                          _buildTaskCard(context, task, isDark, hide),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _TodayFullShimmer extends StatelessWidget {
  final bool isDark;
  const _TodayFullShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final currentLayout = Get.find<SettingsController>().layout.value;

    return Shimmer(
      child: Container(
        color: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Row(
                children: [
                  ShimmerBox(
                    height: 32,
                    width: 32,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ShimmerBox(
                      height: 18,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 16),
                  ShimmerBox(
                    height: 22,
                    width: 22,
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                  SizedBox(width: 12),
                  ShimmerBox(
                    height: 22,
                    width: 22,
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppSummaryCard.shimmer(),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 16),
                  ShimmerBox(
                    height: 14,
                    width: 64,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (currentLayout == 1) // Board skeleton
                SizedBox(
                  height: 400,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _BoardColumn(
                        title: 'To Do',
                        count: 0,
                        tasks: [
                          AppTaskCard.shimmer(isDark: isDark),
                          AppTaskCard.shimmer(isDark: isDark),
                        ],
                        isDark: isDark,
                      ),
                      const SizedBox(width: 16),
                      _BoardColumn(
                        title: 'In Progress',
                        count: 0,
                        tasks: [AppTaskCard.shimmer(isDark: isDark)],
                        isDark: isDark,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    AppTaskCard.shimmer(isDark: isDark),
                    AppTaskCard.shimmer(isDark: isDark),
                    AppTaskCard.shimmer(isDark: isDark),
                    AppTaskCard.shimmer(isDark: isDark),
                  ],
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Board Widgets ───────────────────────────────────────────────────────────
class _BoardColumn extends StatelessWidget {
  final String title;
  final int count;
  final List<Widget> tasks;
  final bool isDark;

  const _BoardColumn({
    required this.title,
    required this.count,
    required this.tasks,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.cardSecondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkBorder : AppColors.borderLight)
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 18,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                if (i == tasks.length) {
                  return _AddCardButton(isDark: isDark);
                }
                return tasks[i];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCardButton extends StatelessWidget {
  final bool isDark;
  const _AddCardButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? AppColors.darkBorder : AppColors.borderLight)
              .withOpacity(0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_rounded,
            size: 18,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
          const SizedBox(width: 4),
          Text(
            'Add task',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZenPainter extends CustomPainter {
  final bool isDark;
  const _ZenPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size s) {
    // Glow
    canvas.drawCircle(
      Offset(s.width / 2, s.height * 0.75),
      s.width * 0.35,
      Paint()
        ..color = AppColors.primaryColor.withOpacity(0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Body
    final bodyP = Paint()..color = AppColors.primaryColor.withOpacity(0.2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s.width / 2, s.height * 0.72),
        width: s.width * 0.4,
        height: s.height * 0.42,
      ),
      bodyP,
    );

    // Head
    canvas.drawCircle(
      Offset(s.width / 2, s.height * 0.42),
      s.width * 0.13,
      Paint()..color = AppColors.primaryColor.withOpacity(0.25),
    );

    // Arms
    final armP = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.2)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(s.width * 0.35, s.height * 0.6),
      Offset(s.width * 0.18, s.height * 0.68),
      armP,
    );
    canvas.drawLine(
      Offset(s.width * 0.65, s.height * 0.6),
      Offset(s.width * 0.82, s.height * 0.68),
      armP,
    );

    // Gold wings
    final wingP = Paint()..color = AppColors.gold.withOpacity(0.8);
    final wL = Path()
      ..moveTo(s.width * 0.4, s.height * 0.55)
      ..cubicTo(
        s.width * 0.1,
        s.height * 0.35,
        s.width * 0.05,
        s.height * 0.52,
        s.width * 0.22,
        s.height * 0.65,
      )
      ..close();
    final wR = Path()
      ..moveTo(s.width * 0.6, s.height * 0.55)
      ..cubicTo(
        s.width * 0.9,
        s.height * 0.35,
        s.width * 0.95,
        s.height * 0.52,
        s.width * 0.78,
        s.height * 0.65,
      )
      ..close();
    canvas.drawPath(wL, wingP);
    canvas.drawPath(wR, wingP);

    // Floating orbs
    final orbColors = [
      AppColors.gold,
      AppColors.accentBlue,
      AppColors.primaryColor,
    ];
    final orbPos = [
      Offset(s.width * 0.12, s.height * 0.25),
      Offset(s.width * 0.88, s.height * 0.3),
      Offset(s.width * 0.78, s.height * 0.1),
    ];
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        orbPos[i],
        s.width * 0.04,
        Paint()..color = orbColors[i].withOpacity(0.5),
      );
    }

    // Legs
    final legP = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.2)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(s.width * 0.42, s.height * 0.88),
      Offset(s.width * 0.35, s.height * 0.98),
      legP,
    );
    canvas.drawLine(
      Offset(s.width * 0.58, s.height * 0.88),
      Offset(s.width * 0.65, s.height * 0.98),
      legP,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
