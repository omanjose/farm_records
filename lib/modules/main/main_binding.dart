import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import '../crops/crop_controller.dart';
import '../livestock/livestock_controller.dart';
import '../finance/finance_controller.dart';
import '../reports/reports_controller.dart';
import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<CropController>(() => CropController(), fenix: true);
    Get.lazyPut<LivestockController>(() => LivestockController(), fenix: true);
    Get.lazyPut<FinanceController>(() => FinanceController(), fenix: true);
    Get.lazyPut<ReportsController>(() => ReportsController(), fenix: true);
  }
}
