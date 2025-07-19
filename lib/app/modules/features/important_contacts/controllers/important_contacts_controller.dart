import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/contact.dart';

class ImportantContactsController extends GetxController {
  var allContacts = <ContactModel>[].obs;
  var selectedCategory = "Semua".obs;
  var searchLocation = "".obs;
  var currentIndex = 0.obs;
  final isLoading = false.obs;
  var visibleCount = 20.obs;
  void loadMore() => visibleCount.value += 20;

  final categories =
      ["Semua", "Polisi", "Pemadam", "Rumah Sakit", "Basarnas", "BPBD"].obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  /// Fungsi dijalankan di isolate untuk parsing besar JSON
  static List<ContactModel> parseContactsInIsolate(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => ContactModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Load dan parsing data dari JSON asset
  Future<void> loadContacts() async {
    try {
      isLoading.value = true;

      final String response = await rootBundle.loadString(
        'assets/contact/contact.json',
      );

      final List<ContactModel> parsed = await compute(
        parseContactsInIsolate,
        response,
      );

      allContacts.value = parsed;
    } catch (e) {
      Get.snackbar(
        "Gagal Memuat Data",
        "Terjadi kesalahan saat memuat kontak.",
      );
      allContacts.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Ubah kategori
  void setCategory(String cat) => selectedCategory.value = cat;

  /// Ubah kata kunci pencarian
  void setSearchLocation(String loc) => searchLocation.value = loc.trim();

  /// Filter hasil berdasarkan kategori & lokasi
  List<ContactModel> get filteredUsers =>
      allContacts
          .where((u) {
            final isMatchCategory =
                selectedCategory.value == "Semua" ||
                u.category.toLowerCase() ==
                    selectedCategory.value.toLowerCase();

            final locationLower = u.location?.toLowerCase() ?? "";
            final searchLower = searchLocation.value.toLowerCase();

            final isMatchLocation =
                searchLower.isEmpty ||
                locationLower.contains(searchLower) ||
                u.location == null;

            return isMatchCategory && isMatchLocation;
          })
          .take(visibleCount.value)
          .toList();

  /// Fungsi panggilan telepon
  Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar("Gagal", "Tidak dapat membuka panggilan ke $phoneNumber");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }
}
