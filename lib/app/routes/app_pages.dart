import 'package:get/get.dart';

import '../modules/crops/bindings/crops_binding.dart';
import '../modules/crops/views/crop_detail_view.dart';
import '../modules/crops/views/crop_form_view.dart';
import '../modules/crops/views/crops_list_view.dart';
import '../modules/finance/bindings/finance_binding.dart';
import '../modules/finance/views/finance_form_view.dart';
import '../modules/finance/views/finance_list_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/livestock/bindings/livestock_binding.dart';
import '../modules/livestock/views/livestock_detail_view.dart';
import '../modules/livestock/views/livestock_form_view.dart';
import '../modules/livestock/views/livestock_list_view.dart';
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/farm_profile_form_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tasks/bindings/tasks_binding.dart';
import '../modules/tasks/views/task_form_view.dart';
import '../modules/tasks/views/tasks_list_view.dart';
import 'app_routes.dart';

/// Central registry mapping every [Routes] name to its view and
/// binding, used by GetMaterialApp for declarative navigation.
class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // Crops
    GetPage(
      name: Routes.cropList,
      page: () => const CropsListView(),
      binding: CropsBinding(),
    ),
    GetPage(
      name: Routes.cropForm,
      page: () => const CropFormView(),
      binding: CropsBinding(),
    ),
    GetPage(
      name: Routes.cropDetail,
      page: () => const CropDetailView(),
      binding: CropsBinding(),
    ),

    // Livestock
    GetPage(
      name: Routes.livestockList,
      page: () => const LivestockListView(),
      binding: LivestockBinding(),
    ),
    GetPage(
      name: Routes.livestockForm,
      page: () => const LivestockFormView(),
      binding: LivestockBinding(),
    ),
    GetPage(
      name: Routes.livestockDetail,
      page: () => const LivestockDetailView(),
      binding: LivestockBinding(),
    ),

    // Finance
    GetPage(
      name: Routes.financeList,
      page: () => const FinanceListView(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: Routes.financeForm,
      page: () => const FinanceFormView(),
      binding: FinanceBinding(),
    ),

    // Tasks
    GetPage(
      name: Routes.taskList,
      page: () => const TasksListView(),
      binding: TasksBinding(),
    ),
    GetPage(
      name: Routes.taskForm,
      page: () => const TaskFormView(),
      binding: TasksBinding(),
    ),

    // Reports
    GetPage(
      name: Routes.reports,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),

    // Settings
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.farmProfileForm,
      page: () => const FarmProfileFormView(),
      binding: SettingsBinding(),
    ),
  ];
}
