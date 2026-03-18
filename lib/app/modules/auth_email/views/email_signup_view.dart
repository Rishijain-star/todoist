 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../routes/app_pages.dart';
import '../../../services/secure_token_service/secure_token_service.dart';
import '../../../services/local_storage_services/local_storage_services.dart';

class EmailSignupView extends StatefulWidget {
  const EmailSignupView({super.key});
  @override
  State<EmailSignupView> createState() => _EmailSignupViewState();
}

class _EmailSignupViewState extends State<EmailSignupView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    
    setState(() => _loading = true);
    await SecureTokenService().setAuthToken('token');
    await LocalStorageService().setEmailId(email);
    if (mounted) {
      Get.offAllNamed(Routes.ONBOARDING_WELCOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
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
              'Sign up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: textColor,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your email and password.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
                fontFamily: 'Nunito',
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
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
  final bool isError;

  const _AuthTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.isError = false,
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
              color: isError ? AppColors.red : (isDark ? AppColors.darkBorder : AppColors.borderLight),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontFamily: 'Nunito',
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: isError ? AppColors.red : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
