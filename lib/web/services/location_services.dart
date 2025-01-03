import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService{

  Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {   
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}
}