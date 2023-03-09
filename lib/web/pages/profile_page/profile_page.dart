import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/pages/list_property/flutter_flow/flutter_flow_util.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase_functions/firebase_fun.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../globar_variables/globals.dart' as globals;
import '../../models/property_model.dart';
import '../../models/user_model.dart';
import '../../providers/base_providers.dart';
import '../edit_profile/edit_profile_page.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../list_property/flutter_flow/upload_media.dart';
import '../nav/serialization_util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController emailfield = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool edit = false;
  final TextEditingController _phoneController = TextEditingController();
  static final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  TabController? tabController;
  int selectedIndex = 0;
  bool saveloading = false;
  UserModel? usermodel;
  bool loading = false;
  bool isEdit = false;
  ValueNotifier? valuepropertydata;
  var circularProgress = 0.0;
  bool addressnotexist = false;
  var data;
  bool Imageloading = false;

  bool loadui = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
    usermodel = Provider.of<UserModel?>(context, listen: false);
    try {
      tabController = TabController(length: 2, vsync: this);
      // print(globals.userdata['name']);
      name.text = userProvider.getUser.name!;
      emailfield.text = userProvider.getUser.email!;
    } catch (e) {
      print(e.toString());
    }
  }

  late BaseProvider userProvider;

  addData() async {
    userProvider = Provider.of<BaseProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  void valuedatafun() async {
    valuepropertydata = await FirebaseServices().valuepropertydata;
  }

  Future<Uint8List?> testCompressFile(File pickedFile) async {
    var result = await FlutterImageCompress.compressWithFile(
      pickedFile.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 90,
    );
    print(pickedFile.lengthSync());
    print(result?.length);
    return result;
  }

  final ImagePicker _picker = ImagePicker();
  var profileimage;

  void takePhoto(ImageSource source) async {
    final pickedFile = await selectMediaWithSourceBottomSheet(
      context: context,
      maxWidth: 700.00,
      maxHeight: 500.00,
      imageQuality: 0,
      allowPhoto: true,
    );
    setState(() {
      Imageloading = true;
    });
    if (pickedFile == null) {
      setState(() {
        Imageloading = false;
      });
    }
    setState(() {
      profileimage = File(pickedFile!.first.filePath!);
    });
    var uploadimage = pickedFile!.first.filePath!;
    var snapshot;
    var download;
    try {
      final firebaseStorage = FirebaseStorage.instance;
      snapshot = await firebaseStorage
          .ref()
          .child('profile/${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(File(uploadimage))
          .whenComplete(() async => {});
    } catch (e) {
      print(e.toString());
    }
    try {
      download = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
    if (download != null) {
      print("sdfsfsdddddddddddddddddddddddddd");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "profileImage": download,
      }).whenComplete(
              () => showToast(context: context, "successfully uploaded!"));
      setState(() {
        Imageloading = false;
      });
      print("success....................................");
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      // globals.userdata['address'];
      print("sddijfsowew");
      print("sdijwew${userProvider.getUser.name}");
      userProvider.getUser.address;
    } catch (e) {
      addressnotexist = true;
    }

    List dataproperty = [];
    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    final color = Theme.of(context).colorScheme.primary;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        shadowColor: FlutterFlowTheme.of(context).primaryBackground,
        flexibleSpace: const FlexibleSpaceBar(),
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () async {
                  final Uri params = Uri(
                      scheme: 'mailto',
                      path: 'team@runforrent.com',
                      query: 'subject=Query about App');
                  var mailurl = params.toString();
                  if (await canLaunch(mailurl)) {
                    await launch(mailurl);
                  } else {
                    throw 'Could not launch $mailurl';
                  }
                },
                icon: const Icon(
                  Icons.help,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'Yes');
                            // ignore: use_build_context_synchronously
                            context.pushNamed(
                              'splashscreen',
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // SizedBox(
          //   width: width < 800 ? width * 0.74 : width * 0.90,
          // ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
            child: Column(
              children: [
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
                          Tab(text: "Profile"),
                          Tab(text: "Properties"),
                        ],
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 10.0),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.73,
                    child: Column(
                      children: [
                        Expanded(
                          child: Consumer<FirebaseServices>(
                              builder: (context, provider, child) {
                            return TabBarView(
                              controller: tabController,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 10.0),
                                    // EditImagePage(),
                                    InkWell(
                                      onTap: () {
                                        takePhoto(ImageSource.gallery);
                                      },
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: Imageloading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.blueAccent,
                                                    backgroundColor:
                                                        Colors.white12,
                                                  )
                                                : Container(),
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            top: 1.9,
                                            right: 2,
                                            left: 2,
                                            child: buildImage(userProvider
                                                .getUser.profileImage),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 4,
                                            child: buildEditIcon(color),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      13.0, 0, 13, 0),
                                              child: TextFormField(
                                                enabled: edit,
                                                controller: name,
                                                validator: (value) {
                                                  if (value
                                                      .toString()
                                                      .isEmpty) {
                                                    return 'Please enter Name';
                                                  }

                                                  if (value.toString().length <
                                                      3) {
                                                    return 'name cannot be less than 3 character';
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration: InputDecoration(
                                                  // hintText: "Name",
                                                  hintText: globals.name == ""
                                                      ? "${userProvider.getUser.name}"
                                                      : globals.name,
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      13.0, 0, 13, 0),
                                              child: TextFormField(
                                                enabled: edit,
                                                controller: emailfield,
                                                validator: (value) {
                                                  if (value
                                                      .toString()
                                                      .isEmpty) {
                                                    return 'Please enter Email';
                                                  }
                                                  if (!email.hasMatch(value!)) {
                                                    return 'Please enter a valid Email';
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    hintText: globals.email ==
                                                            ""
                                                        ? "${userProvider.getUser.email}"
                                                        : globals.email,
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)),
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            addressnotexist
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        13.0, 0, 13, 0),
                                                    child: TextFormField(
                                                      enabled: edit,
                                                      controller: address,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                              suffix:
                                                                  const Icon(
                                                                FontAwesomeIcons
                                                                    .solidAddressCard,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              hintText: globals
                                                                          .address ==
                                                                      ""
                                                                  ? "Complete Address"
                                                                  : globals
                                                                      .address,
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                              )),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        13.0, 0, 13, 0),
                                                    child: TextFormField(
                                                      enabled: edit,
                                                      controller: address,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText: globals
                                                                          .address ==
                                                                      ""
                                                                  ? userProvider.getUser.address ==
                                                                              "" ||
                                                                          userProvider.getUser.address ==
                                                                              null
                                                                      ? "Complete Address"
                                                                      : "${userProvider.getUser.address}"
                                                                  : globals
                                                                      .address,
                                                              border:
                                                                  const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                              )),
                                                    ),
                                                  ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      27.0, 0, 0, 0),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: _phoneController,
                                                validator: (value) {
                                                  return null;
                                                  // if (value.toString().isEmpty) {
                                                  //   return 'Please enter phone number';
                                                  // }
                                                  //
                                                  // if (value.toString().length < 10) {
                                                  //   return 'Please enter a valid phone number';
                                                  // }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                // ignore: prefer_const_constructors
                                                decoration: InputDecoration(
                                                  enabled: false,
                                                  suffix: const Icon(
                                                    FontAwesomeIcons.phone,
                                                    color: Colors.red,
                                                  ),
                                                  labelText:
                                                      "${userProvider.getUser.phone}",
                                                  // border: const OutlineInputBorder(
                                                  //   borderRadius: BorderRadius.all(
                                                  //       Radius.circular(50)),
                                                  // ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      edit = !edit;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: width < 800
                                                        ? width * 0.3
                                                        : width * 0.2,
                                                    // width: MediaQuery.of(context)
                                                    //         .size
                                                    //         .width *
                                                    //     0.3,
                                                    height: 50,
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            50)),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                colors: [
                                                                  // Color(0xFF8A2387),
                                                                  Color(
                                                                      0xFFFF5963),
                                                                  Color(
                                                                      0xFFFF5963),
                                                                ])),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    print('1');
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    print('2');
                                                    try {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        print('3');
                                                        var uid = _auth
                                                            .currentUser!.uid;
                                                        print('4');
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(uid)
                                                            .update({
                                                          "name": name.text
                                                              .toString(),
                                                          "email": emailfield
                                                              .text
                                                              .toString(),
                                                          "address": address
                                                              .text
                                                              .toString(),
                                                        }).whenComplete(() => {
                                                                  showToast(
                                                                      context:
                                                                          context,
                                                                      "sucessfully updated"),
                                                                  setState(() {
                                                                    edit =
                                                                        false;
                                                                    globals.name = name
                                                                        .text
                                                                        .toString();
                                                                    globals.email =
                                                                        emailfield
                                                                            .text
                                                                            .toString();
                                                                    globals.address =
                                                                        address
                                                                            .text
                                                                            .toString();
                                                                  }),
                                                                  setState(() {
                                                                    print('6');
                                                                    loading =
                                                                        false;
                                                                  }),
                                                                });
                                                        print('7');
                                                      } else {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                      }
                                                      print('8');
                                                    } catch (e) {
                                                      print('9');
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      print(e.toString());
                                                      showToast(e.toString(),
                                                          context: context);
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: width < 800
                                                        ? width * 0.3
                                                        : width * 0.2,
                                                    height: 50,
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            50)),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                colors: [
                                                                  // Color(0xFF8A2387),
                                                                  Color(
                                                                      0xFFFF5963),
                                                                  Color(
                                                                      0xFFFF5963),
                                                                ])),
                                                    child: loading
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: const Text(
                                                              'Save',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("City")
                                        .where("uid",
                                            isEqualTo: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          // height: MediaQuery.of(context).size.height*0.9,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.white,
                                            child: Center(
                                                child: GridView.builder(
                                              itemCount: 3,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      mainAxisExtent: 200.0,
                                                      crossAxisCount: 3),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: GestureDetector(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        // image: DecorationImage(
                                                        //   image: ,
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 37.0,
                                                                right: 37.0,
                                                                top: 185.0,
                                                                bottom: 10.0),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
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
                                            )),
                                          ),
                                        );
                                      }

                                      var documents = snapshot.data!.docs;

                                      if (documents.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 180, 0, 0),
                                          child: Container(
                                            child: Column(children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 18),
                                                child: Text(
                                                    "You have not uploaded any property Yet!"),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context.pushNamed(
                                                    'customnav',
                                                    queryParams: {
                                                      'city': serializeParam(
                                                        '${globals.city}',
                                                        ParamType.String,
                                                      ),
                                                      'secondcall':
                                                          serializeParam(
                                                        'uploadproperty',
                                                        ParamType.String,
                                                      ),
                                                      'profile': serializeParam(
                                                        'Prayagraj',
                                                        ParamType.String,
                                                      )
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                  width: 180.0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Center(
                                                      child: Column(
                                                          children: const [
                                                            Center(
                                                              child: Text(
                                                                "Upload Property",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        );
                                      }
                                      ;
                                      var list;
                                      list = documents.where((doc) {
                                        return doc.get("uid").contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid);
                                      }).toList();

                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        return GridView.builder(
                                          itemCount: list.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisExtent: 180.0,
                                                  crossAxisCount: 3),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8, 8, 0),
                                              child: GestureDetector(
                                                onTap: (() {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          EditProfilePage(
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
                                                      fit: BoxFit.cover,
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        list[index][
                                                            'propertyimage'][0],
                                                      ),
                                                      // image: NetworkImage(list[
                                                      //         index]
                                                      //     ['propertyimage'][0]),
                                                      // fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 37.0,
                                                            right: 37.0,
                                                            top: 185.0,
                                                            bottom: 25.0),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
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
                                // provider.valuedata.isNotEmpty
                                // ? GridView.builder(
                                //     itemCount: provider.valuedata.length,
                                //     gridDelegate:
                                //         const SliverGridDelegateWithFixedCrossAxisCount(
                                //             mainAxisExtent: 200.0,
                                //             crossAxisCount: 3),
                                //     itemBuilder: (context, index) {
                                //       return Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                //         child: GestureDetector(
                                //           onTap: (() {
                                //             Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                     builder: (BuildContext
                                //                             context) =>
                                //                         EditProfilePage(
                                //                            provider.valuedata[index])));
                                //           }),
                                //           child: Container(
                                //             decoration: BoxDecoration(
                                //               color: Colors.black,
                                //               borderRadius:
                                //                   BorderRadius.circular(
                                //                       20.0),
                                //               image: DecorationImage(
                                //                 image: NetworkImage(provider
                                //                         .valuedata[index]
                                //                         .propertyimage[
                                //                     0]), //globals
                                //                 //   .listofproperties[index]
                                //                 // .propertyimage[0]

                                //                 fit: BoxFit.cover,
                                //               ),
                                //             ),
                                //             child: Padding(
                                //               padding:
                                //                   const EdgeInsets.only(
                                //                       left: 37.0,
                                //                       right: 37.0,
                                //                       top: 185.0,
                                //                       bottom: 15.0),
                                //               child: Container(
                                //                 alignment: Alignment.center,
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.white,
                                //                     borderRadius:
                                //                         BorderRadius
                                //                             .circular(
                                //                                 15.0)),
                                //                 child: const Text(""),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   )
                                // : noGroupWidget(),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildImage(String? profileImage) {
    dynamic image = Image.network(
        "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg");
    try {
      if (profileimage == null) {
        print("dsfosjdfoiyyyyyyyyyyyyyyyyyy");
        // image = Image.memory(globals.userdata['profileImage']);

        image = Image.network(profileImage!);
      } else {
        print("sdsdewwrtrrr");
      }
    } catch (e) {
      print("weweweweqqqqqqqqqq$e");
      image = Image.network(
          "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg");
    }

    return ClipOval(
        child: Material(
      color: Colors.black12,
      child: profileimage != null
          ? CircleAvatar(
              radius: 50.0,
              backgroundImage: FileImage(File(profileimage.path)),
            )
          : image,
    ));
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
            size: 10,
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
