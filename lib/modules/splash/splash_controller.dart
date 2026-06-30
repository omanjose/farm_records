import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/database/database_helper.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    // ── 1. Initialise the database (seed on first run) ──────────────────────
    try {
      await DatabaseHelper.instance.database
          .timeout(const Duration(seconds: 15));
    
    } catch (e) {
      debugPrint('[DFRMS] DB init error: $e');
      // Continue anyway – login screen will show the error if needed
    }

    // ── 2. Minimum splash display time ──────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 1600));

    // ── 3. Decide where to navigate ─────────────────────────────────────────
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(AppConstants.prefUserId);
      if (userId != null && userId > 0) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('[DFRMS] Session check error: $e');
      Get.offAllNamed(AppRoutes.login);
    }
  }
}


