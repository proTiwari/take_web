import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../Widgets/bottom_nav_bar.dart';
import '../firebase_functions/firebase_fun.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool direction = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delay();
  }

  void delay() async {
    // logic for getting user location and specially city
    try {
      try {
        if (FirebaseAuth.instance.currentUser!.uid != "") {
          globals.logined = true;
        }
      } catch (e) {
        globals.logined = false;
      }
      await getproperty("Allahābād");
      await getUser();

      // String? getStudentInformationEndpoint = "";
      try {
        // var prefs = await SharedPreferences.getInstance();
        // SharedPreferences.setMockInitialValues({});
        // getStudentInformationEndpoint = prefs.getString('login');
        // if (prefs.getString('login') != null) {
        //   direction = true;
        // }
      } catch (e) {
        print("error in splashscreen : $e");
      }

      globals.city = "Allahābād";
    } catch (e) {
      print(e.toString());
    }
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CustomBottomNavigation("Allahābād")),
        ModalRoute.withName('/'));
    // Future.delayed(const Duration(seconds: 0)).then(
    //   (value) => {if (globals.property.isNotEmpty) {}},
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
            height: 220.0,
            width: 220.0,
            child: Image.asset('assets/runforrent1.png')),
      ),
    );
  }
}
