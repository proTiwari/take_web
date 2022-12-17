import 'dart:async';
import 'dart:convert';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:take_web/web/Widgets/paralleldropdownlist.dart';
import '../../Widgets/image_upload_card.dart';
import '../../Widgets/loaded_images.dart';
import 'list_provider.dart';

class ListProperty extends StatefulWidget {
  const ListProperty({Key? key}) : super(key: key);

  @override
  State<ListProperty> createState() => _ListPropertyState();
}

class _ListPropertyState extends State<ListProperty> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String firstName = "";
  String lastName = "";
  String bodyTemp = "";

  late Timer timer;

  bool _loading = false;
  double _progressValue = 0.0;

  bool dataloading = true;

  bool sell = false;
  bool rent = false;
  bool isAPIcallProcess = false;
  final ImagePicker _picker = ImagePicker();
  dynamic imageFile;
  List listImage = [];

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

  bool heightImage = false;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

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
      globals.imageList = listImage;
      if (kDebugMode) {
        print(pickedFile);
      }
    });
  }

  void prints(var s1) {
    String s = s1.toString();
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => print("${match.group(0)}\n"));
  }
  //import 'package:flutter/services.dart' show rootBundle;

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: ProgressHUD(
  //         child: otpVerify(),
  //         inAsyncCall: isAPIcallProcess,
  //         opacity: 0.3,
  //         key: UniqueKey(),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListProvider(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Image.asset("assets/home3.png"),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            text: "List Property",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<ListProvider>(
                            builder: (context, provider, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            height: 104,
                            child: Column(
                              children: [
                                CSCPicker(
                                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                  showStates: true,

                                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                                  showCities: true,

                                  ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                  flagState: CountryFlag.DISABLE,

                                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                  dropdownDecoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),

                                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                  disabledDropdownDecoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1)),

                                  ///placeholders for dropdown search field
                                  countrySearchPlaceholder: "Country",
                                  stateSearchPlaceholder: "State",
                                  citySearchPlaceholder: "City",

                                  ///labels for dropdown
                                  countryDropdownLabel: "*Country",
                                  stateDropdownLabel: "*State",
                                  cityDropdownLabel: "*City",

                                  ///Default Country
                                  defaultCountry: DefaultCountry.India,
                                  disableCountry: true,

                                  ///Disable country dropdown (Note: use it with default country)
                                  //disableCountry: true,

                                  ///selected item style [OPTIONAL PARAMETER]
                                  selectedItemStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),

                                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                  dropdownHeadingStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),

                                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                  dropdownItemStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),

                                  ///Dialog box radius [OPTIONAL PARAMETER]
                                  dropdownDialogRadius: 10.0,

                                  ///Search bar radius [OPTIONAL PARAMETER]
                                  searchBarRadius: 10.0,

                                  ///triggers once country selected in dropdown
                                  onCountryChanged: (value) {
                                    setState(() {
                                      ///store value in country variable
                                      countryValue = value;
                                    });
                                  },

                                  ///triggers once state selected in dropdown
                                  onStateChanged: (value) {
                                    setState(() {
                                      ///store value in state variable
                                      stateValue = value.toString();
                                      provider.changestate(value.toString());
                                    });
                                  },

                                  ///triggers once city selected in dropdown
                                  onCityChanged: (value) {
                                    setState(() {
                                      ///store value in city variable
                                      cityValue = value.toString();
                                      provider.changecity(value.toString());
                                      // provider.city.value = value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return Center(
                              child: SizedBox(
                                height: 43,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black,
                                            //shadow for button
                                            blurRadius: 0.1)
                                        //blur radius of shadow
                                      ]),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          14.0, 0, 0, 2.7),
                                      child: Center(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "Pincode",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider.changePinCode(value);
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return Center(
                              child: SizedBox(
                                height: 43,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black,
                                            //shadow for button
                                            blurRadius: 0.1)
                                        //blur radius of shadow
                                      ]),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          14.0, 0, 0, 2.7),
                                      child: Center(
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            hintText: "Street Address",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider.changeStreetAddress(value);
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: DropdownButton(
                                    hint: provider.wanttotext == ''
                                        ? const Text("Want to?")
                                        : Text(provider.wanttotext),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    underline: Container(),
                                    //empty line
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    items: provider.wantTo.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        if (newValue == "Want to?") {
                                          sell = false;
                                          rent = false;
                                        } else if (newValue ==
                                            "Sell property") {
                                          sell = true;
                                          rent = false;
                                        } else {
                                          rent = true;
                                          sell = false;
                                        }
                                      });
                                      provider.changeWantto(newValue!);
                                      provider.wanttotext = newValue;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        rent
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        rent
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black,
                                                //shadow for button
                                                blurRadius: 0.1)
                                            //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: DropdownButton(
                                          hint: provider.servicetypetext == ''
                                              ? const Text("Service Type?")
                                              : Text(provider.servicetypetext
                                                  .toString()),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          isExpanded: true,
                                          underline: Container(),
                                          //empty line
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          items: provider.servicetypelist
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            provider.servicetypetext =
                                                newValue!;
                                            provider
                                                .changeServiceType(newValue);
                                            if (kDebugMode) {
                                              print(provider.servicetypetext);
                                              print(newValue);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        rent
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        rent
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: DropdownButton(
                                          // Initial Value
                                          hint: provider.sharingtext == ''
                                              ? const Text("Number of sharing?")
                                              : Text(provider.sharingtext),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          isExpanded: true,
                                          //make true to take width of parent widget
                                          underline: Container(),
                                          //empty line
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          // Array list of items
                                          items: provider.sharinglist
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            provider.sharingtext = newValue!;
                                            provider.changeSharing(newValue);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: DropdownButton(
                                    hint: provider.advanceMoneytext == ''
                                        ? const Text("Any Advance Money?")
                                        : Text(provider.advanceMoneytext),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    //make true to take width of parent widget
                                    underline: Container(),
                                    //empty line
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    // Array list of items
                                    items: provider.advanceMoney
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      provider.advanceMoneytext = newValue!;
                                      provider.changeAdvanceMoney(newValue);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        rent
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        rent
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: DropdownButton(
                                          // Initial Value
                                          hint: provider.foodtext == ''
                                              ? const Text("Food Service?")
                                              : Text(provider.foodtext),

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          isExpanded: true,
                                          //make true to take width of parent widget
                                          underline: Container(),
                                          //empty line
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          // Array list of items
                                          items:
                                              provider.food.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            provider.foodtext = newValue!;
                                            provider
                                                .changeFoodService(newValue);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        sell
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        sell
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: DropdownButton(
                                          // Initial Value
                                          hint: provider.roomstext == ''
                                              ? const Text(
                                                  "Number of rooms",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              : Text(provider.roomstext),

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          isExpanded: true,
                                          //make true to take width of parent widget
                                          underline: Container(),
                                          //empty line
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Colors.black,
                                          // Array list of items
                                          items: provider.rooms
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            provider.roomstext = newValue!;
                                            provider
                                                .changeNumberOfRooms(newValue);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        sell
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        sell
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors
                                                  .black, //shadow for button
                                              blurRadius:
                                                  0.1) //blur radius of shadow
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                13),
                                          ],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "Amount",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider.changeAmount(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        rent
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        rent
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.31,
                                        child: DecoratedBox(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(0),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors
                                                      .black, //shadow for button
                                                  blurRadius:
                                                      0.1) //blur radius of shadow
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                14.0, 0, 0, 2.7),
                                            child: TextFormField(
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    13),
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: "Amount",
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                provider.changeAmount(value);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: DecoratedBox(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors
                                                        .black, //shadow for button
                                                    blurRadius:
                                                        0.1) //blur radius of shadow
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                14.0, 0, 0, 2.7),
                                            child: DropdownButton(
                                              // Initial Value
                                              hint: provider.tenortext == ''
                                                  ? const Text(
                                                      "Payment Duration",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )
                                                  : Text(provider.tenortext),

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              isExpanded: true,
                                              //make true to take width of parent widget
                                              underline: Container(),
                                              //empty line
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              dropdownColor: Colors.white,
                                              iconEnabledColor: Colors.black,
                                              // Array list of items
                                              items: provider.tenor
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                provider.tenortext = newValue!;
                                                provider.changePaymentDuration(
                                                    newValue);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: DecoratedBox(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors
                                                        .black, //shadow for button
                                                    blurRadius:
                                                        0.1) //blur radius of shadow
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                14.0, 0, 0, 2.7),
                                            child: DropdownButton(
                                              // Initial Value
                                              hint: provider.roomstext == ''
                                                  ? const Text(
                                                      "Number of rooms",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )
                                                  : Text(provider.roomstext),

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              isExpanded: true,
                                              //make true to take width of parent widget
                                              underline: Container(),
                                              //empty line
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              dropdownColor: Colors.white,
                                              iconEnabledColor: Colors.black,
                                              // Array list of items
                                              items: provider.rooms
                                                  .map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                provider.roomstext = newValue!;
                                                provider.changeNumberOfRooms(
                                                    newValue);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : Container(),
                        sell
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        sell
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Property Name",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider.changePropertyName(value);
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        sell
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        sell
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Area of land (In square feet)",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider.changeAreaOfLand(value);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        sell
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        sell
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 43,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                                color: Colors
                                                    .black, //shadow for button
                                                blurRadius:
                                                    0.1) //blur radius of shadow
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            14.0, 0, 0, 2.7),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText: "Number of floors",
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            provider
                                                .changeNumberOfFloors(value);
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: "Owner's Name",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      provider.changeOwersName(value);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "Mobile Number",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      provider.changeMobileNumber(value);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "WhatsApp Number",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      provider.changeWhatsappNumber(value);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 43,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14.0, 0, 0, 2.7),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      provider.changeEmail(value);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Upload property Image",
                          ),
                        ),
                        heightImage
                            ? Consumer<ListProvider>(
                                builder: (context, provider, child) {
                                  return SizedBox(
                                    height: 136.0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(
                                          () {
                                            listImage = provider.imagelistvalue;
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
                                                if (kDebugMode) {
                                                  print("is this your are taking about :$e");
                                                }
                                                var dsd = LoadedImage(e);
                                                print(dsd);
                                                return LoadedImage(e);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet()),
                            );
                          },
                          child: ImageUploadCard(null),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              height: 200,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Colors.black, //shadow for button
                                          blurRadius:
                                              0.1) //blur radius of shadow
                                    ]),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 10,
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Owner's Description (Optional)",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      provider.changeDescription(value);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<ListProvider>(
                          builder: (context, provider, child) {
                            return true
                                ? InkWell(
                                    onTap: () async {
                                      provider.submit(context);
                                    },
                                    child: Stack(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 65,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Color(0xFFF27121),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xFFF27121)),
                                            value: 0.0,
                                          ),
                                        ),
                                        // ignore: prefer_const_constructors
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 21, 0, 0),
                                          child: Center(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: provider.loading
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  6.0),
                                                          child: SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: Center(
                                                                  child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white))),
                                                        )
                                                      : const Text(
                                                          "List Property",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 23,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 239, 154, 154),
                                        minimumSize: const Size.fromHeight(60)),
                                    onPressed: () async {
                                      // await getResponse();
                                      setState(() {
                                        _loading = !_loading;
                                        // _updateProgress();
                                      });
                                      // print(a);
                                      provider.submit(context);
                                    },
                                    child: const Text(
                                      "List Property",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

/*  void _updateProgress(ListProvider provider) {
    
    if (kDebugMode) {
      print("progress");
    }
    _progressValue = 0.0;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue += 0.08;
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0') {
          _loading = false;
          t.cancel();
          provider.dataloading = false;
          return;
        }
      });
    });
  }*/
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}
