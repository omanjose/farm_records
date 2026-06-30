import 'package:get/get.dart';
import 'livestock_controller.dart';

class LivestockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LivestockController>(() => LivestockController(),
        fenix: true);
  }
}
