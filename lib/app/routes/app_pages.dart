import 'package:get/get.dart';
import '../../modules/splash/splash_binding.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/auth/login_binding.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/auth/signup_binding.dart';
import '../../modules/auth/signup_view.dart';
import '../../modules/main/main_binding.dart';
import '../../modules/main/main_view.dart';
import '../../modules/crops/crop_form_view.dart';
import '../../modules/crops/crop_binding.dart';
import '../../modules/livestock/livestock_form_view.dart';
import '../../modules/livestock/livestock_binding.dart';
import '../../modules/finance/finance_form_view.dart';
import '../../modules/finance/finance_binding.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: SignupBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.cropForm,
      page: () => const CropFormView(),
      binding: CropBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.livestockForm,
      page: () => const LivestockFormView(),
      binding: LivestockBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.financeForm,
      page: () => const FinanceFormView(),
      binding: FinanceBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
