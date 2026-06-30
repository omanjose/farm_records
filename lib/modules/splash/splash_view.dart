import 'package:farm_records/core/constants/app_constants.dart';
import 'package:farm_records/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import 'splash_controller.dart';



class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

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

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: const Icon(Icons.agriculture_rounded,
                    size: 60, color: Colors.white),
              ),
              const SizedBox(height: 28),
              const Text(
                'DFRMS',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3),
              ),
              const SizedBox(height: 8),
              Text(
                'Digital Farm Record\nManagement System',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.75),
                    height: 1.5),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'MOUAU Agro Limited',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}