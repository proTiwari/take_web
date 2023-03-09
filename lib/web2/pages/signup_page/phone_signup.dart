import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:take_web/web/pages/signin_page/phone_login.dart';
import 'package:take_web/web/pages/signin_page/sign_in.provider.dart';
import 'package:take_web/web/pages/signup_page/signup_provider.dart';

class SignUpPage extends StatefulWidget {
  var verificationId;
  var phone;
  SignUpPage(this.verificationId, this.phone, {Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController emailfield = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool loading = true;

  static final RegExp email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\])|(([a-zA-Z\-0–9]+\.)+[a-zA-Z]{2,}))$');
  final _codeController = TextEditingController();

 

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                    height: 50,
                  ),
                  SizedBox(
                    height: 100,
                    width: 450,
                    child: Container(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 325,
                    height: 470,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Form(
                      key: _formKey,
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
                            "Let us know about you",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: name,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'Please enter Name';
                                }

                                if (value.toString().length < 3) {
                                  return 'name cannot be less than 3 character';
                                }
                              },
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  // suffix: Icon(
                                  //   FontAwesomeIcons.envelope,
                                  //   color: Colors.red,
                                  // ),
                                  labelText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              controller: emailfield,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'Please enter Email';
                                }
                                if (!email.hasMatch(value!)) {
                                  return 'Please enter a valid Email';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.red,
                                  ),
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 260,
                            height: 78,
                            child: SizedBox(
                              width: 260,
                              height: 60,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Please enter OTP';
                                  }
                                  if (value.toString().length < 6) {
                                    return 'Please enter a valid OTP';
                                  }
                                },
                                maxLength: 6,
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: "OTP",
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var uid;
                              print("in");
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  provider.loading = true;
                                });
                                provider.verify(
                                    _codeController.text,
                                    context,
                                    widget.verificationId,
                                    name.text,
                                    emailfield.text,
                                    widget.phone.toString());
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 262,
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        // Color(0xFF8A2387),
                                        Color(0xFFF27121),
                                        Color(0xFFF27121),
                                      ])),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: provider.loading && loading == true
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Sign Up',
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
                          // RichText(
                          // text: TextSpan(
                          //   style: defaultStyle,
                          //   children: <TextSpan>[
                          //     const TextSpan(
                          //         text: "already have an account?"),
                          //     TextSpan(
                          //         text: 'SignIn',
                          //         style: linkStyle,
                          //         recognizer: TapGestureRecognizer()
                          //           ..onTap = () {
                          //             print("signin");
                          //             // Navigator.pushAndRemoveUntil<void>(
                          //             //   context,
                          //             //   MaterialPageRoute<void>(
                          //             //       builder: (BuildContext context) =>
                          //             //           LoginApp()),
                          //             //   ModalRoute.withName('/signin'),
                          //             // );
                          // //           })
                          //   ],
                          // ),
                          // ),
                          // const Text(
                          //   "Don't have an account? Sign Up",
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          // const SizedBox(height: 15,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     IconButton(
                          //         onPressed: click,
                          //         icon: const Icon(FontAwesomeIcons.facebook,color: Colors.blue)
                          //     ),
                          //     IconButton(
                          //         onPressed: click,
                          //         icon: const Icon(FontAwesomeIcons.google,color: Colors.redAccent,)
                          //     ),
                          //     IconButton(
                          //         onPressed: click,
                          //         icon: const Icon(FontAwesomeIcons.twitter,color: Colors.orangeAccent,)
                          //     ),
                          //     IconButton(
                          //         onPressed: click,
                          //         icon: const Icon(FontAwesomeIcons.linkedinIn,color: Colors.green,)
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> logintoyouraccount(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Your account has already been created try to login'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LoginApp(),
                  ),
                  ModalRoute.withName('/login'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
