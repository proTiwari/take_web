import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../firebase_functions/firebase_fun.dart';
import '../../globar_variables/globals.dart';
import '../../models/property_model.dart';
import '../../providers/base_providers.dart';
import '../splashscreen.dart';
import 'otp_verification_signup.dart';

class SignupModel {
  String value;
  final String error;

  SignupModel(this.value, this.error);
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

class SignupProvider extends BaseProvider implements LoaderState {
  SignupProvider() {
    setState(ViewState.Idle);
  }
  List valuedata = [];

  getProperties() async {
    try {
      print("ffff");
      var data = userdata['properties'];
      print("jjjj");

      for (var i in data) {
        List dd = i.split("/");
        print("this is first value in the list: ${dd[0]}");
        print(dd[1]);
        // PropertyModel? propertyModel;
        PropertyModel propertyModel;
        await FirebaseFirestore.instance
            .collection("State")
            .doc("City")
            .collection(dd[0])
            .doc(dd[1])
            .get()
            .then((value) => {
                  propertyModel = PropertyModel(
                    city: value.get("city"),
                    state: value.get("state"),
                    propertyId: value.get("propertyId"),
                    propertyimage: value.get("propertyimage"),
                    pincode: value.get("pincode"),
                    streetaddress: value.get("streetaddress"),
                    wantto: value.get("wantto"),
                    advancemoney: value.get("advancemoney"),
                    numberofrooms: value.get("numberofrooms"),
                    amount: value.get("amount"),
                    propertyname: value.get("propertyname"),
                    areaofland: value.get("areaofland"),
                    numberoffloors: value.get("numberoffloors"),
                    ownername: value.get("ownername"),
                    mobilenumber: value.get("mobilenumber"),
                    whatsappnumber: value.get("whatsappnumber"),
                    email: value.get("email"),
                    description: value.get("description"),
                    servicetype: value.get("servicetype"),
                    sharing: value.get('sharing'),
                    foodservice: value.get("foodservice"),
                    paymentduration: value.get("paymentduration"),
                  ),
                  valuedata.add(propertyModel),
                  notifyListeners(),
                })
            .whenComplete(() => {}); // valuedata.add(propertyModel)
      }

      print("valuabledata${valuedata[0].propertyimage}");

      listofproperties = valuedata;
      valuedata = listofproperties;
      valuedata;
      notifyListeners();
    } catch (e) {
      print("here is the error: ${e.toString()}");
    }
  }

  bool loading = false;
  @override
  notifyListeners();

  var phoneauth = 'user does not exist';
  SignupModel _phone = SignupModel("null", "null");
  SignupModel _email = SignupModel("null", "null");
  SignupModel _name = SignupModel("null", "null");
  SignupModel _uid = SignupModel("null", "null");
  SignupModel get uid => _uid;
  SignupModel get email => _email;
  SignupModel get name => _name;
  SignupModel get phone => _phone;

  bool get isValid {
    if (_name.value != "null" &&
        _email.value != "null" &&
        _phone.value != 'null') {
      return true;
    } else {
      return false;
    }
  }

  //Setters
  void changeEmail(String value) {
    if (ValidatorType.email.hasMatch(value)) {
      _email = SignupModel(value, "null");
    } else if (value.isEmpty) {
      _email = SignupModel("null", "null");
    } else {
      _email = SignupModel("null", "Enter a valid email");
    }
    notifyListeners();
  }

  void changeName(String value) {
    if (value != 'null') {
      print(value);
      _name = SignupModel(value, "null");
    } else if (value.isEmpty) {
      _name = SignupModel("null", "");
    } else {
      _name = SignupModel("null", "Must have at least 6 characters");
    }
    notifyListeners();
  }

  Future<void> verify(code, BuildContext context, verifyid, String name,
      String email, String phone) async {
    loading = true;
    notifyListeners();
    dynamic user;
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verifyid, smsCode: code);
      var result = await _auth.signInWithCredential(credential);
      user = result.user;

      if (user != null) {
        var uid = _auth.currentUser!.uid;
        // create user
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          "name": name,
          "email": email,
          "phone": phone,
          "groups": [],
          'devicetoken': devicetoken,
          "id": uid
        });
        // var data = await SignupApi().signuprequest(name.value, email.value, phone.value, uid);
        // print(data);
        print("user 2");
        // await getproperty("Allahābād");
        await getUser();
        loading = false;
        notifyListeners();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    SplashScreen()),
            ModalRoute.withName('/'));
      } else {
        print("Error");
        showToast(context: context, "something went wrong");
        loading = false;
        notifyListeners();
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

  // Future<bool> signupUser(String phone, String email, String name, String uid, BuildContext context) async{
  //   print(phone);
  //   print(email);
  //   print(name);
  //   return false;
  // }

  Future<bool> signupUser(String Phone, String Email, String Name, String Uid,
      BuildContext context) async {
    loading = true;
    notifyListeners();
    phone.value = Phone;
    email.value = Email;
    name.value = Name;
    uid.value = Uid.toString();
    // notifyListeners();
    print(phone);
    _auth.verifyPhoneNumber(
      phoneNumber: "${Phone}",
      timeout: const Duration(seconds: 60),
      verificationFailed: (dynamic exception) {
        print(exception);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        loading = false;
        notifyListeners();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpSignupPage(verificationId)));
      },
      // ignore: avoid_returning_null_for_void
      codeAutoRetrievalTimeout: (verificationId) => null,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    );
    return true;
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
