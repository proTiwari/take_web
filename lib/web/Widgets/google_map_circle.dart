import 'package:flutter/material.dart';

class GoogleMapCircle extends StatelessWidget {
  const GoogleMapCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100,
              offset: const Offset(1, 1),
              blurRadius: 0,
              spreadRadius: 3)
        ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        "assets/map3.png",
      ),
    );
  }
}
