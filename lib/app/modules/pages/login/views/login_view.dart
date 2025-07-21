import 'package:core/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/widgets/loading_screen.dart';
import '../../authcontroller/authC.dart';
import '../../home/controllers/home_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final authC = Get.find<AuthController>();
  final formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: screenHeight * 0.05,
          ),
          child: Form(
            key: formKeyLogin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "Let's Goooo",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Lihat berita terbaru dan terupdate"),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Image.asset(
                    "assets/icons_apps.png",
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                TextFormField(
                  controller: authC.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                TextFormField(
                  controller: authC.pass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                  child: const Text(
                    "Lupa Password?",
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      LoadingWidget.showLoading(
                        context,
                        message: "Memverifikasi...",
                      );

                      final success = await authC.login(
                        authC.email.text.trim(),
                        authC.pass.text.trim(),
                      );

                      LoadingWidget.hideLoading(context);

                      if (success) {
                        Get.offAllNamed(Routes.NAVBAR);
                      }
                      print(
                        Get.isRegistered<HomeController>(),
                      ); // true = aman, false = belum ada
                    },

                    child: const Text("Login"),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum punya akun?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.REGISTER),

                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF06D6A0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
