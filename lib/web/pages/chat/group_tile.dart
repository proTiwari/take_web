import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            FirebaseFirestore.instance
                .collection("Users")
                .doc(i)
                .get()
                .then((value) {
              print('ttttt${i}');
              setState(() {
                profileimage = value.get("profileImage");
              });

              print('uuuuu');
              print("this is profile image: ${profileimage}");
              return profileimage;
            });
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
      onTap: () {
        nextScreen(
            context,
            ChatPage(
                owneruid: owneruid,
                groupId: widget.groupId,
                groupName: widget.groupName,
                userName: widget.userName,
                profileImage: profileimage));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: NetworkImage(profileimage),
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
