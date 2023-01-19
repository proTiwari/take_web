import 'dart:js_util';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/firebase_functions/firebase_fun.dart';
import 'package:take_web/web/pages/profile_page/profile_page.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../../Widgets/image_upload_card.dart';
import '../../Widgets/loaded_images.dart';
import '../../Widgets/loader_image_property_edit.dart';
import '../../Widgets/uploading_image_property_image.dart';
import '../list_property/list_provider.dart';

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
  TextEditingController streetaddress = TextEditingController();
  TextEditingController servicetype = TextEditingController();
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
      print(widget.valuedata.email);
      setState(() {
        propertyon = widget.valuedata.wantto;
      });
      name.text = widget.valuedata.ownername;
      email.text = widget.valuedata.email;
      foodservice.text = widget.valuedata.foodservice;
      phone.text = widget.valuedata.mobilenumber;
      whatsapp.text = widget.valuedata.whatsappnumber;
      advanvemoney.text = widget.valuedata.advancemoney;
      amount.text = widget.valuedata.amount;
      areaofland.text = widget.valuedata.areaofland;
      streetaddress.text = widget.valuedata.streetaddress;
      propertyname.text = widget.valuedata.propertyname;
      sharing.text = widget.valuedata.sharing;
      pincode.text = widget.valuedata.pincode;
      paymentduration.text = widget.valuedata.paymentduration;
      numberoffloors.text = widget.valuedata.numberoffloors;
      numberofrooms.text = widget.valuedata.numberofrooms;
      servicetype.text = widget.valuedata.servicetype;
      discription.text = widget.valuedata.description == 'null'
          ? "   -"
          : widget.valuedata.description;

      initImageList = widget.valuedata.propertyimage;
      globals.initlistimages = widget.valuedata.propertyimage;
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
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

  uploadImage(listofimg) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if (listofimg.isNotEmpty) {
      try {
        print(listofimg.length);

        for (var i = 0; i < listofimg.length; i++) {
          var file = listofimg[i];
          final firebaseStorage = FirebaseStorage.instance;

          if (file != null) {
            //Upload to Firebase
            var snapshot;
            try {
              var pathpass = generateRandomString(34);
              // print(file.path);
              snapshot = await firebaseStorage
                  .ref()
                  .child('property/$uid/$pathpass')
                  .putData(file)
                  .whenComplete(() =>
                      {print("success....................................")});
            } catch (e) {
              print("failed....................................");
              print(e);
            }

            var download = await snapshot.ref.getDownloadURL();
            downloadUrl.add(download);

            // setState(() {
            //   imageUrl = downloadUrl;
            // });
          } else {}
        }
        return downloadUrl;
      } catch (e) {}
    } else {
      // showToast(
      //   "Atleast one property image is needed!",
      //   context: context,
      //   animation: StyledToastAnimation.none,
      // );
    }
  }

  void takePhoto(ImageSource source) async {
    var pickedFile = (await ImagePickerWeb.getImageAsBytes())!;

    setState(() {
      imageFile = pickedFile;
      if (pickedFile.isNotEmpty) {
        heightImage = true;
      }
      listImage.add(pickedFile);
      listImage.remove(null);
      globals.uploadingimageList = listImage;
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
  var tenor = [
    'Payment Duration',
    'per hour',
    'per month',
    'per year',
    'per day',
    'one time payment',
    'will be discussed'
  ];
  var servicetypelist = [
    'Which of the following is your property type?',
    'Hostel',
    'Hotel',
    'PG',
    'Apartment',
    'Flat',
    'Home',
    'Building floor'
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              "Edit Property",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
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
                      const SizedBox(
                        width: 140,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: "  Amount", border: InputBorder.none),
                        ),
                      ),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 30),
                      ),
                      Expanded(
                        child: TextField(
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
                                    hintText: "  No. of floors",
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
                                    hintText: "  No. of floors"),
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
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
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
                            // initImageList = provider.imagelistvalue;
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
                                return LoadedImagePropertyEdit(
                                    e,
                                    widget.valuedata.city,
                                    widget.valuedata.propertyId,
                                    context);
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
                                    listImage = provider.uploadimagelist;
                                    print(listImage);
                                    if (listImage.isEmpty) {
                                      setState(() {
                                        heightImage = false;
                                      });
                                    }
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
                                        return UploadingImageProperty(e);
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
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    // Color(0xFF8A2387),
                                    Color(0xFFF27121),
                                    Color(0xFFF27121),
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
                          // showToast(context: context,"Advance money field not selected!");
                          if (widget.valuedata.wantto == 'Sell property') {
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
                                                    amount.text != 'null' &&
                                                    _isNumeric(amount.text)) {
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
                                                          .collection('State')
                                                          .doc('City')
                                                          .collection(widget
                                                              .valuedata.city)
                                                          .doc(widget.valuedata
                                                              .propertyId)
                                                          .update({
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
                                                      print('8');
                                                      List listdatalink =
                                                          await uploadImage(
                                                              listImage);
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('State')
                                                          .doc('City')
                                                          .collection(widget
                                                              .valuedata.city)
                                                          .doc(widget.valuedata
                                                              .propertyId)
                                                          .update({
                                                        'propertyimage':
                                                            FieldValue.arrayUnion(
                                                                listdatalink),
                                                      });
                                                      await getUser();
                                                      await FirebaseServices()
                                                          .getProperties();
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ProfilePage()),
                                                      );
                                                    } catch (e) {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      print(
                                                          "this is the error: ${e.toString()}");
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

                          //rent property
                          if (widget.valuedata.wantto == 'Rent property') {
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
                                                amount.text != 'null' &&
                                                _isNumeric(amount.text)) {
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
                                                            .collection('State')
                                                            .doc('City')
                                                            .collection(widget
                                                                .valuedata.city)
                                                            .doc(widget
                                                                .valuedata
                                                                .propertyId)
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
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('State')
                                                            .doc('City')
                                                            .collection(widget
                                                                .valuedata.city)
                                                            .doc(widget
                                                                .valuedata
                                                                .propertyId)
                                                            .update({
                                                          'propertyimage':
                                                              FieldValue.arrayUnion(
                                                                  listdatalink),
                                                        });
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const ProfilePage()));
                                                      } catch (e) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        print(
                                                            "this is the error: ${e.toString()}");
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
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: width < 800 ? width * 0.3 : width * 0.2,
                          height: 50,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    // Color(0xFF8A2387),
                                    Color(0xFFF27121),
                                    Color(0xFFF27121),
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
      for (var i in widget.valuedata.propertyimage) {
        var list = i.split('%2F');
        var list2 = list[2].split("?alt");
        print("property/${list[1]}/${list2[0]}");
        final storageRef = FirebaseStorage.instance.ref();
        final desertRef = storageRef.child("property/${list[1]}/${list2[0]}");
        await desertRef.delete();
      }
      var val = [];
      val.add("${widget.valuedata.city}/${widget.valuedata.propertyId}");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'properties': FieldValue.arrayRemove(val),
      });
      await FirebaseFirestore.instance
          .collection("State")
          .doc('City')
          .collection(widget.valuedata.city)
          .doc(widget.valuedata.propertyId)
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
}
