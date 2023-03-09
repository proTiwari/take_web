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

class Sharing extends StatefulWidget {
  const Sharing({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _SharingState createState() => _SharingState();
}

class _SharingState extends State<Sharing> {
  var sharing = [
    'No sharing',
    'Two sharing',
    'Three sharing',
    'Above Three',
    'No limits',
    'Will be discussed'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().sharingcount = sharing[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: sharing,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Sharing",
          hintText: "No sharing",
        ),
      ),
      onChanged: (value) => FFAppState().sharingcount = value!,
      selectedItem: "No sharing",
    );
  }
}
