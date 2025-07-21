import 'package:core/app/modules/pages/authcontroller/authC.dart';
import 'package:core/app/modules/pages/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/bindings/global_binding.dart';
import '../../../../data/widgets/loading_screen.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto Profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/slide_1.png"),
              ),
            ),
            const SizedBox(height: 15),
            // Nama dan Email
            Obx(() {
              final user = authC.currentUser.value;
              return Text(
                user?.fullname ?? "Nama Tidak Ditemukan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            }),
            Obx(() {
              final user = authC.currentUser.value;
              return Text(
                user?.email ?? "Email Tidak Ditemukan",
                style: TextStyle(color: Colors.grey),
              );
            }),

            // Tombol Edit Profil
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => controller.verifyPassword(),

                child: const Text("Edit Profil"),
              ),
            ),
            const SizedBox(height: 30),

            // Menu lainnya
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Ubah Password"),
              onTap: () {
                // Aksi ubah password
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Pengaturan"),
              onTap: () {
                // Aksi ke halaman pengaturan
              },
            ),
            GestureDetector(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text("Keluar"),
              ),
              onTap: () {
                LoadingWidget.showLoading(
                  context,
                  message: "Keluar dari aplikasi...",
                );
                Future.delayed(const Duration(seconds: 3), () {
                  // ignore: use_build_context_synchronously
                  LoadingWidget.hideLoading(context);
                  Get.offAll(
                    () => LoginView(),
                    binding: GlobalBindings(), // atau GlobalBindings()
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
