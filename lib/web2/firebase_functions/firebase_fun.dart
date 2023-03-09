import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:take_web/web/Widgets/bottom_nav_bar.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../models/property_model.dart';
import '../models/user_model.dart';
import 'package:georange/georange.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FirebaseServices extends ChangeNotifier {
  List valuedata = [];
  List owerpropertydata = [];
  ValueNotifier<List> valuepropertydata = ValueNotifier<List>([]);
  // getProperties() async {
  //   valuedata = [];
  //   try {
  //     print("ffff");
  //     var data = globals.userdata['properties'];
  //     print("jjjj$data");

  //     for (var i in data) {
  //       List dd = i.split("/");
  //       print("this is first value in the list: ${dd[0]}");
  //       print(dd[1]);
  //       // PropertyModel? propertyModel;
  //       PropertyModel propertyModel;
  //       await FirebaseFirestore.instance
  //           .collection("State")
  //           .doc("City")
  //           .collection(dd[0])
  //           .doc(dd[1])
  //           .get()
  //           .then((value) => {
  //                 propertyModel = PropertyModel(
  //                   city: value.get("city"),
  //                   state: value.get("state"),
  //                   propertyId: value.get("propertyId"),
  //                   propertyimage: value.get("propertyimage"),
  //                   pincode: value.get("pincode"),
  //                   streetaddress: value.get("streetaddress"),
  //                   wantto: value.get("wantto"),
  //                   advancemoney: value.get("advancemoney"),
  //                   numberofrooms: value.get("numberofrooms"),
  //                   amount: value.get("amount"),
  //                   propertyname: value.get("propertyname"),
  //                   areaofland: value.get("areaofland"),
  //                   numberoffloors: value.get("numberoffloors"),
  //                   ownername: value.get("ownername"),
  //                   mobilenumber: value.get("mobilenumber"),
  //                   whatsappnumber: value.get("whatsappnumber"),
  //                   email: value.get("email"),
  //                   description: value.get("description"),
  //                   servicetype: value.get("servicetype"),
  //                   sharing: value.get('sharing'),
  //                   foodservice: value.get("foodservice"),
  //                   paymentduration: value.get("paymentduration"),
  //                 ),
  //                 valuedata.add(propertyModel),
  //                 notifyListeners(),
  //                 valuepropertydata.value = valuedata
  //               })
  //           .whenComplete(() => {})
  //           .catchError((error) {
  //         //This is my third error handler
  //         valuedata = [];
  //         print("Missed first two error handlers. Got this error:");
  //         print(error);
  //       }); // valuedata.add(propertyModel)
  //     }

  //     changevaluedata(listdata) {
  //       valuedata = listdata;
  //       notifyListeners();
  //     }

  //     print("valuabledata${valuedata}");

  //     globals.listofproperties = valuedata;

  //     valuedata = globals.listofproperties;
  //     notifyListeners();
  //   } catch (e) {
  //     valuedata = [];
  //     notifyListeners();
  //     print("here is the error: ${e.toString()}");
  //   }
  // }

  Stream<UserModel?> get currentUserDetails {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map(
          (documentSnapshot) => UserModel(
            name: (documentSnapshot.data()!["name"] == '')
                ? 'Enter Your Name'
                : documentSnapshot.data()!["name"],
            id: documentSnapshot.data()!["id"],
            email: (documentSnapshot.data()!["email"] == '')
                ? 'Enter Your Email'
                : documentSnapshot.data()!["email"],
            phone: documentSnapshot.data()!["phone"],
            address: documentSnapshot.data()!["address"],
            profileImage: documentSnapshot.data()!['profileImage'],
            properties: documentSnapshot.data()!['properties'],
          ),
        );
  }

  getOwnerProperties(data) async {
    await getUser();
    owerpropertydata = [];
    try {
      print("jjjj$data");

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
                    id: value.get('id'),
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
                  owerpropertydata.add(propertyModel),
                })
            .whenComplete(() => {})
            .catchError((error) {
          //This is my third error handler
          owerpropertydata = [];
          print("Missed first two error handlers. Got this error:");
          print(error);
        }); // valuedata.add(propertyModel)
      }

      print("valuabledata${owerpropertydata}");

      owerpropertydata;
      notifyListeners();
    } catch (e) {
      owerpropertydata = [];
      notifyListeners();
      print("here is the error: ${e.toString()}");
    }
  }
}

