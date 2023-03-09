import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../globar_variables/globals.dart';
import '../pages/chat/chat_page.dart';
import '../pages/list_property/flutter_flow/flutter_flow_theme.dart';
import '../pages/list_property/flutter_flow/flutter_flow_util.dart';
import '../pages/nav/nav.dart';
import '../pages/nav/serialization_util.dart';
import '../pages/signin_page/phone_login.dart';
import '../services/database_service.dart';

class DetailButton extends StatefulWidget {
  var detail;
  var currentUser;
  var profileimage;

  DetailButton(this.detail, this.currentUser, this.profileimage, {Key? key})
      : super(key: key);

  @override
  State<DetailButton> createState() => _DetailButtonState();
}

class _DetailButtonState extends State<DetailButton> {
  var groupid;
  bool groupexist = false;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupid = Provider.of<DatabaseService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        if (widget.currentUser != '') {
          setState(() {
            loading = true;
          });
          print("start");
          var listproperties = [];
          Map groupidmap = {};
          try {
            widget.detail['propertyId'];
            var listofgroups = await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            var grouplist = listofgroups.data()!['groups'];
            var count = 0;
            print("jjjjj: ${grouplist}");
            for (var i in grouplist) {
              i = i.toString().split("_")[0];
              await FirebaseFirestore.instance
                  .collection("groups")
                  .doc(i)
                  .get()
                  .then((value) {
                try {
                  print("printing ff: ${value.data()?.entries}");
                  listproperties.add(value.data()?['propertyId']);
                  groupidmap[value.data()?['propertyId']] =
                      value.data()?['groupId'];
                } catch (e) {
                  print("error::::  ${i} ${e}");
                }
              });
            }
            groupexist = listproperties.contains(widget.detail["propertyId"]);
            print(groupexist);

            print("grouplist${grouplist}");
          } catch (e) {
            setState(() {
              loading = false;
            });
            groupexist = false;
            print("this is the error: ${e.toString()}");
          }
          if (!groupexist) {
            await DatabaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid, widget.detail)
                .createGroup("userName", FirebaseAuth.instance.currentUser!.uid,
                    "groupName", context, widget.detail['propertyId']);
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  groupId: groupidmap[widget.detail["propertyId"]],
                  groupName: "${widget.detail["ownername"]}",
                  userName: "${userdata['name']}",
                  profileImage: widget.detail['profileImage'],
                  owneruid: widget.detail['uid'],
                ),
              ),
            );
          }
        } else {
          showDialog(
            builder: (context) {
              return AlertDialog(
                title: const Text(''),
                content: const Text('Login to start chat with property owners'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      context.pushNamed(
                        'customnav',
                        queryParams: {
                          'city': serializeParam(
                            '${city}',
                            ParamType.String,
                          ),
                          'secondcall': serializeParam(
                            'login',
                            ParamType.String,
                          ),
                          'profile': serializeParam(
                            'Prayagraj',
                            ParamType.String,
                          )
                        }.withoutNulls,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 600),
                          ),
                        },
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginApp()),
                      );
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            },
            context: context,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
        height: 60,
        decoration: BoxDecoration(
          boxShadow: const [
            // BoxShadow(
            //     color: Color(0xFFF27121),
            //     offset: Offset(5, 15),
            //     blurRadius: 5,
            //     spreadRadius: 3)
          ],
          color: FlutterFlowTheme.of(context).alternate,
          // color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        text: "I'm interested, can we chat?",
                      ),
                    ),
                  )),
      ),
    );
  }
}
