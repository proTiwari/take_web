// import 'package:flutter/material.dart';
// import 'package:take/app1/firebase_functions/firebase_fun.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   @override
//   void initState() {
//     super.initState();

//     // Set up a listener for incoming messages
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print('Received push notification: $message');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print('Received push notification (onResume): $message');
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print('Received push notification (onLaunch): $message');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Your app's build method goes here
//   }
// }
