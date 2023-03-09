import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:take_web/web/pages/app_state.dart';
import '../../globar_variables/globals.dart' as globals;
import '../../models/auto_complete_result.dart';
import '../../services/location_services.dart';
import 'flutter_flow/lat_lng.dart';

final placeResultsProvider = ChangeNotifierProvider<PlaceResults>((ref) {
  return PlaceResults();
});

final searchToggleProvider = ChangeNotifierProvider<SearchToggle>((ref) {
  return SearchToggle();
});

final locationProvider = ChangeNotifierProvider<CurrentLocation>((ref) {
  return CurrentLocation();
});

class PlaceResults extends ChangeNotifier {
  List<AutoCompleteResult> allReturnedResults = [];

  void setResults(allPlaces) {
    allReturnedResults = allPlaces;
    notifyListeners();
  }
}

class CurrentLocation extends ChangeNotifier {
  var _currentPosition;
  var _currentAddress;
  var latlonglocation = LatLng(0.0, 0.0);
  var pincode = "211011";
  var citylocation = "Prayagraj";

  Future<void> getCurrentPosition() async {
    try {
      print("hello we are here?");
      FFAppState().lat = latlonglocation.latitude;
      FFAppState().lon = latlonglocation.longitude;
      final hasPermission = await LocationService().handleLocationPermission();
      if (!hasPermission) return;
      try {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position position) async {
          _currentPosition = position;
          latlonglocation = LatLng(position.latitude, position.longitude);
          notifyListeners();
          FFAppState().lat = latlonglocation.latitude;
          notifyListeners();
          FFAppState().lon = latlonglocation.longitude;
          notifyListeners();
          globals.latlong = latlonglocation;
          print("follopp ${latlonglocation}");
          await getAddressFromLatLng(position);
        }).catchError((e) {
          debugPrint("oooooooooppppppppppppp${e}");
        });
      } catch (e) {
        print("sdiojfsoiweoiwttoe${e.toString()}");
      }
      return;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      //calculate all the diffrent city name
      if (place.locality == "Allahabad") {
        globals.city = "Prayagraj";
        citylocation = "Prayagraj";
        notifyListeners();
      } else {
        globals.city = place.locality!;
        citylocation = place.locality!;
        notifyListeners();
      }
      globals.postalcode = place.postalCode;
      pincode = place.postalCode!;
      FFAppState().pincode = pincode;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }
}

//   void setResults(allPlaces) {
//     allReturnedResults = allPlaces;
//     notifyListeners();
//   }
// }

class SearchToggle extends ChangeNotifier {
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}
