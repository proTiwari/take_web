/*
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../signin_page/signin__page.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dojController = TextEditingController();
  bool loading = false;
  DateTime currentDate = DateTime.now();
  String doj = '';
  String Fname = '';
  String Lname = '';
  String email = '';
  String phone = '';
  String password = '';
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    datecall();
  }

  datecall() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate); // 2016-01-25
    doj = formattedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1905),
      lastDate: DateTime(2050),
    );
    // if (pickedDate != null && pickedDate != currentDate) {
    //   setState(() {
    //     doj = '';
    //     doj +=
    //         '${currentDate.day <= 9 ? '0${currentDate.day}' : currentDate.day.toString()}-';
    //     doj += '${monthConversion(currentDate.month)}-';
    //     doj += currentDate.year.toString();
    //     currentDate = pickedDate;
    //     print("doj: ${doj}");
    //   });
    // }
    print(currentDate.toString().split(' ')[0]);
  }

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  monthConversion(int month) {
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/signup.png"),
                const SizedBox(height: 20),
                Text(
                  "Sign UP",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/email_logo.png",
                      scale: 1.5,
                      // color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                            */
/* enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)) *//*

                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 1.5),
                      child: Image.asset(
                        "assets/user.png",
                        scale: 1.5,
                        // color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: nameController,
                          decoration: InputDecoration(
                            // suffixIcon: Image.asset("assets/eye_logo.png"),
                            hintText: "Full Name",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                            */
/* enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)) *//*

                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/phone_logo.png",
                      scale: 1.5,
                      // color: Colors.black,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0.3, 0, 1.0),
                      child: const Text("+91",style: TextStyle(fontSize: 15, color: Colors.grey),),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          decoration: InputDecoration(
                            // suffixIcon: Image.asset("assets/eye_logo.png"),
                            hintText: "Phone Number",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                            */
/* enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)) *//*

                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 9.0),
                      child: Image.asset(
                        "assets/lock_logo.png",
                        scale: 1.5,
                        // color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xffef9a9a),
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          // suffixIcon: Image.asset("assets/eye_logo.png"),
                          hintText: "Password(minimum 8 digit)",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey),
                          */
/* enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.black)) *//*

                        ),
                        obscureText: !_passwordVisible,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    Text(
                      "By SignUp, you agree to our ",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text("terms and Conditions ",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Color(0xffef9a9a))),
                    Text("and ", style: GoogleFonts.poppins(fontSize: 14)),
                    Text("Privacy Policy",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xffef9a9a)))
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    // setState(() {
                    //   loading = true;
                    // });
                    // StudentModel student = setStudentDetails();
                    // Object res = await ApiServices().addNewStudent(
                    //     student,
                    //     nameController.text,
                    //     emailController.text,
                    //     doj.toString(),
                    //     passwordController.text,
                    //     phoneController.text);
                    // setState(() {
                    //   loading = false;
                    // });
                    // print("wewe");
                    // print("res: ${res}");
                    // if (res == 'success') {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('${res}'),
                    //     ),
                    //   );
                    //   // Navigator.pushReplacement(
                    //   //     context,
                    //   //     MaterialPageRoute(
                    //   //         builder: (BuildContext context) => otpPage(
                    //   //             email: emailController.text,
                    //   //             password: passwordController.text)));
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('${res}'),
                    //     ),
                    //   );
                    // }

                    // : null;
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffef9a9a),
                    ),
                    child: !loading
                        ? Center(
                      child: Text(
                        "SignUp",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                        : Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Joined us before?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: const Color(0xffef9a9a)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
