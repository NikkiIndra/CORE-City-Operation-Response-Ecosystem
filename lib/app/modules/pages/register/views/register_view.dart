import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/widgets/loading_screen.dart';
import '../../../../routes/app_pages.dart';
import '../../authcontroller/authC.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final authC = Get.find<AuthController>();
  final formKeyRegister = GlobalKey<FormState>();

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
            key: formKeyRegister,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daftar Sekarang",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Buat akun baru untuk mulai menjelajah"),
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
                  controller: authC.fullname,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.015),

                TextFormField(
                  controller: authC.email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.015),

                TextFormField(
                  controller: authC.pass,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.04),

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
                      if (formKeyRegister.currentState!.validate()) {
                        final users = await authC.db.getProfiles();
                        if (users.isNotEmpty) {
                          Get.snackbar(
                            "Sudah Terdaftar",
                            "Anda sebelumnya sudah melakukan registrasi.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return; // STOP di sini
                        }

                        // Jika belum pernah daftar, baru lanjut
                        // HANYA ditampilkan jika lanjut proses
                        LoadingWidget.showLoading(
                          // ignore: use_build_context_synchronously
                          context,
                          message: "Mendaftarkan...",
                        );

                        await authC.register();
                        // ignore: use_build_context_synchronously
                        LoadingWidget.hideLoading(context);
                      }
                    },

                    child: const Text("Daftar"),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Get.offAllNamed(Routes.LOGIN),

                      child: const Text(
                        "Login",
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
