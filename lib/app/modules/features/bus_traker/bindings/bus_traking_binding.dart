import 'package:get/get.dart';

import '../controllers/bus_traking_controller.dart';

class BusTrakingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusTrakingController>(() => BusTrakingController());
  }
}
