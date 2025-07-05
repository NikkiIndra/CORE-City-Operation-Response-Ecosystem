import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  final _box = GetStorage();

  bool get isDark => _isDarkMode.value;

  Future<void> loadTheme() async {
    _isDarkMode.value = _box.read('isDarkMode') ?? false;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _box.write('isDarkMode', _isDarkMode.value);
  }
}

class AppThemes {
  static final lightTheme = _buildTheme(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    primaryColor: Colors.white,
    textColor: const Color(0xFF2E382E),
  );

  static final darkTheme = _buildTheme(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF2E382E),
    primaryColor: const Color(0xFF2E382E),
    textColor: const Color(0xFF50C9CE),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color backgroundColor,
    required Color primaryColor,
    required Color textColor,

  }) {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      iconTheme: IconThemeData(color: textColor),
      inputDecorationTheme: _inputDecorationTheme(textColor, backgroundColor),
      textTheme: TextTheme(bodyMedium: TextStyle(color: textColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(backgroundColor, textColor),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Color borderColor, Color fillColor) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(8),
    );

    return InputDecorationTheme(
      fillColor: fillColor,
      filled: true,
      labelStyle: TextStyle(color: borderColor),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
    );
  }

  static ButtonStyle _buttonStyle(Color backgroundColor, Color textColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      side: BorderSide(color: textColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
