import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendPushNotification(List<String> to, String title, String body) async {
  // Set up the request headers and body
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=YOUR_FCM_SERVER_KEY',
  };
  final Map<String, dynamic> body = {
    'registration_ids': to,
    'notification': {
      'title': title,
      'body': 'body',
    },
  };

  // Send the request
  final http.Response response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: headers,
    body: json.encode(body),
  );

  // Check the response status code
  if (response.statusCode != 200) {
    throw Exception('Failed to send push notification');
  }
}
