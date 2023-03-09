import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../globar_variables/globals.dart';
import '../pages/chat/chat_page.dart';
import 'package:http/http.dart' as http;

class DatabaseService extends ChangeNotifier {
  final String? uid;
  var detail;
  var groupid;
  DatabaseService(this.detail, {this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  // saving the userdata
  // Future savingUserData(String fullName, String email) async {
  //   return await userCollection.doc(uid).set({
  //     "fullName": fullName,
  //     "email": email,
  //     "groups": [],
  //     "profilePic": "",
  //     "uid": uid,
  //   });
  // }

  // getting user data
  // Future gettingUserData(String email) async {
  //   QuerySnapshot snapshot =
  //   await userCollection.where("email", isEqualTo: email).get();
  //   return snapshot;
  // }

  // get user groups
  getUserGroups() async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName,
      BuildContext context, properyId) async {
    try {
      print("1${groupid}");
      DocumentReference groupDocumentReference = await groupCollection.add({
        "groupName": groupName,
        "groupIcon": "",
        "admin": "${id}_$userName",
        "members": [],
        "groupId": "",
        "propertyId": properyId,
        "recentMessage": "",
        "recentMessageSender": "",
      });
      // update the members
      print("2${groupid}");
      try {
        await groupDocumentReference.update({
          "members": FieldValue.arrayUnion(
              ["${uid}_$userName", "${detail["uid"]}_userName"]),
          "groupId": groupDocumentReference.id,
        });
        await FirebaseFirestore.instance
            .collection("City")
            .doc(detail['propertyId'])
            .update({
          'groupid': FieldValue.arrayUnion(["${groupDocumentReference.id}"])
        });
      } catch (e) {
        print(e.toString());
      }

      Map<String, dynamic> chatMessageMap = {
        "message": "Hello, I'm Interested, can we chat?",
        "imageurl": detail['propertyimage'][0],
        "propertydata": "${detail['streetaddress']}, ${detail['pincode']}",
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now(),
        "status": false
      };

      Map<String, dynamic> payload = {
        "ownerId": detail["uid"],
        "groupName": detail["ownername"],
        "userName": userdata['name'],
        "profileImage": detail["profileImage"],
        "navigator": "",
        "groupId": groupid
      };

      await DatabaseService("sdf")
          .sendMessage(groupDocumentReference.id, chatMessageMap, payload);

      print("3${groupid}");
      groupid = groupDocumentReference.id;
      DocumentReference userDocumentReference = userCollection.doc(uid);
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(
            ["${groupDocumentReference.id}_${detail["ownername"]}"])
      });
      try {
        DocumentReference ownerDocumentReference =
            userCollection.doc(detail["uid"]);
        await ownerDocumentReference.update({
          "groups": FieldValue.arrayUnion(
              ["${groupDocumentReference.id}_${userdata['name']}"])
        });
      } catch (e) {
        print("4$e");
      }

      print("6${groupid}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            groupId: groupid,
            groupName: "${detail["ownername"]}",
            userName: "${userdata['name']}",
            profileImage: detail["profileImage"],
            owneruid: detail["uid"],
          ),
        ),
      );
    } catch (e) {
      print("7${e}");
    }
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      // await userDocumentReference.update({
      //   "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      // });
      // await groupDocumentReference.update({
      //   "members": FieldValue.arrayRemove(["${uid}_$userName"])
      // });
    } else {
      // await userDocumentReference.update({
      //   "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      // });
      // await groupDocumentReference.update({
      //   "members": FieldValue.arrayUnion(["${uid}_$userName"])
      // });
    }
  }

  var profile;
  // send message
  sendMessage(
      String groupId, Map<String, dynamic> chatMessageData, payload) async {
    var devicetoken;

    var userid;
    var username;
    var message;
    message = chatMessageData["message"];
    print("vhhhgggggggg${chatMessageData["uid"]}");
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
    //send notification
    print('send notification');

    await groupCollection.doc(groupId).get().then((value) async {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        profile = value.get("profileImage");
        username = value.get('name');
      });
      var user1 = value.get("members")[0].toString().split("_")[0];
      var user2 = value.get("members")[1].toString().split("_")[0];
      if (user1 != FirebaseAuth.instance.currentUser!.uid) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(value.get("members")[0].toString().split("_")[0])
            .get()
            .then((value) {
          devicetoken = value.get("devicetoken");
          username = value.get('name');
          sendchatnotification(devicetoken, username, message, payload);
        });
      }

      print("user1 ${user1}");
      if (user2 != FirebaseAuth.instance.currentUser!.uid) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user2)
            .get()
            .then((value) {
          devicetoken = value.get("devicetoken");
          username = value.get('name');
          sendchatnotification(devicetoken, username, message, payload);
        });
      }

      print('user2 $user2');
    });
    print("user3");

    print("sfoeiendendendend");
  }

  sendchatnotification(token, username, message, payload) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAgUaarWA:APA91bFA_mb9x7x4RiOq30zOtB60GgLzeYszCSibCuZnMfpzvBpFOziTpoy_Prw_3JeQVatC9Jxw0JgfPFtXtcOPpXgQNT2-l_ccf_2L_STiBKmOzBzMp4cbOfVTg7BAcB37D588KZlg'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": ["$token"],
      "data": payload,
      "notification": {
        "image": profile,
        "body": "$message",
        "title": "$username",
        "android_channel_id": "runforrent",
        "alert": "true",
        "sound": "true",
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    // var headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization':
    //       'key=AAAAgUaarWA:APA91bFA_mb9x7x4RiOq30zOtB60GgLzeYszCSibCuZnMfpzvBpFOziTpoy_Prw_3JeQVatC9Jxw0JgfPFtXtcOPpXgQNT2-l_ccf_2L_STiBKmOzBzMp4cbOfVTg7BAcB37D588KZlg'
    // };
    // var request =
    //     http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    // request.body = json.encode({
    //   "registration_ids": ["$token"],
    //   "data": "payload",
    //   "notification": {
    //     "body": "$message",
    //     "title": "$username",
    //     "android_channel_id": "runforrent",
    //     "sound": "true",
    //   }
    // });
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // } else {
    //   print(response.reasonPhrase);
    // }
    //   try {
    //     final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
    //     final headers = {
    //       'Content-Type': 'application/json',
    //       'Authorization':
    //           'key=AAAAgUaarWA:APA91bFA_mb9x7x4RiOq30zOtB60GgLzeYszCSibCuZnMfpzvBpFOziTpoy_Prw_3JeQVatC9Jxw0JgfPFtXtcOPpXgQNT2-l_ccf_2L_STiBKmOzBzMp4cbOfVTg7BAcB37D588KZlg'
    //     };
    //     Map<String, dynamic> body = {
    //       "registration_ids": ["$token"],
    //       "notification": {
    //         "body": "$message",
    //         "title": "$username",
    //         "android_channel_id": "runforrent",
    //         "sound": false
    //       }
    //     };
    //     print("here2");
    //     String jsonBody = json.encode(body);
    //     final encoding = Encoding.getByName('utf-8');
    //     print("here3");
    //     Response response = await post(
    //       uri,
    //       headers: headers,
    //       body: jsonBody,
    //       encoding: encoding,
    //     );
    //     print("here4");
    //     int statusCode = response.statusCode;
    //     print(statusCode);
    //     String responseBody = response.body;
    //     print(responseBody);
    //   } catch (e) {
    //     print(e.toString());
    //   }
  }
}
