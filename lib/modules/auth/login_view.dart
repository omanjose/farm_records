import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 52),

                // ── Logo + header ────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.agriculture_rounded,
                            size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to DFRMS',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ── Form card ────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'Username',
                        hint: 'Enter your username',
                        controller: controller.usernameCtrl,
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                        validator: Validators.username,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => AppTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: controller.passwordCtrl,
                            prefixIcon: Icons.lock_outline,
                            obscureText: controller.obscurePassword.value,
                            textInputAction: TextInputAction.done,
                            validator: Validators.password,
                            suffix: GestureDetector(
                              onTap: controller.togglePasswordVisibility,
                              child: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )),
                      const SizedBox(height: 28),
                      Obx(() => PrimaryButton(
                            label: 'Sign In',
                            onPressed: controller.login,
                            isLoading: controller.isLoading.value,
                            icon: Icons.login_rounded,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Sign Up CTA ──────────────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Don't have an account?  ",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[600])),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.signup),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Demo credentials hint ────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.secondaryLight, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.info_outline,
                            size: 16, color: AppColors.secondary),
                        SizedBox(width: 6),
                        Text('Demo Credentials',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.secondary)),
                      ]),
                      const SizedBox(height: 8),
                      _credRow('Admin',   'admin / admin123'),
                      const SizedBox(height: 4),
                      _credRow('Manager', 'manager / farm2024'),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Center(
                  child: Text(
                    '© 2025 Sunrise Agro Limited · DFRMS v1.0',
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _credRow(String role, String cred) => Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(role,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
          Text(cred,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontFamily: 'monospace')),
        ],
      );
}
