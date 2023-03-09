import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_functions/firebase_fun.dart';
import '../models/user_model.dart';
import '../pages/list_property/flutter_flow/lat_lng.dart';
import '../services/auth_services.dart';
import '../globar_variables/globals.dart' as globals;
import '../services/location_services.dart';

class BaseProvider with ChangeNotifier {
  var res;
  final firebaseAuthService = AuthService.instance;

  UserModel? _user;

  UserModel get getUser => _user!;

  String? _currentAddress;
  Position? _currentPosition;

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street}, ${place.subLocality},${place.locality}, ${place.postalCode}';
      globals.city = place.locality!;
      globals.postalcode = place.postalCode;
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPosition(contex) async {
    final hasPermission = await LocationService().handleLocationPermission();
    print("sd");
    if (!hasPermission) return;
    print("dsfs");
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) async {
        print("dsisw");
        print("wew");
        _currentPosition = position;
        res = LatLng(position.latitude, position.longitude);
        notifyListeners();
        // valuenoticifierlatlong.value = res;
        globals.latlong = res;
        await _getAddressFromLatLng(position);
      }).catchError((e) {
        debugPrint(e);
        print("sd");
      });
    } catch (e) {
      print(e.toString());
    }
    return;
  }

  Future<void> refreshUser() async {
    try {
      UserModel user = await firebaseAuthService.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }

    // FirebaseServices().getProperties();
  }
}
