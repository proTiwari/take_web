import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginApi{
  Future<dynamic> loginRequest(phone) async {
    var data = await http.post(
      Uri.parse('http://10.0.2.2:4000/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone.toString(),
      }),
    );
    String jsonsDataString = data.body.toString();
    var tok = json.decode(jsonsDataString); // toString of Response's body is assigned to jsonDataString
    return tok;
  }

  Future<dynamic> checkifexist() async{

  }
}