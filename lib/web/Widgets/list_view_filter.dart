import 'package:flutter/material.dart';

class ListViewFilter extends StatelessWidget {
  String value;
  ListViewFilter(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.fromLTRB(9, 3, 9, 3),
      height: 30,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey.shade200,
        //       offset: const Offset(5, 15),
        //       blurRadius: 5,
        //       spreadRadius: 3)
        // ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(

        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16
                ),
                text: "${value}",
              ),

            ],
          ),
        ),
      ),
    );
  }
}
