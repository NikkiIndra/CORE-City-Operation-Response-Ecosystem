import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../authcontroller/authC.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.fullname,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: controller.email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: controller.pass,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await controller.register();
                Get.offNamed(Routes.LOGIN);
              },
              child: const Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
