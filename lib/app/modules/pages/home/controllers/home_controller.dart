import 'package:core/app/modules/features/bus_traker/views/bus_traking_view.dart';
import 'package:core/app/modules/features/report/views/report_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/models/news_item.dart';
import '../../../features/emergency/views/emergency_view.dart';
import '../../../features/important_contacts/views/important_contacts_view.dart';

class HomeController extends GetxController {

  var newsList = <NewsModel>[].obs;
  final box = GetStorage();
  final count = 0.obs;
  final name = ''.obs;
  var isLoading = RxBool(false);
  var isBookmarked = false.obs;
  var isShared = false.obs;
  var isMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    name.value = box.read('namaKtp') ?? '';
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

  List <Widget> widgetFiture = [
    BusTrakingView(),
    ReportView(),
    ImportantContactsView(),
    EmergencyView(),
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

  void increment() => count.value++;
}
