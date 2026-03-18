import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';

import '../controllers/browse_controller.dart';

class TemplatesView extends StatelessWidget {
  const TemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrowseController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final card = isDark ? AppColors.darkSurfaceElevated : Colors.white;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: titleColor),
        ),
        title: Text(
          'Templates',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isTemplatesLoading.value) {
          return _TemplatesShimmer(isDark: isDark);
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: muted, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Search templates',
                      style: TextStyle(
                        color: muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TemplateTab(
                      label: 'My templates',
                      icon: Icons.person_pin_circle_outlined,
                      selected: true,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    _TemplateTab(
                      label: 'Featured',
                      icon: Icons.auto_awesome_outlined,
                      selected: false,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    _TemplateTab(
                      label: 'Productivity',
                      icon: Icons.grid_view_rounded,
                      selected: false,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Learn More Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.backgroundLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: muted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find out more about how to use templates in Taskerer.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: muted,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Popular Header
              Row(
                children: [
                  Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: titleColor,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Popular Templates Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  AppTemplateCard(
                    title: 'Move-Out Inspection',
                    subtitle: 'Property Manager Workflow',
                    icon: Icons.home_work_outlined,
                    color: Colors.blue.shade50,
                    onTap: () => _showMoveOutWorkflow(context),
                  ),
                  AppTemplateCard(
                    title: 'Weekly Review',
                    subtitle: 'Start reviewing your tasks every week with...',
                    icon: Icons.calendar_today_outlined,
                    color: Colors.red.shade50,
                  ),
                  AppTemplateCard(
                    title: 'Project Tracker',
                    subtitle: 'A central, organized place to keep track of...',
                    icon: Icons.track_changes_outlined,
                    color: Colors.green.shade50,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  void _showMoveOutWorkflow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MoveOutWorkflowSheet(),
    );
  }
}

class _TemplatesShimmer extends StatelessWidget {
  final bool isDark;
  const _TemplatesShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ShimmerBox(height: 48, borderRadius: BorderRadius.circular(12)),
            const SizedBox(height: 20),
            Row(
              children: [
                ShimmerBox(
                  height: 36,
                  width: 100,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 12),
                ShimmerBox(
                  height: 36,
                  width: 80,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 12),
                ShimmerBox(
                  height: 36,
                  width: 90,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ShimmerBox(height: 160, borderRadius: BorderRadius.circular(16)),
            const SizedBox(height: 24),
            Row(
              children: const [
                ShimmerBox(
                  height: 18,
                  width: 80,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                Spacer(),
                ShimmerBox(
                  height: 18,
                  width: 18,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                AppTemplateCard.shimmer(),
                AppTemplateCard.shimmer(),
                AppTemplateCard.shimmer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isDark;

  const _TemplateTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryColor;
    final inactiveColor = isDark ? AppColors.darkSurfaceElevated : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(10),
        border: selected ? null : Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: selected
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}

class MoveOutWorkflowSheet extends StatelessWidget {
  const MoveOutWorkflowSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final surface = isDark ? AppColors.darkSurface : Colors.white;

    final subtasks = [
      'Open move-out case',
      'Confirm move-out date and schedule inspection',
      'Collect tenant forwarding address',
      'Prepare inspection documents',
      'Conduct move-out inspection',
      'Capture photos and inspection evidence',
      'Record key / fob return',
      'Finalize and send inspection report',
      'Review tenant ledger and any charges',
      'Verify deduction compliance',
      'Draft statement of account',
      'Approve refund amount',
      'Deliver refund or statement by Day 10',
      'Save proof of delivery',
      'Notify property owner and close the file',
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parent Workflow',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: muted,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Move-Out Workflow',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Icon(Icons.close_rounded, size: 20, color: titleColor),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: subtasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorderLight
                              : AppColors.borderLight,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        subtasks[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GradientButton(
              label: 'Use this template',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
