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

  Color get containerColor =>
      isDark ? const Color.fromARGB(200, 39, 39, 39) : Colors.white;
}

class AppThemes {
  static final lightTheme = _buildTheme(
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFF5F5F5), // terang netral
    primaryColor: Colors.white,
    surfaceColor: Colors.white,
    textColor: const Color(0xFF2E382E),
    cardColor: const Color(0xFFEAEAEA),
    iconColor: Colors.black87,
  );

  static final darkTheme = _buildTheme(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF1E1E1E), // tidak terlalu pekat
    primaryColor: const Color(0xFF2D2D30),
    surfaceColor: const Color(0xFF2F2F33), // sedikit terang untuk surface
    textColor: Colors.white70,
    cardColor: const Color(
      0xFF3C3C42,
    ), // permukaan sedikit lebih terang dari background
    iconColor: Colors.white70,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color backgroundColor,
    required Color primaryColor,
    required Color surfaceColor,
    required Color textColor,
    required Color cardColor,
    required Color iconColor,
  }) {
    return ThemeData(
      fontFamily: 'Poppins',
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      cardColor: cardColor,
      canvasColor: surfaceColor,
      iconTheme: IconThemeData(color: iconColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        elevation: 1, // 1dp elevasi
        selectedItemColor: textColor,
        unselectedItemColor: iconColor.withOpacity(0.6),
      ),
      inputDecorationTheme: _inputDecorationTheme(textColor, surfaceColor),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: textColor),
        bodyLarge: TextStyle(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(surfaceColor, textColor),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    Color borderColor,
    Color fillColor,
  ) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor.withOpacity(0.4)),
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
      side: BorderSide(color: textColor.withOpacity(0.5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
    );
  }
}
