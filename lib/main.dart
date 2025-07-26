import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:core/app/data/Service/db_helper.dart';
import 'package:core/app/modules/notification/controllers/notification_controller.dart';
import 'package:core/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/data/Service/ThemeController.dart';
import 'app/modules/pages/authcontroller/authC.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await GetStorage.init();
  await AwesomeNotifications().requestPermissionToSendNotifications();

  final themeController = Get.put(ThemeController());
  await themeController.loadTheme();

  final dbHelper = DatabaseHelper.instance;

  // 💣 Hapus database hanya untuk DEVELOPMENT
  // Setelah dihapus, Anda harus init lagi:
  await dbHelper.deleteDatabaseFile();

  // ✅ Inisialisasi ulang DB-nya di sini
  await dbHelper.initDB();

  // 🔄 PUT setelah DB valid
  Get.put(AuthController());
  Get.put(NotificationController(), permanent: true);
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
