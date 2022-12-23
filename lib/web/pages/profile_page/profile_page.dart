import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:archive/archive_io.dart' as arc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:take_web/web/Widgets/bottom_nav_bar.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:take_web/web/models/user_model.dart';
import 'package:take_web/web/pages/edit_profile/edit_profile_page.dart';
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import 'package:take_web/web/pages/splashscreen.dart';
import 'package:take_web/web/providers/base_providers.dart';
import '../../firebase_functions/firebase_fun.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as base;

import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    addData();
    try {
      tabController = TabController(length: 2, vsync: this);
      // print(globals.userdata['name']);
      name.text = userProvider.getUser.name!;
      emailfield.text = userProvider.getUser.email!;
      try {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            data = Provider.of<FirebaseServices>(context, listen: false)
                .getProperties();
          });
        });

        print("kkklllk${data}");
        if (data.length == 0) {
          print("sdddddddddddddddddddddddddddddddddd");
          setState(() {
            emptyproperty = false;
          });
        }
      } catch (e) {
        setState(() {
          emptyproperty = false;
        });
        print("ssdsdsdddddd${e.toString()}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  late BaseProvider userProvider;

  addData() async {
    userProvider = Provider.of<BaseProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  var imagedata;

  void downloadimagedata() async {
    try {
      print("sdfjsdweweweeeeee");
      imagedata = await FirebaseStorage.instance
          .ref('profile/${FirebaseAuth.instance.currentUser!.uid}')
          .getDownloadURL();
      print("iwejwewe$imagedata");
      setState(() {
        imagedata;
      });
    } catch (e) {
      print('dsfjoejfwe');
      print(e.toString());
    }
  }

  testCompressFile(File pickedFile) async {
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

  Uint8List compress(Uint8List input) {
    List<int> list = utf8.encode(input.toString());
    Uint8List bytes = Uint8List.fromList(list);

    return bytes;
  }

  Uint8List decompress(dynamic input) {
    const decoder = arc.ZLibDecoder();
    return decoder.decodeBytes(input) as Uint8List;
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? profileimage;
  var download;
  void takePhoto(ImageSource source) async {
    setState(() {
      Imageloading = true;
    });
    profileimage = (await ImagePickerWeb.getImageAsBytes())!;
    // profileimage = compress(profileimage!);
    setState(() {
      profileimage;
    });

    if (profileimage != null) {
      var snapshot = await FirebaseStorage.instance
          .ref('profile/${FirebaseAuth.instance.currentUser!.uid}')
          .putData(profileimage!);
      download = await snapshot.ref.getDownloadURL();
      print(download);

      if (download != null) {
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
    // print("kkklllk${globals.listofproperties}");
    try {
      if (userProvider.getUser.properties!.isEmpty) {
        setState(() {
          emptyproperty = false;
        });
      }
    } catch (e) {
      setState(() {
        emptyproperty = false;
      });
    }

    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    final color = Theme.of(context).colorScheme.primary;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        flexibleSpace: const FlexibleSpaceBar(),
        elevation: 0,
        actions: [
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()),
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
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
            child: Column(
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
                        child: buildImage(userProvider.getUser.profileImage),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: buildEditIcon(color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                userProvider.getUser.name == ''
                    ? Text("${globals.name}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ))
                    : Text(
                        "${userProvider.getUser.name}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

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
                          Tab(text: "Profile"),
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
                          child: Consumer<FirebaseServices>(
                              builder: (context, provider, child) {
                            return TabBarView(
                              controller: tabController,
                              children: [
                                provider.valuedata.isNotEmpty
                                    ? GridView.builder(
                                        itemCount: provider.valuedata.length,
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
                                                            EditProfilePage(provider.valuedata[index])));
                                              }),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  image: DecorationImage(
                                                    image: NetworkImage(provider
                                                            .valuedata[index]
                                                            .propertyimage[
                                                        0]), //globals
                                                    //   .listofproperties[index]
                                                    // .propertyimage[0]

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
                                      )
                                    : noGroupWidget(),
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
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 60,
                                          child: TextFormField(
                                            enabled: edit,
                                            controller: name,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return 'Please enter Name';
                                              }

                                              if (value.toString().length < 3) {
                                                return 'name cannot be less than 3 character';
                                              }
                                            },
                                            keyboardType: TextInputType.name,
                                            decoration: InputDecoration(
                                              // hintText: "Name",
                                              hintText: globals.name == ""
                                                  ? "${userProvider.getUser.name}"
                                                  : globals.name,
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 60,
                                          child: TextFormField(
                                            enabled: edit,
                                            controller: emailfield,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return 'Please enter Email';
                                              }
                                              if (!email.hasMatch(value!)) {
                                                return 'Please enter a valid Email';
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                                suffix: const Icon(
                                                  FontAwesomeIcons.envelope,
                                                  color: Colors.red,
                                                ),
                                                hintText: globals.email == ""
                                                    ? "${userProvider.getUser.email}"
                                                    : globals.email,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50)),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        addressnotexist
                                            ? SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: 60,
                                                child: TextFormField(
                                                  enabled: edit,
                                                  controller: address,
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      suffix: const Icon(
                                                        FontAwesomeIcons
                                                            .solidAddressCard,
                                                        color: Colors.red,
                                                      ),
                                                      hintText: globals
                                                                  .address ==
                                                              ""
                                                          ? "Complete Address"
                                                          : globals.address,
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)),
                                                      )),
                                                ),
                                              )
                                            : SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: 60,
                                                child: TextFormField(
                                                  enabled: edit,
                                                  controller: address,
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      suffix: const Icon(
                                                        FontAwesomeIcons
                                                            .solidAddressCard,
                                                        color: Colors.red,
                                                      ),
                                                      hintText: globals
                                                                  .address ==
                                                              ""
                                                          ? userProvider.getUser
                                                                          .address ==
                                                                      "" ||
                                                                  userProvider
                                                                          .getUser
                                                                          .address ==
                                                                      null
                                                              ? "Complete Address"
                                                              : "${userProvider.getUser.address}"
                                                          : globals.address,
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
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              27.0, 0, 0, 0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 60,
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
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          // Color(0xFF8A2387),
                                                          Color(0xFFF27121),
                                                          Color(0xFFF27121),
                                                        ])),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  saveloading = true;
                                                });
                                                print('1');
                                                setState(() {
                                                  loading = true;
                                                });
                                                print('2');
                                                try {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    print('3');
                                                    var uid =
                                                        _auth.currentUser!.uid;
                                                    print('4');
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(uid)
                                                        .update({
                                                      "name":
                                                          name.text.toString(),
                                                      "email": emailfield.text
                                                          .toString(),
                                                      "address": address.text
                                                          .toString(),
                                                    }).whenComplete(() => {
                                                              setState(() {
                                                                globals.name = name
                                                                    .text
                                                                    .toString();
                                                                globals.email =
                                                                    emailfield
                                                                        .text
                                                                        .toString();
                                                                globals.address =
                                                                    address.text
                                                                        .toString();
                                                              }),
                                                              setState(() {
                                                                print('6');
                                                                loading = false;
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
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          // Color(0xFF8A2387),
                                                          Color(0xFFF27121),
                                                          Color(0xFFF27121),
                                                        ])),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: loading
                                                      ? const SizedBox(
                                                          height: 40,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ))
                                                      : const Text(
                                                          'Save',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
      child: profileimage != null ? Image.memory(profileimage!) : image,
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
