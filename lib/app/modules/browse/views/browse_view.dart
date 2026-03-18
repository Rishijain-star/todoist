import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/browse_controller.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
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
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // Avatar
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.cardSecondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.primaryColor,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Karan Jain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: iconColor),
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: iconColor),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _BrowseItem(
            icon: Icons.search,
            label: 'Search',
            iconColor: AppColors.primaryColor,
          ),
          _BrowseItem(
            icon: Icons.grid_view_rounded,
            label: 'Filters & Labels',
            iconColor: AppColors.primaryColor,
          ),
          _BrowseItem(
            icon: Icons.check_circle_outline_rounded,
            label: 'Completed',
            iconColor: AppColors.primaryColor,
          ),

          const SizedBox(height: 16),

          _ExpandableHeader(
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.cardSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Icon(
                  Icons.folder_open_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.primaryColor,
                ),
              ),
            ),
            label: 'My Projects',
            onTap: () => Get.toNamed(Routes.BROWSE_PROJECTS),
            onAdd: () => Get.toNamed(Routes.BROWSE_ADD_PROJECT),
          ),
          _BrowseItem(
            icon: Icons.edit_outlined,
            label: 'Manage projects',
            inset: true,
            onTap: () => Get.toNamed(Routes.BROWSE_PROJECTS),
          ),

          const SizedBox(height: 16),

          _ExpandableHeader(
            icon: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            label: 'G5tc',
            onTap: () {},
            onAdd: () {},
          ),
          _BrowseItem(
            icon: Icons.tag,
            label: 'Team Setup Guide',
            trailing: const Text(
              '26',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            inset: true,
          ),
          _BrowseItem(
            icon: Icons.grid_view_outlined,
            label: 'Browse all projects',
            inset: true,
          ),

          const SizedBox(height: 24),

          _BrowseItem(
            icon: Icons.style_outlined,
            label: 'Browse templates',
            onTap: () => Get.toNamed(Routes.BROWSE_TEMPLATES),
          ),
          _BrowseItem(
            icon: Icons.help_outline_rounded,
            label: 'Help & resources',
          ),
        ],
      ),
    );
  }
}

