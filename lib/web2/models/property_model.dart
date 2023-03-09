// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

PropertyModel PropertyModelFromJson(String str) => PropertyModel.fromJson(json.decode(str));

String propertyModelToJson(PropertyModel data) => json.encode(data.toJson());

class PropertyModel {
  PropertyModel({
    this.id,
    this.state,
    required this.city,
    this.propertyId,
    this.propertyimage,
    this.pincode,
    this.streetaddress,
    this.wantto,
    this.advancemoney,
    this.numberofrooms,
    this.amount,
    this.propertyname,
    this.areaofland,
    this.numberoffloors,
    this.ownername,
    this.mobilenumber,
    this.whatsappnumber,
    this.email,
    this.description,
    this.servicetype,
    this.sharing,
    this.foodservice,
    this.paymentduration,
  });

  String? id;
  String? state;
  String city;
  String? propertyId;
  List? propertyimage;
  String? pincode;
  String? streetaddress;
  String? wantto;
  String? advancemoney;
  String? numberofrooms;
  String? amount;
  String? propertyname;
  String? areaofland;
  String? numberoffloors;
  String? ownername;
  String? mobilenumber;
  String? whatsappnumber;
  String? email;
  String? description;
  String? servicetype;
  String? sharing;
  String? foodservice;
  String? paymentduration;

  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
    id: json["id"],
    state: json["state"],
    city: json["city"],
    propertyId: json["propertyId"],
    propertyimage: json["propertyimage"],
    pincode: json["pincode"],
    streetaddress: json["streetaddress"],
    wantto: json["wantto"],
    advancemoney: json["advancemoney"],
    numberofrooms: json["numberofrooms"],
    amount: json["amount"],
    propertyname: json["propertyname"],
    areaofland: json["areaofland"],
    numberoffloors: json["numberoffloors"],
    ownername: json["ownername"],
    mobilenumber: json["mobilenumber"],
    whatsappnumber: json["whatsappnumber"],
    email: json["email"],
    description: json["description"],
    servicetype: json["servicetype"],
    sharing: json["sharing"],
    foodservice: json["foodservice"],
    paymentduration: json["paymentduration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state,
    "city": city,
    "propertyId": propertyId,
    "propertyimage": propertyimage,
    "pincode": pincode,
    "streetaddress": streetaddress,
    "wantto": wantto,
    "advancemoney": advancemoney,
    "numberofrooms": numberofrooms,
    "amount": amount,
    "propertyname": propertyname,
    "areaofland": areaofland,
    "numberoffloors": numberoffloors,
    "ownername": ownername,
    "mobilenumber": mobilenumber,
    "whatsappnumber": whatsappnumber,
    "email": email,
    "description": description,
    "servicetype": servicetype,
    "sharing": sharing,
    "foodservice": foodservice,
    "paymentduration": paymentduration,
  };
}
