// import 'dart:async';
// import 'package:csc_picker/csc_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:take/app/globar_variables/globals.dart' as globals;
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:take/app/pages/list_property/cityList.dart';
// import 'package:take/app/pages/list_property/onmap.dart';
// import 'package:take/app/services/location_services.dart';
// import '../../Widgets/image_upload_card.dart';
// import '../../Widgets/loaded_images.dart';
// import '../../providers/base_providers.dart';
// import 'agreement_document.dart';
// import 'list_provider.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:dropdown_search/dropdown_search.dart';

// class ListProperty extends StatefulWidget {
//   const ListProperty({Key? key}) : super(key: key);

//   @override
//   State<ListProperty> createState() => _ListPropertyState();
// }

// class _ListPropertyState extends State<ListProperty> {
//   GlobalKey<FormState> _formKey = GlobalKey();

//   String countryValue = "";
//   String stateValue = "";
//   String cityValue = "";
//   String firstName = "";
//   String lastName = "";
//   String bodyTemp = "";
//   bool agreement = false;

//   late Timer timer;

//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController whatsappController = TextEditingController();
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   TextEditingController pincode = TextEditingController();

//   bool _loading = false;
//   double _progressValue = 0.0;

//   bool dataloading = true;

//   bool sell = false;
//   bool rent = false;
//   bool isAPIcallProcess = false;
//   final ImagePicker _picker = ImagePicker();
//   dynamic imageFile;
//   List listImage = [];
//   String? _currentAddress;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     addData();

//     try {
//       emailController.text = userProvider.getUser.email!;
//       nameController.text = userProvider.getUser.name!;
//       phoneController.text = userProvider.getUser.phone!;
//       whatsappController.text = userProvider.getUser.phone!;
//       pincode.text = globals.postalcode;
//       results = globals.latlong;
//     } catch (e) {
//       print("ttttttttttttt${e}");
//     }
//   }

//   late BaseProvider userProvider;
//   var location;

//   addData() async {
//     userProvider = Provider.of<BaseProvider>(context, listen: false);

//     await userProvider.refreshUser();
//   }

//   Future<void> _getAddressFromLatLng(Position position) async {
//     await placemarkFromCoordinates(
//             _currentPosition!.latitude, _currentPosition!.longitude)
//         .then((List<Placemark> placemarks) {
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//             '${place.street}, ${place.subLocality},${place.locality}, ${place.postalCode}';
//       });
//     }).catchError((e) {
//       debugPrint(e);
//     });
//   }

//   Future<void> _getCurrentPosition() async {
//     final hasPermission =
//         await LocationService().handleLocationPermission();
//     print("sd");
//     if (!hasPermission) return;
//     print("dsfs");
//     try {
//       await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high)
//           .then((Position position) {
//         print("dsisw");
//         setState(() {
//           print("wew");
//           _currentPosition = position;
//           var res = LatLng(position.latitude, position.longitude);
//           _getAddressFromLatLng(position);
//           results = res;
//           globals.latlong = results;
//           print(results);
//         });
//       }).catchError((e) {
//         debugPrint(e);
//         print("sd");
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 70.0,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 10,
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//             TextButton.icon(
//               icon: const Icon(
//                 Icons.camera,
//                 size: 50,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 takePhoto(ImageSource.camera);
//               },
//               label: const Text("Camera"),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.3,
//             ),
//             TextButton.icon(
//               icon: const Icon(
//                 Icons.image,
//                 size: 50,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 takePhoto(ImageSource.gallery);
//                 // Navigator.pop(context);
//               },
//               label: const Text("Gallery"),
//             ),
//           ])
//         ],
//       ),
//     );
//   }

//   bool heightImage = false;

//   @override
//   void dispose() {
//     super.dispose();
//     timer.cancel();
//     emailController;
//     nameController;
//     phoneController;
//     whatsappController;
//   }

//   void takePhoto(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(
//       source: source,
//     );

//     setState(() {
//       imageFile = pickedFile;
//       if (pickedFile != null) {
//         heightImage = true;
//       }
//       listImage.add(pickedFile);
//       listImage.remove(null);
//       globals.imageList = listImage;
//       if (kDebugMode) {
//         print(pickedFile);
//       }
//     });
//   }

//   void prints(var s1) {
//     String s = s1.toString();
//     final pattern = RegExp('.{1,800}');
//     pattern.allMatches(s).forEach((match) => print("${match.group(0)}\n"));
//   }
//   //import 'package:flutter/services.dart' show rootBundle;

