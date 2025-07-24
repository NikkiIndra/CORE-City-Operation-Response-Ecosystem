import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:core/app/data/Service/db_helper.dart';
import 'package:core/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../data/Service/notification_badge_controller.dart';
import '../../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  var reset = 0.obs;
  void badgeCount() => reset.value;
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    notifications.value = await DatabaseHelper.instance.getAllNotifications();
  }

  Future<void> deleteNotification(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      // Kurangi badge jika notif belum dibaca dan badge > 0
      if (Get.find<NotificationBadgeController>().badgeCount > 0) {
        AwesomeNotifications().decrementGlobalBadgeCounter();
        Get.find<NotificationBadgeController>().decrement();
      }
    }

    await DatabaseHelper.instance.deleteNotification(id);
    await loadNotifications(); // refresh list
  }

  void addNotification(NotificationItem notif) {
    notifications.insert(0, notif);
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh();

      // Hanya kurangi jika badge masih > 0
      if (Get.find<NotificationBadgeController>().badgeCount > 0) {
        AwesomeNotifications().decrementGlobalBadgeCounter();
        Get.find<NotificationBadgeController>().decrement();
      }
    }
  }

  Future<void> markAllAsRead() async {
    // Tandai semua notifikasi sebagai dibaca
    for (var notif in notifications) {
      notif.isRead = true;
    }
    notifications.refresh();

    // Simpan ke database
    await DatabaseHelper.instance.markAllAsRead(); // fungsi ini di DBHelper

    // Reset badge
    await AwesomeNotifications().resetGlobalBadge();
    Get.find<NotificationBadgeController>().reset();
  }

  // void deleteNotification(String id) {
  //   notifications.removeWhere((n) => n.id == id);
  // }

  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'basic_channel', //  ini perlu agar badge jalan
          channelName: 'Basic Notifications',
          channelDescription: 'Used for basic notifications',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications().getInitialNotificationAction(
      removeFromActionEvents: false,
    );
  }

  // static ReceivePort? receivePort;
  // static Future<void> initializeIsolateReceivePort() async {
  //   receivePort = ReceivePort('Notification action port in main isolate')
  //     ..listen(
  //         (silentData) => onActionReceivedImplementationMethod(silentData));

  //   // This initialization only happens on main isolate
  //   IsolateNameServer.registerPortWithName(
  //       receivePort!.sendPort, 'notification_action_port');
  // }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedNotification recievedNotification,
  ) async {
    print("ini akan di panggil jika notifnya di Hapus");
    AwesomeNotifications().decrementGlobalBadgeCounter();
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification recievedNotification,
  ) async {
    print("ini akan di panggil jika notifnya Dibuat");
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification recievedNotification,
  ) async {
    print("ini akan di panggil jika notifnya muncul");
    // ini akan menambahkan otomatis setiap kali notif muncul
    AwesomeNotifications().incrementGlobalBadgeCounter();
    Get.find<NotificationBadgeController>().increment();
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    Get.toNamed('/notification', arguments: receivedAction);
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print(
        'Message sent via notification input: "${receivedAction.buttonKeyInput}"',
      );
      print('>>> [NOTIF] onActionReceivedMethod triggered');

      // await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      // if (receivePort == null) {
      //   print(
      //       'onActionReceivedMethod was called inside a parallel dart isolate.');
      //   SendPort? sendPort =
      //       IsolateNameServer.lookupPortByName('notification_action_port');

      //   if (sendPort != null) {
      //     print('Redirecting the execution to main isolate process.');
      //     sendPort.send(receivedAction);
      //     return;
      //   }
      // }

      // return onActionReceivedImplementationMethod(receivedAction);
    }
    Get.find<NotificationBadgeController>().decrement();
  }

  static Future<void> onActionReceivedImplementationMethod(
    ReceivedAction receivedAction,
  ) async {
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/notification-page',
      (route) => (route.settings.name != '/notification-page') || route.isFirst,
      arguments: receivedAction,
    );
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'Get Notified!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: Image.asset(
              //         'assets/images/animated-bell.gif',
              //         height: MediaQuery.of(context).size.height * 0.3,
              //         fit: BoxFit.fitWidth,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              const Text(
                'Allow Awesome Notifications to send you beautiful notifications!',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Deny',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                userAuthorized = true;
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Allow',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(
    String title,
    String body, {
    required String bigPicture,
    List<NotificationActionButton>? actions, // ✅ Tambahkan ini
  }) async {
    final uuid = Uuid();
    final id = uuid.v4();
    final notif = NotificationItem(
      id: id,
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );

    await DatabaseHelper.instance.insertNotification(notif);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().microsecond,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        bigPicture: bigPicture,
        largeIcon: 'assets/icons_apps.png',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'notificationId': notif.id},
      ),
      actionButtons: actions, //  Gunakan parameter actions jika ada
    );
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await myNotifyScheduleInHours(
      title: 'test',
      msg: 'test message',
      heroThumbUrl:
          'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
      hoursFromNow: 5,
      username: 'test user',
      repeatNotif: false,
    );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}

Future<void> myNotifyScheduleInHours({
  required int hoursFromNow,
  required String heroThumbUrl,
  required String username,
  required String title,
  required String msg,
  bool repeatNotif = false,
}) async {
  var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationCalendar(
      //weekday: nowDate.day,
      hour: nowDate.hour,
      minute: 0,
      second: nowDate.second,
      repeats: repeatNotif,
      //allowWhileIdle: true,
    ),
    // schedule: NotificationCalendar.fromDate(
    //    date: DateTime.now().add(const Duration(seconds: 10))),
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'basic_channel',
      title: '${Emojis.food_bowl_with_spoon} $title',
      body: '$username, $msg',
      bigPicture: heroThumbUrl,
      notificationLayout: NotificationLayout.BigPicture,
      //actionType : ActionType.DismissAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
    ),
    actionButtons: [
      NotificationActionButton(key: 'NOW', label: 'btnAct1'),
      NotificationActionButton(key: 'LATER', label: 'btnAct2'),
    ],
  );
}
