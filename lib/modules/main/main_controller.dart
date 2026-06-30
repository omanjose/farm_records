import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_constants.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  String fullName = '';
  String username = '';
  String role     = '';
  int    farmId   = 1;
  int    userId   = 0;

  @override
  void onInit() {
    super.onInit();
    _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      fullName = prefs.getString(AppConstants.prefFullName) ?? 'Farm User';
      username = prefs.getString(AppConstants.prefUsername) ?? '';
      role     = prefs.getString(AppConstants.prefRole)     ?? AppConstants.roleSupervisor;
      farmId   = prefs.getInt(AppConstants.prefFarmId)      ?? 1;
      userId   = prefs.getInt(AppConstants.prefUserId)      ?? 0;
      update();
    } catch (_) {}
  }

  void changeTab(int index) => currentIndex.value = index;

  Future<void> logout() async {
    final confirmed = await Get.defaultDialog<bool>(
      title: 'Sign Out',
      middleText: 'Are you sure you want to sign out?',
      textConfirm: 'Sign Out',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.green.shade700,          // ← fixed (was Colors.green[700])
      onConfirm: () => Get.back(result: true),
      onCancel:  () => Get.back(result: false),
    );
    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }

  bool get isAdmin   => role == AppConstants.roleAdmin;
  bool get isManager => role == AppConstants.roleManager || role == AppConstants.roleAdmin;
}
