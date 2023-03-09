import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/database_service.dart';
import '../../Widgets/group_info.dart';
import '../../Widgets/message_tile.dart';
import '../../globar_variables/globals.dart' as globals;
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../ownersprofile/owners_profile_page.dart';

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
  String admin = "";
  var valuedata;
  var profileimage;

  @override
  void initState() {
    getownerdata(widget.owneruid);
    changestatus();
    getChatandAdmin();

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
        leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(0);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
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
                child: widget.profileImage == ''
                    ? ClipOval(
                        child: Align(
                          child: Image.network(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                        ),
                      )
                    : ClipOval(
                        child: Align(
                          child: Image.network(widget.profileImage),
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.groupName,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 230, 229, 229),
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(0);
          return false;
        },
        child: Container(
          color: Color.fromARGB(255, 230, 229, 229),
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 0 : width * 0.24),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // chat messages here
                chatMessages(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 0, 3, 6),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0.0,
                            offset: Offset(0, 0),
                          )
                        ],
                      ),
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          
                          Expanded(
                              child: TextFormField(
                            maxLines: 30,
                            minLines: 1,
                            controller: messageController,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)),
                            decoration: const InputDecoration(
                              hintText: "Send a message...",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16),
                              border: InputBorder.none,
                            ),
                          )),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("sendmessage");
                              sendMessage();
                            },
                            child: Container(
                              
                              height: 80,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.rectangle
                                
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.send,
                                color: FlutterFlowTheme.of(context).greenColor,
                                
                              )),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 80,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chatMessages() {
    var propertydata;
    var imageurl;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          int reverseIndex;
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  // controller: listScrollController,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    reverseIndex = snapshot.data.docs.length - index - 1;
                    try {
                      if (index == 0) {
                        changestatus();
                      }
                      print(reverseIndex);
                      print(snapshot.data.docs[reverseIndex]['message']);
                      print(snapshot.data.docs.length);
                      if (reverseIndex != 0) {
                        print("siojdfoijeoooooooooooooooooo");
                        globals.recentmessagetemp =
                            snapshot.data.docs[reverseIndex - 1]['sender'];
                      } else {
                        print("siojdfoijeoiiiiiiiiiiiiiii");
                        globals.recentmessagetemp = "justToCreateAdiffrence";
                      }

                      return MessageTile(
                          imageurl: snapshot.data.docs[reverseIndex]
                              ['imageurl'],
                          propertydata: snapshot.data.docs[reverseIndex]
                              ['propertydata'],
                          status: snapshot.data.docs[reverseIndex]['status'],
                          time: snapshot.data.docs[reverseIndex]['time'],
                          message: snapshot.data.docs[reverseIndex]['message'],
                          sender: snapshot.data.docs[reverseIndex]['sender'],
                          sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                              snapshot.data.docs[reverseIndex]['sender']);
                    } catch (e) {
                      return MessageTile(
                          imageurl: '',
                          propertydata: '',
                          status: snapshot.data.docs[reverseIndex]['status'],
                          time: snapshot.data.docs[reverseIndex]['time'],
                          message: snapshot.data.docs[reverseIndex]['message'],
                          sender: snapshot.data.docs[reverseIndex]['sender'],
                          sentByMe: FirebaseAuth.instance.currentUser!.uid ==
                              snapshot.data.docs[reverseIndex]['sender']);
                    }
                  },
                )
              : Container();
        },
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

      Map<String, dynamic> payload = {
        "ownerId": widget.owneruid,
        "groupName": widget.groupName,
        "userName": widget.userName,
        "profileImage": widget.profileImage,
        "navigator": "",
        "groupId": widget.groupId
      };

      DatabaseService("sdf")
          .sendMessage(widget.groupId, chatMessageMap, payload);
      setState(() {
        messageController.clear();
      });
    }
  }
}
