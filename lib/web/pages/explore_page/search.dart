import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as river;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:take_web/web/pages/explore_page/searchcity.dart';
import '../../Widgets/cards.dart';
import '../../Widgets/google_map_circle.dart';
import '../../globar_variables/globals.dart' as globals;
import '../../Widgets/filter_card.dart';
import 'package:filter_list/filter_list.dart';
import '../../Widgets/bottom_nav_bar.dart';
import '../../models/auto_complete_result.dart';
import '../../services/map_services.dart';
import '../app_state.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../list_property/search_place_provider.dart';
import '../property_detail/property_detail.dart';
import 'googlemap.dart';

class Search extends river.ConsumerStatefulWidget {
  String city;
  Search(this.city, secondcall, {Key? key}) : super(key: key);

  @override
  river.ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends river.ConsumerState<Search> {
  List<User>? selectedUserList = [];
  List<City>? selectedCityList = [];
  List<Location>? selectedlocationList = [];
  bool searchToggle = false;
  Timer? _debounce;
  var stream;
  var globalslat;
  var globalslong;
  List searchedList = [];
  List initList = [];
  List initListWithoutLocation = [];
  List? stateCity;
  var templat;
  var templong;
  bool nearboolmarker = false;
  bool CitySelector = false;
  final Map<int, Color?> _yellow700Map = {
    50: const Color(0xFFFFD7C2),
    100: Color(0xFFF27121),
  };
  TextEditingController searchController = TextEditingController();

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
            color: isSelected!
                ? FlutterFlowTheme.of(context).alternate
                : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected
                    ? FlutterFlowTheme.of(context).alternate
                    : Colors.grey[500]),
          ),
        );
      },
    );
  }

  Future<void> openCityDialog() async {
    await FilterListDialog.display<City>(
      width: MediaQuery.of(context).size.width < 800
          ? 14
          : MediaQuery.of(context).size.width * 0.28,
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Serviceable Cities',
      enableOnlySingleSelection: true,
      height: 500,
      listData: cityList,
      selectedListData: selectedCityList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          if (list!.isEmpty) {
            selectedCityList = List.from(list!);
            FFAppState().cityname = '';
            print("selectedCityList: ${selectedCityList!}");
          } else {
            selectedCityList = List.from(list!);
            FFAppState().cityname = list.first.name!;
            print("selectedCityList: ${selectedCityList!}");
          }
        });
        Navigator.pop(context);
      },
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(
            color: isSelected!
                ? FlutterFlowTheme.of(context).alternate
                : Colors.grey[300]!,
          )),
          child: Text(
            item.name,
            style: TextStyle(
                color: isSelected
                    ? FlutterFlowTheme.of(context).alternate
                    : Colors.grey[500]),
          ),
        );
      },
    );
  }

  Future<List> getResponse() async {
    List listtoreturn = [];
    final String res = await rootBundle.loadString("assets/country.json");
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
    State.sort();
    listtoreturn.add(State);
    return listtoreturn;
  }

  bool propertyexist = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdynamiclink();
    getavailablecityname();
    stream = FirebaseFirestore.instance.collection("City").snapshots();
    setState(() {
      if (FFAppState().cityname != '') {
        nearboolmarker = false;
      } else {
        nearboolmarker = true;
      }
    });
    if (globals.secondcall == true) {
      setState(() {
        nearboolmarker = false;
      });
    }
    // globalslat = globals.latlong == null ? null : globals.latlong.latitude;
    // globalslong = globals.latlong == null ? null : globals.latlong.longitude;

    print("init search screen");
    globals.imageList.clear();
    print(widget.city);
    getRes();
  }

  @override
  void dispose() {
    initList.clear();
    super.dispose();
  }

  // function for getting state city list in search page
  getRes() async {
    stateCity = await getResponse();
    /*print(stateCity);*/
    globals.list = stateCity;
  }

  // function for calculating distance between coordinate
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // for printing long string
  void prints(var s1) {
    String s = s1.toString();
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => print("${match.group(0)}\n"));
  }

  var finalList = [];
  var citylist = [];

  void Changeboolfun() {
    print("sjdfojsodfjs99999999999999");
    setState(() {
      if (FFAppState().cityname != '') {
        nearboolmarker = false;
      }
      ;
      CitySelector = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "uuuuuuuuuuuuuuuuuuu:  ${valuenotic().valuenoticifierlatlong.value.latitude}");
    setState(() {
      propertyexist;
    });
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);
    var locationprovider = ref.watch(locationProvider);
    print("globals.propertys ${globals.property}");
    var width = MediaQuery.of(context).size.width;
    globals.width = width * 0.87;
    var height = MediaQuery.of(context).size.height;
    globals.height = height;

    // print(globals.property[0]);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          searchToggle = false;
          CitySelector = false;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 5,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarIconBrightness:
          //       Brightness.dark, //<-- For Android SEE HERE (dark icons)
          //   statusBarBrightness:
          //       Brightness.dark, //<-- For iOS SEE HERE (dark icons)
          // ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: globals.dynamiclink != ''
            ? Center(
                child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.blue),
              ))
            : Center(
                child: Stack(children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                        child: Column(children: [
                          Container(
                            height: 47.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    // offset: const Offset),
                                    blurRadius: 0,
                                    spreadRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                              // color: Colors.white,
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
                                      // _markers = {};
                                      if (searchFlag.searchToggle) {
                                        searchFlag.toggleSearch();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce?.cancel();
                                }
                                print(value);
                                _debounce =
                                    Timer(const Duration(milliseconds: 400),
                                        () async {
                                  if (value.length > 2) {
                                    if (!searchFlag.searchToggle) {
                                      searchFlag.toggleSearch();
                                      // _markers = {};
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  CitySelector = false;
                                                  globals.secondcall = false;
                                                  nearboolmarker =
                                                      !nearboolmarker;
                                                  if (nearboolmarker) {
                                                    FFAppState().cityname = '';
                                                    print("true");
                                                    templat = FFAppState().lat;
                                                    templong = FFAppState().lon;
                                                    initList.clear();
                                                    globalslat =
                                                        FFAppState().lat;
                                                    print(globalslat);
                                                    globalslong =
                                                        FFAppState().lon;
                                                    print(globalslong);
                                                  } else {
                                                    print("false");
                                                    templat = globalslat;
                                                    templong = globalslong;
                                                    initList.clear();
                                                    globalslat = templat;
                                                    globalslong = templong;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        9, 0, 9, 0),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        // offset: const Offset),
                                                        blurRadius: 0,
                                                        spreadRadius: 1)
                                                  ],
                                                  color: nearboolmarker
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .alternate
                                                      : Colors.white,
                                                  // color: Theme.of(context).primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: InkWell(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            style: TextStyle(
                                                                color: nearboolmarker
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black45,
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
                                          Align(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  CitySelector = !CitySelector;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        9, 0, 9, 0),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        // offset: const Offset),
                                                        blurRadius: 0,
                                                        spreadRadius: 1)
                                                  ],
                                                  color:
                                                      FFAppState().cityname !=
                                                              ""
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate
                                                          : Colors.white,
                                                  // color: Theme.of(context).primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: InkWell(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            style: TextStyle(
                                                                color: FFAppState()
                                                                            .cityname !=
                                                                        ""
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black45,
                                                                fontSize: 16),
                                                            text: FFAppState()
                                                                        .cityname ==
                                                                    ""
                                                                ? "Select City"
                                                                : FFAppState()
                                                                    .cityname,
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
                                          Align(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: InkWell(
                                              onTap: () {
                                                openFilterDialog();
                                                setState(() {
                                                  CitySelector = false;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        9, 0, 9, 0),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        // offset: const Offset),
                                                        blurRadius: 0,
                                                        spreadRadius: 1)
                                                  ],
                                                  color: selectedUserList!
                                                          .isNotEmpty
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .alternate
                                                      : Colors.white,
                                                  // color: Theme.of(context).primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Center(
                                                  child: InkWell(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            style: TextStyle(
                                                                color: selectedUserList!
                                                                        .isNotEmpty
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black45,
                                                                fontSize: 16),
                                                            text: selectedUserList!
                                                                    .isNotEmpty
                                                                ? "Filter ${selectedUserList!.length}"
                                                                : "Filter",
                                                          ),
                                                          WidgetSpan(
                                                            child: selectedUserList!
                                                                    .isNotEmpty
                                                                ? const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    size: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
                        ),
                      ),
                      CitySelector ? SearchCity(Changeboolfun) : Container(),
                      !CitySelector
                          ? SingleChildScrollView(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.74,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                                  child: StreamBuilder(
                                    stream: stream,
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      // snapshot.connectionState == ConnectionState.waiting
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Center(
                                            child: ListView.builder(
                                              itemBuilder: (_, __) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8.0, 8, 8, 1),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Container(
                                                          width: 350.0,
                                                          height: 300.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                      ),
                                                      // Expanded(
                                                      //   child: Column(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment.start,
                                                      //     children: <Widget>[
                                                      //       const Padding(
                                                      //           padding: EdgeInsets.only(
                                                      //               top: 5)),
                                                      //       Container(
                                                      //         width: double.infinity,
                                                      //         height: 10.0,
                                                      //         color: Colors.white,
                                                      //       ),
                                                      //       const Padding(
                                                      //         padding: EdgeInsets.symmetric(
                                                      //             vertical: 5.0),
                                                      //       ),
                                                      //       Container(
                                                      //         width: double.infinity,
                                                      //         height: 10.0,
                                                      //         color: Colors.white,
                                                      //       ),
                                                      //       const Padding(
                                                      //         padding: EdgeInsets.symmetric(
                                                      //             vertical: 5.0),
                                                      //       ),
                                                      //       Container(
                                                      //         width: 40.0,
                                                      //         height: 8.0,
                                                      //         color: Colors.white,
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // itemCount: 10,
                                            ),
                                          ),
                                        );
                                      }
                                      print("sdfskdfklsdf hello");

                                      var documents = snapshot.data!.docs;
                                      initListWithoutLocation =
                                          documents.where((element) {
                                        return element
                                            .get("city")
                                            .toString()
                                            .contains("Prayagraj");
                                      }).toList();
                                      print(
                                          "kkkkkkkkkkkkkkkkkkkk:  ${FFAppState().cityname}");

                                      if (FFAppState().cityname != '') {
                                        print("ppppppppppppppppppppppp");
                                        try {
                                          initList = documents.where((element) {
                                            return element
                                                .get("city")
                                                .toString()
                                                .contains(
                                                    FFAppState().cityname);
                                          }).toList();
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      } else {
                                        try {
                                          print("isejifoee");
                                          initList.clear();
                                          // this for loop filters the city collection on the bases of lat long
                                          for (var e in documents) {
                                            print("isejifeweoee");
                                            var lat = e.get("lat");
                                            var lon = e.get("lon");
                                            print(
                                                "sdjfosjfojwoiewew$lat $lon $initList");

                                            var data = calculateDistance(
                                                FFAppState().lat,
                                                FFAppState().lon,
                                                lat,
                                                lon);

                                            print("isejiw22foee");
                                            if (data < 30) {
                                              print("isejifo111ee");
                                              initList.add(e);
                                            }
                                          }
                                        } catch (e) {
                                          print("dsdsdsddd");
                                          // can use this space for toggling filter list on the basis of location permission
                                          print(e.toString());
                                        }
                                      }

                                      //todo Documents list added to filterTitle
                                      finalList = [];

                                      //get widget.city

                                      //filter method starts from here
                                      if (selectedUserList!.isNotEmpty) {
                                        var list = [];
                                        finalList.clear();
                                        list.clear();
                                        for (var i in selectedUserList!) {
                                          for (var j in initList) {
                                            if (j['wantto']
                                                    .toString()
                                                    .toLowerCase() ==
                                                i.avatar
                                                    .toString()
                                                    .toLowerCase()) {
                                              list.add(j);
                                            }
                                          }
                                          finalList = List.from(finalList)
                                            ..addAll(list);
                                          // list = documents.where((element) {
                                          //   return element
                                          //       .get("servicetype")
                                          //       .toString()
                                          //       .toLowerCase()
                                          //       .contains(
                                          //         i.avatar.toString().toLowerCase(),
                                          //       );
                                          // }).toList();
                                          list.clear();
                                          for (var k in initList) {
                                            if (k['servicetype']
                                                    .toString()
                                                    .toLowerCase() ==
                                                i.avatar
                                                    .toString()
                                                    .toLowerCase()) {
                                              list.add(k);
                                            }
                                          }
                                          finalList = List.from(finalList)
                                            ..addAll(list);
                                        }
                                        print("documents: ${documents}");
                                      }

                                      print("sdijj${snapshot.hasData}");
                                      try {
                                        snapshot.data!.docs.first["pincode"];
                                      } catch (e) {
                                        return const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 40, 0, 0),
                                          child: Center(
                                            child: Text(
                                                "There is no property available in this city!"),
                                          ),
                                        );
                                      }
                                      print(
                                          "we are here ${locationprovider.latlonglocation.latitude} ${locationprovider.latlonglocation.longitude}");
                                      // ignore: unnecessary_new
                                      if (FFAppState().lat != 0.0 &&
                                          FFAppState().lon != 0.0) {
                                        // case when location permission is enabled
                                        if (selectedUserList!.isNotEmpty) {
                                          // case when filter is enabled
                                          return ListView(
                                            children:
                                                getExpenseItemsdocs(finalList),
                                          );
                                        } else {
                                          // case when filter is disabled
                                          finalList.clear();
                                          citylist.clear();
                                          print("initList${initList}");
                                          if (initList.isEmpty) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 180, 0, 0),
                                              child: Container(
                                                child: Column(children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 18),
                                                    child: Text(
                                                        "There is no property available near you"),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      openCityDialog();
                                                      setState(() {
                                                        CitySelector = false;
                                                      });
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
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Center(
                                                          child: Column(
                                                              children: const [
                                                                Text(
                                                                  "View Serviceable Cities",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          } else {
                                            return ListView(
                                              children:
                                                  getExpenseItemsdocs(initList),
                                            );
                                          }
                                        }
                                      } else {
                                        // case for handling list when filter is enabled
                                        if (selectedUserList!.isNotEmpty) {
                                          return ListView(
                                            children:
                                                getExpenseItemsdocs(finalList),
                                          );
                                        } else {
                                          print(
                                              "hjjhhjjjjjkkk${snapshot} $initListWithoutLocation");
                                          // case for handling list when location permission is not given
                                          return ListView(
                                            children: getExpenseItemsdocs(
                                                initListWithoutLocation),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  searchFlag.searchToggle
                      ? allSearchResults.allReturnedResults.isNotEmpty
                          ? Stack(children: [
                              Positioned(
                                  top: 68.0,
                                  left: 15.0,
                                  right: 15,
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
                                            .map((e) =>
                                                buildListItem(e, searchFlag))
                                      ],
                                    ),
                                  )),
                            ])
                          : Stack(children: [
                              Positioned(
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
                              ),
                            ])
                      : Container(),
                ]),
              ),
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 13 : width * 0.24),
          child: GestureDetector(
              onTap: (() {
                print("clicked google map button");
                if (initList.isEmpty) {
                  initList = initListWithoutLocation;
                }
                if (initList.isNotEmpty || initListWithoutLocation.isNotEmpty) {
                  selectedUserList!.isNotEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Googlemap(finalList, widget.city, "search"),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Googlemap(initList, widget.city, "search"),
                          ),
                        );
                }
              }),
              child: const GoogleMapCircle()),
        ),
        // drawer: Drawer(
        //   child: Container(
        //     height: 55,
        //     child: ListView(
        //       padding: const EdgeInsets.all(0),
        //       children: [
        //         const DrawerHeader(
        //           decoration: BoxDecoration(
        //             color: Colors.green,
        //           ), //BoxDecoration
        //           child: UserAccountsDrawerHeader(
        //             decoration: BoxDecoration(color: Colors.green),
        //             accountName: Text(
        //               "Abhishek Mishra",
        //               style: TextStyle(fontSize: 18),
        //             ),
        //             accountEmail: Text("abhishekm977@gmail.com"),
        //             currentAccountPictureSize: Size.square(50),
        //             currentAccountPicture: CircleAvatar(
        //               backgroundColor: Color.fromARGB(255, 165, 255, 137),
        //               child: Text(
        //                 "A",
        //                 style: TextStyle(fontSize: 30.0, color: Colors.blue),
        //               ), //Text
        //             ), //circleAvatar
        //           ), //UserAccountDrawerHeader
        //         ), //DrawerHeader
        //         ListTile(
        //           leading: const Icon(Icons.person),
        //           title: const Text(' My Profile '),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         ListTile(
        //           leading: const Icon(Icons.book),
        //           title: const Text(' My Course '),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         ListTile(
        //           leading: const Icon(Icons.workspace_premium),
        //           title: const Text(' Go Premium '),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         ListTile(
        //           leading: const Icon(Icons.video_label),
        //           title: const Text(' Saved Videos '),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         ListTile(
        //           leading: const Icon(Icons.edit),
        //           title: const Text(' Edit Profile '),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         ListTile(
        //           leading: const Icon(Icons.logout),
        //           title: const Text('LogOut'),
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ), //Drawer
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("type of doc from snapshot");
    print(snapshot.data!.docs.first.runtimeType);
    return snapshot.data!.docs.map((doc) => CardsWidget(doc)).toList();
  }

  getExpenseItemsdocs(docs) {
    try {
      print("type of doc from Docs");
      return docs.map<Widget>((doc) => CardsWidget(doc)).toList();
    } catch (e) {
      print("thisis the error--${e}");
    }
  }

  searchedproperty(placelat, placelon) async {
    print('sdfwewef');
    try {
      var data = await FirebaseFirestore.instance.collection("City").get();
      print("thyyhjy${data.docs}");
      var listdata = data.docs;
      locationList.clear();
      // for (var i in listdata) {
      //   valuedistance = calculateDistance(placelat, placelon, i['lat'], i['lon']);
      //   if (valuedistance < 60) {
      //     setState(() {
      //       locationList.add(i);
      //     });

      //     _searchedMarker(LatLng(i['lat'], i['lon']), i);
      //   }
      // }
      setState(() {
        // searchproperty = true;
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

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          print(place);
          setState(() {
            FFAppState().lat = place['geometry']['location']['lat'];
            FFAppState().lon = place['geometry']['location']['lng'];
            nearboolmarker = false;
            globals.secondcall = false;
            initList.clear();
          });
          // await searchedproperty(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']);

          // gotoSearchedPlace(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']);
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

  void getavailablecityname() async {
    try {
      cityList.clear();
      var citylist = FirebaseFirestore.instance
          .collection("State")
          .doc('City')
          .snapshots();
      await citylist.forEach((element) {
        for (var i in element.data()!['city']) {
          setState(() {
            cityList.add(City(name: i, avatar: ""));
          });
        }
        ;
      });
    } catch (e) {
      print("hhhhhhhhhhhhh: ${e.toString()}");
    }
  }

  getdynamiclink() async {
    if (globals.dynamiclink != '') {
      await FirebaseFirestore.instance
          .collection('City')
          .doc(globals.dynamiclink)
          .get()
          .then((value) {
        print("sijofoeijieiwoe");
        print(value.data());
        print(value.data().runtimeType);
        setState(() {
          globals.dynamiclink = '';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Property(detail: value.data())),
        );
      });
    }
  }
}

class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}

class City {
  final String? name;
  final String? avatar;
  City({this.name, this.avatar});
}

List<User> userList = [
  // User(name: "less than 5000/month", avatar: "user.png"),
  // User(name: "less than 10,000/month", avatar: "user.png"),
  // User(name: "more than 10,000/month", avatar: "user.png"),
  // User(name: "Within 10km", avatar: "user.png"),
  // User(name: "Within 5km", avatar: "user.png"),
  // User(name: "Within 1km", avatar: "user.png"),
  User(name: "Seller Property", avatar: "Sell property"), //
  User(name: "Rental Property", avatar: "Rent property"), //
  User(name: "Hotel Service", avatar: "Hotel"), //
  User(name: "PG Service", avatar: "PG"), //
  User(name: "Hostel Service", avatar: "Hostel"), //
  User(name: "Home Service", avatar: "Home"),
  User(name: "Marrige hall", avatar: "Marrige hall"),
];

List<City> cityList = [];

class Location {
  final String? name;
  final String? avatar;
  Location({this.name, this.avatar});
}

List<Location> locationList = [];

Map<String, int> stateId = {
  "Meghalaya": 0,
  "Haryana": 1,
  "Maharashtra": 2,
  "Goa": 3,
  "Manipur": 4,
  "Puducherry": 5,
  "Telangana": 6,
  "Odisha": 7,
  "Rajasthan": 8,
  "Punjab": 9,
  "Uttarakhand": 10,
  "Andhra Pradesh": 11,
  "Nagaland": 12,
  "Lakshadweep": 13,
  "Himachal Pradesh": 14,
  "Delhi": 15,
  "Uttar Pradesh": 16,
  "Andaman and Nicobar Islands": 17,
  "Arunachal Pradesh": 18,
  "Jharkhand": 19,
  "Karnataka": 20,
  "Assam": 21,
  "Kerala": 22,
  "Jammu and Kashmir": 23,
  "Gujarat": 24,
  "Chandigarh": 25,
  "Dadra and Nagar Haveli": 26,
  "Daman and Diu": 27,
  "Sikkim": 28,
  "Tamil Nadu": 29,
  "Mizoram": 30,
  "Bihar": 31,
  "Tripura": 32,
  "Madhya Pradesh": 33,
  "Chhattisgarh": 34,
  "Ladakh": 35,
  "West Bengal": 36,
};
