import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../models/admin_models.dart';

class AdminSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AdminSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }
}

class AdminStatusChip extends StatelessWidget {
  final String label;

  const AdminStatusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final normalized = label.toLowerCase();
    Color color = AppColors.primaryColor;
    if (normalized.contains('inactive') || normalized.contains('overdue') || normalized.contains('blocked')) {
      color = AppColors.red;
    } else if (normalized.contains('pending') || normalized.contains('progress')) {
      color = AppColors.gold;
    } else if (normalized.contains('active') || normalized.contains('done') || normalized.contains('track')) {
      color = AppColors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AdminSimpleBarChart extends StatelessWidget {
  final List<ChartPoint> points;
  final double maxValue;

  const AdminSimpleBarChart({
    super.key,
    required this.points,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: points
            .map(
              (p) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 18,
                        height: ((p.value / maxValue) * 110).clamp(8, 110).toDouble(),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppColors.primaryColor, AppColors.accentBlue],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.label,
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
