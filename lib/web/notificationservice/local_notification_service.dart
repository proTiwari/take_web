import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );

        }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      print("sddsd1");
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      print("sddsd2");
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          icon: "noticon",
          "pushnotificationapp",
          "runforrent",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      print("sddsd3");

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
      print("sddsd4");
    } on Exception catch (e) {
      print("yusiufsiudfis:${message.data}  ${e}");
    }
  }
}