//   // @override
//   // Widget build(BuildContext context) {
//   //   return SafeArea(
//   //     child: Scaffold(
//   //       body: ProgressHUD(
//   //         child: otpVerify(),
//   //         inAsyncCall: isAPIcallProcess,
//   //         opacity: 0.3,
//   //         key: UniqueKey(),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget currentlocation() {
//     return GestureDetector(
//       onTap: (() {
//         print("_getCurrentPosition");
//         _getCurrentPosition();
//       }),
//       child: Container(
//           padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
//           height: 60,
//           width: 60,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade100,
//                   offset: const Offset(1, 1),
//                   blurRadius: 0,
//                   spreadRadius: 3)
//             ],
//             color: Colors.white,
//             // color: Theme.of(context).primaryColor,
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: const Icon(Icons.gps_fixed)),
//     );
//   }

//   var results;
//   Future<void> _navigateAndDisplaySelection(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => OnMap()),
//     );
//     setState(() {
//       results = result;
//       globals.latlong = results;
//     });
//   }

//   late NavigatorState _navigator;

//   @override
//   void didChangeDependencies() {
//     _navigator = Navigator.of(context);
//     super.didChangeDependencies();
//   }

//   Widget onMap() {
//     return GestureDetector(
//       onTap: (() {
//         _navigateAndDisplaySelection(context);
//         // location = Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (BuildContext context) => OnMap(),
//         //   ),
//         // );
//         // if (!mounted) return;

