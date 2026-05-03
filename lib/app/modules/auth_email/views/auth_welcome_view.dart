import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';

class AuthWelcomeView extends StatelessWidget {
  const AuthWelcomeView({super.key});

  void _showEmailOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight)),
        ),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetHandle(),
            const SizedBox(height: 8),
            _EmailOption(
              icon: Icons.edit_outlined,
              label: 'Sign up with Email',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/auth-signup');
              },
            ),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1, indent: 18, endIndent: 18),
            _EmailOption(
              icon: Icons.mail_outline_rounded,
              label: 'Log in with Email',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/auth-login');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Headline ────────────────────────────────
              Text(
                'Organize your\nwork and life,\nfinally.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),

              const Spacer(),

              // ── Hero Illustration ────────────────────────
              Center(child: _WelcomeIllustration()),

              const Spacer(),

              // ── Buttons ──────────────────────────────────
              // Continue with Email (gradient)
              GradientButton(
                label: 'Continue with Email',
                icon: const Icon(Icons.mail_rounded, color: Colors.white, size: 20),
                onPressed: () => _showEmailOptions(context),
              ),
              const SizedBox(height: 12),

              // Continue with Google
              SocialButton(
                label: 'Continue with Google',
                icon: _GoogleIcon(),
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Continue with Facebook
              SocialButton(
                label: 'Continue with Facebook',
                icon: _FacebookIcon(),
                onPressed: () {},
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'By continuing, you agree to Taskrer\'s Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _EmailOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ── Welcome Illustration ──────────────────────────────────────────────────────
class _WelcomeIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(painter: _IllustrationPainter()),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Calendar
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.06, h * 0.2, w * 0.34, h * 0.62),
        AppColors.card, radius: 12, shadowColor: const Color(0x201867E9));
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.06, h * 0.2, w * 0.34, h * 0.16),
        AppColors.primaryColor, radius: 12, bottomFlat: true);
    final gridP = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      double x = w * 0.06 + (w * 0.34 / 4) * i;
      canvas.drawLine(Offset(x, h * 0.4), Offset(x, h * 0.82), gridP);
    }
    for (int i = 1; i < 3; i++) {
      double y = h * 0.4 + (h * 0.42 / 3) * i;
      canvas.drawLine(Offset(w * 0.06, y), Offset(w * 0.4, y), gridP);
    }
    // checkmark on calendar
    final ck = Paint()
      ..color = AppColors.green
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final cp = Path()
      ..moveTo(w * 0.14, h * 0.62)
      ..lineTo(w * 0.2, h * 0.7)
      ..lineTo(w * 0.32, h * 0.52);
    canvas.drawPath(cp, ck);

    // Phone
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.38, h * 0.08, w * 0.24, h * 0.8),
        const Color(0xFF2D6A4F), radius: 14);
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.41, h * 0.16, w * 0.18, h * 0.56),
        const Color(0xFFF8F4E8), radius: 6);
    // App icon on phone
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.44, h * 0.28, w * 0.12, h * 0.18),
        AppColors.primaryColor, radius: 4);
    final taskP = Paint()..color = Colors.white..strokeWidth = 1.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      double y = h * 0.31 + i * h * 0.05;
      canvas.drawLine(Offset(w * 0.46, y), Offset(w * 0.54, y), taskP);
    }

    // Flower
    final flPaint = Paint()..color = AppColors.gold;
    canvas.drawCircle(Offset(w * 0.72, h * 0.22), w * 0.07, flPaint);
    final petalP = Paint()..color = AppColors.gold.withOpacity(0.6);
    for (int i = 0; i < 6; i++) {
      final angle = (i * 3.14159 * 2 / 6);
      canvas.drawCircle(
        Offset(w * 0.72 + w * 0.08 * cos(angle), h * 0.22 + h * 0.08 * sin(angle) * 0.7),
        w * 0.055, petalP,
      );
    }

    // Plant stem
    final stemP = Paint()..color = const Color(0xFF52B788)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.72, h * 0.3), Offset(w * 0.72, h * 0.72), stemP);
    final leafP = Paint()..color = const Color(0xFF74C69D);
    final leafPath = Path()
      ..moveTo(w * 0.72, h * 0.48)
      ..quadraticBezierTo(w * 0.85, h * 0.44, w * 0.82, h * 0.56)
      ..quadraticBezierTo(w * 0.72, h * 0.52, w * 0.72, h * 0.48);
    canvas.drawPath(leafPath, leafP);

    // Pot
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.63, h * 0.66, w * 0.18, h * 0.16),
        const Color(0xFFB7D5E8), radius: 4);

    // Envelope
    _drawRoundRect(canvas, Rect.fromLTWH(w * 0.7, h * 0.52, w * 0.22, h * 0.16),
        const Color(0xFFB7D5E8), radius: 6);
    final envP = Paint()..color = const Color(0xFF52B788)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final envFlap = Path()
      ..moveTo(w * 0.7, h * 0.52)
      ..lineTo(w * 0.81, h * 0.62)
      ..lineTo(w * 0.92, h * 0.52);
    canvas.drawPath(envFlap, envP);

    // Check badge on envelope
    canvas.drawCircle(Offset(w * 0.89, h * 0.64), w * 0.045, Paint()..color = AppColors.green);
    final ck2 = Paint()..color = Colors.white..strokeWidth = 1.8..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()..moveTo(w * 0.87, h * 0.64)..lineTo(w * 0.89, h * 0.67)..lineTo(w * 0.92, h * 0.62),
      ck2,
    );

    // Water drop + check
    _drawDrop(canvas, Offset(w * 0.87, h * 0.32), w * 0.06, const Color(0xFF74C69D));
    canvas.drawCircle(Offset(w * 0.93, h * 0.26), w * 0.025, Paint()..color = AppColors.green);
    canvas.drawPath(
      Path()..moveTo(w * 0.915, h * 0.26)..lineTo(w * 0.93, h * 0.28)..lineTo(w * 0.945, h * 0.24),
      ck2,
    );

    // Clock
    canvas.drawCircle(Offset(w * 0.1, h * 0.8), w * 0.06, Paint()..color = AppColors.gold);
    canvas.drawCircle(Offset(w * 0.1, h * 0.8), w * 0.06,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  void _drawRoundRect(Canvas canvas, Rect rect, Color color,
      {double radius = 8, Color? shadowColor, bool bottomFlat = false}) {
    if (shadowColor != null) {
      final shadow = Paint()
        ..color = shadowColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(RRect.fromRectAndRadius(rect.translate(0, 4), Radius.circular(radius)), shadow);
    }
    canvas.drawRRect(
      bottomFlat
          ? RRect.fromRectAndCorners(rect,
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius))
          : RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()..color = color,
    );
  }

  void _drawDrop(Canvas canvas, Offset center, double r, Color color) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r * 1.5)
      ..cubicTo(center.dx + r, center.dy - r * 0.5, center.dx + r, center.dy + r * 0.8,
          center.dx, center.dy + r * 1.2)
      ..cubicTo(center.dx - r, center.dy + r * 0.8, center.dx - r, center.dy - r * 0.5,
          center.dx, center.dy - r * 1.5);
    canvas.drawPath(path, Paint()..color = color);
  }

  double cos(double angle) => _cosTable(angle);
  double sin(double angle) => _sinTable(angle);
  double _cosTable(double a) => double.parse((1 * _mathCos(a)).toStringAsFixed(6));
  double _sinTable(double a) => double.parse((1 * _mathSin(a)).toStringAsFixed(6));
  double _mathCos(double a) {
    double s = 0, t = 1;
    for (int i = 1; i <= 10; i++) {
      t *= -a * a / (2 * i * (2 * i - 1));
      s += t;
    }
    return 1 + s;
  }
  double _mathSin(double a) {
    double s = a, t = a;
    for (int i = 1; i <= 10; i++) {
      t *= -a * a / ((2 * i + 1) * (2 * i));
      s += t;
    }
    return s;
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Google / Facebook icons ───────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final colors = [const Color(0xFF4285F4), const Color(0xFF34A853), const Color(0xFFFBBC05), const Color(0xFFEA4335)];
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        (i * 3.14159 * 2 / 4) - 3.14159 / 4,
        3.14159 * 2 / 4,
        false,
        Paint()..color = colors[i]..style = PaintingStyle.stroke..strokeWidth = size.width * 0.22,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(c.dx, c.dy - r * 0.3, r, r * 0.6),
      Paint()..color = const Color(0xFF4285F4),
    );
  }
  @override
  bool shouldRepaint(_) => false;
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
