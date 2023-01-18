import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:take_web/web/Widgets/bottom_nav_bar.dart';
import 'package:take_web/web/models/user_model.dart';
import 'package:take_web/web/pages/list_property/agreement_document.dart';
import 'package:take_web/web/pages/responsive_layout.dart';
//app imports
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import 'package:take_web/web/pages/signin_page/sign_in.provider.dart';
import 'package:take_web/web/pages/signup_page/signup_provider.dart';
import 'package:take_web/web/pages/splashscreen.dart';
import 'package:take_web/web/providers/base_providers.dart';
import 'package:take_web/web/services/database_service.dart';
import 'package:take_web/web/firebase_functions/firebase_fun.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB8YcmJ24lcwM_V52pCu9KqcrwzgUAJPk0",
        authDomain: "runforrent-72f1d.firebaseapp.com",
        projectId: "runforrent-72f1d",
        storageBucket: "runforrent-72f1d.appspot.com",
        messagingSenderId: "555235323232",
        appId: "1:555235323232:web:557de2dda8636e9f0d4205",
        measurementId: "G-P3W7EWNPYY"),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseService("")),
        ChangeNotifierProvider(create: (_) => FirebaseServices()),
        ChangeNotifierProvider(create: (_) => BaseProvider()),
        ChangeNotifierProvider(create: (_) => SigninProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        StreamProvider<UserModel?>.value(
          value: FirebaseServices().currentUserDetails,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        // initialRoute: '/',
        // routes: {
        //   '/':(context) =>  auth.currentUser == null ? LoginApp(): const SplashScreen(),
        // },
        routes: {
          '/policy': (context) => AgreementDocument(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: SplashScreen(),
                  webScreenLayout: SplashScreen(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const SplashScreen();
          },
        ),
        title: '',
        theme: ThemeData(
          //#FC7676
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: const Color(0xFFF27121),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
