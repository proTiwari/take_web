// Automatic FlutterFlow imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlon;
import '../../../../services/location_services.dart';
import '../../../app_state.dart';
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../onmap.dart';
import '../../search_place_provider.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
import '../../../../globar_variables/globals.dart' as globals;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class Chooselocation extends ConsumerStatefulWidget {
  const Chooselocation({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  ConsumerState<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends ConsumerState<Chooselocation> {
  @override
  void initState() {
    super.initState();
    // FFAppState().lat = globals.latlong.latitude;
    // FFAppState().lon = globals.latlong.longitude;
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnMap()),
    );
    setState(() {
      results = result;
      print("are you kidding me: ${result}");
      print(result);
      FFAppState().lat = results.latitude;
      FFAppState().lon = results.longitude;
    });
  }

  Widget onMap() {
    return GestureDetector(
      onTap: (() {
        _navigateAndDisplaySelection(context);
      }),
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.shade100,
          //       offset: const Offset(1, 3),
          //       blurRadius: 2,
          //       spreadRadius: 3)
          // ],
          color: Colors.white,
          // color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: SizedBox(child: const Icon(Icons.map_rounded)),
      ),
    );
  }

  Position? _currentPosition;
  String? _currentAddress;
  latlon.LatLng results = latlon.LatLng(0.0, 0.0);

  Future<void> _getCurrentPosition() async {
    final hasPermission = await LocationService().handleLocationPermission();
    print("sd");
    print(hasPermission);
    if (hasPermission == false) {
      showToast(
          context: context,
          "Please enable location(gps) option in your phone");
    }
    if (!hasPermission) return;
    print("dsfs");
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        print("dsisw");
        setState(() {
          print("wew");
          _currentPosition = position;
          var res = latlon.LatLng(position.latitude, position.longitude);
          _getAddressFromLatLng(position);

          results = res;
          FFAppState().lat = results.latitude;
          FFAppState().lon = results.longitude;
          print(results);
        });
      }).catchError((e) {
        debugPrint(e);
        print("sd");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality},${place.locality}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Widget currentlocation() {
    return GestureDetector(
      onTap: (() {
        print("_getCurrentPosition");
        _getCurrentPosition();
      }),
      child: Container(
          padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.grey.shade100,
            //       offset: const Offset(1, 1),
            //       blurRadius: 0,
            //       spreadRadius: 3)
            // ],
            color: Colors.white,
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.gps_fixed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var locationprovider = ref.watch(locationProvider);
    var lat = FFAppState().lat;
    var lon = FFAppState().lon;
    setState(() {
      lat;
      lon;
    });
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Text("${lat}, ${lon}"),
          // child: Text("$results"),
        ),
        IntrinsicHeight(
          child:
              // Column(
              //   children: [

              Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  currentlocation(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("current location",
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
              // const SizedBox(
              //   width: 10,
              // ),
              const VerticalDivider(
                color: Colors.black,
                thickness: 1,
              ),
              // const SizedBox(
              //   width: 10,
              // ),
              Column(
                children: [
                  onMap(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "choose on Map",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              )
            ],
          ),
          //   ],
          // ),
        ),
      ],
    );
  }
}
