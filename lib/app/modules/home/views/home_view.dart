import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../browse/controllers/browse_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final browseController = Get.find<BrowseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person_rounded, color: AppColors.primaryColor, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Home',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            AppSummaryCard(
              greeting: controller.greeting.value,
              name: controller.name.value,
              date: controller.date.value,
              completedTasks: controller.completedTasks.value,
              totalTasks: controller.totalTasks.value,
              motivation: controller.motivation.value,
            ),
            const SizedBox(height: 24),
            
            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickActionItem(
                  icon: Icons.add_task_rounded,
                  label: 'Add Task',
                  onTap: () {},
                  color: Colors.blue,
                  isDark: isDark,
                ),
                _QuickActionItem(
                  icon: Icons.account_tree_outlined,
                  label: 'New Workflow',
                  onTap: () => Get.toNamed(Routes.BROWSE_TEMPLATES),
                  color: Colors.green,
                  isDark: isDark,
                ),
                _QuickActionItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports',
                  onTap: () => Get.toNamed(Routes.REPORTS),
                  color: Colors.orange,
                  isDark: isDark,
                ),
                _QuickActionItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendar',
                  onTap: () => Get.toNamed(Routes.BROWSE_CALENDAR),
                  color: Colors.purple,
                  isDark: isDark,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // AI Suggestions
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: AppColors.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'AI Recommendations',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: controller.aiSuggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 16, color: muted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: titleColor,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: muted),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Active Workflows Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Workflows',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.BROWSE_PROJECTS),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: browseController.projects.take(3).length,
              itemBuilder: (context, index) {
                final project = browseController.projects[index];
                return _ActiveWorkflowCard(
                  name: project.name,
                  progress: project.progress,
                  status: project.status,
                  isDark: isDark,
                );
              },
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveWorkflowCard extends StatelessWidget {
  final String name;
  final double progress;
  final String status;
  final bool isDark;

  const _ActiveWorkflowCard({
    required this.name,
    required this.progress,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
