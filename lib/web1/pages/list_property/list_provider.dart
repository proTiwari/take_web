import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:take_web/web/pages/splashscreen.dart';
import 'package:take_web/web/providers/base_providers.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;

import '../../firebase_functions/firebase_fun.dart';

class ValidatorType {
  static final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  static final RegExp password = RegExp(r'^(?=.*)(.){6,15}$');
}

class ListingModel {
  final String value;
  final String error;

  ListingModel(this.value, this.error);
}

class ListProvider extends BaseProvider {
  List imagelistvalue = [];
  List uploadimagelist = [];

  bool verify = true;

  var servicetypetext = "";
  var servicetypelist = [
    'Which of the following is your property type?',
    'Hostel',
    'Hotel',
    'PG',
    'Apartment',
    'Flat',
    'Home',
    'Building floor'
  ];

  var wanttotext = "";
  var wantTo = [
    'Want to sell property or rent it?',
    'Sell property',
    'Rent property',
  ];

  var sharingtext = "";
  var sharinglist = [
    'Number of sharing?',
    'No sharing',
    'No limits',
    'Two sharing',
    'Three sharing',
    'Family',
    'Many sharing',
    'Will be discussed',
  ];

  // var state;
  // var city;

  var advanceMoneytext = "";
  var advanceMoney = ['Any Advance Money?', 'Yes', 'No'];

  var foodtext = "";
  var food = ['Food service?', 'Yes', 'No'];

  var tenortext = "";
  var tenor = [
    'Payment Duration',
    'per hour',
    'per month',
    'per year',
    'per day',
    'one time payment',
    'will be discussed'
  ];

  var roomstext = "";
  var rooms = [
    'How many rooms does your property have?',
    '1 Room',
    '2 Room',
    '3 Room',
    '4 Room',
    '5 Room',
    '6 Room',
    '7 Room',
    '8 Room',
    '9 Room',
    '10 Room',
    '11 Room',
    '12 Room',
    'Many room',
  ];

  bool loading = false;

  ListingModel _state = ListingModel("null", "null");
  ListingModel _city = ListingModel("null", "null");
  ListingModel _pincode = ListingModel("null", "null");
  ListingModel _streetaddress = ListingModel("null", "null");
  ListingModel _wantto = ListingModel("null", "null");
  ListingModel _servicetype = ListingModel("null", "null");
  ListingModel _sharing = ListingModel("null", "null");
  ListingModel _advancemoney = ListingModel("null", "null");
  ListingModel _foodservice = ListingModel("null", "null");
  ListingModel _amount = ListingModel("null", "null");
  ListingModel _paymentduration = ListingModel("null", "null");
  ListingModel _numberofrooms = ListingModel("null", "null");
  ListingModel _propertyname = ListingModel("null", "null");
  ListingModel _areaofland = ListingModel("null", "null");
  ListingModel _numberoffloors = ListingModel("null", "null");
  ListingModel _ownername = ListingModel("null", "null");
  ListingModel _mobilenumber = ListingModel("null", "null");
  ListingModel _whatsappnumber = ListingModel("null", "null");
  ListingModel _email = ListingModel("null", "null");
  ListingModel _description = ListingModel("null", "null");

  ListingModel get state => _state;
  ListingModel get city => _city;
  ListingModel get pincode => _pincode;
  ListingModel get streetaddress => _streetaddress;
  ListingModel get wantto => _wantto;
  ListingModel get servicetype => _servicetype;
  ListingModel get sharing => _sharing;
  ListingModel get advancemoney => _advancemoney;
  ListingModel get foodservice => _foodservice;
  ListingModel get amount => _amount;
  ListingModel get paymentduration => _paymentduration;
  ListingModel get numberofrooms => _numberofrooms;
  ListingModel get propertyname => _propertyname;
  ListingModel get areaofland => _areaofland;
  ListingModel get numberoffloors => _numberoffloors;
  ListingModel get ownername => _ownername;
  ListingModel get mobilenumber => _mobilenumber;
  ListingModel get whatsappnumber => _whatsappnumber;
  ListingModel get email => _email;
  ListingModel get description => _description;

  void changeState(String value) {
    if (value != "State") {
      _state = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _state = ListingModel("null", "");
    } else {
      _state = ListingModel("null", "Select State");
    }
    notifyListeners();
  }

  void changeCity(String value) {
    if (value != "City") {
      _city = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _city = ListingModel("null", "");
    } else {
      _city = ListingModel("null", "Select City");
    }
    notifyListeners();
  }

