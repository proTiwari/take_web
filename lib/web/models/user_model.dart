// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel usermodelFromJson(String str) => UserModel.fromJson(json.decode(str));

String usermodelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.address,
    this.groups,
    this.name,
    this.email,
    this.id,
    this.phone,
    this.profileImage,
    this.properties,
  });

  String? address;
  List<dynamic>? groups;
  String? name;
  String? email;
  String? id;
  String? phone;
  String? profileImage;
  List<dynamic>? properties;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    address: json["address"],
    groups: List<dynamic>.from(json["groups"].map((x) => x)),
    name: json["name"],
    email: json["email"],
    id: json["id"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    properties: List<dynamic>.from(json["properties"].map((x) => x)),
  );

    static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      id: snapshot["id"],
      email: snapshot["email"],
      phone: snapshot["phone"],
      address: snapshot["address"],
      profileImage: snapshot["profileImage"],
      properties: snapshot["properties"],
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "groups": List<dynamic>.from(groups!.map((x) => x)),
    "name": name,
    "email": email,
    "id": id,
    "phone": phone,
    "profileImage": profileImage,
    "properties": List<dynamic>.from(properties!.map((x) => x)),
  };
}
