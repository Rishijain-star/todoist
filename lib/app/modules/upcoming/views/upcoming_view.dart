import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karan/app/routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../task/views/add_task_sheet.dart';
import '../controllers/upcoming_controller.dart';

class UpcomingView extends StatefulWidget {
  const UpcomingView({super.key});

  @override
  State<UpcomingView> createState() => _UpcomingViewState();
}

class _UpcomingViewState extends State<UpcomingView> {
  int _selectedDayIndex = 0;
  bool _showCalendar = false;
  DateTime _selectedDate = DateTime(2026, 3, 15);
  final DateTime _now = DateTime(2026, 3, 1);
  final UpcomingController _controller = Get.find<UpcomingController>();

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _now.add(Duration(days: i)));

  String _weekLetter(int weekday) =>
      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][weekday - 1];

  String _weekdayFull(int weekday) => [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ][weekday - 1];

  String _monthName(int m) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m - 1];

  String _monthFull(int m) => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][m - 1];

  String _dayLabel(int offset) {
    final d = _now.add(Duration(days: offset));
    final base = '${_weekdayFull(d.weekday)}, ${_monthName(d.month)} ${d.day}';
    if (offset == 0) return '$base · Today';
    if (offset == 1) return '$base · Tomorrow';
    return base;
  }

  void _openAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(onSave: (_) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentMonth = _monthFull(_now.month);
    final currentYear = _now.year;

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
        titleSpacing: 18,
        title: Obx(() {
          if (_controller.isLoading.value) {
            return Shimmer(
              child: const ShimmerBox(
                height: 18,
                width: 140,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            );
          }
          return Text(
            'Upcoming',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito',
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          );
        }),
        actions: [
          AppIconButton(
            size: 34,
            icon: Icon(
              Icons.tune_rounded,
              size: 17,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            onTap: () {},
          ),
          const SizedBox(width: 8),
          AppIconButton(
            size: 34,
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 17,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            onTap: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return _UpcomingShimmer(isDark: isDark);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: GestureDetector(
                  onTap: () => setState(() => _showCalendar = !_showCalendar),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$currentMonth $currentYear',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito',
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showCalendar
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              if (!_showCalendar)
                // ── Week Strip (Scrollable) ───────────────────────────────
                Container(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.backgroundLight,
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 14),
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 30,
                    itemBuilder: (ctx, i) {
                      final day = _now.add(Duration(days: i));
                      final isToday = i == 0;
                      final isSel = i == _selectedDayIndex;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDayIndex = i),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 44,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _weekLetter(day.weekday),
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Nunito',
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isToday
                                        ? const LinearGradient(
                                            colors: [
                                              AppColors.primaryColor,
                                              AppColors.accentBlue,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSel && !isToday
                                        ? AppColors.primaryColor.withOpacity(
                                            0.12,
                                          )
                                        : Colors.transparent,
                                    boxShadow: isToday
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Nunito',
                                        color: isToday
                                            ? Colors.white
                                            : isSel
                                            ? AppColors.primaryColor
                                            : (isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors.textSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                // ── Full Calendar Grid ──────────────────────────────────
                _FullCalendarGrid(
                  isDark: isDark,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),

              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                height: 1,
              ),

              // ── Date Sections & Tasks ────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    _DateSection(
                      label: 'Overdue',
                      isToday: false,
                      isDark: isDark,
                      onAddTap: _openAddTask,
                      tasks: [
                        AppTaskCard(
                          title: 'Using this guide 👇',
                          subtitle: 'Click here!...',
                          category: 'Team Setup Guide',
                          isOverdue: true,
                          time: 'Yesterday',
                        ),
                        AppTaskCard(
                          title: 'All about tasks (Watch)',
                          subtitle: 'Check the video tutorial...',
                          category: 'Team Setup Guide',
                          isOverdue: true,
                          time: 'Yesterday',
                        ),
                      ],
                    ),
                    _DateSection(
                      label: 'Sunday, Mar 15 · Today',
                      isToday: true,
                      isDark: isDark,
                      onAddTap: _openAddTask,
                      tasks: [
                        AppTaskCard(
                          title: 'Sign in on web to access your Business...',
                          subtitle:
                              'Unlimited Projects and Pro features for the who...',
                          category: 'Team Setup Guide',
                        ),
                      ],
                    ),
                    for (int i = 1; i < 10; i++)
                      _DateSection(
                        label: _dayLabel(i),
                        isToday: false,
                        isDark: isDark,
                        onAddTap: _openAddTask,
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
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
              fontFamily: 'Nunito',
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
                      fontFamily: 'Nunito',
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
