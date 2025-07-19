import 'package:core/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/Service/ThemeController.dart';
import 'app/modules/pages/authcontroller/authC.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Get.put(AuthController());// permanent: true);
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme();
  Get.put(AuthController());
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
