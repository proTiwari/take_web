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

class AreaOfLandUnit extends StatefulWidget {
  const AreaOfLandUnit({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _AreaOfLandUnitState createState() => _AreaOfLandUnitState();
}

class _AreaOfLandUnitState extends State<AreaOfLandUnit> {
  var unit = [
    "Bigha-Pucca",
    "Bigha",
    "Bigha-Kachha",
    "Biswa-Pucca",
    "Biswa",
    "Biswa-Kaccha",
    "Biswansi",
    "Killa",
    "Ghumaon",
    "Kanal",
    "Chatak",
    "Decimal",
    "Dhur",
    "Kattha",
    "Lecha",
    "Ankanam",
    "Cent",
    "Ground",
    "Guntha",
    "Kuncham",
    "Square meter",
    "Square yard",
    "Centimeter",
    "Chain",
    "Feet",
    "Furlong",
    "Gaj",
    "Gattha",
    "Hath"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FFAppState().areaoflandunit = unit[20];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: unit,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: "Square meter",
          hintStyle: TextStyle(fontSize: 5)
        ),
      ),
      onChanged: (value) => FFAppState().areaoflandunit = value!,
      selectedItem: "Square meter",
    );
  }
}
