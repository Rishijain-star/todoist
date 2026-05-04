import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../projects/controllers/projects_controller.dart';
import '../../../data/models/task_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemplatesView extends StatefulWidget {
  final ProjectTemplate? initialTemplate;
  const TemplatesView({super.key, this.initialTemplate});

  @override
  State<TemplatesView> createState() => _TemplatesViewState();
}

class _TemplatesViewState extends State<TemplatesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<ProjectsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
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
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_rounded, color: titleColor, size: 24.sp),
        ),
        title: Text(
          widget.initialTemplate?.name ?? 'Weekly Review',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: titleColor, size: 20.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (widget.initialTemplate == null && controller.templates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'No templates available for your account yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
              ),
            );
          }
          final template = widget.initialTemplate ?? controller.templates.first;

          return Column(
            children: [
              // Custom Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primaryColor,
                  indicatorWeight: 3.h,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.textMuted,
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  tabs: const [
                    Tab(text: 'Preview'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _TemplatePreview(template: template, isDark: isDark),
                    _TemplateAbout(template: template, isDark: isDark),
                  ],
                ),
              ),

              // Fixed Bottom Button
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.backgroundLight,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                child: GradientButton(
                  label: 'Copy to My Projects',
                  onPressed: () async {
                    final ok =
                        await controller.createProjectFromTemplate(template);
                    if (ok) Get.back();
                    Get.snackbar(
                      ok ? 'Success' : 'Could not create project',
                      ok
                          ? 'Project "${template.name}" was created with tasks.'
                          : 'Check your connection or try again.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor:
                          ok ? AppColors.primaryColor : Colors.red.shade700,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _TemplatePreview extends StatelessWidget {
  final ProjectTemplate template;
  final bool isDark;

  const _TemplatePreview({required this.template, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: template.phases.length,
      itemBuilder: (context, index) {
        final phase = template.phases[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    phase.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Text(
                  '${phase.tasks.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...phase.tasks.map(
              (task) => _TemplateTaskItem(task: task, isDark: isDark),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class _TemplateTaskItem extends StatelessWidget {
  final Task task;
  final bool isDark;

  const _TemplateTaskItem({required this.task, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle_outlined,
            size: 20,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (task.desc.isNotEmpty)
                  Text(
                    task.desc,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateAbout extends StatelessWidget {
  final ProjectTemplate template;
  final bool isDark;

  const _TemplateAbout({required this.template, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this template',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This template is designed for ${template.category}. It includes ${template.phases.length} phases and a total of ${template.phases.fold(0, (sum, p) => sum + p.tasks.length)} tasks to help you manage your workflow effectively.',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
