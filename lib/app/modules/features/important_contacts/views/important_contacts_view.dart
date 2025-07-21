import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/contact.dart';
import '../controllers/important_contacts_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportantContactsView extends GetView<ImportantContactsController> {
  const ImportantContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Kontak Darurat")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // FILTER BUTTON
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children:
                    controller.categories.map((cat) {
                      final isSelected =
                          controller.selectedCategory.value == cat;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) => controller.setCategory(cat),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          // SEARCH FIELD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari lokasi... (misal: Cirebon)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => controller.setSearchLocation(value),
            ),
          ),

          const SizedBox(height: 10),

          // LIST VERTIKAL KONTAK
          Expanded(
            child: Obx(() {
              final users = controller.filteredUsers;
              if (users.isEmpty) {
                return const Center(
                  child: Text("Tidak ada data kontak untuk kategori ini."),
                );
              }

              // Group data berdasarkan kategori
              final Map<String, List<ContactModel>> grouped = {};
              for (var user in users) {
                grouped.putIfAbsent(user.category, () => []).add(user);
              }

              final categories = grouped.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, catIndex) {
                  final category = categories[catIndex];
                  final contacts = grouped[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul kategori
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child:
                            category.toLowerCase().contains("rsia")
                                ? Text(
                                  "$category [Rs Ibu dan Anak]",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade900,
                                  ),
                                )
                                : Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan.shade900,
                                  ),
                                ),
                      ),

                      // List kontak per kategori
                      ...contacts.map((user) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(child: Text(user.phone ?? "")),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.call),
                                      label: const Text("Panggil"),
                                      onPressed: () async {
                                        final sanitizedPhone =
                                            user.phone ??
                                            " ".replaceAll(
                                              RegExp(r'\s+|\D'),
                                              '',
                                            );
                                        final uri = Uri(
                                          scheme: 'tel',
                                          path: sanitizedPhone,
                                        );
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "Tidak bisa membuka aplikasi telepon",
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lokasi: ${user.location ?? "Nomor Darurat Nasional"}',
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
