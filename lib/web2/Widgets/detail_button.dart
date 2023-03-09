import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/globar_variables/globals.dart';
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import '../pages/chat/chat_page.dart';
import '../services/database_service.dart';
import '../../web/globar_variables/globals.dart' as globals;

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
  bool groupexist = true;
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
    print("group id ${groupid.groupid}");
    return InkWell(
      onTap: () async {
        if (widget.currentUser != '') {
          setState(() {
            loading = true;
          });
          print("start");
          try {
            widget.detail['propertyId'];
            var listofgroups = await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            var grouplist = listofgroups.data()!['groups'];
            var count = 0;
            for (var i in grouplist) {
              i = i.toString().split("_")[0];
              await FirebaseFirestore.instance
                  .collection("groups")
                  .doc(i)
                  .get()
                  .then((value) => {
                        if (value.data()!['propertyId'] ==
                            widget.detail["propertyId"])
                          {
                            print(
                                "moving to chat page ${widget.detail["ownername"]}"),
                            setState(() {
                              loading = false;
                            }),
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  groupId: value.data()!['groupId'],
                                  groupName: "${widget.detail["ownername"]}",
                                  userName: "${globals.userdata['name']}",
                                  profileImage: widget.detail['profileImage'],
                                  owneruid: widget.detail['uid'],
                                ),
                              ),
                            )
                          }
                        else
                          {count += 1}
                      });
              print(count);
              print(grouplist.length);
            }
            if (count == grouplist.length) {
              groupexist = false;
            }

            print(grouplist);
          } catch (e) {
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
                      Navigator.pop(context, 'Okay');
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
          color: const Color(0xFFF27121),
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
