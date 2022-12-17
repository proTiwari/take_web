import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';

class DetailButton extends StatefulWidget {
  var detail;
  DetailButton(this.detail, {Key? key}) : super(key: key);

  @override
  State<DetailButton> createState() => _DetailButtonState();
}

class _DetailButtonState extends State<DetailButton> {
  var groupid;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupid = Provider.of<DatabaseService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    print("group id ${groupid.groupid}");
    return InkWell(
      onTap: () async {
        setState(() {
          loading = true;
        });
        await DatabaseService(
                uid: FirebaseAuth.instance.currentUser!.uid, widget.detail)
            .createGroup("userName", FirebaseAuth.instance.currentUser!.uid,
                "groupName", context);
        setState(() {
          loading = false;
        });


        // if (groupid == null) {}
        // if (groupid != null) {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => ChatPage(
        //               groupId: groupid.groupid,
        //               groupName: "groupName",
        //               userName: "userName")));
        // }
      },
      child: Container(
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
            child:loading?const Center(child: CircularProgressIndicator(color: Colors.white,)): Center(
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
