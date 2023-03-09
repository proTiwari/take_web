import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../firebase_functions/firebase_fun.dart';
import '../globar_variables/globals.dart';
import '../notificationservice/local_notification_service.dart';
import '../pages/chat/chat_page.dart';
import '../pages/chat/group_list.dart';
import '../pages/explore_page/search.dart';
import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';
import '../pages/list_property/flutter_flow/lat_lng.dart';
import '../pages/list_property/home_page/home_page_widget.dart';
import '../pages/list_property/search_place_provider.dart';
import '../pages/profile_page/profile_page.dart';
import '../globar_variables/globals.dart' as globals;
import '../pages/property_detail/property_detail.dart';
import '../pages/signin_page/phone_login.dart';
import '../providers/base_providers.dart';
import '../services/deeplink_service.dart';
import '../services/location_services.dart';

class CustomBottomNavigation extends StatefulWidget {
  String profile;
  var secondcall;
  CustomBottomNavigation(
    city,
    this.secondcall,
    this.profile,
  );

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class valuenotic {
  ValueNotifier<LatLng> valuenoticifierlatlong =
      ValueNotifier(LatLng(0.0, 0.0));
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  late int pageIndex = 0;
  var profilepage;
  String? _currentAddress;
  Position? _currentPosition;

  final pages = [
    Search(city, secondcall),
    const GroupListPage(),
    const ListPropertyPage(),
    const ProfilePage(),
    LoginApp()
  ];
  BaseProvider? _userProvider;
  var count = 0;
  var totalchatcount = 0;

  @override
  void initState() {
    super.initState();
    getuser();
    locationcheck();
    // initPlatformState();
    deeplink();
    // locationcheck();
    calculateMessageCount();
    if (widget.secondcall == "uploadproperty") {
      setState(() {
        pageIndex = 2;
      });
    }
    if (widget.secondcall == "login") {
      setState(() {
        pageIndex = 4;
      });
    }
    if (widget.profile == 'profile') {
      setState(() {
        pageIndex = 3;
      });
    }
  }

  var referralCode;

  void deeplink() async {
    final deepLinkRepo = DeepLinkService.instance;
    referralCode = deepLinkRepo?.referrerCode.value;
    print(
        "sddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd $referralCode");
  }

  var _startTime = DateTime.now().millisecondsSinceEpoch;
  var _bytesPerSec = 0;

  // Platform messages are asynchronous, so we initialize in an async method.

  updatedeviceid() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"devicetoken": fcmToken});
      print("fcmToken: ${fcmToken}");
    } catch (e) {
      print("fmcToken: ${e.toString()}");
    }
    return;
  }

  calculateMessageCount() async {
    try {
      var groupidlist = [];
      var countchat = 0;
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        groupidlist = value.data()!["groups"];
      });
      for (var i in groupidlist) {
        i = i.toString().split("_")[0];
        try {
          await FirebaseFirestore.instance
              .collection("groups")
              .doc(i)
              .collection("messages")
              .get()
              .then((value) {
            for (var i in value.docs) {
              if (i['sender'] != FirebaseAuth.instance.currentUser!.uid) {
                print("yyyyyyyyy: ${i['status']}");
                if (i['status'] != true) {
                  setState(() {
                    count += 1;
                  });
                }
              }
            }
            if (count > 0) {
              countchat += 1;
              count = 0;
            }
          });
        } catch (e) {
          print(e.toString());
        }
      }
      setState(() {
        totalchatcount = countchat;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  locationcheck() async {
    await updatedeviceid();
  }

  void getuser() async {
    try {
      _userProvider = Provider.of<BaseProvider>(context, listen: false);
      await _userProvider!.refreshUser();
    } catch (e) {
      print(e.toString());
    }
  }

  // void _moveToScreen2(BuildContext context) => Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => CustomBottomNavigation(globals.city, "", "")));

  void _moveToScreen2(BuildContext context) {
    try {
      if (pageIndex != 0) {
        setState(() {
          pageIndex = 0;
        });
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(''),
            content: const Text('Do You Want To Exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'No'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  exit(0);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      }

      // context.pushNamed('customnav');
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             CustomBottomNavigation(globals.city, "", "")));
    } catch (e) {
      print(e.toString());
    }
  }

  navigatefun(BuildContext context) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CustomBottomNavigation(globals.city, "", "")));

  // onWillPop: () async {
  //   _moveToScreen2(
  //     context,
  //   );
  //   return false;
  // },
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // _moveToScreen2(
        //   context,
        // );
        return true;
      },
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: pages[pageIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 8 : width * 0.24),
          height: 70,
          // decoration: BoxDecoration(
          //   boxShadow: const [
          //     BoxShadow(
          //         color: Color.fromARGB(255, 248, 243, 243),
          //         offset: Offset(9, 8),
          //         blurRadius: 2,
          //         spreadRadius: 2),
          //     BoxShadow(
          //         color: Color.fromARGB(255, 205, 202, 202),
          //         offset: Offset(5, 15),
          //         blurRadius: 5,
          //         spreadRadius: 3)
          //   ],
          //   color: const Color.fromARGB(255, 255, 255, 255),
          //   // color: Theme.of(context).primaryColor,
          //   borderRadius: BorderRadius.circular(22),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: pageIndex == 0
                      ? FlutterFlowTheme.of(context).alternate
                      : Colors.white,
                ),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () async {
                    final deepLinkRepo = await DeepLinkService.instance;
                    referralCode = await deepLinkRepo?.referrerCode.value;
                    setState(() {
                      print(referralCode);
                      print(
                          "hello there: ${FirebaseAuth.instance.currentUser}");
                      if (FirebaseAuth.instance.currentUser != null) {
                        pageIndex = 0;
                      }
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
                            fontSize: 8),
                      )
                    ],
                  ),
                ),
              ),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6.9, 0, 0),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: pageIndex == 1
                          ? FlutterFlowTheme.of(context).alternate
                          : Colors.white,
                    ),
                    child: IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          if (FirebaseAuth.instance.currentUser == null) {
                            pageIndex = 4;
                          } else {
                            pageIndex = 1;
                          }
                          totalchatcount = 0;
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
                                fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                pageIndex != 1
                    ? totalchatcount == 0
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                            child: Align(
                                alignment: AlignmentDirectional(-10, -0.7),
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          '$totalchatcount',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 11,
                                              ),
                                        ),
                                      ),
                                    ))),
                          )
                    : Container()
              ]),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: pageIndex == 2
                      ? FlutterFlowTheme.of(context).alternate
                      : Colors.white,
                ),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      if (FirebaseAuth.instance.currentUser == null) {
                        pageIndex = 4;
                      } else {
                        pageIndex = 2;
                      }
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
                            fontSize: 8),
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
                    color: pageIndex == 3
                        ? FlutterFlowTheme.of(context).alternate
                        : Colors.white),
                child: IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      if (FirebaseAuth.instance.currentUser == null) {
                        pageIndex = 4;
                      } else {
                        pageIndex = 3;
                      }
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
                            fontSize: 8),
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
