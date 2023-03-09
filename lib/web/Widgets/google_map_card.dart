import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../pages/property_detail/singleloc_googlemap.dart';

class GoogleMapCard extends StatefulWidget {
  var detail;
  var height;
  GoogleMapCard(this.detail, this.height, {Key? key}) : super(key: key);

  @override
  State<GoogleMapCard> createState() => _GoogleMapCardState();
}

class _GoogleMapCardState extends State<GoogleMapCard> {
  Set<Marker> _markers = <Marker>{};
  bool isnotlist = false;
  @override
  void initState() {
    super.initState();
    try {
      for (var i in widget.detail) {
        print("ewrew: ${i['lat']}");
        try {
          setMarker(LatLng(i['lat'], i['lon']));
        } catch (e) {
          print("this si erjeoi");
          print(e.toString());
        }
      }
    } catch (e) {
      setState(() {
        isnotlist = true;
      });
      setMarker(LatLng(widget.detail['lat'], widget.detail['lon']));
    }
  }

  setMarker(point) {
    // var counter = markerIdCounter++;
    // _setCircle(point, counter);
    try {
      final Marker marker = Marker(
          markerId: MarkerId('marker'),
          position: point,
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker);

      CameraPosition _kGooglePlex = CameraPosition(
        target: point,
        zoom: 14.4746,
      );

      setState(() {
        _markers.add(marker);
      });
    } catch (e) {
      print("this is the kinga error");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    CameraPosition _kGooglePlex = CameraPosition(
      target: isnotlist
          ? LatLng(widget.detail['lat'], widget.detail['lon'])
          : LatLng(widget.detail[0]['lat'], widget.detail[0]['lon']),
      zoom: 14.4746,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SingleGooglemap(
              isnotlist
                  ? LatLng(widget.detail['lat'], widget.detail['lon'])
                  : LatLng(widget.detail[0]['lat'], widget.detail[0]['lon']),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: const [
            // BoxShadow(
            //     color: Colors.grey,
            //     offset: Offset(10, 15),
            //     blurRadius: 15,
            //     spreadRadius: 1)
          ],
          color: Colors.white,
          // color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: widget.height,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
