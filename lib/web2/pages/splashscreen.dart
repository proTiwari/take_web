import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spell_checker/spell_checker.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../Widgets/bottom_nav_bar.dart';
import '../firebase_functions/firebase_fun.dart';
import '../services/location_services.dart';

// optional distance parameter. Default is 1.0

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool direction = false;
  String? _currentAddress;
  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GRecaptchaV3.hideBadge();
    // final checker = SingleWordSpellChecker(distance: 2.0);
    // checker.addWords(['Allahabad', 'Allahapur']);
    // const str = 'Allahābād';
    // final findList = checker.find(str);
    // print(findList);

    delay();
    // getCity();
  }

  Future<void> getCity() async {
    var data = await FirebaseFirestore.instance
        .collection("State")
        .doc("City")
        .snapshots();
    // print(
    //   data.map(
    //     (event) => print(event.data()!['city']),
    //   ),
    // );
    print(
      data.first.then(
        (value) => print(value.id),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission =
        await LocationService().handleLocationPermission(context);
    print("sd");
    if (!hasPermission) return;
    print("dsfs");
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        print("dsisw");
        setState(() {
          print("wew");
          _currentPosition = position;
          var res = LatLng(position.latitude, position.longitude);
          globals.latlong = res;
        });
        await _getAddressFromLatLng(position);
      }).catchError((e) {
        debugPrint(e);
        print("sd");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality},${place.locality}, ${place.postalCode}';
        //calculate all the diffrent city name
        if (place.locality == "Prayagraj") {
          globals.city = "Allahabad";
        } else {
          globals.city = place.locality!;
        }
        globals.postalcode = place.postalCode;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  updatedeviceid() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"devicetoken": fcmToken});
    } catch (e) {
      print(e.toString());
    }
  }

  void delay() async {
  
    try {
      try {
        if (FirebaseAuth.instance.currentUser!.uid != "") {
          await updatedeviceid();
          await getUser();
          globals.logined = true;
        }
      } catch (e) {
        globals.logined = false;
      }
      try {
        await _getCurrentPosition();
      } catch (e) {
        print("error in splashscreen : $e");
      }
    } catch (e) {
      print(e.toString());
    }
    print(globals.city);
    // ignore: use_build_context_synchronously
    if (globals.city == null || globals.city == '') {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  CustomBottomNavigation("Allahabad", '', '')),
          ModalRoute.withName('/'));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  CustomBottomNavigation(globals.city, '', '')),
          ModalRoute.withName('/'));
    }

    // Future.delayed(const Duration(seconds: 0)).then(
    //   (value) => {if (globals.property.isNotEmpty) {}},
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 300,
          child: SizedBox(
              height: 220.0,
              width: 220.0,
              child: Image.asset('assets/runforrent1.png')),
        ),
      ),
    );
  }
}
