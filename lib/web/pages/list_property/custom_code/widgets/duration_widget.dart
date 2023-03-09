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

class DurationWidget extends StatefulWidget {
  const DurationWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _DurationWidgetState createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<DurationWidget> {
  var duration = [
    'Per Hour',
    'Per day',
    'Per Month',
    'Per Year',
    'one time payment',
    'Will be discussed'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().payingduration = duration[1];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: duration,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Duration",
          hintText: "Per Month",
        ),
      ),
      onChanged: (value) => FFAppState().payingduration = value!,
      selectedItem: "Per Month",
    );
  }
}
