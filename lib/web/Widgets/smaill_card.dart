import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String city;
  const SmallCard(this.city, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade200,
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.fromLTRB(9, 3.4, 9, 3),
      height: 30,

      decoration: BoxDecoration(
        // border: Border.all(),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey.shade200,
        //       offset: const Offset(5, 15),
        //       blurRadius: 5,
        //       spreadRadius: 3)
        // ],
        color: Colors.grey.shade200,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 13
              ),
              text: "${city} ",
            ),

          ],
        ),
      ),
    );
  }
}
