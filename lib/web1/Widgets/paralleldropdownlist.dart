import 'package:flutter/material.dart';
import 'package:take_web/web/Widgets/bottom_nav_bar.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../firebase_functions/firebase_fun.dart';

class ParallelDropDownList extends StatefulWidget {
  Future<List>? stateCity;
  String city;
  ParallelDropDownList(stateCity, this.city, {Key? key}) : super(key: key);

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
    value = globals.list;
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                  height: MediaQuery.of(context).size.height * 0.75,
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
                  width: MediaQuery.of(context).size.width*0.55,
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
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width*0.55,
                  child: Card(
                    elevation: 0,
                    child: ListView.builder(
                      itemCount: city.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            globals.city = city[index];
                            await getproperty(city[index]);
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      CustomBottomNavigation(city[index])),
                              ModalRoute.withName(
                                  '/custombuttonnavigation'),
                            );
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
