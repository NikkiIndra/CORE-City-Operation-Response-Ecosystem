import 'dart:convert';

import 'package:core/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

import '../../../../data/models/news_item.dart';
import '../../../../data/models/profile_model.dart';

class HomeController extends GetxController {
  var newsList = <NewsModel>[].obs;
  var isLoading = RxBool(false);
  var isBookmarked = false.obs;
  var isShared = false.obs;
  var isMore = false.obs;
  Rx<ProfileModel> user = ProfileModel(fullname: '', email: '', pass: '').obs;

  @override
  void onInit() {
    super.onInit();
    final raw = GetStorage().read("current_user");
    if (raw != null) {
      Map<String, dynamic> data;

      if (raw is String) {
        // Kalau ternyata disimpan dalam bentuk JSON string
        data = jsonDecode(raw);
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        print("Format tidak didukung: $raw");
        return;
      }

      user.value = ProfileModel.fromJson(data);
    }
    loadNews();
  }

  List image = [
    "assets/img1.png",
    "assets/img2.png",
    "assets/img3.png",
    "assets/img4.png",
    "assets/img5.png",
  ];
  List Fiture = ["BUS TRAKING", "LAPOR ", "KONTAK PENTING", "DARURAT"];

  List<IconData> iconFiture = [
    CupertinoIcons.bus,
    CupertinoIcons.paperplane,
    CupertinoIcons.phone,
    CupertinoIcons.exclamationmark_triangle_fill,
  ];

  List<String> widgetFiture = [
    Routes.BUS_TRAKING,
    Routes.REPORT,
    Routes.IMPORTANT_CONTACTS,
    Routes.EMERGENCY,
  ];

  // @override
  // void onReady() {
  //   super.onReady();

  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future<void> loadNews() async {
    isLoading.value = true;
    // newsList.assignAll(fetchedList);
    // bookmarkStatusList.assignAll(List.generate(fetchedList.length, (_) => false.obs));
    await Future.delayed(Duration(seconds: 2)); // Simulasi pemuatan data

    newsList.value = [
      NewsModel(
        title: "Instagram quietly limits ‘daily time limit’ option",
        author: "MacRumors",
        imageUrl: "https://picsum.photos/id/1000/960/540",
        postedOn: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      NewsModel(
        title: "Check your iPhone now: warning signs someone is spying on you",
        author: "New York Times",
        imageUrl: "https://picsum.photos/id/1001/960/540",
        postedOn: DateTime.now().subtract(Duration(hours: 2)),
      ),
      NewsModel(
        title:
            "Amazon’s incredibly popular Lost Ark MMO is ‘at capacity’ in central Europe",
        author: "MacRumors",
        imageUrl: "https://picsum.photos/id/1002/960/540",
        postedOn: DateTime.now().subtract(Duration(days: 1, hours: 3)),
      ),
      NewsModel(
        title:
            "Panasonic's 25-megapixel GH6 is the highest resolution Micro Four Thirds camera yet",
        author: "Polygon",
        imageUrl: "https://picsum.photos/id/1020/960/540",
        postedOn: DateTime.now().subtract(Duration(days: 1, hours: 3)),
      ),
      NewsModel(
        title: "Samsung Galaxy S22 Ultra charges strangely slowly",
        author: "TechRadar",
        imageUrl: "https://picsum.photos/id/1021/960/540",
        postedOn: DateTime.now().subtract(Duration(days: 1, hours: 3)),
      ),
    ];
    isLoading.value = false;
  }
}
