import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../Widgets/Image_animation.dart';
import '../../Widgets/contact_detail.dart';
import '../../Widgets/detail_button.dart';
import '../../Widgets/detail_card.dart';
import '../../Widgets/google_map_card.dart';
import '../../Widgets/profile_card.dart';
import '../../globar_variables/globals.dart';
import '../../models/user_model.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';

class OwnersProfileProperty extends StatefulWidget {
  var list;
  OwnersProfileProperty(this.list, {Key? key}) : super(key: key);

  @override
  State<OwnersProfileProperty> createState() => _OwnersProfilePropertyState();
}

class _OwnersProfilePropertyState extends State<OwnersProfileProperty> {
  UserModel? valuedata;
  var currentUser = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getprofilepic();
    try {
      currentUser = FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      currentUser = '';
    }
    getownerdata(widget.list["uid"]);
  }

  var profileimage;

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
            properties: value.data()!["properties"],
            address: value.data()!["address"]);
        profileimage = valuedata?.profileImage;
        setState(() {
          profileimage = valuedata?.profileImage;
          valuedata?.profileImage;
          ownerprofiledata = valuedata;
          valuedata;
        });
        print("valuedata ${valuedata?.address}");
      });
    } catch (e) {
      print("this is property detail error: ${e}");
    }
  }

  void getprofilepic() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.list["uid"])
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
    var width = MediaQuery.of(context).size.width;
    print(widget.list["uid"]);
    return SafeArea(
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageAnimation(widget.list),
                const SizedBox(
                  height: 15,
                ),
                // OwnerProfileCard(widget.detail, profileimage, valuedata),
                DetailCard(widget.list),
                ContactDetail(widget.list),
                GoogleMapCard(widget.list, 200.0)
              ],
            ),
          ),
        ),
        bottomNavigationBar: currentUser == widget.list["uid"]
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(6.0),
                child: DetailButton(widget.list, currentUser, profileimage),
              ),
      ),
    );
  }
}
