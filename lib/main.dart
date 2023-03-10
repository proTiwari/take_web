import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:take_web/web/Widgets/bottom_nav_bar.dart';
import 'package:take_web/web/models/user_model.dart';
import 'package:take_web/web/pages/app_state.dart';
import 'package:take_web/web/pages/list_property/agreement_document.dart';
import 'package:take_web/web/pages/list_property/flutter_flow/internationalization.dart';
import 'package:take_web/web/pages/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:take_web/web/pages/signin_page/sign_in.provider.dart';
import 'package:take_web/web/pages/signup_page/signup_provider.dart';
import 'package:take_web/web/pages/splashscreen.dart';
import 'package:take_web/web/providers/base_providers.dart';
import 'package:take_web/web/services/database_service.dart';
import 'package:take_web/web/firebase_functions/firebase_fun.dart';

import 'web/pages/nav/nav.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    bool ready = await GRecaptchaV3.ready(
        "6LeNoQ0kAAAAABLPs9kb_boqhpavcX5haQAJKO14"); //--2 //6LeNoQ0kAAAAABLPs9kb_boqhpavcX5haQAJKO14
    print("Is Recaptcha ready? $ready");
    GRecaptchaV3.hideBadge();
  }

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

  runApp(const riverpod.ProviderScope(child: MyApp()));

  final appState = FFAppState(); // Initialize FFAppState

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: const riverpod.ProviderScope(child: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);
  }

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
      child: MaterialApp.router(
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [Locale('en', '')],
        theme: ThemeData(brightness: Brightness.light),
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        // initialRoute: '/',
        // routes: {
        //   '/':(context) =>  auth.currentUser == null ? LoginApp(): const SplashScreen(),
        // },
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       // Checking if the snapshot has any data or not
        //       if (snapshot.hasData) {
        //         // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
        //         return const ResponsiveLayout(
        //           mobileScreenLayout: SplashScreen(),
        //           webScreenLayout: SplashScreen(),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       }
        //     }

        //     // means connection to future hasnt been made yet
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     return const SplashScreen();
        //   },
        // ),
        title: '',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
