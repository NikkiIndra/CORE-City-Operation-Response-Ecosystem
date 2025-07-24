import 'package:core/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../../../data/Service/ThemeController.dart';
import '../controllers/setting_controller.dart';
import 'modern_calendar.dart';

class SettingView extends StatelessWidget {
  SettingView({super.key});
  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                    title: "Dark Mode",
                    icon: CupertinoIcons.moon,
                    trailing: Obx(
                      () => CupertinoSwitch(
                        value: themeController.isDark,
                        onChanged: (value) {
                          themeController.toggleTheme();
                        },
                      ),
                    ),
                  ),

                  Obx(
                    () => _CustomListTile(
                      title:
                          "Notifikasi (${controller.notificationAllowed.value ? 'Diizinkan' : 'Diblokir'})",
                      icon: Icons.notifications_none_rounded,
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () {
                        controller.openSettingsAndRefresh();
                      },
                    ),
                  ),

                  _CustomListTile(
                    title: "Izinkan Kamera",
                    icon: Icons.camera_alt_outlined,
                    trailing: Obx(
                      () => CupertinoSwitch(
                        value: controller.cameraAllowed.value,
                        onChanged: (_) {
                          controller.openSettingsAndRefresh();
                        },
                      ),
                    ),
                  ),
                  _CustomListTile(
                    title: "Izinkan Lokasi",
                    icon: Icons.location_on_outlined,
                    trailing: Obx(
                      () => CupertinoSwitch(
                        value: controller.locationAllowed.value,
                        onChanged: (_) {
                          controller.openSettingsAndRefresh();
                        },
                      ),
                    ),
                  ),

                  const Divider(),
                  _SingleSection(
                    title: "Organization",
                    children: [
                      _CustomListTile(
                        title: "Messaging",
                        icon: Icons.message_outlined,
                        trailing: IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.PLAY_REPORT);
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ),
                      ),
                      const _CustomListTile(
                        title: "Calling",
                        icon: Icons.phone_outlined,
                      ),
                      const _CustomListTile(
                        title: "People",
                        icon: Icons.contacts_outlined,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CustomListTile(
                            title: "Calendar",
                            icon: Icons.calendar_today_rounded,
                            onTap: () => Get.to(() => const ModernCalendar()),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(),
                  const _SingleSection(
                    children: [
                      _CustomListTile(
                        title: "Help & Feedback",
                        icon: Icons.help_outline_rounded,
                      ),
                      _CustomListTile(
                        title: "About",
                        icon: Icons.info_outline_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(children: children),
      ],
    );
  }
}
