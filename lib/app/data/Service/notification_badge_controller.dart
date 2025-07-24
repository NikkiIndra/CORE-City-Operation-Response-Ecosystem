import 'package:get/get.dart';

class NotificationBadgeController extends GetxController {
  var badgeCount = 0.obs;

  void increment() {
    badgeCount.value++;
  }

  void decrement() {
    if (badgeCount.value > 0) {
      badgeCount.value--;
    }
  }

  void reset() {
    badgeCount.value = 0;
  }

  void setBadge(int value) {
    badgeCount.value = value;
  }
}
