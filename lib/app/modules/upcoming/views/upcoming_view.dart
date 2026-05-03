import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../task/views/task_detail_sheet.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../controllers/upcoming_controller.dart';
import 'package:karan/app/services/task_service.dart';

class UpcomingView extends StatefulWidget {
  const UpcomingView({super.key});

  @override
  State<UpcomingView> createState() => _UpcomingViewState();
}

class _UpcomingViewState extends State<UpcomingView> {
  final UpcomingController _controller = Get.find<UpcomingController>();
  final Map<DateTime, GlobalKey> _dateKeys = {};

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    String base = DateFormat('EEEE, d MMM').format(date);
    if (taskDate == today) return '$base · Today';
    if (taskDate == tomorrow) return '$base · Tomorrow';
    return base;
  }

  List<DateTime> _getWeekDays(DateTime centerDate) {
    // Show 7 days starting from 3 days before centerDate
    return List.generate(
      7,
      (index) => centerDate.add(Duration(days: index - 3)),
    );
  }

  void _scrollToDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    _controller.selectDate(dateOnly);

    // Find the actual date to scroll to (either exact match or nearest future date)
    final grouped = _controller.groupedTasks;
    final sortedDates = grouped.keys.toList()..sort();

    DateTime? targetDate;
    if (grouped.containsKey(dateOnly)) {
      targetDate = dateOnly;
    } else {
      // Find the first date after the selected one
      for (var d in sortedDates) {
        if (d.isAfter(dateOnly)) {
          targetDate = d;
          break;
        }
      }
    }

    if (targetDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _dateKeys[targetDate];
        if (key != null && key.currentContext != null) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
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
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 24,
        title: Text(
          'Upcoming',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                AppIconButton(
                  icon: Icon(
                    Icons.article_outlined,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                AppIconButton(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        Future<void> onRefresh() async {
          await Get.find<InboxController>().refreshTasks();
          await _controller.loadUpcoming(silent: false);
        }

        if (_controller.isLoading.value) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  child: _UpcomingShimmer(isDark: isDark),
                ),
              ],
            ),
          );
        }

        final selectedDate = _controller.selectedDate.value;
        final weekDays = _getWeekDays(selectedDate);
        final grouped = _controller.groupedTasks;
        final sortedDates = grouped.keys.toList()..sort();

        // Pre-generate keys for all dates to ensure we can scroll to them
        for (var date in sortedDates) {
          _dateKeys[date] ??= GlobalKey();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Year Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Horizontal Week Calendar
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  final day = weekDays[index];
                  final isSelected =
                      day.year == selectedDate.year &&
                      day.month == selectedDate.month &&
                      day.day == selectedDate.day;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () => _scrollToDate(day),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('E').format(day)[0], // M, T, W...
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.accentBlue
                                  : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accentBlue
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // Scrollable Grouped Tasks List
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: sortedDates.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.45,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_available_rounded,
                                    size: 64,
                                    color: AppColors.textMuted.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No upcoming tasks',
                                    style: TextStyle(
                                      fontSize: 16,
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
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        final date = sortedDates[index];
                        final tasks = grouped[date]!;

                        return Column(
                          key: _dateKeys[date],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                _formatDateHeader(date),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      date.day == selectedDate.day &&
                                          date.month == selectedDate.month
                                      ? AppColors.accentBlue
                                      : textColor,
                                ),
                              ),
                            ),
                            ...tasks.map(
                              (task) => AppTaskCard(
                                title: task.title,
                                subtitle: task.desc,
                                time: task.time,
                                category: task.status,
                                dotColor: task.priority == 1
                                    ? AppColors.red
                                    : task.priority == 2
                                    ? AppColors.gold
                                    : task.priority == 3
                                    ? AppColors.primaryColor
                                    : null,
                                isDone: task.isCompleted,
                                onCheckTap: (v) {
                                  Get.find<TaskService>().toggleTaskCompletion(
                                    task.id,
                                    v,
                                  );
                                },
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => TaskDetailSheet(task: task),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _UpcomingShimmer extends StatelessWidget {
  final bool isDark;
  const _UpcomingShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: const [
                ShimmerBox(
                  height: 16,
                  width: 100,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                SizedBox(width: 4),
                ShimmerBox(
                  height: 16,
                  width: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => const ShimmerBox(
                  height: 60,
                  width: 44,
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                _shimmerDateSection('Overdue', isDark),
                _shimmerDateSection('Today', isDark),
                _shimmerDateSection('Tomorrow', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerDateSection(String label, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
          child: ShimmerBox(
            height: 12,
            width: 120,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        AppTaskCard.shimmer(isDark: isDark),
        if (label == 'Overdue') AppTaskCard.shimmer(isDark: isDark),
      ],
    );
  }
}

// ─── Date Section ─────────────────────────────────────────────────────────────
class _DateSection extends StatelessWidget {
  final String label;
  final bool isToday;
  final bool isDark;
  final VoidCallback onAddTap;
  final List<Widget>? tasks;

  const _DateSection({
    required this.label,
    required this.isToday,
    required this.isDark,
    required this.onAddTap,
    this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isToday
                  ? AppColors.primaryColor
                  : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
            ),
          ),
        ),

        // Tasks
        if (tasks != null) ...tasks!,

        // Add task button row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: GestureDetector(
            onTap: onAddTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0x061867E9),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 11,
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

        const SizedBox(height: 8),
        Divider(
          color: isDark ? AppColors.darkBorder : AppColors.borderLighter,
          height: 1,
          indent: 14,
          endIndent: 14,
        ),
      ],
    );
  }
}

class _FullCalendarGrid extends StatelessWidget {
  final bool isDark;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _FullCalendarGrid({
    required this.isDark,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    // Simplified calendar grid for March 2026
    final mockDays = [
      9, 10, 11, 12, 13, 14, 15, // Week 1
      16, 17, 18, 19, 20, 21, 22, // Week 2
      23, 24, 25, 26, 27, 28, 29, // Week 3
      30, 31, 1, 2, 3, 4, 5, // Week 4
      6, 7, 8, 9, 10, 11, 12, // Week 5
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (d) => SizedBox(
                    width: 44,
                    child: Center(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: muted,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: mockDays.length,
            itemBuilder: (ctx, index) {
              final val = mockDays[index];
              final isNextMonth = index >= 23;
              final currentDayDate = DateTime(2026, isNextMonth ? 4 : 3, val);
              final isSelected =
                  selectedDate.day == currentDayDate.day &&
                  selectedDate.month == currentDayDate.month;

              return GestureDetector(
                onTap: () => onDateSelected(currentDayDate),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isNextMonth && val == 1)
                            Text(
                              'Apr',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : titleColor,
                              ),
                            ),
                          Text(
                            val.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : (isNextMonth ? muted : titleColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
