import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:go_router/go_router.dart';
import '../../firebase_functions/firebase_fun.dart';
import '../../providers/base_providers.dart';
import '../signup_page/phone_signup.dart';
import 'otp_verification_login.dart';

class SigninModel {
  final String value;
  final String error;

  SigninModel(this.value, this.error);
}

enum ViewState { Idle, Busy }

abstract class LoaderState {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  void setState(ViewState viewState);
}

class ValidatorType {
  static final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp password = RegExp(r'^(?=.*)(.){6,15}$');
}

class SigninProvider extends BaseProvider implements LoaderState {
  bool loading = false;
  var phoneauth = 'user does not exist';

  SigninModel _email = SigninModel("null", "null");
  SigninModel _password = SigninModel("null", "null");
  SigninModel get email => _email;
  SigninModel get password => _password;

  bool get isValid {
    if (_password.value != "null" && _email.value != "null") {
      return true;
    } else {
      return false;
    }
  }

  //Setters
  void changeEmail(String value) {
    if (ValidatorType.email.hasMatch(value)) {
      _email = SigninModel(value, "null");
    } else if (value.isEmpty) {
      _email = SigninModel("null", "null");
    } else {
      _email = SigninModel("null", "Enter a valid email");
    }
    notifyListeners();
  }

  void changePassword(String value) {
    if (ValidatorType.password.hasMatch(value)) {
      print(value);
      _password = SigninModel(value, "null");
    } else if (value.isEmpty) {
      _password = SigninModel("null", "");
    } else {
      _password = SigninModel("null", "Must have at least 6 characters");
    }
    notifyListeners();
  }

  Future<void> verify(code, BuildContext context, verifyid) async {
    loading = true;
    notifyListeners();
    try {
      print("uiop1");
      AuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: verifyid, smsCode: code);
      print("uiop2");
      dynamic result = await _auth.signInWithCredential(credential);
      print("uiop3");
      var uid = _auth.currentUser!.uid;
      print("uiop4");
      print(result.user);
      print(uid);

      if (FirebaseAuth.instance.currentUser != null) {
        print("uiop5 ${FirebaseAuth.instance.currentUser}");

        print("user 2");
        // await getproperty("Allahābād");
        await getUser();
        loading = false;
        notifyListeners();
        context.pushNamed('splashscreen');
       
      } else {
/*        print("Error");
        showToast(context: context,"something went wrong");
        loading = false;
        notifyListeners();*/

      }
    } catch (e) {
      print("dfdfg");
      showToast(context: context, e.toString());
      loading = false;
      notifyListeners();
    }
    loading = false;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginUser(String phone, BuildContext context) async {
    loading = true;
    notifyListeners();
    print(loading);
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: "+91${phone}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {},
        verificationFailed: (dynamic exception) {
          loading = false;
          notifyListeners();
          showToast(context: context, exception.toString());
          print(exception);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          var ifexists = await FirebaseFirestore.instance
              .collection("Users")
              .where("phone", isEqualTo: "+91${phone}")
              .get();
          try {
            final userSnapshot = ifexists.docs.first;
            print("usersnapshot: ${userSnapshot}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpLoginPage(verificationId)));
          } catch (e) {
            print("--exists--${e}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(verificationId, "+91${phone}"),
              ),
            );
          }
          loading = false;
          notifyListeners();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OtpLoginPage(verificationId),
          //   ),
          // );
        },
        // ignore: avoid_returning_null_for_void
        codeAutoRetrievalTimeout: (verificationId) => null,
      );
      return false;
    } catch (e) {
      showToast(context: context, e.toString());
      print("uuuu");
      loading = false;
      notifyListeners();
    }
    print("uuuu");
    loading = false;
    notifyListeners();
    return false;
  }

  @override
  late ViewState _state;

  @override
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  @override
  ViewState get state => _state;

  // Future<LoginResponse> submitLogin() async {
  //
  //   setState(ViewState.Busy);
  //   final Mapable response = await apiClient.serverDataProvider.login(_email.value, _password.value,);
  //   setState(ViewState.Idle);
  //   if (response is LoginResponse) {
  //     print(‘response.token ${response.token}’);
  //
  //     return response;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
