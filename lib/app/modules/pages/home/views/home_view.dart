import 'package:core/app/data/Service/ThemeController.dart';
import 'package:core/app/modules/pages/authcontroller/authC.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/Service/notification_badge_controller.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

import '../../../../data/Service/location_service.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final themeController = Get.find<ThemeController>();
  final authC = Get.find<AuthController>();
  final badgeC = Get.find<NotificationBadgeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed("/profile"),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: themeController.containerColor,
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage("assets/slide_1.png"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            final user = authC.currentUser.value;
                            return Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Selamat Datang ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (user?.fullname ?? "Tamu"),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                          Text(
                            "Semoga kamu Ceria Hari Ini",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).primaryTextTheme.labelSmall!.color!
                              // ignore: deprecated_member_use
                              .withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => Get.toNamed(Routes.NOTIFICATION),
                          icon: const Icon(Icons.notifications, size: 30),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Obx(() {
                            if (badgeC.badgeCount.value == 0) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                badgeC.badgeCount.value.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    "Fiture Utama",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 15),
                GridView.builder(
                  itemCount: 4,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (index < 3) {
                          // Tampilkan dialog loading
                          Get.dialog(
                            Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          // Cek koneksi internet
                          await LocationService.checkInternetConnection();
                          await Future.delayed(Duration(milliseconds: 200));
                          Get.back();

                          if (!LocationService.isConnected.value) {
                            Get.snackbar(
                              "Tidak Ada Koneksi Internet",
                              "Silakan periksa koneksi internet Anda.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.transparent,
                              colorText: Colors.black,
                            );
                            return;
                          }
                        }

                        // Navigasi via route name agar binding aktif otomatis
                        Get.toNamed(controller.widgetFiture[index]);
                      },

                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: themeController.containerColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(2, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(controller.iconFiture[index], size: 30),
                              SizedBox(height: 10),
                              Text("${controller.Fiture[index]}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: Text(
                    "Info Terbaru",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),

                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // SizedBox(height: 12),
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.newsList.length,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),

                    padding: EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index) {
                      final item = controller.newsList[index]; // ambil item

                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ), // jarak antar item
                        // height: 100,
                        decoration: BoxDecoration(
                          color: themeController.containerColor,
                          borderRadius: BorderRadius.circular(12),

                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(2, 1),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ), // spasi dalam konten
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    " ${item.author} · ${item.formattedTime}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap:
                                            () =>
                                                item.isBookmarked.value =
                                                    !item.isBookmarked.value,
                                        child: Obx(
                                          () => Icon(
                                            item.isBookmarked.value
                                                ? Icons.bookmark
                                                : Icons.bookmark_border_rounded,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(Icons.share, size: 20),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {},
                                        child: Icon(Icons.more_vert, size: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(controller.image[index]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
