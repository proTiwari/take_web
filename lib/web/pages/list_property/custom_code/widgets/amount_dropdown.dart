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

class AmountDropdown extends StatefulWidget {
  const AmountDropdown({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;

  @override
  _AmountDropdownState createState() => _AmountDropdownState();
}

class _AmountDropdownState extends State<AmountDropdown> {
  var amountList = [
    '0-2,000',
    '2,000-5,000',
    '5,000-10,000',
    '10,000-15,000',
    '15,000-20,000',
    '20,000-25,000',
    '25,000-30,000',
    '30,000-35,000',
    '40,000-45,000',
    '45,000-50,000',
    '50,000-55,000',
    '55,000-60,000',
    '60,000-65,000',
    '65,000-70,000',
    '70,000-75,000',
    '75,000-80,000',
    '85,000-90,000',
    '90,000-95,000',
    '1,00,000',
    'Will be discussed'
  ];

  @override
  void initState() {
    super.initState();
    FFAppState().amountrange = '2,000-5,000';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        menuProps: const MenuProps(borderOnForeground: true, elevation: 0),
        showSearchBox: false,
        showSelectedItems: true,
      ),
      items: amountList,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Amount",
          hintText: "2,000-5,000",
        ),
      ),
      onChanged: (value) => FFAppState().amountrange = value!,
      selectedItem: "2,000-5,000",
    );
  }
}
