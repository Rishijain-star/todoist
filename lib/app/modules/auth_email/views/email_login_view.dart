import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/config/dev_auth_config.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/api_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_progress_service.dart';
import '../../../services/local_storage_services/local_storage_services.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({super.key});
  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // TODO(dev): Remove this block when backend login is required — see [DevAuthConfig].
    if (DevAuthConfig.shouldBypassAuth) {
      DevAuthConfig.navigateAfterLoggedIn();
      return;
    }

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return;
    }

    setState(() => _loading = true);
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Signing in…');
    bool ok = false;
    try {
      ok = await ApiRepository.login(email: email, password: password);
    } finally {
      api?.hide();
    }
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      final isOnboardingCompleted = LocalStorageService()
          .getIsOnboardingCompleted();
      Get.offAllNamed(
        isOnboardingCompleted ? Routes.DASHBOARD : Routes.ONBOARDING_WELCOME,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Check credentials/API URL.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your email and password.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 40),

            // Email Field
            _AuthTextField(
              controller: _emailCtrl,
              label: 'Your personal or work email',
              keyboardType: TextInputType.emailAddress,
              // Removed isError: true to use standard primary/border colors
            ),
            const SizedBox(height: 20),

            // Password Field
            _AuthTextField(
              controller: _passCtrl,
              label: 'Your password',
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 30),

            // Login Button
            GradientButton(
              label: 'Log in',
              onPressed: _loading ? null : _login,
              isLoading: _loading,
            ),

            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(Routes.AUTH_FORGOT_PASSWORD),
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _AuthTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16.sp,
            ),
            strutStyle: StrutStyle(fontSize: 16.sp, forceStrutHeight: true),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar(
        'Invalid email',
        'Please enter a valid email address.',
        backgroundColor: AppColors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    setState(() => _sending = true);
    final ok = await ApiRepository.forgotPassword(email: email);
    if (!mounted) return;
    setState(() => _sending = false);
    Get.snackbar(
      ok ? 'Reset link sent' : 'Request failed',
      ok
          ? 'Check your email to reset your password.'
          : 'Please try again in a moment.',
      backgroundColor: ok ? AppColors.primaryColor : AppColors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 26),
            Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter your email and we will send you a reset link.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 34),
            if (_sending)
              Shimmer(
                child: Column(
                  children: const [
                    ShimmerBox(
                      height: 54,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    SizedBox(height: 20),
                    ShimmerBox(
                      height: 52,
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ],
                ),
              )
            else ...[
              _AuthTextField(
                controller: _emailCtrl,
                label: 'Your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              GradientButton(
                label: 'Send reset link',
                onPressed: _send,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
