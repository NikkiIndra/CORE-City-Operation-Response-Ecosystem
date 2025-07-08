import 'package:get/get.dart';

import '../controllers/important_contacts_controller.dart';

class ImportantContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportantContactsController>(
      () => ImportantContactsController(),
    );
  }
}
