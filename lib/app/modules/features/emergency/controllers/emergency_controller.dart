import 'package:get/get.dart';

class EmergencyController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(microseconds: 500), () {
      isLoading.value = false;
    });
  }
}
