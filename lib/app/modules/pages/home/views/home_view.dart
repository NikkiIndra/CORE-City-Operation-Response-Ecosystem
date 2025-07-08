import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
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
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: AssetImage("assets/slide_1.png"),
                          fit: BoxFit.cover,
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Selamat Datang ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: controller.name.value,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Semoga kamu Ceria Hari Ini",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Text(
                  "Fiture Utama",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 25,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.to(() => controller.widgetFiture[index]),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 0.5),
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
                SizedBox(height: 20),
                Text(
                  "Info Terbaru",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                        margin: EdgeInsets.only(bottom: 12), // jarak antar item
                        // height: 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8), // spasi dalam konten
                        child: Row(
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