void listProperty({
  var state,
  var city,
  var propertyimage,
  var pincode,
  var streetaddress,
  var wantto,
  var advancemoney,
  var numberofrooms,
  var amount,
  var propertyname,
  var areaofland,
  var numberoffloors,
  var ownername,
  var mobilenumber,
  var whatsappnumber,
  var email,
  var description,
  var servicetype,
  var sharing,
  var foodservice,
  var paymentduration,
  var propertyId,
}) async {
  var profileImage;
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      profileImage = value.data()!["profileImage"];
    });
  } catch (e) {
    print(e);
  }

  if (profileImage == null || profileImage == '') {
    try {
      await FirebaseFirestore.instance
          .collection("Controllers")
          .doc("variables")
          .get()
          .then((value) {
        profileImage = value.data()!["defaultprofileImage"];
      });
    } catch (e) {
      print(e);
    }
  }

  if (profileImage == null || profileImage == '') {
    profileImage =
        "https://cdn.pixabay.com/photo/2021/06/07/13/45/user-6318003__340.png";
  }
  GeoRange georange = GeoRange();
  var geohash =
      georange.encode(globals.latlong.latitude, globals.latlong.longitude);

  try {
    await FirebaseFirestore.instance.collection("City").doc(propertyId).set({
      'uid': _auth.currentUser!.uid,
      'date': DateTime.now(),
      'geohash': geohash,
      'profileImage': profileImage,
      'propertyId': propertyId,
      'state': state,
      'city': city,
      'propertyimage': propertyimage,
      'pincode': pincode,
      'streetaddress': streetaddress,
      'wantto': wantto,
      'advancemoney': advancemoney,
      'numberofrooms': numberofrooms,
      'amount': amount,
      'propertyname': propertyname,
      'areaofland': areaofland,
      'numberoffloors': numberoffloors,
      'ownername': ownername,
      'mobilenumber': mobilenumber,
      'whatsappnumber': whatsappnumber,
      'email': email,
      'description': description,
      'servicetype': servicetype,
      'sharing': sharing,
      'foodservice': foodservice,
      'paymentduration': paymentduration,
      'lat': globals.latlong.latitude,
      'lon': globals.latlong.longitude,
    }).whenComplete(() async {
      try {
        try {
          await FirebaseFirestore.instance
              .collection("State")
              .doc("City")
              .update({
            "city": FieldValue.arrayUnion(["$city"])
          });
        } catch (e) {
          print("gsdsdds${e}");
          await FirebaseFirestore.instance.collection("State").doc("City").set({
            "city": FieldValue.arrayUnion(["$city"])
          });
        }
        // await FirebaseFirestore.instance
        //     .collection("Users")
        //     .doc(_auth.currentUser!.uid)
        //     .update({
        //   "properties": FieldValue.arrayUnion(["$city/$propertyId"]),
        // }).whenComplete(() => print("compelete inclusion"));
      } catch (e) {
        print("printdd$e");
      }
    });
  } catch (e) {
    print("this is error: ${e.toString()}");
  }
}

getUser() async {
  var data;
  try {
    if (_auth.currentUser != null) {
      print(
          "lllllllllllllll${_auth.currentUser!.email}llllllllllllllllllllllll${_auth.currentUser!.uid}");

      data = await FirebaseFirestore.instance
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) => {
                // print(value.get("name")),
                globals.userdata = value,
              })
          .whenComplete(() => {
                print("completed${globals.userdata}"),
              });
      // print("globals userdata : ${globals.userdata["name"]}");
    }
  } catch (e) {
    print(e.toString());
  }
}

// getproperty(city) async {
//   try {
//     print("sdfsd");
//     var valuedata;
//     valuedata = await FirebaseFirestore.instance
//         .collection("State")
//         .doc("City")
//         .collection(city)
//         .get()
//         .then((value) => value.docs
//             .map((doc) => {
//                   'id': doc['id'],
//                   'state': doc['state'],
//                   'city': doc['city'],
//                   'propertyId': doc['propertyId'],
//                   'propertyimage': doc['propertyimage'],
//                   'pincode': doc['pincode'],
//                   'streetaddress': doc['streetaddress'],
//                   'wantto': doc['wantto'],
//                   'advancemoney': doc['advancemoney'],
//                   'numberofrooms': doc['numberofrooms'],
//                   'amount': doc['amount'],
//                   'propertyname': doc['propertyname'],
//                   'areaofland': doc['areaofland'],
//                   'numberoffloors': doc['numberoffloors'],
//                   'ownername': doc['ownername'],
//                   'mobilenumber': doc['mobilenumber'],
//                   'whatsappnumber': doc['whatsappnumber'],
//                   'email': doc['email'],
//                   'description': doc['description'],
//                   'servicetype': doc['servicetype'],
//                   'sharing': doc['sharing'],
//                   'foodservice': doc['foodservice'],
//                   'paymentduration': doc['paymentduration'],
//                 })
//             .toList())
//         .catchError((error) {
//       print(error);
//     });
//     print("valuedata ${valuedata}");
//     globals.property = valuedata;
//     return valuedata;
//   } catch (e) {
//     print(e.toString());
//     globals.property = [];
//     return [];
//   }
// }
