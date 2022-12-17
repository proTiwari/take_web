import 'package:flutter/material.dart';

import '../services/auth_services.dart';

class BaseProvider with ChangeNotifier {
  final firebaseAuthService = AuthService.instance;

}
