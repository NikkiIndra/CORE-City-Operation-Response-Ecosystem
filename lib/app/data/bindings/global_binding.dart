import 'package:get/get.dart';

import '../../modules/PAGE/home/controllers/home_controller.dart';
import '../Service/ThemeController.dart';

class GlobalBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<HomeController>(() => HomeController(),);
  }

}