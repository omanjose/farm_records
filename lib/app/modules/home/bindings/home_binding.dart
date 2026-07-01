import 'package:get/get.dart';

import '../../crops/controllers/crops_controller.dart';
import '../../finance/controllers/finance_controller.dart';
import '../../livestock/controllers/livestock_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../controllers/home_controller.dart';

/// Initializes the home shell controller plus every tab controller so
/// they persist across bottom-navigation tab switches (IndexedStack).
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<CropsController>(CropsController(), permanent: true);
    Get.put<LivestockController>(LivestockController(), permanent: true);
    Get.put<FinanceController>(FinanceController(), permanent: true);
    Get.put<TasksController>(TasksController(), permanent: true);
  }
}
