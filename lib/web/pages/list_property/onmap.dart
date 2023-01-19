import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_web/web/pages/list_property/search_place_provider.dart';

import '../../models/auto_complete_result.dart';
import '../../services/map_services.dart';

class OnMap extends ConsumerStatefulWidget {
  OnMap({Key? key}) : super(key: key);

  @override
  ConsumerState<OnMap> createState() => _OnMapState();
}

class _OnMapState extends ConsumerState<OnMap> {
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController searchController = TextEditingController();
  var tappedPoint;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.435801, 81.846313),
    zoom: 14.4746,
  );
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
        markerId: const MarkerId('marker'),
        position: const LatLng(25.435801, 81.846313),
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker));
  }

  var points;

  void _setMarker(point) {
    final Marker marker = Marker(
        markerId: const MarkerId('marker'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var changeId = 0;
    Timer? _debounce;
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (point) {
                  points = point;
                  _setMarker(point);

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
              child: Column(children: [
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        border: InputBorder.none,
                        hintText: 'Search',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.text = '';
                                if (searchFlag.searchToggle) {
                                  searchFlag.toggleSearch();
                                }
                              });
                            },
                            icon: const Icon(Icons.close))),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) {
                        _debounce?.cancel();
                      }
                      _debounce =
                          Timer(const Duration(milliseconds: 700), () async {
                        if (value.length > 2) {
                          if (!searchFlag.searchToggle) {
                            searchFlag.toggleSearch();
                          }

                          List<AutoCompleteResult> searchResults =
                              await MapServices().searchPlaces(value);

                          allSearchResults.setResults(searchResults);
                        } else {
                          List<AutoCompleteResult> emptyList = [];
                          allSearchResults.setResults(emptyList);
                        }
                      });
                    },
                  ),
                )
              ]),
            ),
            searchFlag.searchToggle
                ? allSearchResults.allReturnedResults.isNotEmpty
                    ? Positioned(
                        top: 100.0,
                        left: 15.0,
                        child: Container(
                          height: 200.0,
                          width: screenWidth - 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          child: ListView(
                            children: [
                              ...allSearchResults.allReturnedResults
                                  .map((e) => buildListItem(e, searchFlag))
                            ],
                          ),
                        ))
                    : Positioned(
                        top: 100.0,
                        left: 15.0,
                        child: Container(
                          height: 200.0,
                          width: screenWidth - 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          child: Center(
                            child: Column(children: [
                              const Text('No results to show',
                                  style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: 125.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    searchFlag.toggleSearch();
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Close this',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      )
                : Container()
          ],
        ),
      ),
      floatingActionButton: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: const Text(
                  'Select this location',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pop(context, points);
                  print('Hello');
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
