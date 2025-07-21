import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../authcontroller/authC.dart';

class ResetPasswordView extends StatelessWidget {
  final authC = Get.find<AuthController>();

  final emailC = TextEditingController();
  final newPassC = TextEditingController();
  final confirmPassC = TextEditingController();

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email Terdaftar"),
            ),
            TextField(
              controller: newPassC,
              decoration: const InputDecoration(labelText: "Password Baru"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPassC,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Password Baru",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (newPassC.text != confirmPassC.text) {
                  Get.snackbar("Error", "Password tidak sama");
                  return;
                }

                final success = await authC.resetPassword(
                  emailC.text.trim(),
                  newPassC.text.trim(),
                );
                if (success) {
                  Get.snackbar("Berhasil", "Password berhasil diubah");
                  Get.offAllNamed(Routes.LOGIN);
                } else {
                  Get.snackbar("Gagal", "Email tidak ditemukan");
                }
              },
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
