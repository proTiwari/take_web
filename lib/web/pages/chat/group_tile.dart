import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../list_property/flutter_flow/flutter_flow_theme.dart';
import 'chat_page.dart';
import '../../Widgets/wedigets.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String profileimage;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.profileimage})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String profileimage = '';
  String owneruid = '';
  var recentmessage;
  var recentmessagesendby;
  var count = 0;
  @override
  void initState() {
    super.initState();
    widget.groupId;
    getprofile(widget.groupId);
  }

  getprofile(groupId) async {
    try {
      print("oifjoiejf");
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupId)
          .get()
          .then((value) {
        print('jknkjn');
        var list = value.get("members");
        print(list);
        print('kkkkk');
        for (var i in list) {
          print('iiii');
          i = i.toString().split("_userName")[0];
          if (i != FirebaseAuth.instance.currentUser!.uid) {
            owneruid = i;
            try {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(i)
                  .get()
                  .then((value) {
                print('ttttt${i}');
                setState(() {
                  try {
                    profileimage = value.get("profileImage");
                    print("fwjeijwoeowjofjwoefjoiweofjw: ${profileimage}");
                  } catch (e) {
                    print("iweofjwioe$e");
                    profileimage =
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
                  }
                });
              });
              FirebaseFirestore.instance
                  .collection("groups")
                  .doc(widget.groupId)
                  .get()
                  .then((value) {
                print('ttttt${i}');
                setState(() {
                  recentmessage = value.get("recentMessage");
                  recentmessagesendby = value.get("recentMessageSender");
                });
              });
            } catch (e) {
              print("group tile error: ${e}");
            }

            try {
              FirebaseFirestore.instance
                  .collection("groups")
                  .doc(widget.groupId)
                  .collection("messages")
                  .get()
                  .then((value) {
                for (var i in value.docs) {
                  if (i['sender'] != FirebaseAuth.instance.currentUser!.uid) {
                    print("yyyyyyyyy: ${i['status']}");
                    if (i['status'] != true) {
                      setState(() {
                        count += 1;
                      });
                    }
                  }
                }
              });
            } catch (e) {
              print("ggggggggg ${e.toString()}");
            }
          }
        }
      });
    } catch (e) {
      print("sdcssdca");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("oifjoiejf");
    return GestureDetector(
      onTap: () async {
        try {
          Future.delayed(const Duration(milliseconds: 0), () async {
            var bcount = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                    owneruid: owneruid,
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    userName: widget.userName,
                    profileImage: profileimage),
              ),
            );
            setState(() {
              count = bcount;
            });
          });
        } catch (e) {
          print("grouptilenavigationerror: ${e}");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(profileimage),
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.groupName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      recentmessage == null
                          ? const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topLeft,
                              child: recentmessagesendby ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Text(
                                      "You: ${recentmessage}"
                                          .toString()
                                          .trim()
                                          .replaceAll("\n", "  "),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    )
                                  : Text(
                                      "${recentmessage}"
                                          .toString()
                                          .trim()
                                          .replaceAll("\n", "  "),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                            ),
                    ],
                  ),
                ),
                count != 0
                    ? Expanded(
                        flex: 1,
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                ),
                              ),
                              alignment: AlignmentDirectional(0, 0),
                              child: Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  '$count',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: Colors.green,
                                        fontSize: 14,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ))
                    : Container()
              ],
            ),
          ),
          // subtitle: Text(
          //   "Join the conversation as ${widget.userName}",
          //   style: const TextStyle(fontSize: 13),
          // ),
        ),
      ),
    );
  }
}
