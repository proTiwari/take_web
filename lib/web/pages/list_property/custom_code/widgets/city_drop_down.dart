// Automatic FlutterFlow imports
import '../../../app_state.dart';
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
import '../../../../globar_variables/const_values.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dropdown_search/dropdown_search.dart';

class CityDropDown extends StatefulWidget {
  const CityDropDown({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;
  @override
  _CityDropDownState createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().cityname = "";
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      dropdownButtonProps: DropdownButtonProps(isSelected: false),
      popupProps: PopupProps.menu(
        isFilterOnline: true,
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: true,
        showSelectedItems: true,
        // disabledItemFn: (String s) => s.startsWith('I'),
      ),
      items: Consts().cityList,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "City",
          hintText: "Prayagraj",
        ),
      ),
      onChanged: (value) => FFAppState().cityname = value!,
      selectedItem: "Prayagraj",
    );
  }
}
