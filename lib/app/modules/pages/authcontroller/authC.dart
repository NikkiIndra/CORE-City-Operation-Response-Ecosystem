import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/Service/db_helper.dart';
import '../../../data/models/profile_model.dart';

class AuthController extends GetxController {
  final db = DatabaseHelper();
  var currentUser = Rxn<ProfileModel>();

  final fullname = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
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
    final user = ProfileModel(
      fullname: fullname.text,
      email: email.text,
      pass: pass.text,
      // mobilephone: '',
      // rt: '',
      // rw: '',
      // namaDesa: '',
    );
    await db.saveProfile(user);
    Get.snackbar("Berhasil", "Registrasi berhasil");
    clearForm();
  }

  Future<bool> login(String email, String pass) async {
    final profiles = await db.getProfiles();
    final found = profiles.firstWhereOrNull(
      (p) => p.email == email && p.pass == pass,
    );
    print("Isi DB: ${profiles.map((e) => e.toMap())}");

    if (found != null) {
      currentUser.value = found;

      // simpan juga ke local agar bisa ditarik di screen lain
      await GetStorage().write("current_user", found.toMap());
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
