import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/Service/db_helper.dart';
import '../../authcontroller/authC.dart';

class ProfileController extends GetxController {
  final authC = Get.find<AuthController>();
  final db = DatabaseHelper.instance;

  Future<void> updateUserField(String field, String newValue) async {
    final user = authC.currentUser.value!;
    switch (field) {
      case 'fullname':
        user.fullname = newValue;
        break;
      case 'email':
        user.email = newValue;
        break;
      case 'password':
        user.pass = newValue;
        break;
    }
    await db.updateProfile(user);
    authC.currentUser.value = user;
    await GetStorage().write("current_user", user.toMap());
  }

  bool _verifyPassword(String input) => authC.currentUser.value?.pass == input;

  void verifyPassword() {
    Get.defaultDialog(
      title: "Verifikasi Password",
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onTap: () => authC.pass.clear(),
              controller: authC.pass,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password Lama"),
            ),
          ],
        ),
      ),
      textConfirm: "Lanjut",
      textCancel: "Batal",
      onCancel: () {
        authC.pass.clear(); // clear saat cancel
      },
      onConfirm: () {
        print("Password dari currentUser: ${authC.currentUser.value?.pass}");
        if (_verifyPassword(authC.pass.text)) {
          Get.back();
          authC.pass.clear();
          _showEditOptions();
        } else {
          Get.snackbar("Gagal", "Password lama salah");
          authC.pass.clear();
        }
      },
    );
  }

  void _showEditOptions() {
    Get.bottomSheet(
      Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Ubah Nama"),
            onTap: () => _editSingleField("fullname"),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Ubah Email"),
            onTap: () => _editSingleField("email"),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Ubah Password"),
            onTap: () => _editPassword(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  void _editSingleField(String field) {
    final controller = TextEditingController();
    final auth = Get.find<AuthController>();
    final current = auth.currentUser.value!;

    controller.text = field == "fullname" ? current.fullname : current.email;
    Get.back();

    Get.defaultDialog(
      title: "Ubah ${field == 'fullname' ? 'Nama' : 'Email'}",
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: field == 'fullname' ? "Nama baru" : "Email baru",
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      onConfirm: () async {
        await updateUserField(field, controller.text);
        Get.back();
        Get.snackbar(
          "Sukses",
          "${field == 'fullname' ? 'Nama' : 'Email'} diperbarui",
        );
      },
    );
  }

  void _editPassword() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    Get.back(); // tutup bottom sheet

    Get.defaultDialog(
      title: "Ubah Password",
      content: Column(
        children: [
          TextField(
            controller: oldController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password Lama"),
          ),
          TextField(
            controller: newController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password Baru"),
          ),
          TextField(
            controller: confirmController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Konfirmasi Password"),
          ),
        ],
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      onConfirm: () async {
        final auth = Get.find<AuthController>();
        if (oldController.text != auth.currentUser.value?.pass) {
          Get.snackbar("Gagal", "Password lama salah");
          return;
        }
        if (newController.text != confirmController.text) {
          Get.snackbar("Gagal", "Konfirmasi password tidak sama");
          return;
        }
        await updateUserField("password", newController.text);
        Get.back();
        Get.snackbar("Sukses", "Password berhasil diperbarui");
      },
    );
  }
}
