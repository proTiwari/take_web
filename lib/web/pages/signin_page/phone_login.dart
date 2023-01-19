// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/pages/signup_page/phone_signup.dart';
import 'package:take_web/web/pages/signin_page/sign_in.provider.dart';

import '../signup_page/signup_provider.dart';

class LoginApp extends StatefulWidget {
  LoginApp({Key? key}) : super(key: key);

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final _codeController = TextEditingController();
  static final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 400) {
      setState(() {
        width = MediaQuery.of(context).size.width * 5;
      });
    }
    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    return Consumer<SigninProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            body: ChangeNotifierProvider(
          create: (context) => SigninProvider(),
          child: SingleChildScrollView(child:
              Consumer<SigninProvider>(builder: (context, provider, child) {
            return Center(
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.purpleAccent,
                      Colors.amber,
                      Colors.blue,
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 85,
                    ),
                    SizedBox(
                      height: 80,
                      width: 350,
                      child: Container(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 325,
                      height: 320,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Welcome!",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "To access this feature please login",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: SizedBox(
                              width: 260,
                              height: 74,
                              child: Center(
                                child: TextField(
                                  maxLength: 10,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      suffix: Icon(
                                        FontAwesomeIcons.phone,
                                        color: Colors.red,
                                      ),
                                      labelText: "Phone Number",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (_phoneController.text.length == 10) {
                                provider.loginUser(
                                    _phoneController.text, context);
                                print(provider.loading);
                              } else {
                                showToast(context:context,
                                    "phone number must contain 10 digits");
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 261,
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        // Color(0xFF8A2387),
                                        Color.fromRGBO(242, 113, 33, 1),
                                        Color(0xFFF27121),
                                      ])),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: provider.loading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          RichText(
                            text: TextSpan(
                              style: defaultStyle,
                              children: <TextSpan>[
                                const TextSpan(text: ""),
                                TextSpan(
                                  text: 'Need Help With Your Account?',
                                  style: linkStyle,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      print('jkjbkk');
                                      final Uri params = Uri(
                                          scheme: 'mailto',
                                          path: 'team@runforrent.com',
                                          query: 'subject=Query about App');
                                      var mailurl = params.toString();
                                      if (await canLaunch(mailurl)) {
                                        await launch(mailurl);
                                      } else {
                                        throw 'Could not launch $mailurl';
                                      }
                                    },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
        ));
      },
    );
  }
}
