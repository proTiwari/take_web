library globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:take_web/web/models/property_model.dart';

var width;
var height;
var logintoken;
var list;
var city = 'City';
List imageList = [];
List uploadingimageList = [];
List property = [];
var userdata;
var name = '';
var email = '';
bool logined = false;
var address = '';
var ownerprofiledata;
const webScreenSize = 600;
List listofproperties = [];
List initlistimages = [];
bool userexist() {
  bool exist;
  try {
    var doesexist = FirebaseAuth.instance.currentUser!.uid;
    if (doesexist == '') {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}
// ValueNotifier<List> listofproperties = ValueNotifier([]);