  void changestate(String value) {
    if (value == "" || value == "*State" || value == "null") {
      _state = ListingModel("*State", "no state is selected");
    } else {
      _state = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeimagelist() {
    if (globals.initlistimages.isNotEmpty) {
      imagelistvalue = globals.initlistimages;
      notifyListeners();
    }
    imagelistvalue;
    notifyListeners();
  }//uploadimagelist

  void uploadingimagelist() {
    uploadimagelist;
    notifyListeners();
  }

  void changecity(String value) {
    if (value == "" || value == "*City" || value == "null") {
      _city = ListingModel("*City", "no city is selected");
    } else {
      _city = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeWantto(String value) {
    if (value != "Want you want to sell property or rent it?") {
      _wantto = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _wantto = ListingModel("null", "");
    } else {
      _wantto = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeServiceType(String value) {
    if (value != "Which of the following is your property type?") {
      _servicetype = ListingModel(value, "null");
      // placetext.notifyListeners();
    } else if (value.isEmpty) {
      _servicetype = ListingModel("null", "");
    } else {
      _servicetype = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeSharing(String value) {
    if (value != "Sharing") {
      _sharing = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _sharing = ListingModel("null", "");
    } else {
      _sharing = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeAdvanceMoney(dynamic value) {
    if (value != "Any Advance Money?") {
      _advancemoney = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _advancemoney = ListingModel("null", "");
    } else {
      _advancemoney = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeFoodService(String value) {
    if (value != "Food Service") {
      _foodservice = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _foodservice = ListingModel("null", "");
    } else {
      _foodservice = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeAmount(dynamic value) {
    if (value == null) {
      _amount = ListingModel("null", "Empty field");
    } else if (!_isNumeric(value)) {
      _amount = ListingModel("null", "Amount formatting is invalid!");
    } else {
      _amount = ListingModel(value, "");
    }
    notifyListeners();
  }

  void changePaymentDuration(String value) {
    if (value != "Payment Duration") {
      _paymentduration = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _paymentduration = ListingModel("null", "");
    } else {
      _paymentduration = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  void changeNumberOfRooms(String value) {
    if (value != "How many rooms does your property have?") {
      _numberofrooms = ListingModel(value, "null");
    } else if (value.isEmpty) {
      _numberofrooms = ListingModel("null", "");
    } else {
      _numberofrooms = ListingModel("null", "Select field");
    }
    notifyListeners();
  }

  bool _isNumeric(String str) {
    if (str == "null") {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void changePinCode(dynamic value) {
    if (value == null || value == "null") {
      _pincode = ListingModel("null", "Empty pincode field");
    } else if (!_isNumeric(value)) {
      _pincode = ListingModel("null", "Enter a valid pincode");
    } else {
      _pincode = ListingModel(value, "");
    }
    notifyListeners();
  }

  void changeStreetAddress(dynamic value) {
    if (value == null) {
      _streetaddress = ListingModel("null", "Empty field");
    } else {
      _streetaddress = ListingModel(value, "");
    }
    notifyListeners();
  }

  void changePropertyName(dynamic value) {
    if (value == null) {
      _propertyname = ListingModel("null", "Empty field");
    } else {
      _propertyname = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeAreaOfLand(String value) {
    if (value == "null") {
      _areaofland = ListingModel("null", "Empty field");
    } else {
      _areaofland = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeNumberOfFloors(String value) {
    if (value == "") {
      _numberoffloors = ListingModel("null", "Empty field");
    } else {
      _numberoffloors = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeOwersName(String value) {
    if (value == "") {
      _ownername = ListingModel("null", "Empty field");
    } else {
      _ownername = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeMobileNumber(String value) {
    if (value == "") {
      _mobilenumber = ListingModel("null", "Empty field");
    } else if (!_isNumeric(value)) {
      _mobilenumber = ListingModel("null", "Enter a valid mobile number");
    } else {
      _mobilenumber = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeWhatsappNumber(String value) {
    if (value == "") {
      _whatsappnumber = ListingModel("null", "Empty field");
    } else if (!_isNumeric(value)) {
      _whatsappnumber = ListingModel("null", "Enter a valid whatsapp number");
    } else {
      _whatsappnumber = ListingModel(value, "null");
    }
    notifyListeners();
  }

  void changeEmail(dynamic value) {
    if (ValidatorType.email.hasMatch(value)) {
      _email = ListingModel(value, "null");
    } else if (value == "" || value == null || value == "null") {
      _email = ListingModel("null", "Email field is empty!");
    } else {
      _email = ListingModel("null", "Enter a valid email");
    }
    notifyListeners();
  }

  void changeDescription(String value) {
    _description = ListingModel(value, '');
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    dynamic image;

    loading = true;
    notifyListeners();

    image = await uploadImage(context);

    if (image == "false") {
      verify = false;
      loading = false;
      notifyListeners();
    }
    try {
      if (wanttotext == 'Sell property') {
        print(wanttotext);

        if (_state.error != "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            _state.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }
        if (_city.error != "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            _city.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_pincode.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            _pincode.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_streetaddress.value == "") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "complete address field is empty",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_advancemoney.value == "Any Advance Money?" ||
            _advancemoney.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "Advance money field is empty!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_numberofrooms.value == "null" ||
            _numberofrooms.value == "How many rooms does your property have?") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "select 'How many rooms does your property have?'",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_amount.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "Amount field is empty!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_propertyname.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "property name is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_areaofland.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "area of land is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_areaofland.value)) {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "formatting of 'area of land' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_numberoffloors.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "'Number of floors' field is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_numberoffloors.value)) {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "formatting of 'Number of floors' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_ownername.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "property owner's name is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (_isNumeric(_ownername.value)) {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "formatting of 'owner's name' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_mobilenumber.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "mobile number is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_mobilenumber.value)) {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "formatting of 'mobile number' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_whatsappnumber.value == "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "whatsapp number is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_whatsappnumber.value)) {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            "formatting of 'whatsapp number' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_email.error != "null") {
          verify = false;
          loading = false;
          notifyListeners();
          showToast(
            _email.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }
        print(verify);
        if (verify) {
          loading = false;
          notifyListeners();
          notifyListeners();
          print("dfsdfssddddddddddddddd");
          listproperty(context);
        } else {
          // notifyListeners();
        }

        if (kDebugMode) {
          print(
              // "_country: ${_country.value}  \n"
              "_state: ${state.value}  \n"
              "_city:${_city.value} \n"
              "_pincode:${_pincode.value}  \n"
              "_streetaddress:${_streetaddress.value}  \n"
              "_wantto:${_wantto.value}  \n"
              "advancemoney: ${_advancemoney.value}\n"
              "_numberofrooms:${_numberofrooms.value} \n"
              "_amount: ${_amount.value} \n"
              "_propertyname:${_propertyname.value} \n"
              "areaofland${_areaofland.value}  \n"
              "numberoffloor${_numberoffloors.value}\n"
              "ownername${_ownername.value} \n"
              "_mobilenumber:${_mobilenumber.value} \n"
              "_whatsappnumber:${_whatsappnumber.value} \n"
              "email:${_email.value}  \n"
              "description:${_description.value}  \n");
        }
      } else if (wanttotext == 'Rent property') {
        print(wanttotext);
        if (_city.error != "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            _city.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_state.error != "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            _state.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_pincode.value == "null" || _pincode.value == "") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "invalid pincode field!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_streetaddress.value == "" || _streetaddress.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "complete address field is empty",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_amount.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "Amount field is empty!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_advancemoney.value == "Any Advance Money?" ||
            _advancemoney.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "Advance money field is empty!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_paymentduration.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "payment duration field is empty!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_numberofrooms.value == "null" ||
            _numberofrooms.value == "How many rooms does your property have?") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "select number of rooms!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_ownername.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "property owner's name is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (_isNumeric(_ownername.value)) {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "formatting of 'owner's name' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_mobilenumber.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "mobile number is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_mobilenumber.value)) {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "formatting of 'mobile number' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_whatsappnumber.value == "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "whatsapp number is required!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        } else if (!_isNumeric(_whatsappnumber.value)) {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            "formatting of 'whatsapp number' is wrong!",
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (_email.error != "null") {
          loading = false;
          notifyListeners();
          verify = false;
          showToast(
            _email.error,
            context: context,
            animation: StyledToastAnimation.none,
          );
        }

        if (verify) {
          listproperty(context);
          // notifyListeners();
        } else {
          // notifyListeners();
        }

        if (kDebugMode) {
          print(
              // "_country: ${_country.value}  \n"
              "_state: ${_state.value}  \n"
              "_city:${_city.value} \n"
              "_pincode:${_pincode.value}  \n"
              "_streetaddress:${_streetaddress.value}  \n"
              "_wantto:${_wantto.value}  \n"
              "servicetype:${_servicetype.value}  \n"
              "_sharing:${_sharing.value}\n"
              "advancemoney: ${_advancemoney.value}\n"
              "_foodservice:${_foodservice.value}\n"
              "_amount: ${_amount.value} \n"
              "_paymentduration:${_paymentduration.value} \n"
              "_numberofrooms:${_numberofrooms.value} \n"
              "ownername${_ownername.value} \n"
              "_mobilenumber:${_mobilenumber.value} \n"
              "_whatsappnumber:${_whatsappnumber.value} \n"
              "email:${_email.value}  \n"
              "description:${_description.value}  \n");
        }
      } else {
        loading = false;
        notifyListeners();
        // notifyListeners();
        showToast(
          "select 'Want to sell property or rent it?' field!",
          context: context,
          animation: StyledToastAnimation.none,
        );
        if (kDebugMode) {
          print(_wantto.value);
        }
      }

      // print(
      //     // "_country: ${_country.value}  \n"
      //     "_state: ${_state.value}  \n"
      //     "_city:${_city.value} \n"
      //     "_pincode:${_pincode.value}  \n"
      //     "_wantto:${_wantto.value}  \n"
      //     "_sharing:${_sharing.value}\n"
      //     "servicetype:${_servicetype.value}  \n"
      //     "propertyname:${_propertyname.value}  \n"
      //     "description:${_description.value}  \n"
      //     "email:${_email.value}  \n"
      //     "advancemoney: ${_advancemoney.value}\n"
      //     "_foodservice:${_foodservice.value}\n"
      //     "_propertyname:${_propertyname.value} \n"
      //     "_numberofrooms:${_numberofrooms.value} \n"
      //     "_paymentduration:${_paymentduration.value} \n"
      //     "_amount: ${_amount.value} \n"
      //     "_whatsappnumber:${_whatsappnumber.value} \n"
      //     "_mobilenumber:${_mobilenumber.value} \n"
      //     "ownername${_ownername.value} \n"
      //     "areaofland${_areaofland.value}  \n"
      //     "numberoffloor${_numberoffloors.value}\n"
      // );
    } catch (e) {
      // notifyListeners();
      print("dddd");
      print(e);
    }
  }

  List downloadUrl = [];

  String generateRandomString(int len) {
    var r = Random.secure();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<File?> testCompressFile(File pickedFile) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.absolute.path,
      pickedFile.absolute.path,
      quality: 88,
      rotate: 180,
    );

    print(pickedFile.lengthSync());
    print(result?.lengthSync());

    return result;
    // var result = await FlutterImageCompress.compressWithFile(
    //   pickedFile.absolute.path,
    //   minWidth: 2300,
    //   minHeight: 1500,
    //   quality: 94,
    //   rotate: 90,
    // );
    // print(pickedFile.lengthSync());
    // print(result?.length);
    // return result;
  }

  uploadImage(context) async {
    verify = false;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if (globals.imageList.isNotEmpty) {
      try {
        print(globals.imageList.length);

        for (var i = 0; i < globals.imageList.length; i++) {
          var file = globals.imageList[i];
          final firebaseStorage = FirebaseStorage.instance;

          if (file != null) {
            //Upload to Firebase
            var snapshot;
            try {
              var pathpass = generateRandomString(34);
              // print(file.path);
              snapshot = await firebaseStorage
                  .ref()
                  .child('property/$uid/$pathpass')
                  .putData(file)
                  .whenComplete(() => {
                        verify = true,
                        print("success....................................")
                      });
            } catch (e) {
              loading = false;
              notifyListeners();
              print("failed....................................");
              print(e);
            }

            var download = await snapshot.ref.getDownloadURL();
            downloadUrl.add(download);
            print(downloadUrl);
            print(verify);

            // setState(() {
            //   imageUrl = downloadUrl;
            // });
          } else {
            loading = false;
            notifyListeners();
            if (kDebugMode) {
              print('No Image Path Received');
            }
          }
        }
      } catch (e) {
        loading = false;
        notifyListeners();
        // notifyListeners();
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      verify = false;
      loading = false;
      notifyListeners();
      showToast(
        "atleast one property image is needed!",
        context: context,
        animation: StyledToastAnimation.none,
      );
    }
    return verify.toString();
  }

  Future<void> listproperty(context) async {
    try {
      listProperty(
        propertyId: generateRandomString(74),
        state: state.value,
        city: city.value,
        propertyimage: downloadUrl,
        pincode: pincode.value,
        streetaddress: streetaddress.value,
        wantto: wantto.value,
        advancemoney: advancemoney.value,
        numberofrooms: numberofrooms.value,
        amount: amount.value,
        propertyname: propertyname.value,
        areaofland: areaofland.value,
        numberoffloors: numberoffloors.value,
        ownername: ownername.value,
        mobilenumber: mobilenumber.value,
        whatsappnumber: whatsappnumber.value,
        email: email.value,
        description: description.value,
        servicetype: servicetype.value,
        sharing: sharing.value,
        foodservice: foodservice.value,
        paymentduration: paymentduration.value,
      );
      // await getproperty("Allahābād");
      // await getUser();
      showToast("successfully uploaded", context: context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => SplashScreen()),
          ModalRoute.withName('/'));
    } catch (e) {
      loading = false;
      notifyListeners();
      print(e);
    }
    loading = false;
    notifyListeners();
  }
}
