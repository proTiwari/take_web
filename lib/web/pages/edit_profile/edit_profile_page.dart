import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../Widgets/image_upload_card.dart';
import '../../Widgets/loaded_images.dart';
import '../../Widgets/loader_image_property_edit.dart';

class EditProfilePage extends StatefulWidget {
  var valuedata;
  EditProfilePage(this.valuedata, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool edit = false;
  String propertyon = '';
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
    } catch (e) {
      print("ttttttttttttt");
      print(e.toString());
    }
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

  void takePhoto(ImageSource source) async {
    // final pickedFile = await _picker.pickImage(
    //   source: source,
    // );
    var pickedFile = (await ImagePickerWeb.getImageAsBytes())!;

    setState(() {
      imageFile = pickedFile;
      if (pickedFile.isNotEmpty) {
        heightImage = true;
      }
      listImage.add(pickedFile);
      listImage.remove(null);
      // globals.imageList = listImage;
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
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
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
                        keyboardType: TextInputType.phone,
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
                        keyboardType: TextInputType.phone,
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
                          phone.text = value;
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
                              controller: advanvemoney,
                              keyboardType: TextInputType.phone,
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
                        keyboardType: TextInputType.phone,
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
                              keyboardType: TextInputType.phone,
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
                        keyboardType: TextInputType.phone,
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
                              controller: foodservice,
                              keyboardType: TextInputType.phone,
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
                              controller: numberoffloors,
                              keyboardType: TextInputType.phone,
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
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
              SizedBox(
                height: 136.0,
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        // listImage =
                        //     provider.imagelistvalue;
                      },
                    );
                  },
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (true)
                        ...widget.valuedata.propertyimage.map(
                          (e) {
                            return LoadedImagePropertyEdit(
                                e,
                                widget.valuedata.city,
                                widget.valuedata.propertyId);
                          },
                        ),
                    ],
                  ),
                ),
              ),
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
                        try {
                          for (var i in widget.valuedata.propertyimage) {
                            var list = i.split('%2F');
                            var list2 = list[2].split("?alt");
                            print("property/${list[1]}/${list2[0]}");
                            final storageRef = FirebaseStorage.instance.ref();
                            final desertRef = storageRef
                                .child("property/${list[1]}/${list2[0]}");
                            await desertRef.delete();
                          }
                          var val = [];
                          val.add(
                              "${widget.valuedata.city}/${widget.valuedata.propertyId}");
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
                          showToast(
                              context: context,
                              "property deleted successfully");
                        } catch (e) {
                          print("uuuuuuuuuuuuuuioi${e.toString()}");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width < 800 ? width * 0.3 : width * 0.2,
                        height: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  // Color(0xFF8A2387),
                                  Color(0xFFF27121),
                                  Color(0xFFF27121),
                                ])),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
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
                        try {
                          if (true) {
                            var uid = FirebaseAuth.instance.currentUser!.uid;
                            print('4');
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .update({
                                  
                            }).whenComplete(() => {});
                            print('7');
                          }
                          print('8');
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width < 800 ? width * 0.3 : width * 0.2,
                        height: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  // Color(0xFF8A2387),
                                  Color(0xFFF27121),
                                  Color(0xFFF27121),
                                ])),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: false
                              ? SizedBox(
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : Text(
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
}
