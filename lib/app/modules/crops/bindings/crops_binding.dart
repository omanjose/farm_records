import 'package:get/get.dart';

import '../controllers/crops_controller.dart';

class CropsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropsController>(() => CropsController(), fenix: true);
  }
}
