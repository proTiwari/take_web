import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Widgets/image_upload_card.dart';
import '../../Widgets/loader_image_property_edit.dart';
import '../../Widgets/uploading_image_property_image.dart';
import '../../globar_variables/globals.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../list_property/list_provider.dart';
import '../profile_page/profile_page.dart';

class EditProfilePage extends StatefulWidget {
  var valuedata;
  EditProfilePage(this.valuedata, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool edit = false;
  String propertyon = '';
  bool loading = false;
  bool loadingdelete = false;
  final ImagePicker _picker = ImagePicker();
  static final RegExp emailvalidation = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController advanvemoney = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController areaofland = TextEditingController();
  TextEditingController discription = TextEditingController();
  TextEditingController foodservice = TextEditingController();
  TextEditingController numberoffloors = TextEditingController();
  TextEditingController numberofrooms = TextEditingController();
  TextEditingController ownersname = TextEditingController();
  TextEditingController paymentduration = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController propertyname = TextEditingController();
  TextEditingController sharing = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController streetaddress = TextEditingController();
  TextEditingController servicetype = TextEditingController();
  TextEditingController areaoflandunit = TextEditingController();
  List listImage = [];
  List initImageList = [];
  List downloadUrl = [];
  dynamic imageFile;
  bool heightImage = false;
  // property image

  @override
  void initState() {
    super.initState();
    try {
      print(widget.valuedata['email']);
      setState(() {
        propertyon = widget.valuedata['wantto'];
      });
      name.text = widget.valuedata['ownername'];
      email.text = widget.valuedata['email'];
      foodservice.text = widget.valuedata['foodservice'];
      phone.text = widget.valuedata['mobilenumber'];
      whatsapp.text = widget.valuedata['whatsappnumber'];
      advanvemoney.text = widget.valuedata['advancemoney'];
      amount.text = widget.valuedata['amount'];
      areaofland.text = widget.valuedata['areaofland'];
      streetaddress.text = widget.valuedata['streetaddress'];
      propertyname.text = widget.valuedata['propertyname'];
      sharing.text = widget.valuedata['sharing'];
      pincode.text = widget.valuedata['pincode'];
      paymentduration.text = widget.valuedata['paymentduration'];
      numberoffloors.text = widget.valuedata['numberoffloors'];
      numberofrooms.text = widget.valuedata['numberofrooms'];
      areaoflandunit.text = widget.valuedata['areaoflandunit'];
      servicetype.text = widget.valuedata['servicetype'];
      discription.text = widget.valuedata['description'] == 'null'
          ? "   -"
          : widget.valuedata['description'];

      initImageList = widget.valuedata['propertyimage'];
      print(initImageList);
      initlistimages = widget.valuedata['propertyimage'];

      floor.text = widget.valuedata['numberoffloors'];
    } catch (e) {
      print("ttttttttttttt");
      print(e.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var imagrprovi = Provider.of<ListProvider>(context, listen: false);
      imagrprovi.changeimagelist();
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.camera,
                    size: 50,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    takePhoto(ImageSource.camera);
                  },
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.image,
                    size: 50,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    takePhoto(ImageSource.gallery);
                    // Navigator.pop(context);
                  },
                  label: const Text("Gallery"),
                ),
              ])
        ],
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random.secure();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
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

  uploadImage(List listImage) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    print(listImage.isEmpty);
    if (listImage.isNotEmpty) {
      print("list image");
      try {
        print(listImage.length);

        for (var i = 0; i < listImage.length; i++) {
          var file = listImage[i];
          final firebaseStorage = FirebaseStorage.instance;

          if (file != null) {
            //Upload to Firebase
            var snapshot;
            try {
              var pathpass = generateRandomString(34);
              var selectedImage = File(file!.path);
              var uploadimage = await testCompressFile(selectedImage);
              print(file.path);
              snapshot = await firebaseStorage
                  .ref()
                  .child('property/$uid/$pathpass')
                  .putData(uploadimage!)
                  .whenComplete(() =>
                      {print("success....................................")});
            } catch (e) {
              loading = false;
              print("failed....................................");
              print(e);
            }

            var download = await snapshot.ref.getDownloadURL();
            downloadUrl.add(download);
            print(downloadUrl);

            // setState(() {
            //   imageUrl = downloadUrl;
            // });
          } else {
            loading = false;
          }
        }
        return downloadUrl;
      } catch (e) {
        loading = false;
      }
    } else {
      print("listing");
      // loading = false;
      // showToast(
      //   "atleast one property image is needed!",
      //   context: context,
      //   animation: StyledToastAnimation.none,
      // );
    }
  }

  // uploadImage(listofimg) async {
  //   var uid = FirebaseAuth.instance.currentUser!.uid;
  //   if (listofimg.isNotEmpty) {
  //     try {
  //       print(listofimg.length);

  //       for (var i = 0; i < listofimg.length; i++) {
  //         var file = listofimg[i];
  //         final firebaseStorage = FirebaseStorage.instance;

  //         if (file != null) {
  //           //Upload to Firebase
  //           var snapshot;
  //           try {
  //             var pathpass = generateRandomString(34);
  //             // print(file.path);
  //             snapshot = await firebaseStorage
  //                 .ref()
  //                 .child('property/$uid/$pathpass')
  //                 .putData(file)
  //                 .whenComplete(() =>
  //                     {print("success....................................")});
  //           } catch (e) {
  //             print("failed....................................");
  //             print(e);
  //           }

  //           var download = await snapshot.ref.getDownloadURL();
  //           downloadUrl.add(download);

  //           // setState(() {
  //           //   imageUrl = downloadUrl;
  //           // });
  //         } else {}
  //       }
  //       return downloadUrl;
  //     } catch (e) {}
  //   } else {
  //     // showToast(
  //     //   "Atleast one property image is needed!",
  //     //   context: context,
  //     //   animation: StyledToastAnimation.none,
  //     // );
  //   }
  // }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    setState(() {
      imageFile = pickedFile;
      if (pickedFile != null) {
        heightImage = true;
      }
      listImage.add(pickedFile);

      listImage.remove(null);
      imageList = listImage;
      ListProvider().uploadimagelist = listImage;
      ListProvider().uploadingimagelist();
    });
  }

  var food = ['Food service?', 'Yes', 'No'];
  var rooms = [
    'How many rooms does your property have?',
    '1 Room',
    '2 Room',
    '3 Room',
    '4 Room',
    '5 Room',
    '6 Room',
    '7 Room',
    '8 Room',
    '9 Room',
    '10 Room',
    '11 Room',
    '12 Room',
    'Many room',
  ];

  var advanceMoney = ['Any Advance Money?', 'Yes', 'No'];
  var sharinglist = [
    'Number of sharing?',
    'No sharing',
    'No limits',
    'Two sharing',
    'Three sharing',
    'Family',
    'Many sharing',
    'Will be discussed',
  ];

  var unit = [
    "Bigha-Pucca",
    "Bigha",
    "Bigha-Kachha",
    "Biswa-Pucca",
    "Biswa",
    "Biswa-Kaccha",
    "Biswansi",
    "Killa",
    "Ghumaon",
    "Kanal",
    "Chatak",
    "Decimal",
    "Dhur",
    "Kattha",
    "Lecha",
    "Ankanam",
    "Cent",
    "Ground",
    "Guntha",
    "Kuncham",
    "Square meter",
    "Square yard",
    "Centimeter",
    "Chain",
    "Feet",
    "Furlong",
    "Gaj",
    "Gattha",
    "Hath"
  ];

  var amountList = [
    '0-2,000',
    '2,000-5,000',
    '5,000-10,000',
    '10,000-15,000',
    '15,000-20,000',
    '20,000-25,000',
    '25,000-30,000',
    '30,000-35,000',
    '40,000-45,000',
    '45,000-50,000',
    '50,000-55,000',
    '55,000-60,000',
    '60,000-65,000',
    '65,000-70,000',
    '70,000-75,000',
    '75,000-80,000',
    '85,000-90,000',
    '90,000-95,000',
    '1,00,000',
    'Will be discussed'
  ];

  var tenor = [
    'Payment Duration',
    'Per Hour',
    'Per day',
    'Per Month',
    'Per Year',
    'one time payment',
    'Will be discussed'
  ];
  var servicetypelist = [
    'Which of the following is your property type?',
    'Hostel',
    'Hotel',
    'PG',
    'Apartment',
    'Flat',
    'Home',
    'Building floor',
    'Marrige hall',
  ];

  @override
  void dispose() {
    super.dispose();
    name;
    email;
    foodservice;
    phone;
    whatsapp;
    advanvemoney;
    amount;
    areaofland;
    streetaddress;
    propertyname;
    sharing;
    pincode;
    paymentduration;
    numberoffloors;
    numberofrooms;
    servicetype;
    discription;
  }

  @override
  Widget build(BuildContext context) {
    // ListProvider userProvider =
    //     Provider.of<ListProvider>(context, listen: false);
    // userProvider.imagelistvalue = initImageList;
    // userProvider.changeimagelist();

    var width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => ListProvider(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Owner's name",
                            border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          name.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Name"),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: 60,
              //   child: TextFormField(
              //     // enabled: edit,
              //     controller: name,
              //     validator: (value) {
              //       if (value.toString().isEmpty) {
              //         return 'Please enter Name';
              //       }

              //       if (value.toString().length < 3) {
              //         return 'name cannot be less than 3 character';
              //       }
              //     },
              //     keyboardType: TextInputType.name,
              //     decoration: const InputDecoration(
              //       // hintText: "Name",
              //       hintText: "",
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(50),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Email", border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Email"),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Phone", border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Phone"),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Whatsapp", border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: whatsapp,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          whatsapp.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Whatsapp"),
                      ),
                    )
                  ],
                ),
              ),
              propertyon == "Sell property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Sell property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Adv. money"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: advanceMoney.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  advanvemoney.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: advanvemoney,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                advanvemoney.text = value;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Advance money"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: DropdownButton(
                        hint: const Text("  Amount"),
                        icon: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        isExpanded: true,
                        underline: Container(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.black,
                        items: amountList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            amount.text = newValue!;
                          });
                        },
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: amount,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          amount.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Amount"),
                      ),
                    )
                  ],
                ),
              ),
              propertyon == "Sell property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              Row(
                children: [
                  propertyon == "Sell property"
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 90,
                                  child: TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                        hintText: "  area of land",
                                        border: InputBorder.none),
                                  ),
                                ),
                                const Text(
                                  "|",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: areaofland,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      areaofland.text = value;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "  area of land"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    width: 10,
                  ),
                  propertyon == "Sell property"
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 90,
                                  child: DropdownButton(
                                    hint: const Text("  Unit"),
                                    icon: const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: Icon(Icons.keyboard_arrow_down),
                                    ),
                                    isExpanded: true,
                                    underline: Container(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    items: unit.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        areaoflandunit.text = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  "|",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: areaoflandunit,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      areaoflandunit.text = value;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "  unit"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  description",
                            border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: discription,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          discription.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "  description"),
                      ),
                    )
                  ],
                ),
              ),
              propertyon == "Rent property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Food service"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: food.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  foodservice.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: foodservice,
                              onChanged: (value) {
                                foodservice.text = value;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Food service"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              propertyon == "Sell property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Sell property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 140,
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: "  Number of floor",
                                  border: InputBorder.none),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: numberoffloors,
                              onChanged: (value) {
                                numberoffloors.text = value;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Number of floor"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: DropdownButton(
                        hint: const Text("  No. of rooms"),
                        icon: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        isExpanded: true,
                        underline: Container(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.black,
                        items: rooms.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            numberofrooms.text = newValue!;
                          });
                        },
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        controller: numberofrooms,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          numberofrooms.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "  Number of rooms"),
                      ),
                    )
                  ],
                ),
              ),
              propertyon == "Rent property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Pay duration"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: tenor.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  paymentduration.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: paymentduration,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                paymentduration.text = value;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Payment duration"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Pincode", border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: pincode,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          pincode.text = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "  Pincode"),
                      ),
                    )
                  ],
                ),
              ),
              propertyon == "Sell property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Sell property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 140,
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: "  Property name",
                                  border: InputBorder.none),
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              controller: propertyname,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Property name"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Service type"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: servicetypelist.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  servicetype.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: servicetype,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Service type"),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : const SizedBox(),
              propertyon == "Rent property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Sharing"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: sharinglist.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  sharing.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: sharing,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Sharing"),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              propertyon != "Rent property"
                  ? const SizedBox(
                      height: 20,
                    )
                  : SizedBox(),
              propertyon != "Rent property"
                  ? Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: DropdownButton(
                              hint: const Text("  Number of Floor"),
                              icon: const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              isExpanded: true,
                              underline: Container(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              items: floorlist.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  floor.text = newValue!;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30),
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: floor,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: "  1"),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 140,
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: "  Complete Address",
                            border: InputBorder.none),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 30),
                    ),
                    Expanded(
                      child: TextField(
                        controller: streetaddress,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "  Complete address"),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<ListProvider>(builder: (context, provider, child) {
                return SizedBox(
                  height: 136.0,
                  child: InkWell(
                    onTap: () {
                      setState(
                        () {
                          initImageList = provider.imagelistvalue;
                          print(initImageList);
                        },
                      );
                    },
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (true)
                          ...(initImageList).map(
                            (e) {
                              return oldimagedelete(e, widget.valuedata['city'],
                                  widget.valuedata['propertyId'], context);
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }),
              listImage.isNotEmpty
                  ? Consumer<ListProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          height: 136.0,
                          child: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    listImage = provider.uploadimagelist;
                                    print(listImage);
                                    if (listImage.isEmpty) {
                                      setState(() {
                                        heightImage = false;
                                      });
                                    }
                                  });
                                },
                              );
                            },
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (listImage != [])
                                  ...listImage.map(
                                    (e) {
                                      return newpropertyimage(e);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: ImageUploadCard(null),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text(''),
                            content: const Text(
                                'Are you sure you want to delete this property?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'No'),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context, 'Yes');
                                  await deleteProperty();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width < 800 ? width * 0.3 : width * 0.2,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  // Color(0xFF8A2387),
                                  FlutterFlowTheme.of(context).alternate,
                                  FlutterFlowTheme.of(context).alternate,
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: loadingdelete
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        print('this is start');
                        try {
                          if (widget.valuedata['wantto'] == 'Sell property') {
                            if (name.text != '' && name.text != 'null') {
                              if (pincode.text != '' &&
                                  pincode.text != 'null' &&
                                  _isNumeric(pincode.text)) {
                                if (propertyname.text != '' &&
                                    propertyname.text != 'null') {
                                  if (streetaddress.text != '' &&
                                      streetaddress.text != 'null') {
                                    if (whatsapp.text != '' &&
                                        whatsapp.text != 'null' &&
                                        _isNumeric(whatsapp.text
                                            .toString()
                                            .split('+')[1])) {
                                      if (numberoffloors.text != '' &&
                                          numberoffloors.text != 'null' &&
                                          _isNumeric(numberoffloors.text)) {
                                        if (numberofrooms.text != '' &&
                                            numberofrooms.text != 'null' &&
                                            numberofrooms.text !=
                                                "How many rooms does your property have?") {
                                          if (phone.text != '' &&
                                              phone.text != 'null' &&
                                              _isNumeric(phone.text
                                                  .toString()
                                                  .split('+')[1])) {
                                            if (email.text != '' &&
                                                email.text != 'null' &&
                                                emailvalidation
                                                    .hasMatch(email.text)) {
                                              if (areaofland.text != '' &&
                                                  areaofland.text != 'null' &&
                                                  _isNumeric(areaofland.text)) {
                                                if (amount.text != '' &&
                                                    amount.text != 'null') {
                                                  if (advanvemoney.text != '' &&
                                                      advanvemoney.text !=
                                                          'null' &&
                                                      advanvemoney.text !=
                                                          'Any Advance Money?') {
                                                    try {
                                                      var uid = FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid;
                                                      print('4');
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('City')
                                                          .doc(widget.valuedata[
                                                              'propertyId'])
                                                          .update({
                                                        "areaoflandunit":
                                                            areaoflandunit.text,
                                                        "advancemoney":
                                                            advanvemoney.text,
                                                        "amount": amount.text,
                                                        'areaofland':
                                                            areaofland.text,
                                                        'description':
                                                            discription.text,
                                                        'email': email.text,
                                                        'mobilenumber':
                                                            phone.text,
                                                        'numberofrooms':
                                                            numberofrooms.text,
                                                        'ownername': name.text,
                                                        'numberoffloors':
                                                            numberoffloors.text,
                                                        'pincode': pincode.text,
                                                        'propertyname':
                                                            propertyname.text,
                                                        'streetaddress':
                                                            streetaddress.text,
                                                        'whatsappnumber':
                                                            whatsapp.text,
                                                      }).whenComplete(() => {
                                                                // showToast("")
                                                              });
                                                      print('7');
                                                      print('8 ee');
                                                      if (listImage.isEmpty) {
                                                        showToast(
                                                            context: context,
                                                            "Updated Successfully");
                                                      } else {
                                                        List listdatalink =
                                                            await uploadImage(
                                                                listImage);
                                                        print('8 ee');
                                                        if (listdatalink !=
                                                            null) {
                                                          print('9 ee');
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'City')
                                                                .doc(widget
                                                                        .valuedata[
                                                                    'propertyId'])
                                                                .update({
                                                              'propertyimage':
                                                                  FieldValue
                                                                      .arrayUnion(
                                                                          listdatalink),
                                                            });
                                                          } catch (e) {
                                                            print(e.toString());
                                                          }
                                                        }
                                                      }

                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      Navigator.pop(context);
                                                      // ignore: use_build_context_synchronously
                                                      // Navigator
                                                      //     .pushReplacement(
                                                      //   context,
                                                      // MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         CustomBottomNavigation(
                                                      //             "",
                                                      //             "",
                                                      //             "profile")),
                                                      // );
                                                    } catch (e) {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      print(
                                                          "this is the error 1:  ${e.toString()}");
                                                    }
                                                  } else {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    showToast(
                                                        context: context,
                                                        "Advance money field not selected!");
                                                  }
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showToast(
                                                      context: context,
                                                      "Amount mentioned is invalid!");
                                                }
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });
                                                showToast(
                                                    context: context,
                                                    "Area of land field is invalid!");
                                              }
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              showToast(
                                                  context: context,
                                                  "Email is invalid!");
                                            }
                                          } else {
                                            setState(() {
                                              loading = false;
                                            });
                                            showToast(
                                                context: context,
                                                "Phone is invalid!");
                                          }
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          showToast(
                                              context: context,
                                              "Number of rooms field not selected!");
                                        }
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        showToast(
                                            context: context,
                                            "Number of floor field not selected!");
                                      }
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      showToast(
                                          context: context,
                                          "What's app number field is invalid!");
                                    }
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showToast(
                                        context: context,
                                        "Complete address field is invalid!");
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showToast(
                                      context: context,
                                      "Property name field is invalid!");
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                showToast(
                                    context: context,
                                    "Pincode field is invalid!");
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showToast(
                                  context: context, "Name field is invalid!");
                            }
                          }
                        } catch (e) {
                          print("this is the kinga error: ${e.toString()}");
                          showToast(context: context, e.toString());
                          setState(() {
                            loading = false;
                          });
                        }
                        // showToast(context: context,"Advance money field not selected!");

                        //rent property
                        try {
                          if (widget.valuedata['wantto'] == 'Rent property') {
                            if (name.text != '' && name.text != 'null') {
                              if (paymentduration.text != '' &&
                                  paymentduration.text != 'null') {
                                if (pincode.text != '' &&
                                    pincode.text != 'null' &&
                                    _isNumeric(pincode.text)) {
                                  if (streetaddress.text != '' &&
                                      streetaddress.text != 'null') {
                                    if (whatsapp.text != '' &&
                                        whatsapp.text != 'null' &&
                                        _isNumeric(whatsapp.text
                                            .toString()
                                            .split('+')[1])) {
                                      if (numberofrooms.text != '' &&
                                          numberofrooms.text != 'null' &&
                                          numberofrooms.text !=
                                              "How many rooms does your property have?") {
                                        if (phone.text != '' &&
                                            phone.text != 'null' &&
                                            _isNumeric(phone.text
                                                .toString()
                                                .split('+')[1])) {
                                          if (email.text != '' &&
                                              email.text != 'null' &&
                                              emailvalidation
                                                  .hasMatch(email.text)) {
                                            if (amount.text != '' &&
                                                amount.text != 'null') {
                                              if (advanvemoney.text != '' &&
                                                  advanvemoney.text != 'null' &&
                                                  advanvemoney.text !=
                                                      'Any Advance Money?') {
                                                if (foodservice.text != '' &&
                                                    foodservice.text !=
                                                        'null' &&
                                                    foodservice.text !=
                                                        'Food service?') {
                                                  if (servicetype.text != '' &&
                                                      servicetype.text !=
                                                          'null' &&
                                                      servicetype.text !=
                                                          'Which of the following is your property type?') {
                                                    if (sharing.text != '' &&
                                                        sharing.text !=
                                                            'null' &&
                                                        sharing.text !=
                                                            'Number of sharing?') {
                                                      try {
                                                        var uid = FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid;
                                                        print('4');
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('City')
                                                            .doc(widget
                                                                    .valuedata[
                                                                'propertyId'])
                                                            .update({
                                                          "advancemoney":
                                                              advanvemoney.text,
                                                          "amount": amount.text,
                                                          'description':
                                                              discription.text,
                                                          'servicetype':
                                                              servicetype.text,
                                                          'paymentduration':
                                                              paymentduration
                                                                  .text,
                                                          'foodservice':
                                                              foodservice.text,
                                                          'email': email.text,
                                                          'sharing':
                                                              sharing.text,
                                                          'mobilenumber':
                                                              phone.text,
                                                          'numberofrooms':
                                                              numberofrooms
                                                                  .text,
                                                          'ownername':
                                                              name.text,
                                                          'pincode':
                                                              pincode.text,
                                                          'streetaddress':
                                                              streetaddress
                                                                  .text,
                                                          'whatsappnumber':
                                                              whatsapp.text,
                                                        }).whenComplete(() => {
                                                                  // showToast("")
                                                                });
                                                        print('7');
                                                        print('8');
                                                        List listdatalink =
                                                            await uploadImage(
                                                                listImage);
                                                        if (listdatalink !=
                                                            null) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'City')
                                                              .doc(widget
                                                                      .valuedata[
                                                                  'propertyId'])
                                                              .update({
                                                            'propertyimage':
                                                                FieldValue
                                                                    .arrayUnion(
                                                                        listdatalink),
                                                          });
                                                        }

                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pop(context);
                                                        // Navigator
                                                        //     .pushReplacement(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //     Navigator.pop(context),
                                                        //         // CustomBottomNavigation("","","profile"),
                                                        //   ),
                                                        // );
                                                      } catch (e) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        print(
                                                            "this is the error 2: ${e.toString()}");
                                                      }
                                                    } else {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      showToast(
                                                          context: context,
                                                          "Sharing field not selected!");
                                                    }
                                                  } else {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    showToast(
                                                        context: context,
                                                        "Service type field not selected!");
                                                  }
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showToast(
                                                      context: context,
                                                      "Food service field not selected!");
                                                }
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });
                                                showToast(
                                                    context: context,
                                                    "Advance money field not selected!");
                                              }
                                            } else {
                                              setState(() {
                                                loading = false;
                                              });
                                              showToast(
                                                  context: context,
                                                  "Amount mentioned is invalid!");
                                            }
                                          } else {
                                            setState(() {
                                              loading = false;
                                            });
                                            showToast(
                                                context: context,
                                                "Email is invalid!");
                                          }
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          showToast(
                                              context: context,
                                              "Phone is invalid!");
                                        }
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        showToast(
                                            context: context,
                                            "Number of rooms field not selected!");
                                      }
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      showToast(
                                          context: context,
                                          "What's app number field is invalid!");
                                    }
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showToast(
                                        context: context,
                                        "Complete address field is invalid!");
                                  }
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showToast(
                                      context: context,
                                      "Pincode field is invalid!");
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                showToast(
                                    context: context,
                                    "Payment duration field not selected!");
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showToast(
                                  context: context, "Name field is invalid!");
                            }
                          }
                        } catch (e) {
                          print("dddd--: ${e.toString()}");
                          showToast(context: context, e.toString());
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width < 800 ? width * 0.3 : width * 0.2,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  // Color(0xFF8A2387),
                                  FlutterFlowTheme.of(context).alternate,
                                  FlutterFlowTheme.of(context).alternate,
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : const Text(
                                  'Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List istodelete = [];
  Widget oldimagedelete(e, city, propertyid, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(570),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          e == null
              ? Container()
              : Consumer<ListProvider>(builder: (context, provider, child) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Image.network(
                          e,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.circle,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 43,
                          )),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(''),
                                content: initlistimages.length == 1
                                    ? const Text(
                                        'Atleast one image is required!')
                                    : const Text(
                                        'Are you sure you want to delete this image?'),
                                actions: <Widget>[
                                  initlistimages.length != 1
                                      ? TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('No'),
                                        )
                                      : const SizedBox(),
                                  TextButton(
                                    onPressed: () async {
                                      // ignore: use_build_context_synchronously
                                      // print('hjjjjjjjjj');
                                      // print(globals.initlistimages.length);
                                      if (initlistimages.length != 1) {
                                        istodelete.add(e);
                                        // globals.initlistimages.remove(widget.e);
                                        // provider.imagelistvalue =
                                        //     globals.initlistimages;
                                        // provider.changeimagelist();
                                        // provider.imagelistvalue = globals.imageList;
                                        // provider.changeimagelist();
                                        setState(() {
                                          istodelete;
                                        });
                                        Navigator.pop(
                                            context, "globals.initlistimages");
                                        deleteImage(e, propertyid);
                                      }

                                      // ignore: use_build_context_synchronously
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const ProfilePage()),
                                      // );
                                    },
                                    child: initlistimages.length == 1
                                        ? TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Okay'),
                                          )
                                        : const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                            // deleteImage();
                            // globals.initlistimages.remove(widget.e);
                            // provider.imagelistvalue = globals.imageList;
                            // provider.changeimagelist();
                            // Navigator.pop(context, globals.initlistimages);
                          },
                        ),
                      ),
                      istodelete.contains(e)
                          ? const Positioned(
                              bottom: 38,
                              right: 35,
                              child: Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    )),
                              ),
                            )
                          : const SizedBox()
                    ],
                  );
                }),
        ]),
      ),
    );
  }

  void deleteImage(e, propertyid) async {
    try {
      var valtodelete = [];
      valtodelete.add("${e}");
      var list = e.toString().split('%2F');
      var list2 = list[2].split("?alt");

      print("property/${list[1]}/${list2[0]}");
      final storageRef = FirebaseStorage.instance.ref();
      final desertRef = storageRef.child("property/${list[1]}/${list2[0]}");
      await desertRef.delete();
      await FirebaseFirestore.instance
          .collection("City")
          .doc(propertyid)
          .update({
        'propertyimage': FieldValue.arrayRemove(valtodelete),
      });
      showToast(context: context, "deleted successfully");
      setState(() {
        initImageList.remove(e);
      });
    } catch (e) {
      print("wewewwwwwwwwww$e");
    }
  }

  Widget newpropertyimage(item) {
    print("1");
    // print(widget.e);
    print("2");
    print("9");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      height: 100,
      decoration: BoxDecoration(
        // boxShadow: [

        // ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(570),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            item == null
                ? Container()
                : Consumer<ListProvider>(builder: (context, provider, child) {
                    return Stack(children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: FileImage(File(item.path)),
                      ),
                      const Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.circle,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 43,
                          )),
                      Positioned(
                          bottom: -3,
                          right: -3,
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              // globals.uploadingimageList.remove(item);
                              // provider.uploadimagelist =
                              //     globals.uploadingimageList;
                              setState(() {
                                listImage.remove(item);
                              });
                              // provider.uploadingimagelist();
                              // Navigator.pop(context, globals.imageList);
                            },
                          )),
                    ]);
                  }
                    // : Consumer<ListProvider>(
                    //     builder: (context, provider, child) {
                    //       return Stack(children: [
                    //         CircleAvatar(
                    //           backgroundColor: Colors.white,
                    //           radius: 50.0,
                    //           child: Image.memory(
                    //             widget.e,
                    //             fit: BoxFit.fill,
                    //           ),
                    //         ),
                    //         const Positioned(
                    //           bottom: 0,
                    //           right: 0,
                    //           child: Icon(
                    //             Icons.circle,
                    //             color: Color.fromARGB(255, 255, 255, 255),
                    //             size: 43,
                    //           ),
                    //         ),
                    //         Positioned(
                    //           bottom: -3,
                    //           right: -3,
                    //           child: IconButton(
                    //             icon: const Icon(Icons.delete),
                    //             onPressed: () {
                    //               setState(() {
                    //                 globals.uploadingimageList.remove(widget.e);
                    //                 provider.uploadimagelist =
                    //                     globals.uploadingimageList;
                    //                 provider.uploadingimagelist();
                    //                 // Navigator.pop(context, globals.imageList);
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ]);
                    //     },
                    //   ),
                    )
          ],
        ),
      ),
    );
  }

  bool _isNumeric(String str) {
    if (str == "null") {
      return false;
    }
    return double.tryParse(str) != null;
  }

  deleteProperty() async {
    try {
      setState(() {
        loadingdelete = true;
      });
      for (var i in widget.valuedata['propertyimage']) {
        var list = i.split('%2F');
        var list2 = list[2].split("?alt");
        print("property/${list[1]}/${list2[0]}");
        final storageRef = FirebaseStorage.instance.ref();
        final desertRef = storageRef.child("property/${list[1]}/${list2[0]}");
        await desertRef.delete();
      }

      await FirebaseFirestore.instance
          .collection("City")
          .doc(widget.valuedata['propertyId'])
          .delete();
      showToast(context: context, "property deleted successfully");
    } catch (e) {
      setState(() {
        loadingdelete = false;
      });
      print("uuuuuuuuuuuuuuioi${e.toString()}");
    }
    setState(() {
      loadingdelete = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  var floorlist = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '70',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '79',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99',
    '100',
    '101',
    '102',
    '103',
    '104',
    '105',
    '106',
    '107',
    '108',
    '109',
    '110',
    '111',
    '112',
    '113',
    '114',
    '115',
    '116',
    '117',
    '118',
    '119',
    '120',
    '121',
    '122',
    '123',
    '124',
    '125',
    '126',
    '127',
    '128',
    '129',
    '130',
    '131',
    '132',
    '133',
    '134',
    '135',
    '136',
    '137',
    '138',
    '139',
    '140',
    '141',
    '142',
    '143',
    '144',
    '145',
    '146',
    '147',
    '148',
    '149',
    '150',
    '151',
    '152',
    '153',
    '154',
    '155',
    '156',
    '157',
    '158',
    '159',
    '160',
    '161',
    '162',
    '163',
    '164',
    '165',
    '166',
    '167',
    '168',
    '169',
    '170',
    '171',
    '172',
    '173',
    '174',
    '175',
    '176',
    '177',
    '178',
    '179',
    '180',
    '181',
    '182',
    '183',
    '184',
    '185',
    '186',
    '187',
    '188',
    '189',
    '190',
    '191',
    '192',
    '193',
    '194',
    '195',
    '196',
    '197',
    '198',
    '199',
    '200',
    '201',
    '202',
    '203',
    '204',
    '205',
    '206',
    '207',
    '208',
    '209',
    '210',
    '211',
    '212',
    '213',
    '214',
    '215',
    '216',
    '217',
    '218',
    '219',
    '220',
    '221',
    '222',
    '223',
    '224',
    '225',
    '226',
    '227',
    '228',
    '229',
    '230',
    '231',
    '232',
    '233',
    '234',
    '235',
    '236',
    '237',
    '238',
    '239',
    '240',
    '241',
    '242',
    '243',
    '244',
    '245',
    '246',
    '247',
    '248',
    '249',
    '250',
    '251',
    '252',
    '253',
    '254',
    '255',
    '256',
    '257',
    '258',
    '259',
    '260',
    '261',
    '262',
    '263',
    '264',
    '265',
    '266',
    '267',
    '268',
    '269',
    '270',
    '271',
    '272',
    '273',
    '274',
    '275',
    '276',
    '277',
    '278',
    '279',
    '280',
    '281',
    '282',
    '283',
    '284',
    '285',
    '286',
    '287',
    '288',
    '289',
    '290',
    '291',
    '292',
    '293',
    '294',
    '295',
    '296',
    '297',
    '298',
    '299',
    '300',
    '301',
    '302',
    '303',
    '304',
    '305',
    '306',
    '307',
    '308',
    '309',
    '310',
    '311',
    '312',
    '313',
    '314',
    '315',
    '316',
    '317',
    '318',
    '319',
    '320',
    '321',
    '322',
    '323',
    '324',
    '325',
    '326',
    '327',
    '328',
    '329',
    '330',
    '331',
    '332',
    '333',
    '334',
    '335',
    '336',
    '337',
    '338',
    '339',
    '340',
    '341',
    '342',
    '343',
    '344',
    '345',
    '346',
    '347',
    '348',
    '349',
    '350',
    '351',
    '352',
    '353',
    '354',
    '355',
    '356',
    '357',
    '358',
    '359',
    '360',
    '361',
    '362',
    '363',
    '364',
    '365',
    '366',
    '367',
    '368',
    '369',
    '370',
    '371',
    '372',
    '373',
    '374',
    '375',
    '376',
    '377',
    '378',
    '379',
    '380',
    '381',
    '382',
    '383',
    '384',
    '385',
    '386',
    '387',
    '388',
    '389',
    '390',
    '391',
    '392',
    '393',
    '394',
    '395',
    '396',
    '397',
    '398',
    '399',
    '400',
    '401',
    '402',
    '403',
    '404',
    '405',
    '406',
    '407',
    '408',
    '409',
    '410',
    '411',
    '412',
    '413',
    '414',
    '415',
    '416',
    '417',
    '418',
    '419',
    '420',
    '421',
    '422',
    '423',
    '424',
    '425',
    '426',
    '427',
    '428',
    '429',
    '430',
    '431',
    '432',
    '433',
    '434',
    '435',
    '436',
    '437',
    '438',
    '439',
    '440',
    '441',
    '442',
    '443',
    '444',
    '445',
    '446',
    '447',
    '448',
    '449',
    '450',
    '451',
    '452',
    '453',
    '454',
    '455',
    '456',
    '457',
    '458',
    '459',
    '460',
    '461',
    '462',
    '463',
    '464',
    '465',
    '466',
    '467',
    '468',
    '469',
    '470',
    '471',
    '472',
    '473',
    '474',
    '475',
    '476',
    '477',
    '478',
    '479',
    '480',
    '481',
    '482',
    '483',
    '484',
    '485',
    '486',
    '487',
    '488',
    '489',
    '490',
    '491',
    '492',
    '493',
    '494',
    '495',
    '496',
    '497',
    '498',
    '499',
    '500'
  ];
}
