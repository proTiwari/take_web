import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_web/web/Widgets/wedigets.dart';
import 'package:take_web/web/pages/ownersprofile/owners_profile_page.dart';

import '../../models/user_model.dart';
import '../../services/database_service.dart';
import '../../Widgets/group_info.dart';
import '../../Widgets/message_tile.dart';
import '../../globar_variables/globals.dart' as globals;

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  final String profileImage;
  final String owneruid;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.profileImage,
      required this.owneruid})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  String admin = "";
  var valuedata;
  var profileimage;

  @override
  void initState() {
    getownerdata(widget.owneruid);
    changestatus();
    getChatandAdmin();
    Timer(const Duration(milliseconds: 1000), () {
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 750),
      );
    });

    super.initState();
  }

  changestatus() async {
    try {
      var snapshots = await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupId)
          .collection("messages")
          .where('sender', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var doc in snapshots.docs) {
        await doc.reference.update({
          'status': true,
        });
      }

      // await snapshots.docs.map((e) {
      //   e.data().updateAll("status", (value) => true);
      // });
    } catch (e) {
      print("diogjiodjo");
      print(e.toString());
    }
  }

  getownerdata(id) async {
    print("weweeeeeeeeeeeeee${id}");
    try {
      valuedata = await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .get()
          .then((value) async {
        print("yyyyttttttttttttttttt${value.data()!["groups"]}");
        valuedata = await UserModel(
            name: value.data()!["name"],
            email: value.data()!["email"],
            phone: value.data()!["phone"],
            profileImage: value.data()!["profileImage"],
            groups: value.data()!["groups"],
            id: value.data()!["id"],
            address: value.data()!["address"]);
        profileimage = valuedata?.profileImage;
        setState(() {
          profileimage = valuedata?.profileImage;
          valuedata?.profileImage;
          globals.ownerprofiledata = valuedata;
          print("isjfowjeo");
          print(valuedata!.id);
          valuedata;
        });
        print("valuedata ${valuedata?.address}");
      });
    } catch (e) {
      print("this is property detail error: ${e}");
    }
  }

  getChatandAdmin() {
    DatabaseService("dfg").getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService("dsd").getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //   leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ClipOval(
        //     child: Image(image: Image.network(widget.profileImage).image,),
        //   ),
        // ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    OwnersProfilePage(valuedata, '', widget.owneruid),
              ),
            );
          },
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: Align(
                    child: Image.network(widget.profileImage),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.groupName),
            ],
          ),
        ),
        backgroundColor: Colors.grey[700],
        actions: [
          // SizedBox(
          //   width: 60.0,
          //   height: 60,
          //   child: PopupMenuButton<String>(
          //     icon: ClipOval(
          //       child: Align(
          //         heightFactor: 1,
          //         widthFactor: 1,
          //         child: Image.network(widget.profileImage),
          //       ),
          //     ),
          //     // onSelected: ',
          //     itemBuilder: (BuildContext context) {
          //       return [];
          //     },
          //   ),
          // ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: 0, horizontal: width < 800 ? 0 : width * 0.24),
        child: Stack(
          children: <Widget>[
            // chat messages here
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[700],
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  chatMessages() {
    var propertydata;
    var imageurl;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: StreamBuilder(
          stream: chats,
          builder: (context, AsyncSnapshot snapshot) {
            Timer(const Duration(milliseconds: 100), () {
              listScrollController.animateTo(
                listScrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 750),
              );
            });
            return snapshot.hasData
                ? MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      controller: listScrollController,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        try {
                           return MessageTile(
                            imageurl: snapshot.data.docs[index]['imageurl'],
                            propertydata: snapshot.data.docs[index]['propertydata'],
                            status: snapshot.data.docs[index]['status'],
                            time: snapshot.data.docs[index]['time'],
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                                snapshot.data.docs[index]['sender']);
                        } catch (e) {
                           return MessageTile(
                            imageurl: '',
                            propertydata: '',
                            status: snapshot.data.docs[index]['status'],
                            time: snapshot.data.docs[index]['time'],
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                                snapshot.data.docs[index]['sender']);
                        }
                        
                      },
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now(),
        "status": false
      };

      DatabaseService("sdf").sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
