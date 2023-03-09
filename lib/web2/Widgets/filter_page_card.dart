import 'package:flutter/material.dart';

class FilterPageCard extends StatelessWidget {
  final String value;
  const FilterPageCard(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.fromLTRB(9, 3, 9, 3),
      height: 39.7,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(5, 15),
              blurRadius: 5,
              spreadRadius: 3)
        ],
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16
                ),
                text: "${value} ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
