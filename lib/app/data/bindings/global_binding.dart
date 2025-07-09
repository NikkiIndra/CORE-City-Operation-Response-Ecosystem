import 'package:core/app/modules/pages/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../modules/features/bus_traker/controllers/bus_traking_controller.dart';
import '../../modules/pages/home/controllers/home_controller.dart';
import '../Service/ThemeController.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<BusTrakingController>(() => BusTrakingController());
  }
}
