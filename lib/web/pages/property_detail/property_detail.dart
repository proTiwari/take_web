import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:take_web/web/Widgets/contact_detail.dart';
import 'package:take_web/web/Widgets/detail_button.dart';
import 'package:take_web/web/Widgets/detail_card.dart';
import 'package:take_web/web/globar_variables/globals.dart' as globals;
import '../../Widgets/Image_animation.dart';
import '../../Widgets/google_map_card.dart';
import '../../Widgets/profile_card.dart';
import '../../models/user_model.dart';

class Property extends StatefulWidget {
  var detail;
  Property({Key? key, this.detail}) : super(key: key);

  @override
  State<Property> createState() => _PropertyState();
}

class _PropertyState extends State<Property> {
  UserModel? valuedata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getprofilepic();
    getownerdata(widget.detail["id"]);
  }

  var profileimage;

  getownerdata(id) async {
      valuedata = await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .get()
          .then((value) {
        valuedata = UserModel(
            name: value.data()!["name"],
            email: value.data()!["email"],
            phone: value.data()!["phone"],
            profileImage: value.data()!["profileImage"],
            groups: value.data()!["groups"],
            id: value.data()!["id"],
            properties: value.data()!["properties"],
            address: value.data()!["address"]
        );
        profileimage = valuedata?.profileImage;
        setState(() {
          profileimage = valuedata?.profileImage;
          valuedata?.profileImage;
          globals.ownerprofiledata = valuedata;
          valuedata;
        });
        print("valuedata ${valuedata?.address}");
      });
  }
  void getprofilepic() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.detail["id"])
          .get()
          .then((value) {
        profileimage = value.data()!["profileImage"];
        print("333333333333${value.data()!["profileImage"]}");
      });
      setState(() {
        profileimage;
      });
    } catch (e) {
      print("yyyyyyyyyyy${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    print(widget.detail["id"]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ImageAnimation(widget.detail),
              const SizedBox(
                height: 15,
              ),
              OwnerProfileCard(
                  widget.detail, profileimage, valuedata),
              DetailCard(widget.detail),
              ContactDetail(widget.detail),
              GoogleMapCard()
            ],
          ),
        ),
        bottomNavigationBar:
            FirebaseAuth.instance.currentUser!.uid == widget.detail["id"]
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: DetailButton(widget.detail),
                  ),
      ),
    );
  }
}
