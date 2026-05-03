import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/browse_controller.dart';
import 'templates_view.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/template_model.dart';

class TemplatesListView extends GetView<BrowseController> {
  const TemplatesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundLight,
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
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isTemplatesLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = controller.categories;

        return RefreshIndicator(
          onRefresh: () => controller.loadBrowse(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
            // Search Bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.search, color: muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search templates',
                      style: TextStyle(
                        fontSize: 13,
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category list
            if (grouped.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    'No templates yet. Pull down to refresh, or ask an admin to publish template library entries.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                ),
              ),
            ...grouped.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    child: Text(
                      entry.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: muted,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: entry.templates.length,
                    itemBuilder: (context, index) {
                      final template = entry.templates[index];
                      return _TemplateCard(
                        template: template,
                        isDark: isDark,
                        onTap: () => Get.to(
                          () => TemplatesView(
                            initialTemplate: _toProjectTemplate(template),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              );
            }).toList(),
          ],
          ),
        );
      }),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TaskTemplate template;
  final bool isDark;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.article_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            template.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${template.steps.length} steps',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }
}

ProjectTemplate _toProjectTemplate(TaskTemplate template) {
  final tasks = template.steps
      .asMap()
      .entries
      .map(
        (entry) => Task(
          id: '${template.id}_${entry.key + 1}',
          title: entry.value,
          desc: '',
          dueToday: false,
        ),
      )
      .toList();

  return ProjectTemplate(
    id: template.id,
    name: template.title,
    category: template.category,
    phases: [
      Phase(id: '${template.id}_phase', title: 'Checklist', tasks: tasks),
    ],
  );
}
