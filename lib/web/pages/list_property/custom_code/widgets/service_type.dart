// Automatic FlutterFlow imports
import '../../../app_state.dart';
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dropdown_search/dropdown_search.dart';

class ServiceType extends StatefulWidget {
  const ServiceType({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _ServiceTypeState createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  var servicetype = [
    'Hostel',
    'Hotel',
    'PG',
    'Apartment',
    'Flat',
    'Home',
    'Building floor',
    'Marrige hall'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().serviceType = servicetype[2];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: servicetype,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Service type",
          hintText: "PG",
        ),
      ),
      onChanged: (value) => FFAppState().serviceType = value!,
      selectedItem: "PG",
    );
  }
}
