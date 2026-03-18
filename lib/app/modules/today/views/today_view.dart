import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/today_controller.dart';
import '../../settings/controllers/settings_controller.dart';

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
        title: Row(
          children: [
            Image.asset('assets/taskerer_logo_small.png', height: 32),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Nunito',
                ),
                children: [
                  TextSpan(
                    text: 'Task',
                    style: TextStyle(color: textColor),
                  ),
                  const TextSpan(
                    text: 'erer',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(Icons.search_rounded, color: iconColor),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
              child: Stack(
                children: [
                  Icon(Icons.notifications_none_rounded, color: iconColor),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackground
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 6,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _TodayFullShimmer(isDark: isDark);
          }

          final currentLayout = settings.layout.value;

          return Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  children: [
                    _TodayMainContent(
                      isDark: isDark,
                      textColor: textColor,
                      currentLayout: currentLayout,
                    ),
                    _TodayMainContent(
                      isDark: isDark,
                      textColor: textColor,
                      currentLayout: currentLayout,
                      isNextDay: true,
                    ),
                  ],
                ),
              ),
              // Dots Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? textColor
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.borderLight),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _TodayMainContent extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final int currentLayout;
  final bool isNextDay;

  const _TodayMainContent({
    required this.isDark,
    required this.textColor,
    required this.currentLayout,
    this.isNextDay = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayController>();
    return SingleChildScrollView(
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
              fontFamily: 'Nunito',
            ),
          ),
          Text(
            isNextDay ? '5 tasks' : '3 tasks',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 24),

          if (!isNextDay)
            Obx(
              () => AppSummaryCard(
                greeting: 'Good Morning',
                name: 'Karan',
                date: 'Sun, 8 Mar',
                completedTasks: controller.completedCount.value,
                totalTasks: controller.totalCount.value,
                motivation:
                    '${controller.totalCount.value - controller.completedCount.value} more to go — you\'re killing it!',
              ),
            ),
          const SizedBox(height: 32),

          // Overdue Section (Image 2)
          if (!isNextDay) ...[
            Row(
              children: [
                Text(
                  'Overdue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    fontFamily: 'Nunito',
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '2',
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
            AppTaskCard(
              title: 'Using this guide 👇',
              subtitle: 'Click here!...',
              category: 'Team Setup Guide',
              time: 'Yesterday',
              isOverdue: true,
            ),
            AppTaskCard(
              title: 'All about tasks (Watch)',
              subtitle: 'Check the video tutorial...',
              category: 'Team Setup Guide',
              time: 'Yesterday',
              isOverdue: true,
              commentCount: 1,
            ),
            const SizedBox(height: 24),
          ],

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

          // Conditional Layout
          if (currentLayout == 1) // Board Layout
            SizedBox(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _BoardColumn(
                    title: 'To Do',
                    count: 2,
                    tasks: [
                      AppTaskCard(
                        title: 'Team standup meeting',
                        time: '10:00 AM',
                        category: 'Work',
                        dotColor: AppColors.primaryColor,
                        onCheckTap: (v) => controller.toggleTask(v),
                      ),
                      AppTaskCard(
                        title: 'Review Q1 project report',
                        time: '2:00 PM',
                        category: 'Important',
                        dotColor: AppColors.gold,
                        onCheckTap: (v) => controller.toggleTask(v),
                      ),
                    ],
                    isDark: isDark,
                  ),
                  const SizedBox(width: 16),
                  _BoardColumn(
                    title: 'In Progress',
                    count: 1,
                    tasks: [
                      AppTaskCard(
                        title: 'Buy groceries',
                        time: 'Personal',
                        category: 'Errand',
                        dotColor: AppColors.accentBlue,
                        onCheckTap: (v) => controller.toggleTask(v),
                      ),
                    ],
                    isDark: isDark,
                  ),
                  const SizedBox(width: 16),
                  _BoardColumn(
                    title: 'Done',
                    count: 1,
                    tasks: [
                      AppTaskCard(
                        title: 'Morning workout 💪',
                        time: 'Done',
                        category: '',
                        dotColor: AppColors.green,
                        isDone: true,
                        onCheckTap: (v) => controller.toggleTask(v),
                      ),
                    ],
                    isDark: isDark,
                  ),
                ],
              ),
            )
          else if (currentLayout == 2) // Calendar Layout
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: const Center(child: Text('Calendar View - Coming Soon')),
            )
          else // List Layout (Default)
            Column(
              children: [
                AppTaskCard(
                  title: 'Team standup meeting',
                  time: '10:00 AM',
                  category: 'Work',
                  dotColor: AppColors.primaryColor,
                  onCheckTap: (v) => controller.toggleTask(v),
                ),
                AppTaskCard(
                  title: 'Review Q1 project report',
                  time: '2:00 PM',
                  category: 'Important',
                  dotColor: AppColors.gold,
                  onCheckTap: (v) => controller.toggleTask(v),
                ),
                AppTaskCard(
                  title: 'Buy groceries on the way home',
                  time: 'Personal',
                  category: 'Errand',
                  dotColor: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.textMuted,
                  onCheckTap: (v) => controller.toggleTask(v),
                ),
                AppTaskCard(
                  title: 'Morning workout 💪',
                  time: 'Done',
                  category: '',
                  dotColor: AppColors.green,
                  isDone: true,
                  onCheckTap: (v) => controller.toggleTask(v),
                ),
              ],
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
                  fontFamily: 'Nunito',
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
              fontFamily: 'Nunito',
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
