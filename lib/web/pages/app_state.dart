import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_property/flutter_flow/lat_lng.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _sellerform = false;
  bool get sellerform => _sellerform;
  set sellerform(bool _value) {
    _sellerform = _value;
  }

  String _image = '';
  String get image => _image;
  set image(String _value) {
    _image = _value;
  }

  String _image2 = '';
  String get image2 => _image2;
  set image2(String _value) {
    _image2 = _value;
  }

  bool _advanceMoney = false;
  bool get advanceMoney => _advanceMoney;
  set advanceMoney(bool _value) {
    _advanceMoney = _value;
  }

  bool _foodService = false;
  bool get foodService => _foodService;
  set foodService(bool _value) {
    _foodService = _value;
  }

  String _numberofrooms = '1';
  String get numberofrooms => _numberofrooms;
  set numberofrooms(String _value) {
    _numberofrooms = _value;
  }

  String _numberoffloors = '1';
  String get numberoffloors => _numberoffloors;
  set numberoffloors(String _value) {
    _numberoffloors = _value;
  }

  String _sharingcount = 'No Sharing';
  String get sharingcount => _sharingcount;
  set sharingcount(String _value) {
    _sharingcount = _value;
  }

  String _amountrange = '2000-5000';
  String get amountrange => _amountrange;
  set amountrange(String _value) {
    _amountrange = _value;
  }

  String _payingduration = 'Per Month';
  String get payingduration => _payingduration;
  set payingduration(String _value) {
    _payingduration = _value;
  }

  String _serviceType = 'PG';
  String get serviceType => _serviceType;
  set serviceType(String _value) {
    _serviceType = _value;
  }

  String _cityname = '';
  String get cityname => _cityname;
  set cityname(String _value) {
    _cityname = _value;
  }

  String _areaofland = '';
  String get areaofland => _areaofland;
  set areaofland(String _value) {
    _areaofland = _value;
  }

  String _selleramount = '';
  String get selleramount => _selleramount;
  set selleramount(String _value) {
    _selleramount = _value;
  }

  String _propertyname = '';
  String get propertyname => _propertyname;
  set propertyname(String _value) {
    _propertyname = _value;
  }

  String _streetaddress = '';
  String get streetaddress => _streetaddress;
  set streetaddress(String _value) {
    _streetaddress = _value;
  }

  String _pincode = '';
  String get pincode => _pincode;
  set pincode(String _value) {
    _pincode = _value;
  }

  String _name = '';
  String get name => _name;
  set name(String _value) {
    _name = _value;
  }

  String _email = '';
  String get email => _email;
  set email(String _value) {
    _email = _value;
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String _value) {
    _phone = _value;
  }

  String _altphone = '';
  String get altphone => _altphone;
  set altphone(String _value) {
    _altphone = _value;
  }

  String _description = '';
  String get description => _description;
  set description(String _value) {
    _description = _value;
  }

  double _lat = 0.0;
  double get lat => _lat;
  set lat(double _value) {
    _lat = _value;
  }

  double _lon = 0.0;
  double get lon => _lon;
  set lon(double _value) {
    _lon = _value;
  }

  String _areaoflandunit = '';
  String get areaoflandunit => _areaoflandunit;
  set areaoflandunit(String _value) {
    _areaoflandunit = _value;
  }
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
