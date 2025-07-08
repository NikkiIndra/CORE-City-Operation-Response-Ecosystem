import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final user = box.read('currentUser') ?? {};
    name.value = user['namaKtp'] ?? '';
    email.value = user['email'] ?? '';
  }
}