class _BrowseItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Widget? trailing;
  final bool inset;
  final VoidCallback? onTap;

  const _BrowseItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.trailing,
    this.inset = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(inset ? 52 : 16, 12, 16, 12),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  iconColor ??
                  (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _ExpandableHeader extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onAdd;
  final VoidCallback? onTap;

  const _ExpandableHeader({
    required this.icon,
    required this.label,
    required this.onAdd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.add,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onAdd,
            ),
            Icon(
              Icons.keyboard_arrow_up_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class MyProjectsView extends GetView<BrowseController> {
  const MyProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final hintColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final surface = isDark ? AppColors.darkSurfaceElevated : Colors.white;

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
          'My Projects',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
            fontFamily: 'Nunito',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.BROWSE_ADD_PROJECT),
            icon: Icon(
              Icons.add,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.BROWSE_ADD_PROJECT),
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(Icons.search, color: hintColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search projects & folders',
                        style: TextStyle(
                          fontSize: 13,
                          color: hintColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Active projects',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: hintColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isProjectsLoading.value) {
                    return Shimmer(
                      child: ListView.separated(
                        itemCount: 6,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, __) => Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: const Row(
                            children: [
                              ShimmerBox(
                                height: 18,
                                width: 18,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ShimmerBox(
                                  height: 14,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (controller.projects.isEmpty) {
                    return _ProjectsEmptyState(isDark: isDark);
                  }

                  return ListView.separated(
                    itemCount: controller.projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = controller.projects[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.borderLight,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => Get.to(
                            () => ProjectDetailView(projectName: p.name),
                          ),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.tag,
                                    size: 12,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: titleColor,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectDetailView extends StatelessWidget {
  final String projectName;
  const ProjectDetailView({super.key, required this.projectName});

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
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: titleColor),
        ),
        title: Text(
          projectName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
            fontFamily: 'Nunito',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_add_outlined, color: titleColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.description_outlined, color: titleColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: titleColor),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'How to Use This Template',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                    fontFamily: 'Nunito',
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '8',
                  style: TextStyle(
                    fontSize: 14,
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_vert_rounded, color: muted, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: PageController(viewportFraction: 0.85),
              children: [
                _TemplateInstructionCard(
                  text:
                      'Keeping track of all the different steps of a project is key to actually getting it done. This template will guide you through creating, planning, and executing whatever...',
                  isDark: isDark,
                ),
                _TemplateInstructionCard(
                  text:
                      'Need to assign tasks to other people? If you\'re on a personal plan, you can share the project with them. Business users can collaborate in shared workspaces.',
                  isDark: isDark,
                  link: 'share the project',
                ),
                _TemplateInstructionCard(
                  text:
                      'Use the task descriptions to include relevant links or information. Like this!',
                  isDark: isDark,
                ),
                _TemplateInstructionCard(
                  text:
                      'Work backwards from your goal delivery dates to set realistic timelines. Switch to Calendar view to make sure your work is evenly distributed.',
                  isDark: isDark,
                  link: 'realistic timelines',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.add, color: AppColors.primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'Add task',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: muted,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(8, (index) {
              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == 0 ? titleColor : muted.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _TemplateInstructionCard extends StatelessWidget {
  final String text;
  final String? link;
  final bool isDark;

  const _TemplateInstructionCard({
    required this.text,
    this.link,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final cardColor = isDark ? AppColors.darkSurfaceElevated : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.borderLight;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: titleColor,
              fontFamily: 'Nunito',
              height: 1.5,
            ),
          ),
          if (link != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.link_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  link!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectsEmptyState extends StatelessWidget {
  final bool isDark;
  const _ProjectsEmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _ProjectsIllustrationPainter(isDark: isDark),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No projects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: titleColor,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first project to start organizing work.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: muted,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Get.toNamed(Routes.BROWSE_TEMPLATES),
              child: const Text(
                'Browse templates',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsIllustrationPainter extends CustomPainter {
  final bool isDark;
  const _ProjectsIllustrationPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color =
          (isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary)
              .withOpacity(0.7);
    final accent = Paint()..color = AppColors.primaryColor.withOpacity(0.25);
    final accent2 = Paint()..color = AppColors.gold.withOpacity(0.35);
    final blue = Paint()..color = AppColors.primaryColor.withOpacity(0.7);

    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.62),
      size.width * 0.24,
      bg,
    );
    canvas.drawCircle(
      Offset(size.width * 0.62, size.height * 0.54),
      size.width * 0.22,
      bg,
    );

    final easel = Paint()
      ..color = (isDark ? AppColors.darkBorderLight : AppColors.borderLight)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.62, size.height * 0.32),
      Offset(size.width * 0.52, size.height * 0.82),
      easel,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.32),
      Offset(size.width * 0.82, size.height * 0.82),
      easel,
    );
    canvas.drawLine(
      Offset(size.width * 0.52, size.height * 0.82),
      Offset(size.width * 0.82, size.height * 0.82),
      easel,
    );

    final canvasRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.67, size.height * 0.48),
        width: size.width * 0.34,
        height: size.height * 0.3,
      ),
      const Radius.circular(14),
    );
    canvas.drawRRect(
      canvasRect,
      Paint()..color = isDark ? AppColors.darkSurface : Colors.white,
    );
    canvas.drawRRect(
      canvasRect,
      Paint()
        ..color = (isDark ? AppColors.darkBorder : AppColors.borderLight)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.43),
      size.width * 0.03,
      blue,
    );
    canvas.drawCircle(
      Offset(size.width * 0.70, size.height * 0.52),
      size.width * 0.05,
      accent2,
    );
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.50),
      size.width * 0.05,
      accent2,
    );
    canvas.drawCircle(
      Offset(size.width * 0.73, size.height * 0.58),
      size.width * 0.05,
      accent,
    );

    final person = Paint()..color = AppColors.primaryColor.withOpacity(0.18);
    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.46),
      size.width * 0.08,
      person,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.28, size.height * 0.62),
          width: size.width * 0.22,
          height: size.height * 0.26,
        ),
        const Radius.circular(24),
      ),
      person,
    );

    final brush = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.55)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.36, size.height * 0.58),
      Offset(size.width * 0.56, size.height * 0.52),
      brush,
    );
  }

  @override
  bool shouldRepaint(covariant _ProjectsIllustrationPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class AddProjectView extends StatefulWidget {
  const AddProjectView({super.key});

  @override
  State<AddProjectView> createState() => _AddProjectViewState();
}

class _AddProjectViewState extends State<AddProjectView> {
  final _nameCtrl = TextEditingController();
  bool _favorite = false;
  BrowseProjectLayout _layout = BrowseProjectLayout.list;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final c = Get.find<BrowseController>();
    c.addProject(name: _nameCtrl.text, favorite: _favorite, layout: _layout);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
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
          'Add project',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
            fontFamily: 'Nunito',
          ),
        ),
        actions: [
          IconButton(
            onPressed: _nameCtrl.text.trim().isEmpty ? null : _save,
            icon: Icon(
              Icons.check,
              color: _nameCtrl.text.trim().isEmpty
                  ? muted
                  : AppColors.primaryColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                  color: titleColor,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(color: muted, fontFamily: 'Nunito'),
                  filled: true,
                  fillColor: card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.borderLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.borderLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _SettingRow(
                icon: Icons.palette_outlined,
                title: 'Color',
                subtitle: 'Charcoal',
                isDark: isDark,
                onTap: () {},
              ),
              _SettingRow(
                icon: Icons.layers_outlined,
                title: 'Workspace',
                subtitle: 'My Projects',
                isDark: isDark,
                onTap: () {},
              ),
              _SettingRow(
                icon: Icons.tag_outlined,
                title: 'Parent project',
                subtitle: 'No parent',
                isDark: isDark,
                onTap: () {},
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Favorite',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: _favorite,
                    onChanged: (v) => setState(() => _favorite = v),
                    activeColor: AppColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Layout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LayoutOption(
                    label: 'List',
                    icon: Icons.view_list_rounded,
                    selected: _layout == BrowseProjectLayout.list,
                    onTap: () =>
                        setState(() => _layout = BrowseProjectLayout.list),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 14),
                  _LayoutOption(
                    label: 'Board',
                    icon: Icons.dashboard_outlined,
                    selected: _layout == BrowseProjectLayout.board,
                    onTap: () =>
                        setState(() => _layout = BrowseProjectLayout.board),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 14),
                  _LayoutOption(
                    label: 'Calendar',
                    icon: Icons.calendar_month_outlined,
                    selected: _layout == BrowseProjectLayout.calendar,
                    onTap: () =>
                        setState(() => _layout = BrowseProjectLayout.calendar),
                    isDark: isDark,
                  ),
                ],
              ),
              const Spacer(),
              if (_nameCtrl.text.trim().isNotEmpty)
                GradientButton(
                  label: 'Create project',
                  onPressed: _save,
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final subColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: subColor,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subColor),
          ],
        ),
      ),
    );
  }
}

class _LayoutOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _LayoutOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark ? AppColors.darkBorder : AppColors.borderLight;
    final titleColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final bg = isDark ? AppColors.darkSurfaceElevated : Colors.white;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primaryColor : border,
              width: selected ? 1.8 : 1.0,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primaryColor : titleColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primaryColor : titleColor,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
