import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../../Widgets/google_map_card.dart';
import '../../firebase_functions/firebase_fun.dart';
import 'owners_profile_property_detail.dart';

class OwnersProfilePage extends StatefulWidget {
  var valuedata;
  var detail;
  var owneruid;
  OwnersProfilePage(this.valuedata, this.detail,this.owneruid, {Key? key}) : super(key: key);

  @override
  _OwnersProfilePageState createState() => _OwnersProfilePageState();
}

class _OwnersProfilePageState extends State<OwnersProfilePage>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool edit = false;
  static final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  TabController? tabController;
  int selectedIndex = 0;
  bool saveloading = false;
  bool loading = false;
  bool isEdit = false;
  var circularProgress = 0.0;
  bool emptyproperty = true;
  bool addressnotexist = false;

  var data;
  bool Imageloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      data = Provider.of<FirebaseServices>(context, listen: false)
          .getOwnerProperties(globals.ownerprofiledata.properties);
    });
    getlocationlatlong();
  }

  List latlonglist = [];

  getlocationlatlong() async {
    try {
      // print(widget.valuedata.id);
      // print(widget.valuedata['id']);
      var snapshot = await FirebaseFirestore.instance
          .collection("City")
          .where("uid", isEqualTo: widget.owneruid)
          .get()
          .then((value) {
        // value.docs.map((e) {
        //   latlonglist.add(e);
        // });
        for (var i in value.docs) {
          latlonglist.add(i);
        }
        print("yyysdfsd: ${latlonglist}");
      });
    } catch (e) {
      print("kejoiwejoowei: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    try {
      globals.ownerprofiledata.address;
    } catch (e) {
      addressnotexist = true;
    }
    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(child:
          Consumer<FirebaseServices>(builder: (context, provider, child) {
        // provider.getProperties();
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                // EditImagePage(),
                InkWell(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 111,
                        width: 111,
                        child: Imageloading
                            ? const CircularProgressIndicator(
                                color: Colors.blueAccent,
                                backgroundColor: Colors.white12,
                              )
                            : Container(),
                      ),
                      Positioned(
                        bottom: 2,
                        top: 1.9,
                        right: 2,
                        left: 2,
                        child: buildImage(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Text("${globals.ownerprofiledata.name}",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text("${globals.ownerprofiledata.email}",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text("${globals.ownerprofiledata.phone}",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    )),

                const SizedBox(height: 20.0),

                const SizedBox(height: 7.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TabBar(
                        isScrollable: true,
                        controller: tabController,
                        indicator: const BoxDecoration(
                            borderRadius: BorderRadius.zero),
                        labelColor: Colors.black,
                        labelStyle: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        unselectedLabelColor: Colors.black26,
                        onTap: (tapIndex) {
                          setState(() {
                            selectedIndex = tapIndex;
                          });
                        },
                        tabs: const [
                          Tab(text: "Properties"),
                          Tab(text: "On Map"),
                        ],
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 10.0),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("City")
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    var documents = snapshot.data!.docs;
                                    print(
                                        "jnknkjnk: ${documents.first['uid']}");
                                    var list;
                                    list = documents.where((doc) {
                                      return doc.get("uid").contains(
                                          globals.ownerprofiledata.id);
                                    }).toList();
                                    print("lllll/: ${list}");

                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      return GridView.builder(
                                        itemCount: list.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisExtent: 200.0,
                                                crossAxisCount: 3),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: (() {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        OwnersProfileProperty(
                                                            list[index]),
                                                  ),
                                                );
                                              }),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  image: DecorationImage(
                                                    image: NetworkImage(list[
                                                            index]
                                                        ['propertyimage'][0]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 37.0,
                                                          right: 37.0,
                                                          top: 185.0,
                                                          bottom: 15.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.0)),
                                                    child: const Text(""),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.red,
                                      ));
                                    }
                                    // get sections from the document
                                  }),
                              GoogleMapCard(latlonglist),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      })),
    );
  }

  Widget buildImage() {
    dynamic image = const NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQd9gwkP14yXTwV2JMOryOh3Q4tS1UHmBqkcPGNfawYLr8UwHwrRsv_t50q5X5OMsqP5Ag&usqp=CAU");
    try {
      image = NetworkImage(globals.ownerprofiledata.profileImage);
    } catch (e) {
      image = const NetworkImage(
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQd9gwkP14yXTwV2JMOryOh3Q4tS1UHmBqkcPGNfawYLr8UwHwrRsv_t50q5X5OMsqP5Ag&usqp=CAU");
    }

    return ClipOval(
      child: Material(
        color: Colors.black12,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 108,
          height: 108,
          child: InkWell(onTap: () {}),
        ),
      ),
    );
  }

  noGroupWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 130, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              "No property uploaded yet!",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.black12,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
