import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/user_repository.dart';

class LoginController extends GetxController {
  final formKey          = GlobalKey<FormState>();
  final usernameCtrl     = TextEditingController();
  final passwordCtrl     = TextEditingController();

  final isLoading        = false.obs;
  final obscurePassword  = true.obs;

  final _repo = UserRepository();

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final user = await _repo.authenticate(
        usernameCtrl.text.trim(),
        passwordCtrl.text,
      );

      if (user == null) {
        Get.snackbar(
          'Login Failed',
          'Invalid username or password. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,       // ← fixed (was Colors.red[700])
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 10,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.prefUserId,    user.id!);
      await prefs.setString(AppConstants.prefUsername,  user.username);
      await prefs.setString(AppConstants.prefFullName,  user.fullName);
      await prefs.setString(AppConstants.prefRole,      user.role);
      await prefs.setInt(AppConstants.prefFarmId,    1);

      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,      // ← fixed (was Colors.orange[800])
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
