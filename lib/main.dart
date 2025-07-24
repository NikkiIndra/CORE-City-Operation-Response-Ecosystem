import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:core/app/modules/notification/controllers/notification_controller.dart';
import 'package:core/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/Service/ThemeController.dart';
import 'app/modules/pages/authcontroller/authC.dart';

Future<void> main() async {
  final themeController = Get.put(ThemeController());
  // final dbHelper = DatabaseHelper.instance;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await GetStorage.init();
  await NotificationController.initializeLocalNotifications();
  await AwesomeNotifications().requestPermissionToSendNotifications();
  // await DatabaseHelper.instance.initDB();
  await themeController.loadTheme();

  Get.put(AuthController());
  Get.put(NotificationController(), permanent: true);
  // await dbHelper.deleteDatabaseFile();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
