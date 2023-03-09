import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import '../../Widgets/Image_animation.dart';
import '../../Widgets/contact_detail.dart';
import '../../Widgets/detail_button.dart';
import '../../Widgets/detail_card.dart';
import '../../Widgets/google_map_card.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../Widgets/profile_card.dart';
import '../../globar_variables/globals.dart';
import '../../models/user_model.dart';
import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../list_property/flutter_flow/flutter_flow_util.dart';

class Property extends StatefulWidget {
  var detail;
  Property({Key? key, this.detail}) : super(key: key);

  @override
  State<Property> createState() => _PropertyState();
}

class _PropertyState extends State<Property> {
  UserModel? valuedata;
  var currentUser = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dynamiclink = '';
    //getprofilepic();
    try {
      currentUser = FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      currentUser = '';
    }
    try {
      getownerdata(widget.detail["uid"]);
    } catch (e) {
      print("you kinga: ${e.toString()}");
    }
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
            address: value.data()!["address"]);
        profileimage = valuedata?.profileImage;
        setState(() {
          profileimage = valuedata?.profileImage;
          valuedata?.profileImage;
          ownerprofiledata = valuedata;
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

  void getprofilepic() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.detail["uid"])
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
    print(widget.detail["uid"]);
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: 0, horizontal: width < 800 ? 10 : width * 0.24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageAnimation(widget.detail),
                const SizedBox(
                  height: 15,
                ),
                OwnerProfileCard(widget.detail, profileimage, valuedata),
                DetailCard(widget.detail),
                ContactDetail(widget.detail),
                InkWell(
                    onTap: () {
                      print("clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GoogleMapCard(widget.detail, 200.0)),
                      );
                    },
                    child: Container(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Stack(children: [
                        GoogleMapCard(widget.detail, 200.0),
                        Container(
                          color: Colors.transparent,
                          height: 200,
                          width: 400,
                        )
                      ]),
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: currentUser == widget.detail["uid"]
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: DetailButton(widget.detail, currentUser, profileimage),
            ),
    );
  }
}
