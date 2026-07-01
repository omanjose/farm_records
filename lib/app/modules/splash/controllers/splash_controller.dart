import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

/// Handles the brief startup delay/branding screen before routing the
/// user into the main app shell.
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    Get.offAllNamed(Routes.home);
  }
}
