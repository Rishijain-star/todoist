import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/reports_controller.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: titleColor),
        ),
        title: Text(
          'Reports & Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _StatCard(
                  label: 'Completed Tasks',
                  value: controller.completedTasks.value.toString(),
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.green,
                  isDark: isDark,
                ),
                _StatCard(
                  label: 'Overdue Tasks',
                  value: controller.overdueTasks.value.toString(),
                  icon: Icons.error_outline_rounded,
                  color: Colors.red,
                  isDark: isDark,
                ),
                _StatCard(
                  label: 'Active Workflows',
                  value: controller.activeWorkflows.value.toString(),
                  icon: Icons.account_tree_outlined,
                  color: Colors.blue,
                  isDark: isDark,
                ),
                _StatCard(
                  label: 'Completion Rate',
                  value: '${(controller.workflowCompletionRate.value * 100).toInt()}%',
                  icon: Icons.speed_rounded,
                  color: Colors.orange,
                  isDark: isDark,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            Text(
              'User Activity (Last 7 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Activity Chart Placeholder
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: controller.userActivityData.map((data) {
                  return Container(
                    width: 20,
                    height: data * 5, // Simple scaling
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.accentBlue],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              'Active Workflow Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _WorkflowProgressItem(
              name: 'Unit 402 Move-Out',
              progress: 0.65,
              isDark: isDark,
            ),
            _WorkflowProgressItem(
              name: 'Periodic Inspection - Block A',
              progress: 0.20,
              isDark: isDark,
            ),
            _WorkflowProgressItem(
              name: 'Unit 105 Lease Renewal',
              progress: 0.90,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowProgressItem extends StatelessWidget {
  final String name;
  final double progress;
  final bool isDark;

  const _WorkflowProgressItem({
    required this.name,
    required this.progress,
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
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
