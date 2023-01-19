import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:take_web/web/Widgets/cards.dart';
import 'package:take_web/web/Widgets/paralleldropdownlist.dart';
import '../../Widgets/google_map_circle.dart';
import '../../globar_variables/globals.dart' as globals;
import '../../Widgets/filter_card.dart';
import 'package:filter_list/filter_list.dart';

class Search extends StatefulWidget {
  String city;
  Search(this.city, {Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<User>? selectedUserList = [];
  List<Location>? selectedlocationList = [];
  List? stateCity;
  bool CitySelector = false;
  final Map<int, Color?> _yellow700Map = {
    50: const Color(0xFFFFD7C2),
    100: Color(0xFFF27121),
  };

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
    listtoreturn.add(State);
    return listtoreturn;
  }

  var Citys = "Allahabad";
  bool propertyexist = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init search screen");
    globals.imageList.clear();

    getRes();
  }

  getRes() async {
    stateCity = await getResponse();
    /*print(stateCity);*/
    globals.list = stateCity;
  }

  void prints(var s1) {
    String s = s1.toString();
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => print("${match.group(0)}\n"));
  }

  Future<void> openLocationFilterDialog() async {
    await FilterListDialog.display<Location>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Filter',
      height: 500,
      listData: locationList,
      selectedListData: selectedlocationList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        openFilterDialog;
        setState(() {
          selectedlocationList = List.from(list!);
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

  @override
  Widget build(BuildContext context) {
    setState(() {
      propertyexist;
    });
    print("globals.propertys ${globals.property}");
    var width = MediaQuery.of(context).size.width;
    globals.width = width * 0.87;
    var height = MediaQuery.of(context).size.height;
    globals.height = height;
    print(globals.property.length);
    // print(globals.property[0]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 27, 0),
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
                              onTap: () {},
                              child: FilterCard("Near me"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  CitySelector = !CitySelector;
                                });
                              },
                              child: FilterCard(widget.city),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: InkWell(
                              onTap: openFilterDialog,
                              child: FilterCard("Filter"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              CitySelector
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 0),
                      child: ParallelDropDownList(stateCity, widget.city),
                    )
                  : Container(),
              !CitySelector
                  ? SingleChildScrollView(
                      child: Container(
                      height: MediaQuery.of(context).size.height - 110,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("State")
                              .doc("City")
                              .collection(widget.city)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            var documents = snapshot.data!.docs;
                            //todo Documents list added to filterTitle
                            var finalList = [];
                            if (selectedUserList!.isNotEmpty) {
                              var list;
                              for (var i in selectedUserList!) {
                                list = documents.where((element) {
                                  return element
                                      .get("wantto")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          i.avatar.toString().toLowerCase());
                                }).toList();
                                finalList = List.from(finalList)..addAll(list);
                                list = documents.where((element) {
                                  return element
                                      .get("servicetype")
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          i.avatar.toString().toLowerCase());
                                }).toList();
                                finalList = List.from(finalList)..addAll(list);
                              }
                              print("documents: ${documents}");
                            }
                            print("sdijj${snapshot.hasData}");
                            try {
                              snapshot.data!.docs.first["pincode"];
                            } catch (e) {
                              return const Padding(
                                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                child: Center(
                                    child: Text(
                                        "There is no property upload from this city!")),
                              );
                            }
                            // ignore: unnecessary_new
                            if (selectedUserList!.isNotEmpty) {
                              return ListView(
                                  children: getExpenseItemsdocs(finalList));
                            } else {
                              print(snapshot);
                              return ListView(
                                  children: getExpenseItems(snapshot));
                            }
                          },
                        ),
                      ),
                    ))
                  : Container(),
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
          child: const GoogleMapCircle(),
        ),
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
}

class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}

List<User> userList = [
  // User(name: "less than 5000/month", avatar: "user.png"),
  // User(name: "less than 10,000/month", avatar: "user.png"),
  // User(name: "more than 10,000/month", avatar: "user.png"),
  // User(name: "Within 10km", avatar: "user.png"),
  // User(name: "Within 5km", avatar: "user.png"),
  // User(name: "Within 1km", avatar: "user.png"),
  User(name: "Property On Sale", avatar: "Sell property"), //
  User(name: "Property On Rent", avatar: "Rent property"), //
  User(name: "Hotel Service", avatar: "Hotel"), //
  User(name: "PG Service", avatar: "PG"), //
  User(name: "Hostel Service", avatar: "Hostel"), //
  User(name: "Home Service", avatar: "Home"), //
  // User(name: "No Sharing", avatar: "user.png"),
  // User(name: "Two Sharing", avatar: "user.png"),
  // User(name: "Three Sharing", avatar: "user.png"),
  // User(name: "Many Sharing", avatar: "user.png"),
];

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