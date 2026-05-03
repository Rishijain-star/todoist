import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/config/dev_auth_config.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/api_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_progress_service.dart';
import 'auth_feedback.dart';

class EmailSignupView extends StatefulWidget {
  const EmailSignupView({super.key});
  @override
  State<EmailSignupView> createState() => _EmailSignupViewState();
}

class _EmailSignupViewState extends State<EmailSignupView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_clearFieldErrors);
    _emailCtrl.addListener(_clearFieldErrors);
    _passCtrl.addListener(_clearFieldErrors);
  }

  void _clearFieldErrors() {
    if (_nameError != null || _emailError != null || _passwordError != null) {
      setState(() {
        _nameError = null;
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_clearFieldErrors);
    _emailCtrl.removeListener(_clearFieldErrors);
    _passCtrl.removeListener(_clearFieldErrors);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _validateFields() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    _nameError = name.isEmpty ? 'Please enter your name' : null;
    _emailError = email.isEmpty
        ? 'Please enter your email'
        : (!isValidEmailFormat(email)
              ? 'Enter a valid email address (e.g. you@example.com)'
              : null);
    _passwordError = password.isEmpty
        ? 'Please enter a password'
        : (password.length < 8
              ? 'Password must be at least 8 characters'
              : null);

    setState(() {});
    return _nameError == null && _emailError == null && _passwordError == null;
  }

  Future<void> _signup() async {
    // TODO(dev): Remove when real registration is required — see [DevAuthConfig].
    if (DevAuthConfig.shouldBypassAuth) {
      DevAuthConfig.navigateAfterRegistered();
      return;
    }

    FocusScope.of(context).unfocus();
    if (!_validateFields()) {
      final first = _nameError ?? _emailError ?? _passwordError;
      if (first != null) {
        showAuthSnackBar(context, message: first, isError: true);
      }
      return;
    }

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    setState(() => _loading = true);
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Creating your account…');
    final result = await ApiRepository.register(
      name: name,
      email: email,
      password: password,
    );
    api?.hide();
    if (!mounted) return;
    setState(() => _loading = false);

    if (result.ok) {
      Get.offAllNamed(Routes.ONBOARDING_WELCOME);
    } else {
      showAuthSnackBar(context, message: result.message, isError: true);
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
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your email and password.',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 40),

            _AuthTextField(
              controller: _nameCtrl,
              label: 'Your full name',
              keyboardType: TextInputType.name,
              errorText: _nameError,
            ),
            const SizedBox(height: 20),

            // Email Field
            _AuthTextField(
              controller: _emailCtrl,
              label: 'Your personal or work email',
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            const SizedBox(height: 20),

            // Password Field
            _AuthTextField(
              controller: _passCtrl,
              label: 'Your password',
              obscureText: _obscure,
              errorText: _passwordError,
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

            // Sign up Button
            GradientButton(
              label: 'Sign up',
              onPressed: _loading ? null : _signup,
              isLoading: _loading,
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
  final String? errorText;

  const _AuthTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null && errorText!.isNotEmpty;
    final fieldFont = 16.sp.clamp(14.0, 22.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? AppColors.red
                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: fieldFont,
            ),
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
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
