import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import '../services/database_service.dart';

class DetailButton extends StatefulWidget {
  var detail;
  var currentUser;
  DetailButton(this.detail, this.currentUser, {Key? key}) : super(key: key);

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
    var width = MediaQuery.of(context).size.width;
    print("group id ${groupid.groupid}");
    return InkWell(
      onTap: () async {
        if (widget.currentUser != '') {
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
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginApp()),
                  );
                },
                child: const Text('Okay'),
              ),
            ],
          );
            }, context: context,
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
