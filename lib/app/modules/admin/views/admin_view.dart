import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../controllers/admin_controller.dart';
import '../models/admin_models.dart';
import 'admin_sections.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(
          () {
            final section = controller.selectedSection.value;
            return Row(
              children: [
                if (MediaQuery.of(context).size.width > 900)
                  _Sidebar(active: section, onSelect: controller.changeSection),
                Expanded(
                  child: Column(
                    children: [
                      _TopNavbar(active: section),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _SectionBody(controller: controller, section: section),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      drawer: MediaQuery.of(context).size.width <= 900
          ? Drawer(
              child: _Sidebar(
                active: controller.selectedSection.value,
                onSelect: (section) {
                  controller.changeSection(section);
                  Get.back();
                },
              ),
            )
          : null,
    );
  }
}

class _SectionBody extends StatelessWidget {
  final AdminController controller;
  final AdminSection section;
  const _SectionBody({required this.controller, required this.section});

  @override
  Widget build(BuildContext context) {
    switch (section) {
      case AdminSection.dashboard:
        return DashboardSection(controller: controller);
      case AdminSection.users:
        return UsersSection(controller: controller);
      case AdminSection.workflows:
        return WorkflowsSection(controller: controller);
      case AdminSection.templates:
        return TemplatesSection(controller: controller);
      case AdminSection.tasks:
        return TasksSection(controller: controller);
      case AdminSection.notifications:
        return NotificationsSection(controller: controller);
      case AdminSection.reports:
        return ReportsSection(controller: controller);
      case AdminSection.settings:
        return const SettingsSection();
    }
  }
}

class _Sidebar extends StatelessWidget {
  final AdminSection active;
  final ValueChanged<AdminSection> onSelect;
  const _Sidebar({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Container(
      width: 240,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Taskerer',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text('Admin Panel', style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 20),
          ...AdminSection.values.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor:
                    active == item ? AppColors.primaryColor.withValues(alpha: 0.12) : null,
                leading: Icon(
                  item.icon,
                  color: active == item ? AppColors.primaryColor : muted,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: active == item ? AppColors.primaryColor : textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                onTap: () => onSelect(item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNavbar extends StatelessWidget {
  final AdminSection active;
  const _TopNavbar({required this.active});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width <= 900)
            Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              ),
            ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search (UI only)',
                isDense: true,
                prefixIcon: Icon(Icons.search_rounded),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
          const SizedBox(width: 4),
          Row(
            children: [
              const CircleAvatar(radius: 16, child: Icon(Icons.person_outline, size: 18)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  Text('Super Admin', style: TextStyle(fontSize: 11, color: muted)),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ],
      ),
    );
  }
}
