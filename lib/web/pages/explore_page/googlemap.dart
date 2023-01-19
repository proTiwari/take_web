import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:georange/georange.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:take_web/web/pages/list_property/search_place_provider.dart';
import 'package:take_web/web/pages/property_detail/property_detail.dart';
import '../../../web/Widgets/filter_card.dart';
import '../../../web/Widgets/paralleldropdownlist.dart';
import '../../../web/globar_variables/globals.dart';
import '../../../web/pages/explore_page/search.dart';
import 'dart:ui' as ui;
import '../../Widgets/bottom_nav_bar.dart';
import '../../models/auto_complete_result.dart';
import '../../services/map_services.dart';
import '../../globar_variables/globals.dart' as globals;

class Googlemap extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var citylist;
  String city;
  String calledin;
  Googlemap(this.citylist, this.city, this.calledin, {Key? key})
      : super(key: key);

  @override
  ConsumerState<Googlemap> createState() => _GooglemapState();
}

class Location {
  final String? name;
  final String? avatar;
  Location({this.name, this.avatar});
}

class _GooglemapState extends ConsumerState<Googlemap> {
  List<User>? selectedUserList = [];
  List<Location>? selectedlocationList = [];
  List serarchlocationlist = [];
  List? stateCity;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Circle> _circles = <Circle>{};
  final Set<Circle> _circles2 = <Circle>{};
  Set<Marker> _markers = <Marker>{};
  Set<Marker> nearmarker = <Marker>{};
  Set<Marker> searchedmarker = <Marker>{};
  bool cardList = false;
  bool cir = false;
  bool cis = false;
  bool searchproperty = false;
  bool cin = false;
  bool searchToggle = false;
  bool radiusSlider = true;
  int markerIdCounter = 1;
  var radiusValue = 3000.0;
  var tappedPoint;
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(25.435801, 81.846313),
    zoom: 14.4746,
  );

  Future<void> openFilterDialog() async {
    await FilterListDialog.display<User>(
      width: MediaQuery.of(context).size.width < 800
          ? 10
          : MediaQuery.of(context).size.width * 0.24,
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Filter',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
          print("selectedList: ${selectedUserList!}");
        });
        Navigator.pop(context);
      },
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected! ? Color(0xFFF27121) : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected ? Color(0xFFF27121) : Colors.grey[500]),
          ),
        );
      },
    );
  }

  Future<List> getResponse() async {
    List listtoreturn = [];
    final String res =
        await rootBundle.rootBundle.loadString("assets/country.json");
    var b = await json.decode(res);
    Map<String, List> mapcitystate = {};
    List State = [];
    for (int i = 0; i < 37; i++) {
      var v = await b[100]["state"][i]["name"];
      State.add(v);
      var k = b[100]["state"][i]["city"];
      mapcitystate["$v"] = k;
    }
    // print(mapcitystate);
    // print(State);
    listtoreturn.add(mapcitystate);
    listtoreturn.add(State);
    return listtoreturn;
  }

  bool CitySelector = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.citylist);
    if (widget.calledin == 'search') {
      snapshotnearproperty();
      for (var i in widget.citylist) {
        _setMarkerProperty(LatLng(i['lat'], i['lon']), i);
        _kGooglePlex = CameraPosition(
          target: LatLng(i['lat'], i['lon']),
          zoom: 14.4746,
        );
      }
      ;
      settingIcon();
    }
    if (widget.calledin == 'map') {
      getpropertydata();
    }
  }

  settingIcon() async {
    print('hjhjhjjjhh');
    try {
      final Uint8List markIcons =
          await getBytesFromAsset("assets/hhh.png", 100);
      marker = Marker(
        markerId: const MarkerId('marker_user'),
        position: globals.latlong,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markIcons),
      );
      _kGooglePlex = CameraPosition(
        target: globals.latlong,
        zoom: 14.4746,
      );
      setState(() {
        _markers.add(marker);
        nearmarker.add(marker);
      });
    } catch (e) {
      print("kllklklklkl${e.toString()}");
    }
  }

  bool isReviews = true;
  bool nearboolmarker = false;
  late Marker marker;

  void _setMarkerProperty(point, i) {
    print("this is setmarkerpropertylist ${i}    ${i.runtimeType}");
    var counter = markerIdCounter++;
    // _setCircle(point, counter);
    marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        infoWindow: InfoWindow(title: i['streetaddress']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Property(detail: i),
            ),
          );
        },
        icon: BitmapDescriptor.defaultMarker);

    CameraPosition _kGooglePlex = CameraPosition(
      target: point,
      zoom: 14.4746,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _setMarker(point) {
    var counter = markerIdCounter++;
    // _setCircle(point, counter);
    marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {
          print(point);
        },
        icon: BitmapDescriptor.defaultMarker);

    CameraPosition _kGooglePlex = CameraPosition(
      target: point,
      zoom: 14.4746,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _searchedMarker(point, i) {
    print(
        "this is _searchedMarker ${locationList}    ${locationList.runtimeType}");
    print("sdfsdlsdfml");
    try {
      var counter = markerIdCounter++;
      marker = Marker(
          markerId: MarkerId('marker_$counter'),
          position: point,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Property(detail: i),
              ),
            );
          },
          icon: BitmapDescriptor.defaultMarker);

      searchedmarker.add(marker);
      searchedmarker.addAll(nearmarker);
      // print("nearboolmarker${nearboolmarker}");
    } catch (e) {
      print(e.toString());
    }
  }

  void _setNearMarker(point, i) {
    print("sdfsdlsdfml");
    try {
      var counter = markerIdCounter++;
      marker = Marker(
          markerId: MarkerId('marker_$counter'),
          position: point,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Property(detail: i),
              ),
            );
          },
          icon: BitmapDescriptor.defaultMarker);
      nearmarker.add(marker);
      print("nearboolmarker${nearboolmarker}");
    } catch (e) {
      print(e.toString());
    }
  }

  final GoogleMapController? controller = null;

  void _setCircle(LatLng point, dynamic n, {double? radius}) async {
    if (cir == false) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: point, zoom: 12)));
      setState(() {
        _circles.add(Circle(
            circleId: CircleId("$n"),
            center: point,
            fillColor: Colors.blue.withOpacity(0.1),
            radius: radius ?? radiusValue,
            strokeColor: Colors.blue,
            strokeWidth: 1));

        // searchToggle = false;
        // radiusSlider = true;
      });
    }
  }

  void _sCircle(LatLng point, dynamic n, {double? radius}) async {
    if (cir == true) {
      controller?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: point, zoom: 12)));
      setState(() {
        _circles2.add(Circle(
            circleId: CircleId("$n"),
            center: point,
            fillColor: Colors.blue.withOpacity(0.1),
            radius: radius ?? radiusValue,
            strokeColor: Colors.blue,
            strokeWidth: 1));

        // searchToggle = false;
        // radiusSlider = true;
      });
    }
  }

  // void _onAddMarkerButtonPressed(LatLng latlang) {
  //   loadAddress(latlang);
  //   _latLng = latlang;
  //   setState(() {
  //     _markers.add(Marker(
  //       // This marker id can be anything that uniquely identifies each marker.
  //       markerId: MarkerId(_lastMapPosition.toString()),
  //       position: latlang,
  //       infoWindow: InfoWindow(
  //         title: address,
  //         //  snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  var finalList = [];
  var citylist = [];
  var valuedistance;
  List locationList = [];

  snapshotnearproperty() async {
    print('sdfwewef');
    try {
      var data = await FirebaseFirestore.instance.collection("City").get();
      print("thyyhjy${data.docs}");
      var listdata = data.docs;
      for (var i in listdata) {
        valuedistance = calculateDistance(globals.latlong.latitude,
            globals.latlong.longitude, i['lat'], i['lon']);
        if (valuedistance < 30) {
          locationList.add(i);
          _setNearMarker(LatLng(i['lat'], i['lon']), i);
        }
      }
      // data.docs.map((e) {

      //   print('jhbjbj');
      //   valuedistance = calculateDistance(globals.latlong.latitude,
      //       globals.latlong.longitude, e['lat'], e['lon']);
      //   print("sdfjshdfs${valuedistance}");
      //   if (valuedistance < 10) {
      //     locationList.add(e);
      //     _setNearMarker(LatLng(e['lat'], e['lon']));
      //   }
      // });
    } catch (e) {
      print('jhb');
      print(e.toString());
    }
  }

  searchedproperty(placelat, placelon) async {
    print('sdfwewef');
    try {
      var data = await FirebaseFirestore.instance.collection("City").get();
      print("thyyhjy${data.docs}");
      var listdata = data.docs;
      locationList.clear();
      for (var i in listdata) {
        valuedistance =
            calculateDistance(placelat, placelon, i['lat'], i['lon']);
        if (valuedistance < 60) {
          setState(() {
            locationList.add(i);
          });

          _searchedMarker(LatLng(i['lat'], i['lon']), i);
        }
      }
      setState(() {
        searchproperty = true;
      });
      // data.docs.map((e) {

      //   print('jhbjbj');
      //   valuedistance = calculateDistance(globals.latlong.latitude,
      //       globals.latlong.longitude, e['lat'], e['lon']);
      //   print("sdfjshdfs${valuedistance}");
      //   if (valuedistance < 10) {
      //     locationList.add(e);
      //     _setNearMarker(LatLng(e['lat'], e['lon']));
      //   }
      // });
    } catch (e) {
      print('jhb');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var changeId = 0;
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);
    List lst = [];
    _circles.clear();
    // print(marker);
    // for (var i in widget.liss) {
    //   var lat = double.parse(i["lat"]);
    //   var lon = double.parse(i["long"]);
    //   var latlong = LatLng(lat, lon);
    //   _setMarker(latlong);
    // }

    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  markers: searchproperty
                      ? searchedmarker
                      : nearboolmarker
                          ? nearmarker
                          : _markers,
                  // circles: cir ? _circles2 : _circles,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (point) {
                    print(point);
                    tappedPoint = point;
                    var n = Random();
                    // radiusSlider = cir;
                    _sCircle(point, n.nextInt(1000));
                  },
                ),
              ),

              true
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                      child: Column(children: [
                        Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                border: InputBorder.none,
                                hintText: 'Search',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchToggle = false;

                                        searchController.text = '';
                                        _markers = {};
                                        if (searchFlag.searchToggle) {
                                          searchFlag.toggleSearch();
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.close))),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce?.cancel();
                              }
                              _debounce = Timer(
                                  const Duration(milliseconds: 400), () async {
                                if (value.length > 2) {
                                  if (!searchFlag.searchToggle) {
                                    searchFlag.toggleSearch();
                                    _markers = {};
                                  }

                                  List<AutoCompleteResult> searchResults =
                                      await MapServices().searchPlaces(value);

                                  allSearchResults.setResults(searchResults);
                                } else {
                                  List<AutoCompleteResult> emptyList = [];
                                  allSearchResults.setResults(emptyList);
                                }
                              });
                            },
                          ),
                        )
                      ]),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 27, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  nearboolmarker = !nearboolmarker;
                                  if (nearboolmarker == true) {
                                    goToTappedPlace(globals.latlong.latitude,
                                        globals.latlong.longitude);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
                                height: 30,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: const Offset(1, 1),
                                        blurRadius: 1,
                                        spreadRadius: 0)
                                  ],
                                  color: nearboolmarker
                                      ? const Color(0xFFF27121)
                                      : Colors.white,
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: InkWell(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            style: TextStyle(
                                                color: nearboolmarker
                                                    ? Colors.white
                                                    : Colors.black45,
                                                fontSize: 16),
                                            text: "Near me ",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Align(
                          //   alignment: AlignmentDirectional.center,
                          //   child: InkWell(
                          //     onTap: () {
                          //       setState(() {
                          //         CitySelector = !CitySelector;
                          //       });
                          //     },
                          //     child: FilterCard(widget.city),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          // Align(
                          //   alignment: AlignmentDirectional.center,
                          //   child: InkWell(
                          //     onTap: openFilterDialog,
                          //     child: FilterCard("Filter"),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              // CitySelector
              //     ? AnimatedSwitcher(
              //         duration: const Duration(milliseconds: 0),
              //         child: ParallelDropDownList(
              //             stateCity, widget.city, "map", []),
              //       )
              //     : Container(),
              searchFlag.searchToggle
                  ? allSearchResults.allReturnedResults.isNotEmpty
                      ? Positioned(
                          top: 100.0,
                          left: 15.0,
                          child: Container(
                            height: 300.0,
                            width: screenWidth - 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: ListView(
                              children: [
                                ...allSearchResults.allReturnedResults
                                    .map((e) => buildListItem(e, searchFlag))
                              ],
                            ),
                          ))
                      : Positioned(
                          top: 100.0,
                          left: 15.0,
                          child: Container(
                            height: 200.0,
                            width: screenWidth - 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Center(
                              child: Column(children: [
                                const Text('No results to show',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  width: 125.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      searchFlag.toggleSearch();
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Close this',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'WorkSans',
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.9, 0, 0),
                child: InkWell(
                  onTap: (() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomBottomNavigation(globals.city, "", ""),
                      ),
                    );
                  }),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Colors.blueAccent,
                      elevation: 10,
                      child: Container(
                        // color: Colors.blueAccent,
                        padding: const EdgeInsets.all(0.0),
                        height: 60.0, //MediaQuery.of(context).size.width * .08,
                        width: MediaQuery.of(context).size.width * 0.9, //MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Row(
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,color: Color.fromARGB(255, 255, 255, 255)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
// bottom list
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 430, 0, 0),
              //   child: SizedBox(
              //     child: SizedBox(
              //       height: 230.0,
              //       child: StreamBuilder(builder: (BuildContext context,
              //           AsyncSnapshot<dynamic> snapshot) {
              //         return ListView(
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           children: [
              //             if (isReviews && widget.citylist != null)
              //               ...widget.citylist!.map((e) {
              //                 print("is this your are taking about :$e");
              //                 // return _buildReviewItem(e);
              //                 return cardwid(e);
              //               }),
              //           ],
              //         );
              //       }),
              //     ),
              //   ),
              // ),
              // : Container(),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(
              //         0, MediaQuery.of(context).size.height * 0.67, 0, 0),
              //     child: SizedBox(
              //       height: 230,
              //       child: StreamBuilder(
              //         stream: FirebaseFirestore.instance
              //             .collection("City")
              //             .snapshots(),
              //         builder:
              //             (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //           // snapshot.connectionState == ConnectionState.waiting
              //           if (snapshot.connectionState ==
              //               ConnectionState.waiting) {}

              //           var documents = snapshot.data!.docs;

              //           //todo Documents list added to filterTitle
              //           finalList = [];
              //           citylist = [];

              //           citylist = documents.where((element) {
              //             return element
              //                 .get("city")
              //                 .toString()
              //                 .toLowerCase()
              //                 .contains(widget.city.toString().toLowerCase());
              //           }).toList();

              //           if (selectedUserList!.isNotEmpty) {
              //             var list;

              //             for (var i in selectedUserList!) {
              //               list = documents.where((element) {
              //                 return element
              //                     .get("wantto")
              //                     .toString()
              //                     .toLowerCase()
              //                     .contains(i.avatar.toString().toLowerCase());
              //               }).toList();

              //               finalList = List.from(finalList)..addAll(list);
              //               list = documents.where((element) {
              //                 return element
              //                     .get("servicetype")
              //                     .toString()
              //                     .toLowerCase()
              //                     .contains(i.avatar.toString().toLowerCase());
              //               }).toList();
              //               finalList = List.from(finalList)..addAll(list);
              //             }
              //             print("documents: ${documents}");
              //           }
              //           print("sdijj${snapshot.hasData}");
              //           try {
              //             snapshot.data!.docs.first["pincode"];
              //           } catch (e) {
              //             return const Padding(
              //               padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
              //               child: Center(
              //                   child: Text(
              //                       "There is no property upload from this city!")),
              //             );
              //           }

              //           // ignore: unnecessary_new
              //           if (nearboolmarker) {
              //             return ListView(
              //               scrollDirection: Axis.horizontal,
              //               shrinkWrap: true,
              //               children: getExpenseItemsdocs(locationList),
              //             );
              //           } else {
              //             if (selectedUserList!.isNotEmpty) {
              //               return ListView(
              //                 scrollDirection: Axis.horizontal,
              //                 shrinkWrap: true,
              //                 children: getExpenseItemsdocs(finalList),
              //               );
              //             } else {
              //               print(snapshot);
              //               return ListView(
              //                 scrollDirection: Axis.horizontal,
              //                 shrinkWrap: true,
              //                 children: getExpenseItemsdocs(citylist),
              //               );
              //             }
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )
        ],
      )),
    );
  }

  getlocationfilterdata() async {
    try {
      // var position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      // double lat = 0.0144927536231884;
      // double lon = 0.0181818181818182;
      // double distance = 1000 * 0.000621371;
      // double lowerLat = position.latitude - (lat * distance);
      // double lowerLon = position.longitude - (lon * distance);
      // double greaterLat = position.latitude + (lat * distance);
      // double greaterLon = position.longitude + (lon * distance);
      // GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
      // GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
      // var querySnapshot = await FirebaseFirestore.instance.collection("Users")
      //     .where("livelocation", isGreaterThan: lesserGeopoint)
      //     .where("livelocation", isLessThan: greaterGeopoint)
      //     .limit(100)
      //     .get();

      print("1");
      var locationfilter = [];
      GeoRange georange = GeoRange();
      print("2");
      Range range = georange.geohashRange(
          globals.latlong.latitude, globals.latlong.longitude,
          distance: 10);

      print("3");
      print(range.lower);
      print(range.upper);
      print("4");
      // QuerySnapshot snapshot = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isLessThanOrEqualTo: range.lower)
      //     .get();
      // QuerySnapshot snapshot1 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isLessThanOrEqualTo: range.upper)
      //     .get();
      // QuerySnapshot snapshot2 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isGreaterThanOrEqualTo: range.lower)
      //     .get();
      // QuerySnapshot snapshot3 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isGreaterThanOrEqualTo: range.upper)
      //     .get();
      // QuerySnapshot snapshot4 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isLessThan: range.upper)
      //     .get();
      // QuerySnapshot snapshot5 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isGreaterThan: range.upper)
      //     .get();
      // QuerySnapshot snapshot6 = await FirebaseFirestore.instance
      //     .collection("City")
      //     .where("geohash", isLessThan: range.lower)
      //     .get();
      QuerySnapshot snapshot7 = await FirebaseFirestore.instance
          .collection("City")
          .where("geohash", isGreaterThan: range.lower)
          .where("geohash", isLessThan: range.upper)
          .get();

      // print("5${snapshot.docs}");
      // print("5${snapshot1.docs}");
      // print("5${snapshot2.docs}");
      // print("5${snapshot3.docs}");
      // print("5${snapshot4.docs}");
      // print("5${snapshot5.docs}");
      // print("5${snapshot6.docs}");
      print("5${snapshot7.docs}");

      var distance = calculateDistance(
          globals.latlong.latitude,
          globals.latlong.longitude,
          snapshot7.docs[0]['lat'],
          snapshot7.docs[0]['lon']);
      print("distance: ${distance}");
      // var data = snapshot.docs;
      // print("6${data}");
    } catch (e) {
      print("tdsfjl");
      print(e.toString());
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("type of doc from snapshot");
    print(snapshot.data!.docs.first.runtimeType);
    return snapshot.data!.docs.map((doc) => cardwid(doc)).toList();
  }

  getExpenseItemsdocs(docs) {
    try {
      print("type of doc from Docs");
      return docs.map<Widget>((doc) => cardwid(doc)).toList();
    } catch (e) {
      print("thisis the error--${e}");
    }
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    // _setMarker(LatLng(lat, lng));
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    await placemarkFromCoordinates(position!.latitude, position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        var address = place.locality;
        // '${place.street}, ${place.subLocality},${place.locality}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          print(place);
          await searchedproperty(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);

          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          // _getAddressFromLatLng(LatLng(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']));
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cardwid(e) {
    controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(e['lat'], e['lon']), zoom: 12)));
    // controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(review, review2),
    //     zoom: 14.0,
    //     bearing: 45.0,
    //     tilt: 45.0)));
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Property(
              detail: e,
            ),
          ),
        );
      }),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    // height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          // 0.2,
                          // 0.5,
                          0.7,
                          // 0.6,
                        ],
                        colors: [
                          // Colors.transparent,
                          // Colors.white10,
                          // Colors.white54,
                          Color.fromARGB(190, 255, 255, 255),
                        ],
                      ),

                      // boxShadow: const [
                      //   BoxShadow(
                      //       color: Colors.grey,
                      //       blurRadius: 15,
                      //       spreadRadius: 10,
                      //       offset: Offset(4 * 10, 5 * 10)),
                      // ],
                    ),
                    child: Stack(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              // width: MediaQuery.of(context).size.width*0.37,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(0)),
                                child: Image.network(
                                  "${e["propertyimage"][0]}",
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.37,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(108.0),
                                  child: Image.network(
                                    "${e['profileImage']}",
                                    height: 50.0,
                                    width: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text("${e['ownername']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: e['wantto'] == "Sell property"
                                        ? const Text(
                                            "   ( Seller Property )   ",
                                            style: TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 153, 137, 137),
                                            ),
                                          )
                                        : const Text(
                                            "   ( Rental Property )   ",
                                            style: TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 153, 137, 137),
                                            ),
                                          ),
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 7, top: 0.5),
                                      child: Text("",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(width: 5),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: e['date']
                                                      .toDate()
                                                      .toString()
                                                      .substring(0, 11),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Opacity(
                    opacity: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // gradient: const LinearGradient(
                        //     begin: Alignment.topRight,
                        //     end: Alignment.bottomLeft,
                        //     colors: [
                        //       Color.fromARGB(255, 255, 0, 85),
                        //       Colors.green,
                        //     ]),
                      ),
                    ),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.all(20),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
              //   const Text(
              //     "All transactions :",
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black),
              //   ),
              //   const SizedBox(
              //     height: 25,
              //   ),
              // SizedBox(
              //   height: 500,
              //   child: Shimmer.fromColors(
              //     baseColor: Colors.grey.shade300,
              //     highlightColor: Colors.white,
              //     child: ListView.builder(
              //       itemBuilder: (_, __) => Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Container(
              //               width: 70.0,
              //               height: 70.0,
              //               color: Colors.white,
              //             ),
              //             const Padding(
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 10.0),
              //             ),
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment:
              //                     CrossAxisAlignment.start,
              //                 children: <Widget>[
              //                   Padding(
              //                       padding: EdgeInsets.only(top: 5)),
              //                   Container(
              //                     width: double.infinity,
              //                     height: 10.0,
              //                     color: Colors.white,
              //                   ),
              //                   const Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: 5.0),
              //                   ),
              //                   Container(
              //                     width: double.infinity,
              //                     height: 10.0,
              //                     color: Colors.white,
              //                   ),
              //                   const Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: 5.0),
              //                   ),
              //                   Container(
              //                     width: 40.0,
              //                     height: 8.0,
              //                     color: Colors.white,
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //       itemCount: 10,
              //     ),
              //   ),
              // )
              // ],
              // ),
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(review) {
    return SizedBox(
      child: Row(
        children: [
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple,
                      Colors.orangeAccent,
                    ]),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15,
                      spreadRadius: 10,
                      offset: Offset(4 * 10, 5 * 10)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: SizedBox(
                width: 300,
                height: 800,
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 2,
                  child: InkWell(
                    onTap: () => {
                      goToTappedPlace(double.parse(review['lat'].toString()),
                          double.parse(review['lon'].toString()))
                    },
                    child: Row(
                      children: [
                        Image(
                          width: 50,
                          height: 70,
                          image: NetworkImage(review["propertyimage"][0]),
                        ),
                        Text(review['ownername'] +
                            '\n' +
                            review['email'] +
                            '\n' +
                            review['mobilenumber'] +
                            '\n' +
                            review['streetaddress']),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
          Divider(color: Colors.grey.shade600, height: 1.0)
        ],
      ),
    );
  }

  Future<void> goToTappedPlace(review, review2) async {
    final GoogleMapController controller = await _controller.future;
    _markers = {};

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(review, review2),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  void getpropertydata() async {
    List citylist = [];
    print('djsnfsfiewoewiiiiiiiiiiiiiiiiiiiiii');
    print(widget.city);
    await FirebaseFirestore.instance
        .collection("City")
        .where("city", isEqualTo: widget.city)
        .get()
        .then((value) {
      citylist.addAll(value.docs);
    });

    print(citylist);

    snapshotnearproperty();
    for (var i in citylist) {
      _setMarkerProperty(LatLng(i['lat'], i['lon']), i);
      _kGooglePlex = CameraPosition(
        target: LatLng(i['lat'], i['lon']),
        zoom: 14.4746,
      );
    }

    settingIcon();
  }
}
