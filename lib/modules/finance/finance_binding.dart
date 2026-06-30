import 'package:get/get.dart';
import 'finance_controller.dart';

class FinanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinanceController>(() => FinanceController(), fenix: true);
  }
}
