import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── Header ───────────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join DFRMS as a Farm Supervisor',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Form card ────────────────────────────────────────────────
                _FormCard(
                  title: 'PERSONAL INFORMATION',
                  children: [
                    AppTextField(
                      label: 'Full Name *',
                      hint: 'e.g. Adaeze Chibuzo Nwosu',
                      controller: controller.fullNameCtrl,
                      prefixIcon: Icons.badge_outlined,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: controller.validateFullName,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'user@example.com (optional)',
                      controller: controller.emailCtrl,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: controller.validateEmail,
                    ),
                  ],
                ),

                _FormCard(
                  title: 'LOGIN CREDENTIALS',
                  children: [
                    AppTextField(
                      label: 'Username *',
                      hint: 'Letters, numbers and underscores only',
                      controller: controller.usernameCtrl,
                      prefixIcon: Icons.alternate_email_rounded,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      validator: controller.validateUsername,
                    ),
                    const SizedBox(height: 14),
                    Obx(() => AppTextField(
                          label: 'Password *',
                          hint: 'Min. 6 characters',
                          controller: controller.passwordCtrl,
                          prefixIcon: Icons.lock_outline,
                          obscureText: controller.obscurePassword.value,
                          textInputAction: TextInputAction.next,
                          validator: controller.validatePassword,
                          suffix: GestureDetector(
                            onTap: controller.togglePassword,
                            child: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )),
                    const SizedBox(height: 14),
                    Obx(() => AppTextField(
                          label: 'Confirm Password *',
                          hint: 'Re-enter your password',
                          controller: controller.confirmPwCtrl,
                          prefixIcon: Icons.lock_outline,
                          obscureText: controller.obscureConfirm.value,
                          textInputAction: TextInputAction.done,
                          validator: controller.validateConfirm,
                          suffix: GestureDetector(
                            onTap: controller.toggleConfirm,
                            child: Icon(
                              controller.obscureConfirm.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )),
                  ],
                ),

                // ── Role info banner ─────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.secondaryLight, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 18, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'New accounts are created with Supervisor access. '
                          'An Administrator can upgrade your role after login.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Submit ───────────────────────────────────────────────────
                Obx(() => PrimaryButton(
                      label: 'Create Account',
                      onPressed: controller.register,
                      isLoading: controller.isSaving.value,
                      icon: Icons.person_add_rounded,
                    )),
                const SizedBox(height: 20),

                // ── Back to login ────────────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Already have an account?  ',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[600])),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _FormCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
