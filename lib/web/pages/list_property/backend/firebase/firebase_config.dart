import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDZW0Ljw4RRamtIROEymwTfvhEj-bKDZ6o",
            authDomain: "uploaduirfr.firebaseapp.com",
            projectId: "uploaduirfr",
            storageBucket: "uploaduirfr.appspot.com",
            messagingSenderId: "167899098188",
            appId: "1:167899098188:web:e15eacd013d5a6aae1d8e9",
            measurementId: "G-BG8EH2BYJD"));
  } else {
    await Firebase.initializeApp();
  }
}
