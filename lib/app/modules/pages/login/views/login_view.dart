import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../authcontroller/authC.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: c.email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: c.pass,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await c.login(
                  c.email.text.trim(),
                  c.pass.text.trim(),
                );
                if (success) {
                  Get.offNamed(Routes.NAVBAR);
                } else {
                  Get.snackbar("Error", "Login gagal");
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
