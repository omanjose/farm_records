import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameCtrl    = TextEditingController();
  final usernameCtrl    = TextEditingController();
  final emailCtrl       = TextEditingController();
  final passwordCtrl    = TextEditingController();
  final confirmPwCtrl   = TextEditingController();

  final isSaving          = false.obs;
  final obscurePassword   = true.obs;
  final obscureConfirm    = true.obs;

  final _repo = UserRepository();

  void togglePassword()       => obscurePassword.toggle();
  void toggleConfirm()        => obscureConfirm.toggle();

  // ── Validators ─────────────────────────────────────────────────────────────
  String? validateFullName(String? v)  => Validators.required(v, 'Full name');
  String? validateUsername(String? v)  => Validators.username(v);
  String? validateEmail(String? v)     => Validators.email(v);
  String? validatePassword(String? v)  => Validators.password(v);

  String? validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;

    try {
      final username = usernameCtrl.text.trim().toLowerCase();

      // Check username uniqueness
      final exists = await _repo.usernameExists(username);
      if (exists) {
        Get.snackbar(
          'Username Taken',
          '"$username" is already in use. Please choose another.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
        );
        return;
      }

      final user = UserModel(
        username: username,
        passwordHash: _repo.hashPassword(passwordCtrl.text),
        fullName: fullNameCtrl.text.trim(),
        role: 'supervisor',                      // self-registrations = supervisor
        email: emailCtrl.text.trim().isEmpty
            ? null
            : emailCtrl.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await _repo.create(user);

      Get.offNamed(AppRoutes.login);
      // Wait a frame so the login screen is mounted before snackbar fires
      await Future.delayed(const Duration(milliseconds: 200));
      Get.snackbar(
        'Account Created! 🎉',
        'Welcome, ${user.fullName.split(' ').first}! You can now sign in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPwCtrl.dispose();
    super.onClose();
  }
}
