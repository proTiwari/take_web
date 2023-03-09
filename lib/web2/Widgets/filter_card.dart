import 'package:flutter/material.dart';
import '../globar_variables/const_values.dart';

class FilterCard extends StatelessWidget {
  String value;
  FilterCard(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 0)
        ],
        color:  value == "Near me"? const Color(0xFFF27121): Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: InkWell(

          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: TextStyle(
                    color: value == "Near me"?  Colors.white:Colors.black45,
                    fontSize: 16
                  ),
                  text: "$value ",
                ),
                WidgetSpan(
                  child: value == "Near me"? Container(): Icon(Icons.arrow_drop_down, size: Consts.fontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
