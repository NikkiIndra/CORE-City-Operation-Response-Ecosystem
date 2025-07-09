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
        speed: 1.8,
        imageVerticalOffset: 20,
        headerBackgroundColor: Colors.black,
        finishButtonText: 'Register',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.black,
          elevation: 13,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          disabledElevation: 23,
          focusColor: Colors.black,
        ),
        onFinish: () {
          Get.offAllNamed(Routes.REGISTER);
        },
        skipTextButton: Container(
          padding: const EdgeInsets.only(
            right: 16,
            top: 3,
            left: 16,
            bottom: 5,
          ),
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),

            color: Colors.transparent,
            border: Border.fromBorderSide(BorderSide(color: Colors.black)),
          ),
          child: Text("Skip", style: TextStyle(color: Colors.black)),
        ),
        // hasSkip: true,
        // hasFloatingButton: true,
        trailing: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Login"),
          onPressed: () => Get.offAllNamed(Routes.NAVBAR),
        ),

        background: [
          Image.asset('assets/slide_1.png', height: 400, fit: BoxFit.contain),
          Image.asset('assets/slide_2.png', height: 400, fit: BoxFit.contain),
          Image.asset('assets/slide_3.png', height: 400, fit: BoxFit.contain),
        ],
        centerBackground: true,
        pageBodies: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: "nunggu yang ga pasti ?\n",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "\npasti kesel kan nugguin terus bus yang ga kunjung datang tanpa tau dia di mana?",
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: "nunggu yang ga pasti ?\n",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "\npasti kesel kan nugguin terus bus yang ga kunjung datang tanpa tau dia di mana?",
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: "nunggu yang ga pasti ?\n",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "\npasti kesel kan nugguin terus bus yang ga kunjung datang tanpa tau dia di mana?",
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
