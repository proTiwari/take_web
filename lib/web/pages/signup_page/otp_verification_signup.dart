// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../list_property/flutter_flow/flutter_flow_theme.dart';
import '../signup_page/signup_provider.dart';

class OtpSignupPage extends StatefulWidget {
  String verificationId;
  OtpSignupPage(this.verificationId, {Key? key}) : super(key: key);

  @override
  State<OtpSignupPage> createState() => _OtpSignupPageState();
}

class _OtpSignupPageState extends State<OtpSignupPage> {
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle =
        const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14.0);
    TextStyle linkStyle =
        const TextStyle(color: Color.fromARGB(255, 9, 114, 199));
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            body: ChangeNotifierProvider(
          create: (context) => SignupProvider(),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: FlutterFlowTheme.of(context).primaryBackground,
              // decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [
              //       Colors.purpleAccent,
              //       Colors.amber,
              //       Colors.blue,
              //     ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 85,
                  ),
                  SizedBox(
                    height: 180,
                    width: 450,
                    child: Container(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 325,
                    height: 320,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x32000000),
                          offset: Offset(0, 2),
                        )
                      ],
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        const Text(
                          "otp verification",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Enter the otp send on your number",
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
                          child: TextField(
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
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          // onTap: () {
                          //   provider.verify(_codeController.text, context,
                          //       widget.verificationId);
                          // },
                          child: Container(
                            alignment: Alignment.center,
                            width: 262,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      // Color(0xFF8A2387),
                                      FlutterFlowTheme.of(context).alternate,
                                      FlutterFlowTheme.of(context).alternate,
                                    ])),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: provider.loading
                                  ? const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Verify',
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
                              const TextSpan(text: "Don't have an account?"),
                              TextSpan(
                                  text: 'Sign Up',
                                  style: linkStyle,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("signup");
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             SignUpPage("")));
                                    })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
