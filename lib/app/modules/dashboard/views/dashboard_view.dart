import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/user_assets.dart';
import '../../inbox/views/inbox_view.dart';
import '../../today/views/today_view.dart';
import '../../upcoming/views/upcoming_view.dart';
import '../../projects/views/projects_view.dart';
import '../../projects/controllers/projects_controller.dart';
import '../../browse/views/browse_view.dart';
import '../controllers/dashboard_controller.dart';
import '../../task/views/add_task_sheet.dart';
import '../../inbox/controllers/inbox_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  final _screens = const [
    InboxView(),
    TodayView(),
    UpcomingView(),
    ProjectsView(),
    BrowseView(),
  ];

  void _openAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(
        onSave: (task) async {
          await Get.find<InboxController>().createTaskFromSheet(task);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(index: controller.index.value, children: _screens),
        ),
      ),
      bottomNavigationBar: Obx(
        () => _TaskererNavBar(
          currentIndex: controller.index.value,
          isDark: isDark,
          onTap: (i) => controller.setIndex(i),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          heroTag: 'dashboard_add_fab',
          onPressed: () {
            if (controller.index.value == 3) {
              final projectsController = Get.find<ProjectsController>();
              ProjectsView.showCreateProjectDialog(
                context,
                projectsController,
              );
            } else {
              _openAddTask(context);
            }
          },
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
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
    final projectsController = Get.find<ProjectsController>();
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          ),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, -2.h),
                ),
              ],
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom + 8.h,
      ),
      child: Obx(
        () => Row(
          children: [
            _NavItem(
              iconAsset: UserAssets.navIconInbox,
              label: 'Inbox',
              index: 0,
              current: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              iconAsset: UserAssets.navIconToday,
              label: 'Today',
              index: 1,
              current: currentIndex,
              onTap: onTap,
            ),
            _NavItem(
              iconAsset: UserAssets.navIconUpcoming,
              label: 'Upcoming',
              index: 2,
              current: currentIndex,
              onTap: onTap,
            ),
            if (projectsController.projects.isNotEmpty)
              _NavItem(
                icon: Icons.folder_open_rounded,
                label: 'Projects',
                index: 3,
                current: currentIndex,
                onTap: onTap,
              ),
            _NavItem(
              iconAsset: UserAssets.navIconBrowse,
              label: 'Browse',
              index: 4,
              current: currentIndex,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon;
  final String? iconAsset;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    this.icon,
    this.iconAsset,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  }) : assert(icon != null || iconAsset != null);

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final iconColor =
        active ? AppColors.primaryColor : AppColors.textSecondary;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset!,
                        width: 22.w,
                        height: 22.w,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        icon,
                        size: 22.sp,
                        color: iconColor,
                      ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active
                    ? AppColors.primaryColor
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
