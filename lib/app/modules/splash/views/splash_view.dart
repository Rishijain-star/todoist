import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade  = CurvedAnimation(parent: _ctrl, curve: const Interval(0.4, 1.0));
    _ctrl.forward();
    
    // Ensure controller is initialized
    Get.find<SplashController>();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo Card ──────────────────────────────────
            ScaleTransition(
              scale: _scale,
              child: Image.asset(
                'assets/taskerer_logo_small.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),

            // ── App Name ───────────────────────────────────
            FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Nunito',
                      ),
                      children: [
                        TextSpan(
                          text: 'Task',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: 'erer',
                          style: TextStyle(color: AppColors.accentBlue),
                        ),
                        TextSpan(
                          text: '.net',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Plan It. Track It. Finish It.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // ── Loader dots ───────────────────────────────
            FadeTransition(
              opacity: _fade,
              child: _PulseDots(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Taskrer Logo SVG ─────────────────────────────────────────────────────────
class _LogoSVG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LogoPainter(),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Calendar body
    final calPaint = Paint()..color = AppColors.primaryColor;
    final calRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, h * 0.15, w * 0.75, h * 0.72),
      const Radius.circular(6),
    );
    canvas.drawRRect(calRRect, calPaint);

    // Calendar header bar
    final headerPaint = Paint()..color = AppColors.primaryDark;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.15, w * 0.75, h * 0.18), const Radius.circular(6)),
      headerPaint,
    );

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      double x = (w * 0.75 / 4) * i;
      canvas.drawLine(Offset(x, h * 0.38), Offset(x, h * 0.87), gridPaint);
    }
    for (int i = 1; i < 3; i++) {
      double y = h * 0.38 + (h * 0.49 / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(w * 0.75, y), gridPaint);
    }

    // Bell icon (gold)
    final bellPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
    final bellPath = Path();
    final bx = w * 0.58;
    final by = h * 0.08;
    bellPath.moveTo(bx + w * 0.15, by + h * 0.18);
    bellPath.arcTo(
      Rect.fromCenter(center: Offset(bx + w * 0.15, by + h * 0.25), width: w * 0.22, height: h * 0.22),
      -3.14, 3.14, false,
    );
    bellPath.lineTo(bx + w * 0.06, by + h * 0.38);
    bellPath.lineTo(bx + w * 0.24, by + h * 0.38);
    bellPath.close();
    canvas.drawPath(bellPath, bellPaint);

    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final cp = Path();
    cp.moveTo(w * 0.12, h * 0.62);
    cp.lineTo(w * 0.28, h * 0.74);
    cp.lineTo(w * 0.55, h * 0.52);
    canvas.drawPath(cp, checkPaint);

    // Blue notification dot
    final dotPaint = Paint()..color = AppColors.primaryColor;
    canvas.drawCircle(Offset(w * 0.86, h * 0.1), w * 0.1, dotPaint);
    final tPainter = TextPainter(
      text: const TextSpan(
        text: '1',
        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tPainter.paint(canvas, Offset(w * 0.82, h * 0.05));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Animated pulse dots ───────────────────────────────────────────────────────
class _PulseDots extends StatefulWidget {
  @override
  State<_PulseDots> createState() => _PulseDotsState();
}

class _PulseDotsState extends State<_PulseDots> with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final v = ((_c.value - i * 0.2).abs() < 0.3) ? 1.0 : 0.4;
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(v),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
