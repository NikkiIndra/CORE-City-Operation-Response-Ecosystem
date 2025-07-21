import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/Service/db_helper.dart';
import '../../../data/models/profile_model.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final db = DatabaseHelper();
  var currentUser = Rxn<ProfileModel>();

  final fullname = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    final storedUser = GetStorage().read("current_user");
    if (storedUser != null) {
      currentUser.value = ProfileModel.fromJson(
        Map<String, dynamic>.from(storedUser),
      );
    }
  }

  Future<void> register() async {
    final existingUsers = await db.getProfiles();
    if (existingUsers.isNotEmpty) {
      // Hindari pendaftaran dobel
      return;
    }
    if (!isValidEmail(email.text)) {
      Get.snackbar(
        "Email Tidak Valid",
        "Gunakan email seperti user@domain.com",
      );
      return;
    }

    if (!isValidPassword(pass.text)) {
      Get.snackbar(
        "Password Lemah",
        "Gunakan minimal 8 karakter dengan huruf dan angka",
      );
      return;
    }

    final profiles = await db.getProfiles();
    final exists = profiles.any((p) => p.email == email.text);

    if (exists) {
      Get.snackbar("Email Sudah Terdaftar", "Silakan gunakan email lain");
      return;
    }

    final user = ProfileModel(
      fullname: fullname.text,
      email: email.text,
      pass: pass.text,
    );

    await db.saveProfile(user);
    await GetStorage().write("current_user", user.toMap());

    Get.snackbar("Berhasil", "Registrasi berhasil");
    clearForm();
    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(Routes.LOGIN);
  }

  Future<bool> login(String emailInput, String passInput) async {
    if (!isValidEmail(emailInput)) {
      Get.snackbar("Email Tidak Valid", "Masukkan email yang benar");
      return false;
    }

    if (!isValidPassword(passInput)) {
      Get.snackbar(
        "Password Tidak Valid",
        "Password harus minimal 8 karakter dan mengandung simbol",
      );
      return false;
    }

    final profiles = await db.getProfiles();
    final found = profiles.firstWhereOrNull(
      (p) => p.email == emailInput && p.pass == passInput,
    );

    if (found != null) {
      currentUser.value = found;
      await GetStorage().write("current_user", found.toMap());
      await GetStorage().write("is_logged_in", true); // Tandai login
      return true;
    }

    Get.snackbar("Gagal Login", "Email atau Password salah");
    return false;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+(com|id|org|net|outlook|edu)$",
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Minimal 8 karakter, mengandung huruf, angka, dan simbol
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final users = await db.getProfiles();
    final user = users.firstWhereOrNull((u) => u.email == email);
    if (user != null) {
      final updatedUser = user.copyWith(pass: newPassword);
      await db.updateProfile(updatedUser);
      return true;
    }
    return false;
  }

  void clearForm() {
    fullname.clear();
    email.clear();
    pass.clear();
  }
}
