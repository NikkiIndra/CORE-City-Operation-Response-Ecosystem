import 'package:get/get.dart';

import '../controllers/play_report_controller.dart';

class PlayReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayReportController>(
      () => PlayReportController(),
    );
  }
}