//         // // After the Selection Screen returns a result, hide any previous snackbars
//         // // and show the new result.
//         // ScaffoldMessenger.of(context)
//         //   ..removeCurrentSnackBar()
//         //   ..showSnackBar(SnackBar(content: Text('$location')));
//       }),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
//         height: 60,
//         width: 60,
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.grey.shade100,
//                 offset: const Offset(1, 3),
//                 blurRadius: 2,
//                 spreadRadius: 3)
//           ],
//           color: Colors.white,
//           // color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: SizedBox(
//           child: Image.asset(
//             "assets/oop.png",
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool> handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services'),
//         ),
//       );
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(location);
//     final width = MediaQuery.of(context).size.width;
//     return ChangeNotifierProvider(
//       create: (context) => ListProvider(),
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: Container(
//           margin: EdgeInsets.symmetric(
//               vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16.0, 26, 16, 1),
//               child: Column(
//                 children: <Widget>[
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: RichText(
//                       textAlign: TextAlign.left,
//                       text: const TextSpan(
//                         children: [
//                           TextSpan(
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold),
//                             text: "List Property",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         // city field parameter

//                         Container(
//                           child: DropdownSearch<String>(
//                             popupProps: PopupProps.menu(
//                               menuProps: const MenuProps(borderOnForeground: true ,elevation: 0),
//                               showSearchBox: true,
//                               showSelectedItems: true,
//                               disabledItemFn: (String s) => s.startsWith('I'),
//                             ),
//                             items: cityList,
//                             dropdownDecoratorProps: const DropDownDecoratorProps(
//                               dropdownSearchDecoration: InputDecoration(
//                                 labelText: "City",
//                                 hintText: "Prayagraj",
//                               ),
//                             ),
//                             onChanged: print,
//                             selectedItem: "Prayagraj",
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Consumer<ListProvider>(
//                             builder: (context, provider, child) {
//                           return Container(
//                             padding: const EdgeInsets.symmetric(vertical: 0),
//                             height: 104,
//                             child: Column(
//                               children: [
//                                 CSCPicker(
//                                   ///Enable disable state dropdown [OPTIONAL PARAMETER]
//                                   showStates: true,

//                                   /// Enable disable city drop down [OPTIONAL PARAMETER]
//                                   showCities: true,

//                                   ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
//                                   flagState: CountryFlag.DISABLE,

//                                   ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
//                                   dropdownDecoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(20)),
//                                       color: Colors.white,
//                                       border: Border.all(
//                                           color: Colors.grey.shade300,
//                                           width: 1)),

//                                   ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
//                                   disabledDropdownDecoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(20)),
//                                       color: Colors.grey.shade300,
//                                       border: Border.all(
//                                           color: Colors.grey.shade300,
//                                           width: 1)),

//                                   ///placeholders for dropdown search field
//                                   countrySearchPlaceholder: "Country",
//                                   stateSearchPlaceholder: "State",
//                                   citySearchPlaceholder: "City",

//                                   ///labels for dropdown
//                                   countryDropdownLabel: "*Country",
//                                   stateDropdownLabel: "*State",
//                                   cityDropdownLabel: "*City",

//                                   ///Default Country
//                                   defaultCountry: DefaultCountry.India,
//                                   disableCountry: true,

//                                   ///Disable country dropdown (Note: use it with default country)
//                                   //disableCountry: true,

//                                   ///selected item style [OPTIONAL PARAMETER]
//                                   selectedItemStyle: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                   ),

//                                   ///DropdownDialog Heading style [OPTIONAL PARAMETER]
//                                   dropdownHeadingStyle: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold),

//                                   ///DropdownDialog Item style [OPTIONAL PARAMETER]
//                                   dropdownItemStyle: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                   ),

//                                   ///Dialog box radius [OPTIONAL PARAMETER]
//                                   dropdownDialogRadius: 10.0,

//                                   ///Search bar radius [OPTIONAL PARAMETER]
//                                   searchBarRadius: 10.0,

//                                   ///triggers once country selected in dropdown
//                                   onCountryChanged: (value) {
//                                     setState(() {
//                                       ///store value in country variable
//                                       countryValue = value;
//                                     });
//                                   },

//                                   ///triggers once state selected in dropdown
//                                   onStateChanged: (value) {
//                                     setState(() {
//                                       ///store value in state variable
//                                       stateValue = value.toString();
//                                       provider.changestate(value.toString());
//                                     });
//                                   },

//                                   ///triggers once city selected in dropdown
//                                   onCityChanged: (value) {
//                                     setState(() {
//                                       ///store value in city variable
//                                       cityValue = value.toString();
//                                       provider.changecity(value.toString());
//                                       // provider.city.value = value.toString();
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return Center(
//                               child: SizedBox(
//                                 height: 43,
//                                 child: DecoratedBox(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20),
//                                       boxShadow: const <BoxShadow>[
//                                         BoxShadow(
//                                             color: Colors.black,
//                                             //shadow for button
//                                             blurRadius: 0.1)
//                                         //blur radius of shadow
//                                       ]),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           14.0, 0, 0, 8),
//                                       child: Center(
//                                         child: TextFormField(
//                                           controller: pincode,
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(
//                                             fillColor: Colors.black,
//                                             hintText: "Pincode",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider.changePinCode(value);
//                                             provider.changeEmail(
//                                                 userProvider.getUser.email);
//                                             provider.changeOwersName(
//                                                 userProvider.getUser.name
//                                                     .toString());
//                                             provider.changeWhatsappNumber(
//                                                 userProvider.getUser.phone
//                                                     .toString());
//                                             provider.changeMobileNumber(
//                                                 userProvider.getUser.phone
//                                                     .toString());
//                                           },
//                                           validator: (value) {
//                                             return null;
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return Center(
//                               child: SizedBox(
//                                 height: 43,
//                                 child: DecoratedBox(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20),
//                                       boxShadow: const <BoxShadow>[
//                                         BoxShadow(
//                                             color: Colors.black,
//                                             //shadow for button
//                                             blurRadius: 0.1)
//                                         //blur radius of shadow
//                                       ]),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           14.0, 0, 0, 8),
//                                       child: Center(
//                                         child: TextFormField(
//                                           keyboardType: TextInputType.text,
//                                           decoration: const InputDecoration(
//                                             hintText: "Complete Address",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider.changeStreetAddress(value);
//                                           },
//                                           validator: (value) {
//                                             return null;
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),

//                         const SizedBox(
//                           height: 30,
//                         ),

//                         results == null
//                             ? const SizedBox()
//                             : Text(results.toString().substring(6)),
//                         const SizedBox(
//                           height: 7,
//                         ),
//                         // location on map or current coordinate

//                         // Column(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     Text('LAT: ${_currentPosition?.latitude ?? ""}'),
//                         //     Text('LNG: ${_currentPosition?.longitude ?? ""}'),
//                         //     Text('ADDRESS: ${_currentAddress ?? ""}'),
//                         //     const SizedBox(height: 32),
//                         //     ElevatedButton(
//                         //       onPressed: _getCurrentPosition,
//                         //       child: const Text("Get Current Location"),
//                         //     )
//                         //   ],
//                         // ),
//                         // const SizedBox(
//                         //   height: 20,
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.all(18.0),
//                           child: IntrinsicHeight(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [
//                                     currentlocation(),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     const Text("current location",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w200))
//                                   ],
//                                 ),
//                                 // const SizedBox(
//                                 //   width: 10,
//                                 // ),
//                                 const VerticalDivider(
//                                   color: Colors.black,
//                                   thickness: 1,
//                                 ),
//                                 // const SizedBox(
//                                 //   width: 10,
//                                 // ),
//                                 Column(
//                                   children: [
//                                     onMap(),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     const Text(
//                                       "choose on Map",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w200),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color: Colors.black,
//                                           //shadow for button
//                                           blurRadius: 0.1)
//                                       //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       14.0, 5, 0, 2.7),
//                                   child: DropdownButton(
//                                     hint: provider.wanttotext == ''
//                                         ? const Text(
//                                             "Want to sell property or rent it?",
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               color: Color.fromARGB(
//                                                   255, 184, 160, 160),
//                                             ),
//                                           )
//                                         : Text(
//                                             provider.wanttotext,
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Color.fromARGB(
//                                                   255, 184, 160, 160),
//                                             ),
//                                           ),
//                                     icon: const Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                       child: Icon(Icons.keyboard_arrow_down),
//                                     ),
//                                     isExpanded: true,
//                                     underline: Container(),
//                                     //empty line
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                     dropdownColor: Colors.white,
//                                     iconEnabledColor: Colors.black,
//                                     items: provider.wantTo.map((String items) {
//                                       return DropdownMenuItem(
//                                         value: items,
//                                         child: Text(items),
//                                       );
//                                     }).toList(),
//                                     onChanged: (String? newValue) {
//                                       provider.changePinCode(
//                                           globals.postalcode.toString());
//                                       provider.changeEmail(
//                                           userProvider.getUser.email);
//                                       provider.changeOwersName(
//                                           userProvider.getUser.name.toString());
//                                       provider.changeWhatsappNumber(userProvider
//                                           .getUser.phone
//                                           .toString());
//                                       provider.changeMobileNumber(userProvider
//                                           .getUser.phone
//                                           .toString());
//                                       setState(() {
//                                         if (newValue ==
//                                             "How many rooms does your property have?") {
//                                           sell = false;
//                                           rent = false;
//                                         } else if (newValue ==
//                                             "Sell property") {
//                                           sell = true;
//                                           rent = false;
//                                         } else {
//                                           rent = true;
//                                           sell = false;
//                                         }
//                                       });
//                                       provider.changeWantto(newValue!);
//                                       provider.wanttotext = newValue;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         rent
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         rent
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors.black,
//                                                 //shadow for button
//                                                 blurRadius: 0.1)
//                                             //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 0),
//                                         child: DropdownButton(
//                                           hint: provider.servicetypetext == ''
//                                               ? const Text(
//                                                   "Which of the following is your property type?",
//                                                   style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160)),
//                                                 )
//                                               : Text(
//                                                   provider.servicetypetext
//                                                       .toString(),
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160))),
//                                           icon: const Padding(
//                                             padding:
//                                                 EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                             child:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                           isExpanded: true,
//                                           underline: Container(),
//                                           //empty line
//                                           style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.black),
//                                           dropdownColor: Colors.white,
//                                           iconEnabledColor: Colors.black,
//                                           items: provider.servicetypelist
//                                               .map((String items) {
//                                             return DropdownMenuItem(
//                                               value: items,
//                                               child: Text(items),
//                                             );
//                                           }).toList(),
//                                           onChanged: (String? newValue) {
//                                             provider.servicetypetext =
//                                                 newValue!;
//                                             provider
//                                                 .changeServiceType(newValue);
//                                             if (kDebugMode) {
//                                               print(provider.servicetypetext);
//                                               print(newValue);
//                                             }
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         rent
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         rent
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 0),
//                                         child: DropdownButton(
//                                           // Initial Value
//                                           hint: provider.sharingtext == ''
//                                               ? const Text("Number of sharing?",
//                                                   style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160)))
//                                               : Text(provider.sharingtext,
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160))),
//                                           icon: const Padding(
//                                             padding:
//                                                 EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                             child:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                           isExpanded: true,
//                                           //make true to take width of parent widget
//                                           underline: Container(),
//                                           //empty line
//                                           style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.black),
//                                           dropdownColor: Colors.white,
//                                           iconEnabledColor: Colors.black,
//                                           // Array list of items
//                                           items: provider.sharinglist
//                                               .map((String items) {
//                                             return DropdownMenuItem(
//                                               value: items,
//                                               child: Text(items),
//                                             );
//                                           }).toList(),
//                                           // After selecting the desired option,it will
//                                           // change button value to selected value
//                                           onChanged: (String? newValue) {
//                                             provider.sharingtext = newValue!;
//                                             provider.changeSharing(newValue);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
//                                   child: DropdownButton(
//                                     hint: provider.advanceMoneytext == ''
//                                         ? const Text("Any advance money?",
//                                             style: TextStyle(
//                                                 color: Color.fromARGB(
//                                                     255, 184, 160, 160)))
//                                         : Text(provider.advanceMoneytext,
//                                             style: const TextStyle(
//                                                 fontSize: 16,
//                                                 color: Color.fromARGB(
//                                                     255, 184, 160, 160))),
//                                     icon: const Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                       child: Icon(Icons.keyboard_arrow_down),
//                                     ),
//                                     isExpanded: true,
//                                     //make true to take width of parent widget
//                                     underline: Container(),
//                                     //empty line
//                                     style: const TextStyle(
//                                         fontSize: 16, color: Colors.black),
//                                     dropdownColor: Colors.white,
//                                     iconEnabledColor: Colors.black,
//                                     // Array list of items
//                                     items: provider.advanceMoney
//                                         .map((String items) {
//                                       return DropdownMenuItem(
//                                         value: items,
//                                         child: Text(items),
//                                       );
//                                     }).toList(),
//                                     // After selecting the desired option,it will
//                                     // change button value to selected value
//                                     onChanged: (String? newValue) {
//                                       provider.advanceMoneytext = newValue!;
//                                       provider.changeAdvanceMoney(newValue);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         rent
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         rent
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 0),
//                                         child: DropdownButton(
//                                           // Initial Value
//                                           hint: provider.foodtext == ''
//                                               ? const Text(
//                                                   "Food service?",
//                                                   style: TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 184, 160, 160),
//                                                   ),
//                                                 )
//                                               : Text(provider.foodtext,
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160))),

