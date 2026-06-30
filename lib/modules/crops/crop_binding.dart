import 'package:get/get.dart';
import 'crop_controller.dart';

class CropBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropController>(() => CropController(), fenix: true);
  }
}
