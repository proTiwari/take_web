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

class NumberOfRooms extends StatefulWidget {
  NumberOfRooms({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _NumberOfRoomsState createState() => _NumberOfRoomsState();
}

class _NumberOfRoomsState extends State<NumberOfRooms> {
  var roomlist = [
    '1 Room',
    '2 Room',
    '3 Room',
    '4 Room',
    '5 Room',
    '6 Room',
    '7 Room',
    '8 Room',
    '9 Room',
    '10 Room',
    '11 Room',
    '12 Room',
    'Will be discussed'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().numberofrooms = roomlist[0];
  }

  var roomdata;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: roomlist,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Number of Room",
          hintText: "1 Room",
        ),
      ),
      onChanged: (value) => FFAppState().numberofrooms = value!,
      selectedItem: "1 Room",
    );
  }
}
