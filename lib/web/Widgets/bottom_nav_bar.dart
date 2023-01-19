import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/globar_variables/globals.dart';
import 'package:take_web/web/pages/chat/group_list.dart';
import 'package:take_web/web/pages/list_property/list_property.dart';
import 'package:take_web/web/pages/explore_page/search.dart';
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import 'package:take_web/web/providers/base_providers.dart';
import '../notificationservice/local_notification_service.dart';
import '../pages/profile_page/profile_page.dart';
import '../globar_variables/globals.dart' as globals;

class CustomBottomNavigation extends StatefulWidget {
  String profile;
  CustomBottomNavigation(city, secondcall, this.profile);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int pageIndex = 0;
  var profilepage;

  final pages = [
    Search(city, secondcall),
    globals.logined == false ? LoginApp() : const GroupListPage(),
    globals.logined == false ? LoginApp() : const ListProperty(),
    globals.logined == false ? LoginApp() : const ProfilePage()
  ];
  BaseProvider? _userProvider;

  @override
  void initState() {
    super.initState();
    getuser();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  void getuser() async {
    _userProvider = Provider.of<BaseProvider>(context, listen: false);
    await _userProvider!.refreshUser();
  }

  void _moveToScreen2(BuildContext context) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CustomBottomNavigation(globals.city, "", "")));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        _moveToScreen2(
          context,
        );
        return false;
      },
      child: Scaffold(
        // backgroundColor: Colors.blueAccent,
        body: widget.profile == "profile" ? pages[3] : pages[pageIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
          height: 70,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 248, 243, 243),
                  offset: Offset(9, 8),
                  blurRadius: 2,
                  spreadRadius: 2),
              BoxShadow(
                  color: Color.fromARGB(255, 205, 202, 202),
                  offset: Offset(5, 15),
                  blurRadius: 5,
                  spreadRadius: 3)
            ],
            color: const Color.fromARGB(255, 255, 255, 255),
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:
                      pageIndex == 0 ? const Color(0xFFF27121) : Colors.white,
                ),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/search.png",
                        color: pageIndex == 0
                            ? Colors.white
                            : const Color(0xfff24086a),
                        height: 30,
                      ),
                      Text(
                        "Search",
                        style: GoogleFonts.poppins(
                            color: pageIndex == 0
                                ? Colors.white
                                : const Color(0xfff24086a),
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:
                      pageIndex == 1 ? const Color(0xFFF27121) : Colors.white,
                ),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/chatpp.png",
                        color: pageIndex == 1
                            ? Colors.white
                            : const Color(0xfff24086a),
                        height: 30,
                      ),
                      Text(
                        "Chat",
                        style: GoogleFonts.poppins(
                            color: pageIndex == 1
                                ? Colors.white
                                : const Color(0xfff24086a),
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:
                      pageIndex == 2 ? const Color(0xFFF27121) : Colors.white,
                ),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/list.png",
                        color: pageIndex == 2
                            ? Colors.white
                            : const Color(0xfff24086a),
                        height: 30,
                      ),
                      Text(
                        "Add",
                        style: GoogleFonts.poppins(
                            color: pageIndex == 2
                                ? Colors.white
                                : const Color(0xfff24086a),
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: pageIndex == 3 ? Color(0xFFF27121) : Colors.white),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 3;
                    });
                  },
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/me.png",
                        color: pageIndex == 3
                            ? Colors.white
                            : const Color(0xfff24086a),
                        height: 30,
                      ),
                      Text(
                        "Me",
                        style: GoogleFonts.poppins(
                            color: pageIndex == 3
                                ? Colors.white
                                : const Color(0xfff24086a),
                            fontSize: 9),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
