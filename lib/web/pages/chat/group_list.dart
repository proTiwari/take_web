import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/char_services.dart';
import '../../services/database_service.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import 'group_tile.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key? key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  String userName = "";
  String email = "";
  AuthChatService authService = AuthChatService();
  var groups;
  bool _isLoading = false;
  String groupName = "";
  bool shownomassagetext = false;

  bool groupexists = false;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserDatka() async {
    var snap = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    print("sdfsdfsdssssffg${snap}");
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> get user {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    try {
      print("sdfsdfsdfs");
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid, "sdsf")
          .getUserGroups()
          .then((snapshots) {
        if (snapshots == null) {
          setState(() {
            shownomassagetext = true;
          });
        }

        print("sdfsdfgggggggd${snapshots.runtimeType}");
        snapshots.data['groups'].length;
        setState(() {
          groups = snapshots;
          try {
            print("sdfsfsdfsds${snapshots.data()?["groups"]}");
          } catch (e) {
            setState(() {
              shownomassagetext = true;
            });
          }
        });
      });
    } catch (e) {
      setState(() {
        shownomassagetext = true;
      });
      print("sdfsdfs${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: const Text("chats", style: TextStyle(color: Colors.black)),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      body: groupList(),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     if (groupName != "") {
                //       setState(() {
                //         _isLoading = true;
                //       });
                //       DatabaseService(
                //               uid: FirebaseAuth.instance.currentUser!.uid, "sdfs")
                //           .createGroup(userName,
                //               FirebaseAuth.instance.currentUser!.uid, groupName)
                //           .whenComplete(() {
                //         _isLoading = false;
                //       });
                //       Navigator.of(context).pop();
                //       showSnackbar(
                //           context, Colors.green, "Group created successfully.");
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //       primary: Theme.of(context).primaryColor),
                //   child: const Text("CREATE"),
                // )
              ],
            );
          }));
        });
  }

  getprofile(groupId) async {
    print("oifjoiejf");
    try {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupId)
          .get()
          .then((value) {
        var list = value.get("members");
        print(list);
        for (var i in list) {
          if (i != FirebaseAuth.instance.currentUser!.uid) {
            try {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(i)
                  .get()
                  .then((value) {
                String profileimage = value.get("profileImage");
                print("this is profile image: ${profileimage}");
                return profileimage;
              });
            } catch (e) {
              print("error In group list:: $e");
            }
          }
        }
      });
    } catch (e) {
      print("group_list:: $e");
    }
  }

  groupList() {
    //FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots()
    try {
      var width = MediaQuery.of(context).size.width;
      return Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            try {
              // print("sdfsdfsddewreww${snapshot.data["groups"]}");
              // make some checks

              if (snapshot.hasData) {
                if (snapshot.data['groups'] != null) {
                  if (snapshot.data['groups'].length != 0) {
                    try {
                      return ListView.builder(
                        itemCount: snapshot.data['groups'].length,
                        itemBuilder: (context, index) {
                          print(
                              "7777777777777: ${snapshot.data['groups'][index]}");
                          // return Text(getId(snapshot.data['groups'][reverseIndex]));}
                          // var profileimage =
                          //     getprofile(snapshot.data['groups'][reverseIndex]);
                          return Container(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            margin: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: width < 800 ? 10 : width * 0.24),
                            child: GroupTile(
                                profileimage: 'profileimage',
                                groupId: getId(
                                    snapshot.data['groups'][index]),
                                groupName: getName(
                                    snapshot.data['groups'][index]),
                                userName: snapshot.data['id']),
                          );
                        },
                      );
                    } catch (e) {
                      return Container();
                    }
                  } else {
                    return noGroupWidget();
                  }
                } else {
                  return noGroupWidget();
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }
            } catch (e) {
              return noGroupWidget();
            }
          },
        ),
      );
    } catch (e) {
      return const Center(child: CircularProgressIndicator());
    }
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          // GestureDetector(
          //   onTap: () {
          //     popUpDialog(context);
          //   },
          //   child: Icon(
          //     Icons.add_circle,
          //     color: Colors.grey[700],
          //     size: 75,
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "There is no chat with property owners",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
