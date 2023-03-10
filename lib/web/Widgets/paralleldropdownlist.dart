import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../web/globar_variables/globals.dart';
import '../firebase_functions/firebase_fun.dart';
import '../globar_variables/globals.dart';
import '../pages/explore_page/googlemap.dart';
import 'bottom_nav_bar.dart';

class ParallelDropDownList extends StatefulWidget {
  Future<List>? stateCity;
  String city;
  String page;
  List properties;
  ParallelDropDownList(stateCity, this.city, this.page, this.properties,
      {Key? key})
      : super(key: key);

  @override
  State<ParallelDropDownList> createState() => _ParallelDropDownListState();
}

class _ParallelDropDownListState extends State<ParallelDropDownList> {
  var value;
  var state;
  var citys;
  List city = [];
  var tempState;
  @override
  void initState() {
    super.initState();
    value = 'list';
    state = value[1];
    citys = value[0];
  }

  void transfercitytocitylist(tempState) {
    city.clear();
    var citylist = citys["$tempState"];
    for (var i in citylist) {
      city.add(i["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  print(globals.list);
    return Card(
      elevation: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "State",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(00, 0, 0, 0),
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    elevation: 0,
                    child: ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                tempState = state[index];
                              });
                              transfercitytocitylist(tempState);
                            },
                            child: Text(
                              "${state[index]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "City",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Card(
                    elevation: 0,
                    child: ListView.builder(
                      itemCount: city.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            city = city[index];
                            // getproperty(city[index]);
                            var namecity = city[index].toString();
                            String result = namecity.replaceAll('ā', 'a');
                            result = result.replaceAll('Ā', 'A');
                            result = result.replaceAll('ū', 'u');
                            var finalcity = result.replaceAll('ī', 'i');
                            print("hhhhhhhhhhhhh${finalcity}");
                            city = finalcity as List;
                            secondcall = true;
                            // ignore: use_build_context_synchronously
                            if (widget.page == "search") {
                              Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        CustomBottomNavigation(
                                            finalcity, 'secondcall', "")),
                                ModalRoute.withName('/custombuttonnavigation'),
                              );
                            }
                            if (widget.page == "map") {
                              // take snapshot of city

                              print(
                                  'sdfjofjoeojeofijsoidjoidfijsdfivsidgisdhidsfigjdofjodij');
                              print(finalcity);

                              Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Googlemap(const [], finalcity, 'map')),
                                ModalRoute.withName('/map'),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${city[index]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
