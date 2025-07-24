import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text("Tidak ada notifikasi"));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];

            return ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(notif.title),
              subtitle: Text(notif.body),
              trailing:
                  notif.isRead
                      ? null
                      : const Icon(Icons.circle, size: 10, color: Colors.red),
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder:
                      (context) => CupertinoActionSheet(
                        title: Text(notif.title),
                        message: Text(notif.body),
                        actions: [
                          CupertinoActionSheetAction(
                            child: const Text("Tandai Sudah Dibaca"),
                            onPressed: () {
                              controller.markAsRead(notif.id);
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text("Hapus"),
                            isDestructiveAction: true,
                            onPressed: () {
                              controller.deleteNotification(notif.id);
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text("Tandai Semua Sudah Dibaca"),
                            onPressed: () async {
                              await controller.markAllAsRead();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: const Text("Tutup"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
