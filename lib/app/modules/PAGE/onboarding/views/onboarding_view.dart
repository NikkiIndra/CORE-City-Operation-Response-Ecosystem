import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,

      home: OnBoardingSlider(
        totalPage: 3,
        imageVerticalOffset: 20,
        headerBackgroundColor: Colors.black.withOpacity(0.8),
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.black12.withOpacity(0.8),
        ),

        onFinish: () {
          Get.offAllNamed(Routes.REGISTER);
        },
        skipTextButton: Container(
          padding: const EdgeInsets.only(
            right: 16,
            top: 3,
            bottom: 3,
            left: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            border: Border.fromBorderSide(BorderSide(color: Colors.black)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.greaterthan_circle, color: Colors.black),
              SizedBox(width: 8),
              Text("Skip", style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        // hasSkip: true,
        // hasFloatingButton: true,
        trailing: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Login"),
          onPressed: () => Get.offAllNamed(Routes.NAVBAR),
        ),

        background: [
          // Halaman 1
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/slide_1.png', fit: BoxFit.cover),
          ),
          // Halaman 2
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/slide_2.png', fit: BoxFit.cover),
          ),
          // Halaman 3 (Tengah)
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/slide_3.png', fit: BoxFit.cover),
          ),
        ],

        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 540),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Gimana kalo aplikasi ini ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'bisa membantu ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'kamu? menyelamatkan ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' nyawa ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'misalnya!!!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 540),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Atau gimana Kalo aplika',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'si ini bisa ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' membantu menyelamat',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'kan kamu dari ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' pemotongan gaji? Kar',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'ena Terlambat ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),

                      TextSpan(
                        text: 'Kerja  misalnya!!!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 540),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Okh Sudah',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' Waktunya Kita Mulai,',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' Perjalanan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' Untuk Menjadi Seseorang ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'yang ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'lebih bermanfaat',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