//                                           // Down Arrow Icon
//                                           icon: const Padding(
//                                             padding:
//                                                 EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                             child:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                           isExpanded: true,
//                                           //make true to take width of parent widget
//                                           underline: Container(),
//                                           //empty line
//                                           style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.black),
//                                           dropdownColor: Colors.white,
//                                           iconEnabledColor: Colors.black,
//                                           // Array list of items
//                                           items:
//                                               provider.food.map((String items) {
//                                             return DropdownMenuItem(
//                                               value: items,
//                                               child: Text(items),
//                                             );
//                                           }).toList(),
//                                           onChanged: (String? newValue) {
//                                             provider.foodtext = newValue!;
//                                             provider
//                                                 .changeFoodService(newValue);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         sell
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         sell
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20),
//                                               bottomRight: Radius.circular(20)),
//                                           boxShadow: <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 0),
//                                         child: DropdownButton(
//                                           // Initial Value
//                                           hint: provider.roomstext == ''
//                                               ? const Text(
//                                                   "How many rooms does your property have?",
//                                                   style: TextStyle(
//                                                       fontSize: 16,
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160)),
//                                                 )
//                                               : Text(provider.roomstext,
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Color.fromARGB(
//                                                           255, 184, 160, 160))),

//                                           // Down Arrow Icon
//                                           icon: const Padding(
//                                             padding:
//                                                 EdgeInsets.fromLTRB(0, 0, 8, 0),
//                                             child:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                           ),
//                                           isExpanded: true,
//                                           //make true to take width of parent widget
//                                           underline: Container(),
//                                           //empty line
//                                           style: const TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.black),
//                                           dropdownColor: Colors.white,
//                                           iconEnabledColor: Colors.black,
//                                           // Array list of items
//                                           items: provider.rooms
//                                               .map((String items) {
//                                             return DropdownMenuItem(
//                                               value: items,
//                                               child: Text(items),
//                                             );
//                                           }).toList(),
//                                           // After selecting the desired option,it will
//                                           // change button value to selected value
//                                           onChanged: (String? newValue) {
//                                             provider.roomstext = newValue!;
//                                             provider
//                                                 .changeNumberOfRooms(newValue);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         sell
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         sell
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20),
//                                           topRight: Radius.circular(20),
//                                           bottomLeft: Radius.circular(20),
//                                           bottomRight: Radius.circular(20),
//                                         ),
//                                         boxShadow: <BoxShadow>[
//                                           BoxShadow(
//                                               color: Colors
//                                                   .black, //shadow for button
//                                               blurRadius:
//                                                   0.1) //blur radius of shadow
//                                         ],
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 8),
//                                         child: TextFormField(
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(
//                                                 13),
//                                           ],
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(
//                                             hintText: "Amount",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider.changeAmount(value);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         rent
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         rent
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           SizedBox(
//                                             height: 43,
//                                             // margin: EdgeInsets.symmetric(vertical: 0, horizontal: width < 800?10:width*0.24),
//                                             width: width < 800
//                                                 ? 170
//                                                 : width * 0.22,
//                                             child: DecoratedBox(
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(20),
//                                                   topRight: Radius.circular(0),
//                                                   bottomLeft:
//                                                       Radius.circular(20),
//                                                   bottomRight:
//                                                       Radius.circular(0),
//                                                 ),
//                                                 boxShadow: <BoxShadow>[
//                                                   BoxShadow(
//                                                       color: Colors
//                                                           .black, //shadow for button
//                                                       blurRadius:
//                                                           0.1) //blur radius of shadow
//                                                 ],
//                                               ),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         14.0, 0, 0, 8),
//                                                 child: TextFormField(
//                                                   inputFormatters: [
//                                                     LengthLimitingTextInputFormatter(
//                                                         13),
//                                                   ],
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     hintText: "Amount",
//                                                     border: InputBorder.none,
//                                                   ),
//                                                   onChanged: (value) {
//                                                     provider
//                                                         .changeAmount(value);
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 43,
//                                             width: width < 800
//                                                 ? 170
//                                                 : width * 0.22,
//                                             child: DecoratedBox(
//                                               decoration: const BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                           topLeft: Radius
//                                                               .circular(0),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   20),
//                                                           bottomLeft:
//                                                               Radius.circular(
//                                                                   0),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   20)),
//                                                   boxShadow: <BoxShadow>[
//                                                     BoxShadow(
//                                                         color: Colors
//                                                             .black, //shadow for button
//                                                         blurRadius:
//                                                             0.1) //blur radius of shadow
//                                                   ]),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         14.0, 0, 0, 0),
//                                                 child: DropdownButton(
//                                                   // Initial Value
//                                                   hint: provider.tenortext == ''
//                                                       ? const Text(
//                                                           "Payment duration",
//                                                           style: TextStyle(
//                                                               fontSize: 16,
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       184,
//                                                                       160,
//                                                                       160)),
//                                                         )
//                                                       : Text(provider.tenortext,
//                                                           style: const TextStyle(
//                                                               fontSize: 16,
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       184,
//                                                                       160,
//                                                                       160))),

//                                                   // Down Arrow Icon
//                                                   icon: const Padding(
//                                                     padding:
//                                                         EdgeInsets.fromLTRB(
//                                                             0, 0, 8, 0),
//                                                     child: Icon(Icons
//                                                         .keyboard_arrow_down),
//                                                   ),
//                                                   isExpanded: true,
//                                                   //make true to take width of parent widget
//                                                   underline: Container(),
//                                                   //empty line
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       color: Colors.black),
//                                                   dropdownColor: Colors.white,
//                                                   iconEnabledColor:
//                                                       Colors.black,
//                                                   // Array list of items
//                                                   items: provider.tenor
//                                                       .map((String items) {
//                                                     return DropdownMenuItem(
//                                                       value: items,
//                                                       child: Text(items),
//                                                     );
//                                                   }).toList(),
//                                                   onChanged:
//                                                       (String? newValue) {
//                                                     provider.tenortext =
//                                                         newValue!;
//                                                     provider
//                                                         .changePaymentDuration(
//                                                             newValue);
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       SizedBox(
//                                         height: 43,
//                                         child: DecoratedBox(
//                                           decoration: const BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(20),
//                                                   topRight: Radius.circular(20),
//                                                   bottomLeft:
//                                                       Radius.circular(20),
//                                                   bottomRight:
//                                                       Radius.circular(20)),
//                                               boxShadow: <BoxShadow>[
//                                                 BoxShadow(
//                                                     color: Colors
//                                                         .black, //shadow for button
//                                                     blurRadius:
//                                                         0.1) //blur radius of shadow
//                                               ]),
//                                           child: Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 14.0, 0, 0, 0),
//                                             child: DropdownButton(
//                                               // Initial Value
//                                               hint: provider.roomstext == ''
//                                                   ? const Text(
//                                                       "How many rooms does your property have?",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           color: Color.fromARGB(
//                                                               255,
//                                                               184,
//                                                               160,
//                                                               160)),
//                                                     )
//                                                   : Text(provider.roomstext,
//                                                       style: const TextStyle(
//                                                           fontSize: 16,
//                                                           color: Color.fromARGB(
//                                                               255,
//                                                               184,
//                                                               160,
//                                                               160))),

//                                               // Down Arrow Icon
//                                               icon: const Padding(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     0, 0, 8, 0),
//                                                 child: Icon(
//                                                     Icons.keyboard_arrow_down),
//                                               ),
//                                               isExpanded: true,
//                                               //make true to take width of parent widget
//                                               underline: Container(),
//                                               //empty line
//                                               style: const TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.black),
//                                               dropdownColor: Colors.white,
//                                               iconEnabledColor: Colors.black,
//                                               // Array list of items
//                                               items: provider.rooms
//                                                   .map((String items) {
//                                                 return DropdownMenuItem(
//                                                   value: items,
//                                                   child: Text(items),
//                                                 );
//                                               }).toList(),
//                                               // After selecting the desired option,it will
//                                               // change button value to selected value
//                                               onChanged: (String? newValue) {
//                                                 provider.roomstext = newValue!;
//                                                 provider.changeNumberOfRooms(
//                                                     newValue);
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         sell
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         sell
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 8),
//                                         child: TextFormField(
//                                           decoration: const InputDecoration(
//                                             hintText: "Property Name",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider.changePropertyName(value);
//                                           },
//                                           validator: (value) {
//                                             return null;
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         sell
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         sell
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 8),
//                                         child: TextFormField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(
//                                             hintText:
//                                                 "Area of land (In square feet)",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider.changeAreaOfLand(value);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         sell
//                             ? const SizedBox(
//                                 height: 10,
//                               )
//                             : Container(),
//                         sell
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 43,
//                                     child: DecoratedBox(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           boxShadow: const <BoxShadow>[
//                                             BoxShadow(
//                                                 color: Colors
//                                                     .black, //shadow for button
//                                                 blurRadius:
//                                                     0.1) //blur radius of shadow
//                                           ]),
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             14.0, 0, 0, 8),
//                                         child: TextFormField(
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(
//                                             hintText: "Number of floors",
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             provider
//                                                 .changeNumberOfFloors(value);
//                                           },
//                                           validator: (value) {
//                                             return null;
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(14.0, 0, 0, 8),
//                                   child: TextFormField(
//                                     controller: nameController,
//                                     keyboardType: TextInputType.text,
//                                     decoration: const InputDecoration(
//                                       hintText: "Owner's Name",
//                                       border: InputBorder.none,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.changeOwersName(value);
//                                     },
//                                     validator: (value) {
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(14.0, 0, 0, 8),
//                                   child: TextFormField(
//                                     keyboardType: TextInputType.number,
//                                     controller: phoneController,
//                                     decoration: const InputDecoration(
//                                       hintText: "Mobile Number",
//                                       border: InputBorder.none,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.changeMobileNumber(value);
//                                     },
//                                     validator: (value) {
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(14.0, 0, 0, 8),
//                                   child: TextFormField(
//                                     controller: whatsappController,
//                                     keyboardType: TextInputType.number,
//                                     decoration: const InputDecoration(
//                                       hintText: "WhatsApp Number",
//                                       border: InputBorder.none,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.changeWhatsappNumber(value);
//                                     },
//                                     validator: (value) {
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 43,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(14.0, 0, 0, 8),
//                                   child: TextFormField(
//                                     controller: emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: const InputDecoration(
//                                       hintText: "Email",
//                                       border: InputBorder.none,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.changeEmail(value);
//                                     },
//                                     validator: (value) {
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Text(
//                             "Upload property Image",
//                           ),
//                         ),
//                         heightImage
//                             ? Consumer<ListProvider>(
//                                 builder: (context, provider, child) {
//                                   return SizedBox(
//                                     height: 136.0,
//                                     child: InkWell(
//                                       onTap: () {
//                                         setState(
//                                           () {
//                                             listImage = provider.imagelistvalue;
//                                           },
//                                         );
//                                       },
//                                       child: ListView(
//                                         shrinkWrap: true,
//                                         scrollDirection: Axis.horizontal,
//                                         children: [
//                                           if (listImage != [])
//                                             ...listImage.map(
//                                               (e) {
//                                                 if (kDebugMode) {
//                                                   // print("is this your are taking about :$e");
//                                                 }
//                                                 var dsd = LoadedImage(e);
//                                                 return LoadedImage(e);
//                                               },
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               )
//                             : Container(),
//                         InkWell(
//                           onTap: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: ((builder) => bottomSheet()),
//                             );
//                           },
//                           child: ImageUploadCard(null),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return SizedBox(
//                               height: 200,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const <BoxShadow>[
//                                       BoxShadow(
//                                           color:
//                                               Colors.black, //shadow for button
//                                           blurRadius:
//                                               0.1) //blur radius of shadow
//                                     ]),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
//                                   child: TextFormField(
//                                     minLines: 1,
//                                     maxLines: 10,
//                                     decoration: const InputDecoration(
//                                       hintText:
//                                           "Owner's Description (Optional)",
//                                       border: InputBorder.none,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.changeDescription(value);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           children: <Widget>[
//                             const SizedBox(
//                               width: 10,
//                             ), //SizedBox
//                             Checkbox(
//                               value: agreement,
//                               onChanged: (value) {
//                                 setState(() {
//                                   agreement = value!;
//                                 });
//                                 print(agreement);
//                               },
//                             ),
//                             const SizedBox(width: 10),
//                             InkWell(
//                                 child: const Text(
//                                   'agree to terms and conditions',
//                                   style: TextStyle(
//                                       color: Colors.deepPurpleAccent,
//                                       fontSize: 17.0),
//                                 ),
//                                 onTap: () => {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               AgreementDocument(),
//                                         ),
//                                       ),
//                                     }),
//                             // Text(
//                             //   'agree to terms and conditions',
//                             //   style: TextStyle(fontSize: 17.0),
//                             // ), //Checkbox
//                           ], //<Widget>[]
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Consumer<ListProvider>(
//                           builder: (context, provider, child) {
//                             return true
//                                 ? InkWell(
//                                     onTap: () async {
//                                       if (agreement == true) {
//                                         provider.submit(context);
//                                       } else {
//                                         showToast(
//                                             context: context,
//                                             "Please agree to the terms and conditions");
//                                       }
//                                     },
//                                     child: Stack(
//                                       // mainAxisAlignment:
//                                       //     MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         const SizedBox(
//                                           height: 65,
//                                           child: LinearProgressIndicator(
//                                             backgroundColor: Color(0xFFF27121),
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                                     Color(0xFFF27121)),
//                                             value: 0.0,
//                                           ),
//                                         ),
//                                         // ignore: prefer_const_constructors
//                                         Padding(
//                                           padding: const EdgeInsets.fromLTRB(
//                                               0, 21, 0, 0),
//                                           child: Center(
//                                             child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(0.0),
//                                                   child: provider.loading
//                                                       ? const Padding(
//                                                           padding:
//                                                               EdgeInsets.all(
//                                                                   6.0),
//                                                           child: SizedBox(
//                                                               height: 20,
//                                                               width: 20,
//                                                               child: Center(
//                                                                   child: CircularProgressIndicator(
//                                                                       color: Colors
//                                                                           .white))),
//                                                         )
//                                                       : const Text(
//                                                           "List Property",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: 23,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                 )),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 : ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         primary:
//                                             Color.fromARGB(255, 239, 154, 154),
//                                         minimumSize: const Size.fromHeight(60)),
//                                     onPressed: () async {
//                                       // await getResponse();
//                                       setState(() {
//                                         _loading = !_loading;
//                                         // _updateProgress();
//                                       });
//                                       // print(a);
//                                       provider.submit(context);
//                                     },
//                                     child: const Text(
//                                       "List Property",
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// /*  void _updateProgress(ListProvider provider) {
    
//     if (kDebugMode) {
//       print("progress");
//     }
//     _progressValue = 0.0;
//     const oneSec = Duration(seconds: 1);
//     timer = Timer.periodic(oneSec, (Timer t) {
//       setState(() {
//         _progressValue += 0.08;
//         // we "finish" downloading here
//         if (_progressValue.toStringAsFixed(1) == '1.0') {
//           _loading = false;
//           t.cancel();
//           provider.dataloading = false;
//           return;
//         }
//       });
//     });
//   }*/
// }

// extension StringExtension on String {
//   // Method used for capitalizing the input from the form
//   String capitalize() {
//     return "${this[0].toLowerCase()}${substring(1)}";
//   }
// }
