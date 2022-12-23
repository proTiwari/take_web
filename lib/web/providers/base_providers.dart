import 'package:flutter/material.dart';
import 'package:take_web/web/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_functions/firebase_fun.dart';
import '../services/auth_services.dart';

class BaseProvider with ChangeNotifier {
  final firebaseAuthService = AuthService.instance;

  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await firebaseAuthService.getUserDetails();
    _user = user;
    notifyListeners();
    // FirebaseServices().getProperties();
  }
}
