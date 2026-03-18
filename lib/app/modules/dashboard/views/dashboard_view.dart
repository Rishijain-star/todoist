import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../inbox/views/inbox_view.dart';
import '../../today/views/today_view.dart';
import '../../upcoming/views/upcoming_view.dart';
import '../../team/views/team_view.dart';
import '../../browse/views/browse_view.dart';
import '../controllers/dashboard_controller.dart';

import '../../task/views/add_task_sheet.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  final _screens = const [
    InboxView(),
    TodayView(),
    UpcomingView(),
    TeamView(),
    BrowseView(),
  ];

  void _openAddTask(BuildContext context) {
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
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.index.value,
            children: _screens,
          )),
      bottomNavigationBar: Obx(() => _TaskererNavBar(
            currentIndex: controller.index.value,
            isDark: isDark,
            onTap: (i) => controller.setIndex(i),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTask(context),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

// ─── Custom Nav Bar ───────────────────────────────────────────────────────────
class _TaskererNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _TaskererNavBar({
    required this.currentIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight)),
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      padding: EdgeInsets.only(top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
      child: Row(
        children: [
          _NavItem(icon: Icons.inbox_outlined, label: 'Inbox', index: 0, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.calendar_today_outlined, label: 'Today', index: 1, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.date_range_outlined, label: 'Upcoming', index: 2, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.people_outline_rounded, label: 'Team', index: 3, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.menu_rounded, label: 'Browse', index: 4, current: currentIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon, required this.label,
    required this.index, required this.current, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54, height: 32,
              decoration: BoxDecoration(
                color: active ? AppColors.primaryColor.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 22,
                  color: active ? AppColors.primaryColor : AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.primaryColor : AppColors.textSecondary,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
