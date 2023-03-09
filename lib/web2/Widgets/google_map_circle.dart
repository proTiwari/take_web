import 'package:flutter/material.dart';

class GoogleMapCircle extends StatelessWidget {
  const GoogleMapCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(9, 3, 9, 0),
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
      child: const Padding(
        padding: EdgeInsets.all(7.0),
        child: Icon(Icons.location_on, color: Color.fromARGB(255, 218, 69, 69), size: 50.0),
      ),
    );
  }
}
